//
//  ViewController.swift
//  TestCase CRUD
//
//  Created by Karan Verma on 03/10/24.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordFiels: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!

    @IBOutlet weak var signupLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginBtn()
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
    }
    
    private func handleSignup(){
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC else {return}
        
        self.present(vc, animated: true)
    }   
}
