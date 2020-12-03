//
//  AppUtility.swift
//  Demo_Code
//
//  Created by Diken Shah on 04/12/20.
//

import Foundation
import UIKit

//MARK:- Alert View
func showAlertWithTitle(title: String,message: String, viewController : UIViewController!){
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let btnOKAction = UIAlertAction(title: StringConstant.Ok, style: .default) { (action) -> Void in
    }
    alertController.addAction(btnOKAction)
    DispatchQueue.main.async {
        viewController.present(alertController, animated: true, completion: nil)
    }
}
