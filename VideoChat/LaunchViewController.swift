//
//  LaunchViewController.swift
//  VideoChat
//
//  Created by Evgenia Kucherenko on 17.11.2024.
//

import Foundation
import UIKit

final class LaunchViewController: UIViewController {
    // MARK: - Lifycycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupConstraints()
    }
    
    //MARK: - UI Elements
    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .logo
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let splashImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .splash
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Setup Methods
    private func setupConstraints() {
        view.addSubview(splashImage)
        view.addSubview(logoImage)
       
        NSLayoutConstraint.activate([
            logoImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            logoImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            splashImage.topAnchor.constraint(equalTo: view.topAnchor),
            splashImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            splashImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            splashImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
