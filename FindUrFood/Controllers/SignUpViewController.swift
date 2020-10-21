//
//  SignUpViewController.swift
//  FindUrFood
//
//  Created by Abhinay kukkadapu on 12/13/19.
//  Copyright © 2019 Deepthi. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setupUI(){
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        
        self.signUpButton.layer.cornerRadius = self.signUpButton.frame.height/2
        self.signUpButton.layer.masksToBounds = true
        self.signUpButton.setImage(ImageNames.arrow.maskWithColor(UIColor.white), for: .normal)
        self.signUpButton.backgroundColor = Colors.dark_skyBlue
        
        for case let textField as UITextField in self.view.subviews {
            textField.layer.cornerRadius = 25
            textField.layer.masksToBounds = true
           
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
            textField.leftView = paddingView
            textField.leftViewMode = .always
            textField.delegate = self
        }
    }
    
    @IBAction func signUpClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.nameTF.text == "" {
            CommonAlertView.shared.showAlert("User Name", "Please enter user name", .normal)
            return
        }
        else if self.emailTF.text == "" {
            CommonAlertView.shared.showAlert("Email ID", "Please enter email id", .normal)
            return
        }
        else if self.passwordTF.text == "" {
            CommonAlertView.shared.showAlert("Password", "Please enter password", .normal)
            return
        }
        
        let userExists = usersList.filter({$0.emailId == self.emailTF.text!}).count > 0
        
        if !userExists {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let plistPath = appDelegate.localPlistPath
            
            if usersList.count == 0 {
                var usersListArray = [[String:String]]()
                var newUser = [String:String]()
                newUser["User Name"] = self.nameTF.text!
                newUser["Email"] = self.emailTF.text!
                newUser["Password"] = self.passwordTF.text!
                usersListArray.append(newUser)
                
                (usersListArray as NSArray).write(toFile: plistPath, atomically: false)
                
                let userModel = UserModel()
                userModel.userName = self.nameTF.text!
                userModel.emailId = self.emailTF.text!
                userModel.password = self.passwordTF.text!
                usersList.append(userModel)
                let alert = UIAlertController(title: "", message: "Account successfully created", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive, handler: { action in
                    self.navigateToHomeScreen()

                }))
                self.present(alert, animated: true, completion: nil)
                
            }else{
                self.saveUserToDatabase(plistPath: plistPath)
            }
            
        }
            
        else {
            CommonAlertView.shared.showAlert("Email already exits", "Please try with another email Id", .normal)
        }
    }
    
    func saveUserToDatabase(plistPath:String){
        if let data =  FileManager.default.contents(atPath: plistPath) as Data? {
            do{
                if var usersListArray = try PropertyListSerialization.propertyList(from: data, options: PropertyListSerialization.MutabilityOptions.mutableContainersAndLeaves, format: nil) as? [[String:String]] {
                    var newUser = [String:String]()
                    newUser["User Name"] = self.nameTF.text!
                    newUser["Email"] = self.emailTF.text!
                    newUser["Password"] = self.passwordTF.text!
                    usersListArray.append(newUser)
                    
                    (usersListArray as NSArray).write(toFile: plistPath, atomically: false)
                    
                    let userModel = UserModel()
                    userModel.userName = self.nameTF.text!
                    userModel.emailId = self.emailTF.text!
                    userModel.password = self.passwordTF.text!
                    usersList.append(userModel)
                }
            }catch{
                print("Error occured while reading from the plist file")
            }
        }
        
    }
    
    func navigateToHomeScreen(){
        self.nameTF.text = ""
        self.emailTF.text = ""
        self.passwordTF.text = ""
        let filterView = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        self.navigationController?.pushViewController(filterView, animated: true)
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SignUpViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
