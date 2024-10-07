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
    var userModel : UserModel?
    
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
    }
    
    private func setupData(){
        guard let userModel else {
            print("userModel not found in Profile Screen")
            return
        }
        
        userNameLbl.text = userModel.firstName + " " + userModel.lastName
        userNumberLbl.text = userModel.email
        accountLbl.text = userModel.userId
        let date = Date(timeIntervalSince1970: TimeInterval(userModel.dateCreated))
        createdOnLbl.text = date.formatted(date: .abbreviated, time: .omitted)
        roleLbl.text = userModel.role
        tenantLbl.text = userModel.tenantId
        
        
    }
    
    private func openEditScreen(){
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileVC else {return}
        
        vc.userModel = self.userModel
        
        // defining what to do when dismissed
        vc.onDismissClosure = {[weak self] in
            FirebaseManager().getUserInfo { status, userModel in
                if status, let userModel = userModel{
                    self?.userModel = userModel
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
        
        promptView.cancelBtnClosure = { [weak self] in
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
                print("Could Not delete account")
            }
        }
    }
}
