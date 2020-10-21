//
//  Utilities.swift
//  ShiftBoss
//
//  Created by Abhinay kukkadapu on 12/13/19.
//  Copyright © 2019 Deepthi. All rights reserved.
//

import Foundation
import UIKit



enum AlertType : String
{
    case normal
}


class CommonAlertView {
    static let shared = CommonAlertView()
    
    private init(){}
    
    func showAlert(_ title: String,_ message:String,_ alertType:AlertType) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        if let topViewController = self.topMostController() {
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    func topMostController() -> UIViewController? {
        guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else {
            return nil
        }
        
        var topController = rootViewController
        
        while let newTopController = topController.presentedViewController {
            topController = newTopController
        }
        
        return topController
    }
    
}
