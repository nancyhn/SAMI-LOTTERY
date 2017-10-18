//
//  ViewController.swift
//  SAMI-LOTTERY
//
//  Created by Nguyễn Khoa on 10/18/17.
//  Copyright © 2017 Nguyễn Khoa. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UITextFieldDelegate {

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
    var arrTextField = Array<UITextField>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        arrTextField = [tfNhat, tfNhi1, tfNhi2, tfBa1, tfBa2, tfBa3, tfBa4, tfBa5, tfBa6, tfTu1, tfTu2, tfTu3, tfTu4, tfNam1, tfNam2, tfNam3, tfNam4, tfNam5, tfNam6, tfSau1, tfSau2, tfSau3, tfBay1, tfBay2, tfBay3, tfBay4, tfDB]
        configTextField()
        
        tfNhat.becomeFirstResponder()
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
        
        let dataPost : [String: Any] = ["result" : "tt 99112 - ----- --- ----- -- ----"]
        ApiService.sharedInstance.send_loterry_data(dataPost: dataPost, { jsonData in
                print(jsonData)
        })
        
        
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print("~!@#$%^&*IOP{")
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            if self.view.frame.height - textFieldOriginY < keyboardRectangle.height {
                self.botContranst.constant = keyboardRectangle.height - (self.view.frame.height - textFieldOriginY)
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        self.botContranst.constant = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
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
        
        if textField == tfDB {
            if text?.characters.count == 5 {
                textField.resignFirstResponder()
            }
            return
        }
        if text?.characters.count == 5 {
            switch textField{
            case tfNhat:
                tfNhi1.isUserInteractionEnabled = true
                tfNhi1.tfColor(color: UIColor.green)
                tfNhi1.becomeFirstResponder()
            case tfNhi1:
                tfNhi2.isUserInteractionEnabled = true
                tfNhi2.tfColor(color: UIColor.green)
                tfNhi2.becomeFirstResponder()
            case tfNhi2:
                tfBa1.isUserInteractionEnabled = true
                tfBa1.tfColor(color: UIColor.green)
                tfBa1.becomeFirstResponder()
            case tfBa1:
                tfBa2.isUserInteractionEnabled = true
                tfBa2.tfColor(color: UIColor.green)
                tfBa2.becomeFirstResponder()
            case tfBa2:
                tfBa3.isUserInteractionEnabled = true
                tfBa3.tfColor(color: UIColor.green)
                tfBa3.becomeFirstResponder()
            case tfBa3:
                tfBa4.isUserInteractionEnabled = true
                tfBa4.tfColor(color: UIColor.green)
                tfBa4.becomeFirstResponder()
            case tfBa4:
                tfBa5.isUserInteractionEnabled = true
                tfBa5.tfColor(color: UIColor.green)
                tfBa5.becomeFirstResponder()
            case tfBa5:
                tfBa6.isUserInteractionEnabled = true
                tfBa6.tfColor(color: UIColor.green)
                tfBa6.becomeFirstResponder()
            case tfBa6:
                tfTu1.isUserInteractionEnabled = true
                tfTu1.tfColor(color: UIColor.green)
                tfTu1.becomeFirstResponder()
            default:
                break
            }
        }
        else if text?.characters.count == 4 {
            switch textField{
            case tfTu1:
                tfTu2.isUserInteractionEnabled = true
                tfTu2.tfColor(color: UIColor.green)
                tfTu2.becomeFirstResponder()
            case tfTu2:
                tfTu3.isUserInteractionEnabled = true
                tfTu3.tfColor(color: UIColor.green)
                tfTu3.becomeFirstResponder()
            case tfTu3:
                tfTu4.isUserInteractionEnabled = true
                tfTu4.tfColor(color: UIColor.green)
                tfTu4.becomeFirstResponder()
            case tfTu4:
                tfNam1.isUserInteractionEnabled = true
                tfNam1.tfColor(color: UIColor.green)
                tfNam1.becomeFirstResponder()
            case tfNam1:
                tfNam2.isUserInteractionEnabled = true
                tfNam2.tfColor(color: UIColor.green)
                tfNam2.becomeFirstResponder()
            case tfNam2:
                tfNam3.isUserInteractionEnabled = true
                tfNam3.tfColor(color: UIColor.green)
                tfNam3.becomeFirstResponder()
            case tfNam3:
                tfNam4.isUserInteractionEnabled = true
                tfNam4.tfColor(color: UIColor.green)
                tfNam4.becomeFirstResponder()
            case tfNam4:
                tfNam5.isUserInteractionEnabled = true
                tfNam5.tfColor(color: UIColor.green)
                tfNam5.becomeFirstResponder()
            case tfNam5:
                tfNam6.isUserInteractionEnabled = true
                tfNam6.tfColor(color: UIColor.green)
                tfNam6.becomeFirstResponder()
            case tfNam6:
                tfSau1.isUserInteractionEnabled = true
                tfSau1.tfColor(color: UIColor.green)
                tfSau1.becomeFirstResponder()
            default:
                break
            }
        }
        else if text?.characters.count == 3 {
            switch textField{
            case tfSau1:
                tfSau2.isUserInteractionEnabled = true
                tfSau2.tfColor(color: UIColor.green)
                tfSau2.becomeFirstResponder()
            case tfSau2:
                tfSau3.isUserInteractionEnabled = true
                tfSau3.tfColor(color: UIColor.green)
                tfSau3.becomeFirstResponder()
            case tfSau3:
                tfBay1.isUserInteractionEnabled = true
                tfBay1.tfColor(color: UIColor.green)
                tfBay1.becomeFirstResponder()
            default:
                break
            }
        }
        else if text?.characters.count == 2 {
            switch textField{
            case tfBay1:
                tfBay2.isUserInteractionEnabled = true
                tfBay2.tfColor(color: UIColor.green)
                tfBay2.becomeFirstResponder()
            case tfBay2:
                tfBay3.isUserInteractionEnabled = true
                tfBay3.tfColor(color: UIColor.green)
                tfBay3.becomeFirstResponder()
            case tfBay3:
                tfBay4.isUserInteractionEnabled = true
                tfBay4.tfColor(color: UIColor.green)
                tfBay4.becomeFirstResponder()
            case tfBay4:
                tfDB.isUserInteractionEnabled = true
                tfDB.tfColor(color: UIColor.green)
                tfDB.becomeFirstResponder()
            default:
                break
            }
        }
    }
}

