//
//  ViewController.swift
//  CoreDataDemo3
//
//  Created by Apple on 01/08/24.
//

import UIKit
import CoreData
import PhotosUI

class RegisterViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var emailID: UITextField!
    
    @IBOutlet weak var passField: UITextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    var user: UserEntity?
    private let manager = DatabaseManager()
    private var imageSelectedByUser: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        // Do any additional setup after loading the view.
    }

    @IBAction func submitClick(_ sender: Any) {
        guard let firstName = firstName.text, !firstName.isEmpty else {
                    openAlert(message: "Please enter your first name")
                    return
                }
                guard let lastName = lastName.text, !lastName.isEmpty else {
                    openAlert(message: "Please enter your last name")
                    return
                }
                guard let email = emailID.text, !email.isEmpty else {
                    openAlert(message: "Please enter your email address")
                    return
                }

                guard let password = passField.text, !password.isEmpty else {
                    openAlert(message: "Please enter your password")
                    return
                }
        if !imageSelectedByUser {
            openAlert(message: "Please select image")
            return
        }
        let imageName = UUID().uuidString
        var newUser = UserModel(firstName: firstName, lastName: lastName, email: email, password: password ,imageName: imageName)
        
        if let user {
            newUser.imageName = user.imageName ?? ""
            saveImagetoDocumentDirectory(imageName: user.imageName ?? "")
            manager.updateUser(user: newUser, userEntity: user)
        } else {
            saveImagetoDocumentDirectory(imageName: imageName)
            manager.addUser(newUser)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func saveImagetoDocumentDirectory(imageName: String){
        let fileURL = URL.documentsDirectory.appending(components: imageName).appendingPathExtension("png")
        if let data = imageView.image?.pngData() {
            do{
                try data.write(to: fileURL) //saving data in path
            } catch{
                print("Saving image to document directory error")
            }
        }
    }
    @objc func openGallery(){
        var config = PHPickerConfiguration()
        config.selectionLimit = 1 // 0 unlimited
        
        let pickerVC = PHPickerViewController(configuration: config)
        
        pickerVC.delegate = self
        present(pickerVC, animated: true)
    }
    
}


extension RegisterViewController {
    
    func configuration(){
        addGesture()
        uiConfiguartion()
        userDetailConfiguration()
    }
    func uiConfiguartion(){
        self.imageView.layer.cornerRadius = self.imageView.frame.size.height/2
    }
    func userDetailConfiguration(){
        if let user {
            self.navigationItem.title = "Update User"
            firstName.text = user.firstname
            lastName.text = user.lastname
            emailID.text = user.emailID
            passField.text = user.password
            let imageURL = URL.documentsDirectory.appending(components: user.imageName ?? "").appendingPathExtension("png")
            imageView.image = UIImage(contentsOfFile: imageURL.path)
            submitBtn.setTitle("Update", for: .normal)
            imageSelectedByUser = true
        } else {
            self.navigationItem.title = "Add User"
            submitBtn.setTitle("Register", for: .normal)
        }
    }
    func addGesture(){
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openGallery))
        imageView.addGestureRecognizer(imageTap)
    }
    func showAlert(){
        let alertController = UIAlertController(title: nil, message: "User added", preferredStyle: .alert)
              let okay = UIAlertAction(title: "Okay", style: .default)
              alertController.addAction(okay)
              present(alertController, animated: true)
    }
    func openAlert(message: String){
            let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default)
            alertController.addAction(okay)
            present(alertController, animated: true)
        }
}

extension RegisterViewController: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self){
                //load object uses background thread
                image,error in
                guard let image = image as? UIImage else {return}
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.imageSelectedByUser = true
                }
               
            }
        }
    }
}
