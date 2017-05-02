//
//  MainVC.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/20/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import VK_ios_sdk
import UIKit

class MainVC: UIViewController, VKSdkUIDelegate, UITableViewDelegate, UITableViewDataSource, MainInteractorUpdateProtocol {
    
    var navigation: MainWireFrame?
    var interactor: MainInteractor?
    var dataSource: [FileObject]?
    var dataSourceSavedObjects: [FileObject] = []
    var headerTitles = ["Files in Documents", "Files Saved"]
    
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
        interactor?.delegate = self
        interactor?.prepareAllData(){
            [weak self] (array: [FileObject]?, savedObjects:[FileObject]?) in
            if array != nil {
                DispatchQueue.main.async {
                    self?.dataSource = array
                    if let saved = savedObjects {
                        self?.dataSourceSavedObjects = saved
                    }
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
        
        navigationItem.rightBarButtonItem?.title = "Sign out"
        navigationItem.rightBarButtonItem?.action = #selector(signOut)
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
        
        interactor?.makeSignOut()
        navigationItem.rightBarButtonItem?.title = "Sign in"
        navigationItem.rightBarButtonItem?.action = #selector(signInPressed)
        setDefaultProfile()
        
    }
    
    // MARK:- Notifications
    
    func catchNotification(notification:Notification) -> Void {
        navigationItem.rightBarButtonItem?.title = "Sign in"
        navigationItem.rightBarButtonItem?.tag = 5
        setDefaultProfile()
        
    }
    // MARK:- VKSDK UI Delegate
    
    public func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.present(controller, animated: true, completion: nil)
    }
    
    public func vkSdkNeedCaptchaEnter(_ captchaError: VKError!){
        let vc = VKCaptchaViewController.captchaControllerWithError(captchaError)
        vc?.present(in: self)
    }
    
    // MARK:- UITableViewCell Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if dataSourceSavedObjects.count > 0 {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (dataSource?.count)!
        } else {
            return dataSourceSavedObjects.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: FileCell?
        var fileInfo: FileObject!
        let sectionTwo = indexPath.section == 1 ? true : false
        if indexPath.section == 1 {
            fileInfo = dataSourceSavedObjects[indexPath.row]
        } else {
            fileInfo = dataSource?[indexPath.row]
        }
        guard let file = fileInfo else {
            return cell!
        }
        switch file.type {
        case FileType.Text:
            let cellText = tableView.dequeueReusableCell(withIdentifier: "TextFileCell", for: indexPath) as? TextFileCell
            let objText = fileInfo as! TXTFile
            cellText?.configureCell(fileObj:objText, inSpecialSection: sectionTwo)
            cell = cellText
        case .PDF:
            let obj = fileInfo as! PDFFile
            let cellText = tableView.dequeueReusableCell(withIdentifier: "PDFFileCell", for: indexPath) as? PdfFileCell
            cellText?.configureCell(fileObj:obj, inSpecialSection: sectionTwo)
            cellText?.delegatePDF = navigation!
            cell = cellText
        case .PNG:
            let obj = fileInfo as! PNGFile
            let cellText = tableView.dequeueReusableCell(withIdentifier: "ImageFileCell", for: indexPath) as? ImageFileCell
            cellText?.configureCell(fileObj:obj, inSpecialSection: sectionTwo)
            cell = cellText
        case .ZIP:
            let cellText = tableView.dequeueReusableCell(withIdentifier: "ZipCell", for: indexPath) as? ZipFileCell
            cellText?.configureCell(fileObj:file, inSpecialSection: sectionTwo)
            cellText?.delegateZip = self.interactor
            cell = cellText
        default:
            break
        }
        cell?.delegate = self.interactor
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headerTitles.count
    }
    
    // MARK:- MainInteractorUpdateProtocol
    
    func updateData(newArray array: [FileObject]?, newSavedArray savedObjects:[FileObject]?) {
        dataSource = array
        if savedObjects != nil {
            dataSourceSavedObjects = savedObjects!
        }
        detailTableView.reloadData()
        zipQty.text = "\(DataSource.shared.zipFile)"
        txtQty.text = "\(DataSource.shared.txtFile)"
        pngQty.text = "\(DataSource.shared.pngFile)"
        pdfQty.text = "\(DataSource.shared.pdfFile)"
    }
    
    // MARK:- Status Bar appearance
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK:- Deinit
    
    deinit {
        print("****Main deinit****")
        NotificationCenter.default.removeObserver(self, name: authNotification, object: nil)
    }
}
