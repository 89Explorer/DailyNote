//
//  RegisterViewController.swift
//  DailyNote
//
//  Created by 권정근 on 1/15/25.
//

import UIKit

class RegisterViewController: UIViewController {
    
    private let registerView: RegisterView = {
        let view = RegisterView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        configureConstraints()
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // MARK: - Functions
    private func configureConstraints() {
        view.addSubview(registerView)
        
        registerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            registerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            registerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            registerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            registerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            
        ])
    }
}
