//
//  ViewController.swift
//  MemeMe-v1.0
//
//  Created by Ravi on 13/11/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit

class MemeViewEditorController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var memeTopText: UITextField!
    @IBOutlet weak var memeBottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var cameraPickerButton: UIBarButtonItem!
    @IBOutlet weak var albumPickerButton: UIBarButtonItem!
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    let UP = "TOP"
    let DOWN = "BOTTOM"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "The Meme Editor"
        view.backgroundColor = UIColor.darkGray
        setTextFieldProperties()
        setDefaultTextAndImage()
        checkForImage(memeImageView)
        UIApplication.shared.isStatusBarHidden = true
        cameraPickerButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @IBAction func pickAnImageFromGallery(_ sender: Any) {
        setImagePicker(albumPickerButton, sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        setImagePicker(cameraPickerButton, sourceType: .camera)
    }
    
    @IBAction func cancelMeme(_ sender: UIBarButtonItem) {
        setDefaultTextAndImage()
        checkForImage(memeImageView)
    }
    
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
            if completed {
                self.saveMeme(memedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
        // Popover for iPad
        let popoverPresentationController = activityViewController.popoverPresentationController
        popoverPresentationController?.barButtonItem = shareButton
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    func setTextFieldProperties(){
        if let fontStyle = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40) {
            let memeTextFieldAttributes: [String: AnyObject] = [
                NSStrokeColorAttributeName : UIColor.black,
                NSForegroundColorAttributeName : UIColor.white,
                NSFontAttributeName : fontStyle,
                NSStrokeWidthAttributeName : -3.0 as AnyObject
            ]
            memeTopText.defaultTextAttributes = memeTextFieldAttributes
            memeBottomText.defaultTextAttributes = memeTextFieldAttributes
        }
    }
    
    func generateMemedImage() -> UIImage {
        setToolbarVisibility(flag: true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame,
                           afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        setToolbarVisibility(flag: false)
        return memedImage
    }
    
    func setToolbarVisibility(flag: Bool)->Void {
        navigationController?.isNavigationBarHidden = flag
        toolbar.isHidden = flag
    }
    
    func saveMeme(_ memeImage: UIImage) {
        if let topText = memeTopText.text, let bottomText = memeBottomText.text, let image = memeImageView.image {
            let memModel = MemeModel(topText: topText, bottomText: bottomText, realImage: image, modifiedImage: memeImage)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memes.append(memModel)
        }
    }
    
    func checkForImage(_ imageView: UIImageView) {
        shareButton.isEnabled = imageView.image != nil ? true : false
    }

    
    func setTextField(_ textField: UITextField) {
        textField.delegate = self
        textField.textAlignment = .center
    }
    
    func setDefaultTextAndImage() {
        memeTopText.text = UP
        memeBottomText.text = DOWN
        memeImageView.image = nil
        setTextField(memeTopText)
        setTextField(memeBottomText)
    }

    
    func setImagePicker(_ barButton: UIBarButtonItem, sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self

        imagePicker.modalPresentationStyle = .popover
        let popoverPresentationController = imagePicker.popoverPresentationController
        popoverPresentationController?.barButtonItem = barButton
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Keyboard
    func keyboardWillShow(_ notification: Notification) {
        if memeBottomText.isEditing {
            view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if memeBottomText.isEditing {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        var keyboardHeight = CGFloat()
        if let userInfo = notification.userInfo {
            let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
            keyboardHeight = keyboardSize.cgRectValue.height
        }
        return keyboardHeight
    }
    
    // UITextField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == memeTopText && memeTopText.text == UP {
            memeTopText.text = ""
        } else if textField == memeBottomText && memeBottomText.text == DOWN {
            memeBottomText.text = ""
        }
        cancelButton.isEnabled = false
    }
    
    func dismissKeyboard() {
        memeTopText.resignFirstResponder()
        memeBottomText.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == memeTopText && memeTopText.text == "" {
            memeTopText.text = UP
        } else if textField == memeBottomText && memeBottomText.text == "" {
            memeBottomText.text = DOWN
        }
        cancelButton.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageView.image = image
            checkForImage(memeImageView)
            dismiss(animated: true, completion: nil)
        }
    }

}

