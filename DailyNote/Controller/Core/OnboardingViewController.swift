//
//  OnboardingViewController.swift
//  DailyNote
//
//  Created by 권정근 on 1/15/25.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    private let onboardingView: OnboardingView = {
        let view = OnboardingView()
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        configureCosntarints()
        didTappedCreateButton()
    }
    
    
    private func configureCosntarints() {
        view.addSubview(onboardingView)
        
        onboardingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            onboardingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            onboardingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            onboardingView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            onboardingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            
        ])
    }
    
    private func didTappedCreateButton() {
        onboardingView.calledcreateButton().addTarget(self, action: #selector(tappedCreateButton), for: .touchUpInside)
    }
    
    private func didTappedLoginButton() {
        onboardingView.calledloginButton().addTarget(self, action: #selector(tappedLoginButton), for: .touchUpInside)
    }
    
    @objc private func tappedCreateButton() {
        print("tappedCreateButton - called")
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @objc private func tappedLoginButton() {
        print("tappedLoginButon - called")
    }
    
}
