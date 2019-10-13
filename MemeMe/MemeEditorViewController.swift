//
//  ViewController.swift
//  MemeMe
//
//  Created by Faisal Babkoor on 10/2/19.
//  Copyright © 2019 Faisal Babkoor. All rights reserved.
//

import UIKit
class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet var imagePickerView: UIImageView!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var BottomToolBar: UIToolbar!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var sharButton: UIBarButtonItem!
    @IBOutlet var topToolBar: UIToolbar!
    
    var memes: [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    var editMeme: Meme?
    var numberInList: Int?
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        styleTextField(topTextField, defaultText: "TOP")
        styleTextField(bottomTextField, defaultText: "BOTTOM")
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        if let editMeme = editMeme {
            imagePickerView.image = editMeme.originalImage
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func styleTextField(_ textField: UITextField, defaultText: String){
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
        textField.text = defaultText
    }
    
    
    func pickImageFrom(_ source: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true)
        
        present(imagePicker, animated: true)
    }
    @IBAction func cameraButtonWasPressed(_ sender: Any) {
        pickImageFrom(.camera)
    }
    @IBAction func albumcameraButtonWasPressed(_ sender: Any) {
        pickImageFrom(.photoLibrary)
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification){
        if bottomTextField.isFirstResponder{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        if bottomTextField.isFirstResponder{
            view.frame.origin.y = 0.0
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self)
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        hideBar(true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        hideBar(false)
        return memedImage
    }
    
    func hideBar(_ hide: Bool){
        topToolBar.isHidden = hide
        BottomToolBar.isHidden = hide
    }
    func save() {
        // Create the meme
        if let _ = editMeme, let numberInList = numberInList{
            if let meme = createMeme(){
                 let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                   appDelegate.memes.append(meme)
                appDelegate.memes.remove(at: numberInList)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }else{
            if let meme = createMeme() {
                 let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                   appDelegate.memes.append(meme)
                                   self.navigationController?.popToRootViewController(animated: true)
            }
        }
    
    }
    func createMeme() -> Meme? {
        if let image = imagePickerView.image{
                   let memedImage = generateMemedImage()
                   let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: image, memedImage: memedImage)
                   return meme
               }else{
                   showAlert(title: "You need to add an image", message: "You can't share whitout choose an image")
                   return nil
               }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.allowsEditing = true
        if let image = info[.originalImage] as? UIImage{
            imagePickerView.image = image
            dismiss(animated: true, completion: nil)
        }else if let cropImage = info[.editedImage] as? UIImage{
            imagePickerView.image = cropImage
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func shareButtonWasPressed(_ sender: Any) {
        let memeImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = {
            activity, success, items, error in
            if success{
                self.save()
            }
        }
        present(activityController, animated: true)
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    @IBAction func cancelBarButtonWasPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

