//
//  SignUpVC.swift
//  TestCase CRUD
//
//  Created by Karan Verma on 03/10/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpVC: UIViewController {

    var userModel : UserModel?
    // IB Outlets
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var mobileNumField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var signinPageBtn: UIButton!
    
    // Properties
    var checkboxTicked = false {
        didSet{
            let image = UIImage(systemName: checkboxTicked ? "checkmark.square.fill" : "square.fill")
            checkbox.setImage(image, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func signinPagePressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        handleSignup()
    }
    
    @IBAction func goBackBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chechboxTapped(_ sender: Any) {
        checkboxTicked.toggle()
    }
}

extension SignUpVC {
    private func setupViews(){
        signupBtn.layer.cornerRadius = 5
    }
    
    private func handleSignup(){
        guard let email = emailField.text else {
            print("No email Found")
            return
        }
        
        guard let password = passwordField.text else{
            print("enter Password")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authDataResult, error in
            if error != nil{
                print("Error while signup: \(error?.localizedDescription ?? "")")
                return
            }
            
            if let user = authDataResult?.user{
                UserDefaults.standard.set(user.uid, forKey: "userId")
                self?.addInfoToStore(for: user)
            }
            
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DashboardVC") as? DashboardVC else {return}
            
            vc.displayName = self?.firstNameField.text
            vc.isNewUser = true
            vc.userModel = self?.userModel
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func addInfoToStore( for user: FirebaseAuth.User){
        
        guard let firstName = firstNameField.text else{
            print("Enter First Name")
            return
        }
        
        guard let lastName = lastNameField.text else{
            print("Enter Last Name")
            return
        }
        
        let mobileNumber = mobileNumField.text
        
        let userInfo : [String: Any]=[
            "userId": user.uid,
            "email": user.email ?? "",
            "firstName": firstName,
            "lastName": lastName,
            "tenantId": "TESLA",
            "role": "securityLevel1",
            "dateCreated": Int(Date().timeIntervalSince1970),
            "mobileNumber": mobileNumber ?? ""
        ]
        
        self.userModel = userInfo.toUserModel() // also locally storing userModel created
        
        let db = Firestore.firestore()
        
        db.collection("users").document(user.uid).setData(userInfo){error in
            if let error{
                print("Error in saving userinfo: \(error.localizedDescription)")
            }
            else{
                print("Successfully saved user to Firestore")
            }
            
        }
    }
}


