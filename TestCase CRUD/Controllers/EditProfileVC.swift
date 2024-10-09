//
//  EditProfileVC.swift
//  TestCase CRUD
//
//  Created by Karan Verma on 07/10/24.
//

import UIKit

class EditProfileVC: UIViewController {

    var onDismissClosure : (() -> Void)?
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var selectPhotoBtn: UIButton!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var mobileNumberField: UITextField!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    var didPhotoChange = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
   
    @IBAction func selectImagePressed(_ sender: Any) {
        handleImageSelection()
        
    }
    
    @IBAction func saveChangesPressed(_ sender: Any) {
        saveChangesInProfile()
    }
}

extension EditProfileVC {
    private func setupView(){
        selectPhotoBtn.layer.cornerRadius = 13
        saveBtn.layer.cornerRadius = 5
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 5
    }
    
    private func setupData(){
        if let userModel = UserModelManager.shared.userModel{
            firstNameField.text = userModel.firstName
            lastNameField.text = userModel.lastName
            mobileNumberField.text = userModel.mobileNumber
            
            if let profileURL = URL(string: userModel.photoURL){
                profileURL.loadImage {[weak self] image in
                    if let image{
                        self?.profileImageView.image = image
                    }
                }
            }
        }
    }
    
    private func saveChangesInProfile(){
        
        if didPhotoChange{
            /// when photo is changed, then we'll upload image first, then update rest with photourl
            FirebaseManager().uploadImage(self.profileImageView.image ?? UIImage()) { url in
                if let url {
                    FirebaseManager().storeImageInfoInFirestore(imageURL: url) {[weak self] status in
                        if status{
                            self?.updateDataChanges(profilePhotoURL: url) // with photo URL
                        }
                    }
                }
            }
        }
        else{
            updateDataChanges()
        }
    }
    
    private func updateDataChanges(profilePhotoURL: String? = nil) {
        let firstName = firstNameField.text
        let lastName = lastNameField.text
        let mobileNumber = mobileNumberField.text
        
        FirebaseManager().updateUserData(firstName, lastName, mobileNumber, profilePhotoURL){[weak self] status in
            if status{
                print("Succesfully updated the data")
                if let closure = self?.onDismissClosure{
                    closure()
                }
                self?.dismiss(animated: true)
            }
            else{
                print("Could not update data")
                self?.dismiss(animated: true)
            }
        }
    }
    
    private func handleImageSelection(){
        PHPickerManager.shared.presentPicker(from: self) {[weak self] image in
            if let image {
                self?.profileImageView.image = image
                self?.didPhotoChange = true
            }
        }
    }

}
