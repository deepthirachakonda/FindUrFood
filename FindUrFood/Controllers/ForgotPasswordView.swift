//
//  ForgotPasswordView.swift
//  FindUrFood
//
//  Created by Abhinay kukkadapu on 12/13/19.
//  Copyright © 2019 Deepthi. All rights reserved.
//

import UIKit

class ForgotPasswordView: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var forgotPwdButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupUI()
    }
    
    func setupUI(){
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        self.setupLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setupLayouts(){
        emailTF.layer.cornerRadius = 25
        emailTF.layer.masksToBounds = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: emailTF.frame.height))
        emailTF.leftView = paddingView
        emailTF.leftViewMode = .always
        emailTF.delegate = self
        
        self.forgotPwdButton.layer.cornerRadius = self.forgotPwdButton.frame.height/2
        self.forgotPwdButton.layer.masksToBounds = true
        self.forgotPwdButton.setImage(ImageNames.arrow.maskWithColor(UIColor.white), for: .normal)
        self.forgotPwdButton.backgroundColor = Colors.dark_skyBlue
    }
    
    @IBAction func forgotPwdClicked(_ sender: UIButton) {
       if self.emailTF.text == "" {
            CommonAlertView.shared.showAlert("Email ID", "Please enter email id", .normal)
            return
        }
        if let userDetails = usersList.filter({$0.emailId == self.emailTF.text!}).first {
            CommonAlertView.shared.showAlert("Password", userDetails.password, .normal)
        }else{
            CommonAlertView.shared.showAlert("Email not registered", "Please enter registered email id", .normal)
        }
    }
    
    
    @IBAction func loginClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ForgotPasswordView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
