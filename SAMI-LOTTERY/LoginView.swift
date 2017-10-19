//
//  LoginView.swift
//  SAMI-LOTTERY
//
//  Created by Nguyễn Khoa on 10/19/17.
//  Copyright © 2017 Nguyễn Khoa. All rights reserved.
//

import UIKit
import Toast_Swift

class LoginView: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var centerY: NSLayoutConstraint!
    
    var viewController = ViewController()
    var dict = [String: Any]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfUserName.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if let path = Bundle.main.path(forResource: "ListAccount", ofType: "plist") {
            dict = NSDictionary(contentsOfFile: path) as! [String : Any]
        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            centerY.constant = -(keyboardRectangle.height/2)
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        centerY.constant = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    @IBAction func hideKB(sender: UIButton) {
        self.view.endEditing(true)
    }
    @IBAction func login(sender: UIButton) {
        if tfUserName.text == nil || tfUserName.text == "" {
            self.view.makeToast("Nhập tên tài khoản trước khi đăng nhập.", duration: 3.0, position: .center)
            return
        }
        if tfPassword.text == nil || tfPassword.text == "" {
            self.view.makeToast("Nhập mật khẩu trước khi đăng nhập.", duration: 3.0, position: .center)
            return
        }
        if tfPassword.text == dict[tfUserName.text!] as? String {
            viewController.accountKey = (tfPassword.text!.characters.first?.description)!
            self.view.removeFromSuperview()
            
        }
        else {
            self.view.makeToast("Tài khoản hoặc mật khẩu không đúng.", duration: 3.0, position: .center)
            return
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
