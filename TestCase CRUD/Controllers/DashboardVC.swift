//
//  DashboardVC.swift
//  TestCase CRUD
//
//  Created by Karan Verma on 05/10/24.



import UIKit

class DashboardVC: UIViewController {
    
    @IBOutlet weak var tenantLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var newUserView: UIView!
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var welcomeTextLbl: UILabel!
    
    var displayName : String? = nil
    var isNewUser = false
    var expandableButton: ExpandableButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupExpandableButton()
        setupProfileImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupData()
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        isNewUser = false
        setupView()
    }
}

extension DashboardVC {
    private func setupView() {
        print("setup view called")
            
        if isNewUser == false {
            // animates to hide the new user view
            UIView.animate(withDuration: 0.5) {
                self.newUserView.alpha = 0
                self.profileImageView.alpha = 1
                self.labelStackView.alpha = 1 // showing it slowly
            }
        }
        else {
            let firstName = UserModelManager.shared.userModel?.firstName
            self.welcomeLbl.text = "Welcome, \(firstName ?? "")"
            
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
    
    private func setupExpandableButton() {
        let buttonFrame = CGRect(x: view.frame.width - 80, y: view.frame.height - 100, width: 51, height: 51)
        let _ = ExpandableButton(frame: buttonFrame, parentView: self.view, actions: [
            {
                print("Action 1")
                self.slideInGallery()
            },
            { print("Action 2") },
            { print("Action 3") },
            { print("Action 4") }
        ])
    }
    
    private func slideInGallery(){
        print("slideInGalleryView")
        let galleryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GalleryVC")
        self.navigationController?.pushViewController(galleryVC, animated: true)
    }
    
    private func setupProfileImage() {
        profileImageView.layer.shadowColor = UIColor.black.cgColor
        profileImageView.layer.shadowOpacity = 0.5
        profileImageView.layer.shadowRadius = 4
        profileImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 5
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openProfileInfo))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
    }
    
    @objc func openProfileInfo() {
        print("open profile info")
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileVC") as? ProfileVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupData() {
        if let userModel = UserModelManager.shared.userModel{
            if let profileURL = URL(string: userModel.photoURL){
                profileURL.loadImage {[weak self] image in
                    if let image{
                        self?.profileImageView.image = image
                    }
                }
            }
            self.tenantLbl.text = userModel.tenantId
            self.statusLbl.text = userModel.role
        }
        
    }
}

