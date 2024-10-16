//
//  ProfileVC.swift
//  TestCase CRUD
//
//  Created by Karan Verma on 06/10/24.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userNumberLbl: UILabel!
    @IBOutlet weak var deleteProfileView: UIView!
    @IBOutlet weak var editProfileBtn: UIButton!
    
    @IBOutlet weak var accountLbl: UILabel!
    @IBOutlet weak var createdOnLbl: UILabel!
    @IBOutlet weak var roleLbl: UILabel!
    @IBOutlet weak var tenantLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData()
        setupDeleteView()
    }
    
    @IBAction func editProfilePressed(_ sender: Any) {
        openEditScreen()
    }
}

extension ProfileVC {
    
    private func setupView(){
        editProfileBtn.layer.cornerRadius = 10
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 5
    }
    
    private func setupData(){
        guard let userModel = UserModelManager.shared.userModel else {
            print("userModel not found in Profile Screen")
            return
        }
        
        userNameLbl.text = userModel.firstName + " " + userModel.lastName
        userNumberLbl.text = userModel.mobileNumber
        accountLbl.text = userModel.email
        createdOnLbl.text = userModel.dateCreated.dateValue().formatted(date: .abbreviated, time: .omitted)
        roleLbl.text = userModel.role
        tenantLbl.text = userModel.tenantId
        
        setupProfilePicture()
    }
    
    private func setupProfilePicture(){
        guard let userModel = UserModelManager.shared.userModel else {return}
        let profileURL = userModel.photoURL
        
        // checking and applying image from local
        if let profileImageItem = UserModelManager.shared.imageItems.first(where: { $0.imageUrl == profileURL}) {
            if let profileImage = UserModelManager.shared.images[profileImageItem.imageId]{
                self.profileImageView.image = profileImage
            }
        }else{
            // if image is not available locally
            if let profileURL = URL(string: userModel.photoURL){
                profileURL.loadImage {[weak self] image in
                    if let image{
                        self?.profileImageView.image = image
                    }
                }
            }
        }
    }
    
    private func openEditScreen(){
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileVC else {return}
        
        // defining what to do when dismissed
        vc.onDismissClosure = {[weak self] in
            FirebaseManager().getUserInfo { status in
                if status{
                    self?.setupData()
                }
            }
        }
        
        self.present(vc, animated: true)
    }
    
    private func setupDeleteView(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDeletePrompt))
        deleteProfileView.isUserInteractionEnabled = true
        deleteProfileView.addGestureRecognizer(tapGesture)
    }
    
    @objc func showDeletePrompt(){
        print("Delete?")
        
        let promptView = DeleteAccountView()
        
        promptView.deleteBtnClosure = { [weak self] in
            self?.deleteUserAccount()
            promptView.isHidden = true
        }
        
        promptView.cancelBtnClosure = {
            print("cancel")
            promptView.isHidden = true
        }
        
        let width = view.frame.width * 0.8
        let height = view.frame.height * 0.55
        let x = (view.frame.width - width)/2
        let y = (view.frame.height - height)/2
        promptView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        view.addSubview(promptView)
    }
    
    private func deleteUserAccount(){
        FirebaseManager().deleteUser{ result in
            if result{
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                print("Could not delete account")
            }
        }
    }
}
