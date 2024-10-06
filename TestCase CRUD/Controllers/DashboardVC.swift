////
////  DashboardVC.swift
////  TestCase CRUD
////
////  Created by Karan Verma on 05/10/24.
////
//
//import UIKit
//
//class DashboardVC: UIViewController {
//    
//    @IBOutlet weak var tenantLbl: UILabel!
//    @IBOutlet weak var statusLbl: UILabel!
//    @IBOutlet weak var profileImageView: UIImageView!
//    
//    @IBOutlet var mainView: UIView!
//    
//    @IBOutlet weak var labelStackView: UIStackView!
//    @IBOutlet weak var newUserView: UIView!
//    
//    var isNewUser = true
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        if isNewUser {
//            setupView()
//        }
//
//    }
//
//
//}
//



import UIKit

class DashboardVC: UIViewController {
    

    @IBOutlet weak var tenantLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet var mainView: UIView!

    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var newUserView: UIView!
    
    var isNewUser = true
    var isExpanded = false
    let mainButton = UIButton()
    let button1 = UIButton()
    let button2 = UIButton()
    let button3 = UIButton()
    let button4 = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupButtons()
        setupButtonsActions()
        setupProfileImage()
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        isNewUser = false
        setupView()
    }
}

extension DashboardVC{
    private func setupView(){
        print("setup New User View called")
            
        if isNewUser == false {
            // animates to hide the new user view
            UIView.animate(withDuration: 0.5) {
                self.newUserView.alpha = 0
                self.profileImageView.alpha = 1
                self.labelStackView.alpha = 1 // showing it slowly
            }
        }
        else{
            self.newUserView.alpha = self.isNewUser ? 1 : 0
            self.profileImageView.alpha = 0
            self.labelStackView.alpha = 0 // hiding it
        }
        
        self.newUserView.layer.cornerRadius = 5
        // Add shadow
        self.newUserView.layer.shadowColor = UIColor.black.cgColor
        self.newUserView.layer.shadowOpacity = 0.2
        self.newUserView.layer.shadowOffset = CGSize(width: 2, height: 2) // Right and bottom shadow
        self.newUserView.layer.shadowRadius = 4

        self.newUserView.layer.masksToBounds = false
    }
    
    private func setupButtons() {
        // Setup mainButton
        mainButton.frame = CGRect(x: view.frame.width - 80, y: view.frame.height - 100, width: 51, height: 51)
        mainButton.backgroundColor = UIColor.rgb(40, 34, 139)
        mainButton.tintColor = .white
        mainButton.layer.cornerRadius = 3
        mainButton.setImage(UIImage(systemName: "square.stack.3d.up"), for: .normal)
        mainButton.addTarget(self, action: #selector(toggleExpand), for: .touchUpInside)
        mainButton.layer.shadowColor = UIColor.black.cgColor
        mainButton.layer.shadowOpacity = 0.4
        mainButton.layer.shadowOffset = .init(width: 2, height: -4)
        mainButton.layer.shadowRadius = 4

        view.addSubview(mainButton)

        // Setup other buttons (hidden initially)
        setupActionButton(button: button1, image: UIImage(systemName: "camera"))
        setupActionButton(button: button2, image: UIImage(systemName: "trophy"))
        setupActionButton(button: button3, image: UIImage(systemName: "triangle.lefthalf.filled"))
        setupActionButton(button: button4, image: UIImage(systemName: "circle.circle"))

        // Hide the buttons initially
        toggleButtonVisibility(isHidden: true)
    }

    private func setupActionButton(button: UIButton, image: UIImage?){
        button.frame = CGRect(x: view.frame.width - 80, y: view.frame.height - 100, width: 51, height: 51)
        button.backgroundColor = UIColor.rgb(40, 34, 139) // custom blue color
        button.layer.cornerRadius = 3
        button.setImage(image, for: .normal)
//        if let text{
//            button.setTitle(text, for: .normal)
//            button.configuration?.imagePlacement = .top
//            button.configuration?.titleAlignment = .center
//        }
        button.tintColor = .white
        button.alpha = 0 // hiding by default
        view.addSubview(button)
    }

    @objc private func toggleExpand() {
        isExpanded.toggle()

        if isExpanded {
            UIView.animate(withDuration: 0.3, animations: {
                self.button1.transform = CGAffineTransform(translationX: 0, y: -48)
                self.button2.transform = CGAffineTransform(translationX: 0, y: -96)
                self.button3.transform = CGAffineTransform(translationX: 0, y: -144)
                self.button4.transform = CGAffineTransform(translationX: 0, y: -192)
                
                self.mainButton.layer.cornerRadius = 3

                self.toggleButtonVisibility(isHidden: false)
                self.mainButton.setImage(UIImage(systemName: "xmark"), for: .normal) // Change icon
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.button1.transform = .identity
                self.button2.transform = .identity
                self.button3.transform = .identity
                self.button4.transform = .identity
                
                self.mainButton.layer.cornerRadius = 5


                self.toggleButtonVisibility(isHidden: true)
                self.mainButton.setImage(UIImage(systemName: "square.stack.3d.up"), for: .normal) // Reset icon
            })
        }
    }

    private func toggleButtonVisibility(isHidden: Bool) {
        let alpha: CGFloat = isHidden ? 0 : 1
        self.button1.alpha = alpha
        self.button2.alpha = alpha
        self.button3.alpha = alpha
        self.button4.alpha = alpha
    }
    
    private func setupButtonsActions(){
    }
    
    private func setupProfileImage(){
        profileImageView.layer.cornerRadius = 3
        profileImageView.layer.shadowColor = UIColor.black.cgColor
        profileImageView.layer.shadowOpacity = 0.5
        profileImageView.layer.shadowRadius = 4
        profileImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        profileImageView.backgroundColor = .red
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openProfileInfo))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
    }
    
    @objc func openProfileInfo(){
        print("open profile info")
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
