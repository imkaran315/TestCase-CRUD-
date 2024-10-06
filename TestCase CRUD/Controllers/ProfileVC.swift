//
//  ProfileVC.swift
//  TestCase CRUD
//
//  Created by Karan Verma on 06/10/24.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var deleteProfileView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDeleteView()
    }
}

extension ProfileVC {
    private func setupDeleteView(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDeletePrompt))
        deleteProfileView.isUserInteractionEnabled = true
        deleteProfileView.addGestureRecognizer(tapGesture)
    }
    
    @objc func showDeletePrompt(){
        print("Delete?")
    }

}
