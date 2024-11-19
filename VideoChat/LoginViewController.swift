//
//  LoginViewController.swift
//  VideoChat
//
//  Created by Evgenia Kucherenko on 17.11.2024.
//

import UIKit
import GoogleSignIn
import AuthenticationServices

final class LoginViewController: UIViewController {

    // MARK: - UI Elements
    private let googleButton: UIButton = {
        let button = UIButton(type: .system)
        
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Sign in with Google"
        configuration.image = UIImage(named: "icon_google")
        configuration.imagePadding = 5
        configuration.imagePlacement = .leading
        configuration.baseBackgroundColor = .grayButton
        configuration.baseForegroundColor = .black
        configuration.cornerStyle = .medium
        
        button.configuration = configuration
        return button
    }()
    
    private let appleButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        return button
    }()
    
    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo_large")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       
        googleButton.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
        appleButton.addTarget(self, action: #selector(handleAppleSignIn), for: .touchUpInside)

        setupViews()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        
        [logoImage, googleButton, appleButton].forEach {
           view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
       
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 165),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: 146),
            logoImage.heightAnchor.constraint(equalToConstant: 120),
            
            googleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleButton.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 30),
            googleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            googleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            googleButton.heightAnchor.constraint(equalToConstant: 50),
            
            appleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleButton.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 25),
            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            appleButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // MARK: - Google Sign-In
    @objc private func handleGoogleSignIn() {
        let clientID = "747016525733-42k2ei1t7ol6rifjng495r0d54df4tqe.apps.googleusercontent.com"
        
        _ = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            if let error = error {
                print("Ошибка входа через Google: \(error.localizedDescription)")
                return
            }

            guard let user = signInResult?.user else {
                print("Ошибка: пользователь не найден")
                return
            }
        }
    }
    
    // MARK: - Apple Sign-In
    @objc private func handleAppleSignIn() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print("User ID: \(credential.user)")
            print("Email: \(credential.email ?? "No Email")")
            print("Full Name: \(credential.fullName?.description ?? "No Name")")
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
