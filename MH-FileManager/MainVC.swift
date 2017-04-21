//
//  MainVC.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/20/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var navigation: MainWireFrame?
    var interactor: MainInteractor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signInPressed(_ sender: Any) {
        
        
    }

    func configureNavigationBar() {
        navigationItem.hidesBackButton = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOut))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        navigationController?.title = interactor?.getCurrentUserInfo()
    }
    
    func signOut() {
    
        interactor?.makeSignOut()
        navigation?.popToLoginVCInWindow()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
