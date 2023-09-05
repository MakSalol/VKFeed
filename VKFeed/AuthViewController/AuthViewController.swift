//
//  ViewController.swift
//  VKNewsFeed
//
//  Created by Максим on 02.06.2023.
//

import UIKit

class AuthViewController: UIViewController, AuthServiceDelegate {
    

    private var authService: AuthService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        authService = AppDelegate.shared().authService
        authService.delegate = self
    }

    @IBAction func signInButton() {
        authService.wakeUpSession()
    }
    
    
    func authServiceShouldShow(_ viewController: UIViewController) {
        print(#function)
        self.present(viewController, animated: true)
    }
    
    func authServiceSignIn() {
        print(#function)
        let feedVC = UIStoryboard(name: "NewsfeedViewController", bundle: nil).instantiateInitialViewController() as! NewsfeedViewController
        
        let navVC = UINavigationController(rootViewController: feedVC)
        navVC.modalPresentationStyle = .fullScreen
        navVC.modalTransitionStyle = .crossDissolve
        
        self.present(navVC, animated: true)
    }
    
    func authServiceDidSignInFail() {
        print(#function)
    }
    
}

