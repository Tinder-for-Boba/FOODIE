//
//  LoginViewController.swift
//  app
//
//  Created by Paul Pan on 20/4/11.
//  Copyright © 2020 Foodie Inc. All rights reserved.
//

import UIKit
import YogaKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    lazy var foodieLogo: UIImageView = {
        let logo = UIImageView(image: UIImage(named: "FoodieLogo"))
        logo.styleLoginLogo(safeAreaTop: view.safeAreaInsets.top)
        return logo
    }()
    
    lazy var emailTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Email"
        textfield.styleAuth()
        return textfield
    }()
    
    lazy var passwordTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Password"
        textfield.isSecureTextEntry = true
        textfield.styleAuth()
        return textfield
    }()
    
    lazy var loginButtonsView: LoginButtonsView = {
        let buttonsView = LoginButtonsView()
        buttonsView.styleLoginButtons()
        return buttonsView
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.styleAuth()
        button.addTarget(self, action: #selector(loginPressed(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("Signup", for: .normal)
        button.styleAuth()
        button.addTarget(self, action: #selector(signupPressed(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var signupViewController: SignupViewController = {
        let viewController = SignupViewController()
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }()
    
    lazy var preferenceNavigator: UINavigationController = {
        let bottomTabBarController = BottomTabBarController()
        let navigationController = UINavigationController(rootViewController: bottomTabBarController)
        navigationController.modalPresentationStyle = .overFullScreen
        return navigationController
    }()
    
    lazy var alertPopup: UIAlertController = {
        let alert = UIAlertController(title: "Login Failed", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }()

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        hideKeyboardWhenTappedAround()
        styleAuthViewController()
        addSubviewsAndEnableStyle()
    }
    
    func addSubviewsAndEnableStyle() {
        view.addSubview(foodieLogo)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        loginButtonsView.addSubview(loginButton)
        loginButtonsView.addSubview(signupButton)
        view.addSubview(loginButtonsView)
        view.yoga.applyLayout(preservingOrigin: true)
    }

    @objc func loginPressed(sender: UIButton!) {
        //let restaurantTableViewCell = RestaurantTableViewCell()
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if error == nil {
                strongSelf.present(strongSelf.preferenceNavigator, animated: true, completion: nil)
            } else {
                strongSelf.alertPopup.message = error?.localizedDescription
                strongSelf.present(strongSelf.alertPopup, animated: true, completion: nil)
            }
        }
    }

    @objc func signupPressed(sender: UIButton!) {
        self.present(signupViewController, animated: true, completion: nil)
    }
}
