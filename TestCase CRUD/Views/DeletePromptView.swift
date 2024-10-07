//
//  DeletePromptView.swift
//  TestCase CRUD
//
//  Created by Karan Verma on 07/10/24.
//

import UIKit

class DeleteAccountView: UIView {

    var deleteBtnClosure : (() -> Void)? = nil
    var cancelBtnClosure : (() -> Void)? = nil
    

    // MARK: - UI Elements
    private let warningImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
        imageView.tintColor = .red
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Delete your account?"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = """
        You will lose all of your data by deleting your account.
        
        This includes all of your images and any other data on our servers.
        
        This action cannot be undone.
        """
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("No Do Not Delete and Go Back", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete My Account", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 10
        addSubview(warningImageView)
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(cancelButton)
        addSubview(deleteButton)
    }
    
    @objc func deleteButtonPressed(){
        if let closure = deleteBtnClosure{
            closure()
        }
    }
    
    @objc func cancelButtonPressed(){
        if let closure = cancelBtnClosure{
            closure()
        }
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        warningImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Warning image
            warningImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            warningImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            warningImageView.widthAnchor.constraint(equalToConstant: 50),
            warningImageView.heightAnchor.constraint(equalToConstant: 50),
            
            // Title label
            titleLabel.topAnchor.constraint(equalTo: warningImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Message label
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Cancel button
//            cancelButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 40),
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Delete button
            deleteButton.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 10),
            deleteButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}
