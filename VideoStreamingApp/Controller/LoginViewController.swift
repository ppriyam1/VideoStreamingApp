//
//  LoginViewController.swift
//  VideoStreamingApp
//
//  Created by Preeti Priyam on 4/30/21.
//

import UIKit

class LoginViewController: UIViewController, SignupViewDelegate{
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var validateCredentails: UILabel!
    
    let loginDataModel = LoginUserDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.delegate = self
        password.delegate = self
    }
    
    /* function to be implemeneted by conforming to the SignupViewDelegate protocol*/
    func updateLabel(with text: String, with color: UIColor) {
        validateCredentails.textColor = color
        validateCredentails.text = text
    }
    
    //function to login to the user accont by calling loginUser function
    @IBAction func loginButton(_ sender: UIButton) {
        if let currentUsername = userName.text, let currentPassword = password.text {
            loginUser(currentUsername, currentPassword)
        } 
    }
    
    @IBAction func signupButton(_ sender: UIButton) {
    }
    
    //function to login in the user
    func loginUser(_ currentUsername: String, _ currentPassword: String){
        SaveJournalModel.userName = currentUsername
        self.loginDataModel.createAccount(currentUsername, currentPassword, completion: { [weak self] (result) in
            if(result){
                self?.validateCredentails.text = ""
            }else{
                self?.validateCredentails.text = "User Name or Pasword is wrong! Please try again."
            }
            //if login is successful -> go to the next view by calling performsegue
            if(result){
                // self?.performSegue(withIdentifier: "loginToSplitview", sender: self)
                let scene = self?.view.window?.windowScene?.delegate as? SceneDelegate
                scene?.openHome()
            }
        })
    }
    
    //function to be called before the perform segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            //set the SignupViewController delegate to self
            case Constants.loginToSignupSegue:
                let controller = segue.destination as! SignupViewController
                controller.delegate = self
                break
            default:
                return
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == password){
            validateCredentails.text = ""
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == password){
            validateCredentails.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == userName) {
            userName.endEditing(true)
            return true
        }
        if (textField == password) {
            password.endEditing(true)
            return true
        }
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(textField == userName){
            if userName.text != "" {
                return true
            }
            else {
                userName.placeholder = "Type Something"
                return false
            }
        }
        
        if(textField == password){
            if password.text != "" {
                return true
            }
            else {
                password.placeholder = "Type Something"
                return false
            }
        }
        return false
    }
    
}
