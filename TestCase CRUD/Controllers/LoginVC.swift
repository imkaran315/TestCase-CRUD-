//
//  ViewController.swift
//  TestCase CRUD
//
//  Created by Karan Verma on 03/10/24.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordFiels: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!

    @IBOutlet weak var signupLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginBtn()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func forgotPassowordPressed(_ sender: Any) {
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        handleLogin()
    }
    @IBAction func signupPressed(_ sender: Any) {
        handleSignup()
    }
}

extension LoginVC{
    func setupLoginBtn(){
        loginBtn.layer.cornerRadius = 5
    }
    
    private func handleLogin(){
        print("Login Pressed")
        
        Auth.auth().signIn(withEmail: emailField.text ?? "", password: passwordFiels.text ?? ""){ [weak self] authResult, error in
            
            if error != nil{
                print("error in signin : \(String(describing: error))")
                return
            }
            
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC else {return}
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func handleSignup(){
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
