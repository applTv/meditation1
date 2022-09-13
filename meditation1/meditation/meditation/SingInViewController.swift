//
//  ViewController.swift
//  meditation
//
//  Created by user on 07.09.2022.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation


class SingInViewController: UIViewController {
    @IBOutlet weak var inputlogin: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    
    let userDef = UserDefaults.standard
    
    override func viewDidLoad(){
        super.viewDidLoad()
        let tapGesture = UIGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        inputlogin.text = "K31@ru.ru"
        inputPassword.text = "123"
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func signInAction(_ sender: UIButton){
        guard inputPassword.text?.isEmpty == false && inputPassword.text?.isEmpty == false else{ return showAlert(message: "Поля пустые")}
        guard isValidEmail(emailID: inputlogin.text!) else {return showAlert(message: "Проверте правильность почты") }
        
        let url = "http://mskko2021.mad.hakta.pro/api/user/login"
        
        let param: [String: String] = [
            "email": inputlogin.text!,
            "password": inputPassword.text!
        ]
        AF.request(url, method: .post, parameters: param, encoder: JSONParameterEncoder.default).validate().responseJSON { response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let token = json["token"].stringValue
                self.userDef.setValue(token, forKey: "userToken")
            case .failure(let error):
                let errorJSON = JSON(response.data)
                let errorDesciption = errorJSON["error"].stringValue
                self.showAlert(message: errorDesciption)
            }
        }
        
    }
    func showAlert(message: String){
        let alert = UIAlertController(title: "Уведомление", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler:  nil))
        present(alert, animated: true, completion: nil)
    }
    func isValidEmail(emailID: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%=-]=@[A-za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MASTCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }

}

