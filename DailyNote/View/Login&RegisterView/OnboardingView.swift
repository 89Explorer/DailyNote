//
//  OnboardingView.swift
//  DailyNote
//
//  Created by 권정근 on 1/15/25.
//

import UIKit

class OnboardingView: UIView {
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "환영합니다!" + "\n" + "오늘 하루는 어땠나요?"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Account", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 30
        button.tintColor = .white
        button.layer.masksToBounds = true
        return button
    }()
    
    private let promptLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인 계정이 있나요?"
        label.tintColor = .white
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.backgroundColor = .white
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBlue
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        addSubview(welcomeLabel)
        addSubview(createAccountButton)
        addSubview(promptLabel)
        addSubview(loginButton)
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            welcomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            welcomeLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -80),
            
            createAccountButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            createAccountButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 30),
            createAccountButton.widthAnchor.constraint(equalTo: welcomeLabel.widthAnchor, constant: -20),
            createAccountButton.heightAnchor.constraint(equalToConstant: 60),
            
            promptLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            promptLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60),
            
            loginButton.centerYAnchor.constraint(equalTo: promptLabel.centerYAnchor),
            loginButton.leadingAnchor.constraint(equalTo: promptLabel.trailingAnchor, constant: 10),
            loginButton.widthAnchor.constraint(equalToConstant: 100),
            loginButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    public func calledcreateButton() -> UIButton {
        return createAccountButton
    }
    
    public func calledloginButton() -> UIButton {
        return loginButton
    }
}
