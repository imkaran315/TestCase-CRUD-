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
    var userModel : UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
   
    @IBAction func selectImagePressed(_ sender: Any) {
        
    }
    
    @IBAction func saveChangesPressed(_ sender: Any) {
        saveChangesInProfile()
    }
}

extension EditProfileVC {
    private func setupView(){
        selectPhotoBtn.layer.cornerRadius = 13
        saveBtn.layer.cornerRadius = 5
        
    }
    
    private func setupData(){
        if let userModel{
            firstNameField.text = userModel.firstName
            lastNameField.text = userModel.lastName
            mobileNumberField.text = userModel.mobileNumber
        }
    }
    
    private func saveChangesInProfile(){
        let firstName = firstNameField.text
        let lastName = lastNameField.text
        let mobileNumber = mobileNumberField.text
        
        FirebaseManager().updateUserData(firstName, lastName, mobileNumber ){[weak self] status in
            if status{
                print("Succesfully updated the data")
                if let closure = self?.onDismissClosure{
                    closure()
                }
                self?.dismiss(animated: true)
            }
            else{
                print("COuld not update data")
                self?.dismiss(animated: true)
            }
        }
    }
}
