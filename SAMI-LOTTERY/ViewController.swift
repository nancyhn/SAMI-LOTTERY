//
//  ViewController.swift
//  SAMI-LOTTERY
//
//  Created by Nguyễn Khoa on 10/18/17.
//  Copyright © 2017 Nguyễn Khoa. All rights reserved.
//

import UIKit
import SwiftyJSON
import MessageUI

class ViewController: UIViewController, UITextFieldDelegate, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var tfNhat: UITextField!
    @IBOutlet weak var tfNhi1: UITextField!
    @IBOutlet weak var tfNhi2: UITextField!
    @IBOutlet weak var tfBa1: UITextField!
    @IBOutlet weak var tfBa2: UITextField!
    @IBOutlet weak var tfBa3: UITextField!
    @IBOutlet weak var tfBa4: UITextField!
    @IBOutlet weak var tfBa5: UITextField!
    @IBOutlet weak var tfBa6: UITextField!
    @IBOutlet weak var tfTu1: UITextField!
    @IBOutlet weak var tfTu2: UITextField!
    @IBOutlet weak var tfTu3: UITextField!
    @IBOutlet weak var tfTu4: UITextField!
    @IBOutlet weak var tfNam1: UITextField!
    @IBOutlet weak var tfNam2: UITextField!
    @IBOutlet weak var tfNam3: UITextField!
    @IBOutlet weak var tfNam4: UITextField!
    @IBOutlet weak var tfNam5: UITextField!
    @IBOutlet weak var tfNam6: UITextField!
    @IBOutlet weak var tfSau1: UITextField!
    @IBOutlet weak var tfSau2: UITextField!
    @IBOutlet weak var tfSau3: UITextField!
    @IBOutlet weak var tfBay1: UITextField!
    @IBOutlet weak var tfBay2: UITextField!
    @IBOutlet weak var tfBay3: UITextField!
    @IBOutlet weak var tfBay4: UITextField!
    @IBOutlet weak var tfDB: UITextField!
    
    @IBOutlet weak var botContranst: NSLayoutConstraint!
    
    var textFieldOriginY : CGFloat = 0
    var keyboardHeight : CGFloat = 0
    var arrTextField = Array<UITextField>()
    var accountKey : String = "" {
        didSet {
            print("~~~~~~~~~~~\(accountKey)")
            
            tfNhat.becomeFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.hideKeyboardWhenTappedAround()
        
        arrTextField = [tfNhat, tfNhi1, tfNhi2, tfBa1, tfBa2, tfBa3, tfBa4, tfBa5, tfBa6, tfTu1, tfTu2, tfTu3, tfTu4, tfNam1, tfNam2, tfNam3, tfNam4, tfNam5, tfNam6, tfSau1, tfSau2, tfSau3, tfBay1, tfBay2, tfBay3, tfBay4, tfDB]
        configTextField()
        addExKBView()
        
        for i in 0..<arrTextField.count {
            let tf = arrTextField[i]
            tf.border(color: UIColor.gray)
            if i == 0 {
                tf.isUserInteractionEnabled = true
                
            }
            else {
                tf.isUserInteractionEnabled = false
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        checkLogin()
    }
    lazy var login : LoginView = {
        let lg = LoginView.init(nibName: "LoginView", bundle: nil)
        lg.viewController = self
        return lg
    }()
    func checkLogin() {
        login.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        
        self.view.addSubview(login.view)
        UIView.animate(withDuration: 0.3, animations: {
            self.login.view.frame = CGRect(x: 0, y: (self.view.frame.height - self.login.view.frame.size.height)/2, width: self.view.frame.width, height: self.view.frame.height)
        })
    }
    var strInTF = String()
    var tagPrevious : Int = 0
    @IBAction func sendResult(sender: UIButton) {
        strInTF = "tt "
        for i in 0..<arrTextField.count {
            let tf = arrTextField[i]
            if tagPrevious != 0 || tagPrevious != tf.tag {
                
            }
            tagPrevious = tf.tag
            if tf.text == "" || tf.text == nil {
                strInTF = String.init(format: "%@-%@", strInTF, createEmptyString(lenght: tf.tag))
            }
            else {
                if tf.text!.characters.count == tf.tag {
                    strInTF = String.init(format: "%@-%@", strInTF, tf.text!)
                }
                else {
                    tf.textColor = UIColor.red
                    return
                }
            }
        }
        let dataPost : [String: Any] = ["result" : strInTF]
        ApiService.sharedInstance.send_loterry_data(dataPost: dataPost, { jsonData in
            print(jsonData)
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = self.strInTF.replacingOccurrences(of: "-", with: self.accountKey)
                controller.recipients = ["8050"]
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }
        })
        print(strInTF)
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController!, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    func createEmptyString(lenght: Int) -> String {
        var str = ""
        for _ in 0..<lenght {
            str = str + "-"
        }
        return str
    }
    @objc func keyboardWillShow(notification: NSNotification) {

        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height

            viewExKB.frame = CGRect(x: 0, y: self.view.frame.height - keyboardHeight - 40, width: viewExKB.frame.width, height: viewExKB.frame.height)
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        self.botContranst.constant = 0
        viewExKB.frame = CGRect(x: 0, y: self.view.frame.height, width: viewExKB.frame.width, height: viewExKB.frame.height)
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    var viewExKB = UIView()
    func addExKBView () {
        viewExKB = UIView.init(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 40))
        viewExKB.isUserInteractionEnabled = true
        viewExKB.backgroundColor = UIColor.white
        
        let btnSend = UIButton.init(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        btnSend.backgroundColor = UIColor.black
        btnSend.setTitleColor(UIColor.white, for: .normal)
        btnSend.addTarget(self, action: #selector(sendResult(sender:)), for: .touchUpInside)
        btnSend.setTitle("SEND", for: .normal)
        viewExKB.addSubview(btnSend)
        
        let btnHideKB = UIButton.init(frame: CGRect(x: self.view.frame.width - 120, y: 0, width: 120, height: 40))
        btnHideKB.backgroundColor = UIColor.black
        btnHideKB.setTitleColor(UIColor.white, for: .normal)
        btnHideKB.addTarget(self, action: #selector(hideKB), for: .touchUpInside)
        btnHideKB.setTitle("HIDE", for: .normal)
        viewExKB.addSubview(btnHideKB)
        self.view.addSubview(viewExKB)
        
    }
    func addSwipe() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.viewExKB.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.viewExKB.addGestureRecognizer(swipeDown)
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        print(sender.direction)
    }
    @objc func hideKB() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        
        if textField == tfNhat || textField == tfNhi1 || textField == tfNhi2 || textField == tfBa1 || textField == tfBa2 || textField == tfBa3 || textField == tfBa4 || textField == tfBa5 || textField == tfBa6 || textField == tfDB {
            return newLength <= 5
        }
        else if textField == tfTu1 || textField == tfTu2 || textField == tfTu3 || textField == tfTu4 || textField == tfNam1 || textField == tfNam2 || textField == tfNam3 || textField == tfNam4 || textField == tfNam5 || textField == tfNam6 {
            return newLength <= 4
        }
        else if textField == tfSau1 || textField == tfSau2 || textField == tfSau3 {
            return newLength <= 3
        }
        else if textField == tfBay1 || textField == tfBay2 || textField == tfBay3 || textField == tfBay4 {
            return newLength <= 2
        }
        else {return newLength <= 5}
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldOriginY = (textField.superview?.frame.origin.y)! + (textField.superview?.frame.height)!
        if self.view.frame.height - textFieldOriginY < keyboardHeight {
            self.botContranst.constant = keyboardHeight - (self.view.frame.height - textFieldOriginY) + 40
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: ------------------CONFIG TEXT FIELD------------------------
    func configTextField() {
        tfNhat.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfNhi1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfNhi2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfBa1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfBa2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfBa3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfBa4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfBa5.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfBa6.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfTu1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfTu2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfTu3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfTu4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfNam1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfNam2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfNam3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfNam4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfNam5.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfNam6.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfSau1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfSau2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfSau3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfBay1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfBay2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfBay3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfBay4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        tfDB.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    }
    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        //textField.tfColor(color: UIColor.black)
        if textField == tfDB {
            if text?.characters.count == 5 {
                tfDB.tfColor(color: UIColor.init(hex: "#ee2a2a"))
                textField.resignFirstResponder()
            }
            return
        }
        if text?.characters.count == 5 {
            switch textField{
            case tfNhat:
                tfNhat.tfColor(color: UIColor.init(hex: "#36b548"))
                tfNhi1.isUserInteractionEnabled = true
                tfNhi1.becomeFirstResponder()
            case tfNhi1:
                tfNhi1.tfColor(color: UIColor.init(hex: "#36b548"))
                tfNhi2.isUserInteractionEnabled = true
                tfNhi2.becomeFirstResponder()
            case tfNhi2:
                tfNhi2.tfColor(color: UIColor.init(hex: "#36b548"))
                tfBa1.isUserInteractionEnabled = true
                tfBa1.becomeFirstResponder()
            case tfBa1:
                tfBa1.tfColor(color: UIColor.init(hex: "#36b548"))
                tfBa2.isUserInteractionEnabled = true
                tfBa2.becomeFirstResponder()
            case tfBa2:
                tfBa2.tfColor(color: UIColor.init(hex: "#36b548"))
                tfBa3.isUserInteractionEnabled = true
                tfBa3.becomeFirstResponder()
            case tfBa3:
                tfBa3.tfColor(color: UIColor.init(hex: "#36b548"))
                tfBa4.isUserInteractionEnabled = true
                tfBa4.becomeFirstResponder()
            case tfBa4:
                tfBa4.tfColor(color: UIColor.init(hex: "#36b548"))
                tfBa5.isUserInteractionEnabled = true
                tfBa5.becomeFirstResponder()
            case tfBa5:
                tfBa5.tfColor(color: UIColor.init(hex: "#36b548"))
                tfBa6.isUserInteractionEnabled = true
                tfBa6.becomeFirstResponder()
            case tfBa6:
                tfBa6.tfColor(color: UIColor.init(hex: "#36b548"))
                tfTu1.isUserInteractionEnabled = true
                tfTu1.becomeFirstResponder()
            default:
                break
            }
        }
        else if text?.characters.count == 4 {
            switch textField{
            case tfTu1:
                tfTu1.tfColor(color: UIColor.init(hex: "#36b548"))
                tfTu2.isUserInteractionEnabled = true
                tfTu2.becomeFirstResponder()
            case tfTu2:
                tfTu2.tfColor(color: UIColor.init(hex: "#36b548"))
                tfTu3.isUserInteractionEnabled = true
                tfTu3.becomeFirstResponder()
            case tfTu3:
                tfTu3.tfColor(color: UIColor.init(hex: "#36b548"))
                tfTu4.isUserInteractionEnabled = true
                tfTu4.becomeFirstResponder()
            case tfTu4:
                tfTu4.tfColor(color: UIColor.init(hex: "#36b548"))
                tfNam1.isUserInteractionEnabled = true
                tfNam1.becomeFirstResponder()
            case tfNam1:
                tfNam1.tfColor(color: UIColor.init(hex: "#36b548"))
                tfNam2.isUserInteractionEnabled = true
                tfNam2.becomeFirstResponder()
            case tfNam2:
                tfNam2.tfColor(color: UIColor.init(hex: "#36b548"))
                tfNam3.isUserInteractionEnabled = true
                tfNam3.becomeFirstResponder()
            case tfNam3:
                tfNam3.tfColor(color: UIColor.init(hex: "#36b548"))
                tfNam4.isUserInteractionEnabled = true
                tfNam4.becomeFirstResponder()
            case tfNam4:
                tfNam4.tfColor(color: UIColor.init(hex: "#36b548"))
                tfNam5.isUserInteractionEnabled = true
                tfNam5.becomeFirstResponder()
            case tfNam5:
                tfNam5.tfColor(color: UIColor.init(hex: "#36b548"))
                tfNam6.isUserInteractionEnabled = true
                tfNam6.becomeFirstResponder()
            case tfNam6:
                tfNam6.tfColor(color: UIColor.init(hex: "#36b548"))
                tfSau1.isUserInteractionEnabled = true
                tfSau1.becomeFirstResponder()
            default:
                break
            }
        }
        else if text?.characters.count == 3 {
            switch textField{
            case tfSau1:
                tfSau1.tfColor(color: UIColor.init(hex: "#36b548"))
                tfSau2.isUserInteractionEnabled = true
                tfSau2.becomeFirstResponder()
            case tfSau2:
                tfSau2.tfColor(color: UIColor.init(hex: "#36b548"))
                tfSau3.isUserInteractionEnabled = true
                tfSau3.becomeFirstResponder()
            case tfSau3:
                tfSau3.tfColor(color: UIColor.init(hex: "#36b548"))
                tfBay1.isUserInteractionEnabled = true
                tfBay1.becomeFirstResponder()
            default:
                break
            }
        }
        else if text?.characters.count == 2 {
            switch textField{
            case tfBay1:
                tfBay1.tfColor(color: UIColor.init(hex: "#36b548"))
                tfBay2.isUserInteractionEnabled = true
                tfBay2.becomeFirstResponder()
            case tfBay2:
                tfBay2.tfColor(color: UIColor.init(hex: "#36b548"))
                tfBay3.isUserInteractionEnabled = true
                tfBay3.becomeFirstResponder()
            case tfBay3:
                tfBay3.tfColor(color: UIColor.init(hex: "#36b548"))
                tfBay4.isUserInteractionEnabled = true
                tfBay4.becomeFirstResponder()
            case tfBay4:
                tfBay4.tfColor(color: UIColor.init(hex: "#36b548"))
                tfDB.isUserInteractionEnabled = true
                tfDB.becomeFirstResponder()
            default:
                break
            }
        }
    }
}

