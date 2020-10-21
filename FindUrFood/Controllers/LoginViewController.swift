//
//  LoginViewController.swift
//  FindUrFood
//
//  Created by Abhinay kukkadapu on 12/13/19.
//  Copyright © 2019 Deepthi. All rights reserved.
//

import UIKit


var usersList = [UserModel]()

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPwdButton: UIButton!
    
    
    var plistPath = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setupUI()
        self.loadUsers()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    func setupUI(){
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        
        self.loginButton.layer.cornerRadius = self.loginButton.frame.height/2
        self.loginButton.layer.masksToBounds = true
        self.loginButton.setImage(ImageNames.arrow.maskWithColor(UIColor.white), for: .normal)
        self.loginButton.backgroundColor = Colors.dark_skyBlue
        
        self.setCorners(textField: self.emailTF, radius: 23)
        self.setCorners(textField: self.passwordTF, radius: 23
        )
        
    }
    
    func setCorners(textField:UITextField,radius:CGFloat) {
        textField.layer.cornerRadius = radius
        textField.layer.masksToBounds = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.delegate = self
    }
    
    
    @IBAction func loginClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.emailTF.text == "" {
            CommonAlertView.shared.showAlert("Email ID", "Please enter email id", .normal)
            return
        }
        else if self.passwordTF.text == "" {
            CommonAlertView.shared.showAlert("Password", "Please enter password", .normal)
            return
        }
        
        if let userDetails = usersList.filter({$0.emailId == self.emailTF.text!}).first {
            if userDetails.password == self.passwordTF.text {
                self.emailTF.text = ""
                self.passwordTF.text = ""
                let filterView = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
                self.navigationController?.pushViewController(filterView, animated: true)
            }else{
                CommonAlertView.shared.showAlert("Invalid password", "Please enter valid Password", .normal)
            }
        }else{
            CommonAlertView.shared.showAlert("Invalid email", "Please enter valid email", .normal)
        }
        
    }
    
    @IBAction func signUpClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        let signUpView = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signUpView, animated: true)
    }
    
    @IBAction func forgotPwdClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        let forgotPwdView = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordView") as! ForgotPasswordView
        self.navigationController?.pushViewController(forgotPwdView, animated: true)
    }
    
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension LoginViewController {
    
    func loadUsers(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        plistPath = appDelegate.localPlistPath
       // print(plistPath)
        // Extract the content of the file as NSData
        if let data =  FileManager.default.contents(atPath: plistPath) as Data? {
            do{
                if let usersArray = try PropertyListSerialization.propertyList(from: data, options: PropertyListSerialization.MutabilityOptions.mutableContainersAndLeaves, format: nil) as? [[String:String]] {
                    for userDetails in usersArray {
                        let userModel = UserModel()
                        userModel.userName = userDetails["User Name"] ?? ""
                        userModel.emailId = userDetails["Email"] ?? ""
                        userModel.password = userDetails["Password"] ?? ""
                        usersList.append(userModel)
                    }
                }
            }catch{
                print("Error occured while reading from the plist file")
            }
        }
    }
}
