//
//  SignupViewController.swift
//  VideoStreamingApp
//
//  Created by Preeti Priyam on 4/30/21.
//

import UIKit

protocol SignupViewDelegate: class {
    func updateLabel(with text: String, with color: UIColor)
}

class SignupViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    weak var delegate: SignupViewDelegate?
    
    let signupDataModel = SignupUserDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.delegate = self
        password.delegate = self
    }
    
    //function to register the user
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        if let currentUsername = userName.text, let currentPassword = password.text {
            //function to pass the username and password to createUser function
            createUser(currentUsername, currentPassword)
        }
    }
    
    //function to create the user account by calling the signupUserDataModel class 
    func createUser(_ currentUsername: String, _ currentPassword: String){
        signupDataModel.signupIntoAccount(currentUsername, currentPassword, completion: { [weak self] (result) in
            if(result){
                //self?.resultLabel.textColor = .systemGreen
                //self?.resultLabel.text = "Signup Successful!"
                self?.delegate?.updateLabel(with: Constants.successfullSignupMessage, with: .systemGreen)
                self?.navigationController?.popToRootViewController(animated: true)
                //self?.dismiss(animated: true, completion: nil)
            }else{
                self?.resultLabel.text = Constants.signupErrorMessage
            }
        })
    }
}

extension SignupViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == password){
            resultLabel.text = ""
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == password){
            resultLabel.text = ""
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
