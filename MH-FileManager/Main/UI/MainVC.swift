//
//  MainVC.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/20/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import VK_ios_sdk
import UIKit

class MainVC: UIViewController, VKSdkUIDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var navigation: MainWireFrame?
    var interactor: MainInteractor?
    var dataSource: [FileObject]?
    
    
    @IBOutlet weak var zipQty: UILabel!
    @IBOutlet weak var txtQty: UILabel!
    @IBOutlet weak var pngQty: UILabel!
    @IBOutlet weak var pdfQty: UILabel!
    @IBOutlet weak var detailTableView: UITableView!
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        signInPressed()
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:authNotification,
                       object:nil, queue:nil,
                       using:catchNotification)
        
        configureNavigationBar()
        interactor?.prepareAllData(){
            [weak self] (array: [FileObject]?) in
            if array != nil {
                DispatchQueue.main.async {
                    self?.dataSource = array
                    self?.detailTableView.delegate = self
                    self?.detailTableView.dataSource = self
                    self?.detailTableView.estimatedRowHeight = 80
                    self?.detailTableView.rowHeight = UITableViewAutomaticDimension
                    
                    self?.detailTableView.setNeedsLayout()
                    self?.detailTableView.layoutIfNeeded()
                    self?.detailTableView.reloadData()
                    self?.zipQty.text = "\(DataSource.shared.zipFile)"
                    self?.txtQty.text = "\(DataSource.shared.txtFile)"
                    self?.pngQty.text = "\(DataSource.shared.pngFile)"
                    self?.pdfQty.text = "\(DataSource.shared.pdfFile)"
                }
            }
        }

    }
    
    func signInPressed() {
        interactor?.networkManager.sdkInstance?.uiDelegate = self as VKSdkUIDelegate
        interactor?.networkManager.getTokenWithSDK() {
            [weak self] (error: Error?) in
            if let erro = error {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert", message: erro.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self?.setUserProfile()
                }
            }
        }
    }
    
    func configureNavigationBar() {
        
            interactor?.networkManager.userInfo.getUserdataFromDefaults()
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOut))
            if let font = UIFont(name: "Menlo", size: 17) {
                navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName:font], for: .normal)
            }
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    

    
    func setUserProfile() {
        let navbar = navigation?.navigationController?.navigationBar as! UserNavBar
        
        navbar.setNavigationBar(withImage: interactor?.networkManager.userInfo.photo_50, username: interactor?.networkManager.userInfo.userFirstName, userLastName: interactor?.networkManager.userInfo.userLastName, userNickname: interactor?.networkManager.userInfo.userNickName)
    }
    
    func setDefaultProfile() {
        let navbar = navigation?.navigationController?.navigationBar as! UserNavBar
        
        navbar.imageView?.image = UIImage.init(named: "vk")
        navbar.imageView?.maskDownloadImageView()
        navbar.username?.text = ""
    }
    
    func signOut() {
        if navigationItem.rightBarButtonItem?.tag == 0 && interactor?.networkManager.token.token == nil {
            interactor?.makeSignOut()
            navigationItem.rightBarButtonItem?.title = "Sign in"
            navigationItem.rightBarButtonItem?.tag = 5
            setDefaultProfile()
        } else {
            signInPressed()
            navigationItem.rightBarButtonItem?.tag = 0
            navigationItem.rightBarButtonItem?.title = "Sign out"
        }
        
    }
    
    // Notifications
    
    func catchNotification(notification:Notification) -> Void {
        navigationItem.rightBarButtonItem?.title = "Sign in"
        navigationItem.rightBarButtonItem?.tag = 5
        setDefaultProfile()
       
    }
    // VKSDK UI Delegate
    
    public func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.present(controller, animated: true, completion: nil)
    }
    
    public func vkSdkNeedCaptchaEnter(_ captchaError: VKError!){
        let vc = VKCaptchaViewController.captchaControllerWithError(captchaError)
        vc?.present(in: self)
    }
    
    // UITableViewCell Delegate
 
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (dataSource?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fileInfo = dataSource?[indexPath.row] as! FileObject
        var cell: FileCell?

        switch fileInfo.type {
        case .Text:
            let cellText = tableView.dequeueReusableCell(withIdentifier: "TextFileCell", for: indexPath) as? TextFileCell
            let objText = fileInfo as! TXTFile
            cellText?.configureCell(fileObj:objText)
            cell = cellText
         case .PDF:
            let obj = fileInfo as! PDFFile
            let cellText = tableView.dequeueReusableCell(withIdentifier: "PDFFileCell", for: indexPath) as? PdfFileCell
            cellText?.configureCell(fileObj:obj)
            cellText?.delegate = navigation!
            cell = cellText
        case .PNG:
            let obj = fileInfo as! PNGFile
            let cellText = tableView.dequeueReusableCell(withIdentifier: "ImageFileCell", for: indexPath) as? ImageFileCell
            cellText?.configureCell(fileObj:obj)
            cell = cellText
        case .ZIP:
            cell = tableView.dequeueReusableCell(withIdentifier: "FileCell", for: indexPath) as? FileCell
            cell?.configureCell(fileObj:fileInfo)
        default:
            break
        }
       return cell!
    }
    
    // Status Bar appearance
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Deinit
    
    deinit {
        print("****Main deinit****")
        NotificationCenter.default.removeObserver(self, name: authNotification, object: nil)
    }
}
