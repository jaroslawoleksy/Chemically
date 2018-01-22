//
//  ViewController.swift
//  chemically
//
//  Created by Jaroslaw Oleksy on 15.09.2016.
//  Copyright © 2016 codePark. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth

class ViewController: UIViewController, UITextFieldDelegate {
    
    var signupMode = true
    

    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var signupModeButton: UIButton!
    
    var currentTextFields: [UITextField] = []
    
    @IBAction func signMeUp(_ sender: AnyObject) {

        if emailTextField.text!.isEmpty {
            infoLabel.textColor = UIColor.red
            infoLabel.text = "Porządny Chemik musi posiadać adres e-mail"
            emailTextField.becomeFirstResponder()
            
        } else if passwordTextField.text!.isEmpty {
            infoLabel.textColor = UIColor.red
            infoLabel.text = "Chemiku młody, hasło jak powietrze niezbędne jest do działania"
            passwordTextField.becomeFirstResponder()
        } else if nicknameTextField.text!.isEmpty && signupMode {
            
            infoLabel.textColor = UIColor.red
            infoLabel.text = "Wsyp jeszcze ksywkę poniżej, żebym Cię nie pomylił. Ja jestem Alex."
            nicknameTextField.becomeFirstResponder()
        } else
            
        {
            
            let email = emailTextField.text
            let password = passwordTextField.text
        
            if signupMode {
        
                FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: { (user, error) in
                
                    if user != nil {
                        
                        self.performSegue(withIdentifier: "showElementsViewConroller", sender: self)
                        
                    } else {
                        
                        self.infoLabel.text = "Nie mogłem Cię zapisać. Coś nie trybi"
                    
                    }
                
                
                })
            } else {
                //loginMode
                
                FIRAuth.auth()?.signIn(withEmail: email!, password: password!, completion: { (user, error) in
                
                    
                    if (user != nil) {
                        
                        print(user)
                        self.performSegue(withIdentifier: "showElementsViewConroller", sender: self)
                        
                    } else {
                        
                        self.infoLabel.text = "Się nie mogłem zalogować. Spróbuj jeszcze raz"
                    }
                })
            }
        }
    }
    @IBAction func chageSignupMode(_ sender: AnyObject) {
        
        if signupMode {
            
            signupMode = false
            nicknameTextField.isHidden = true
            infoLabel.text = "Się znamy? To witam! I o login pytam:"
            infoLabel.textColor = UIColor.white
            signupButton.setTitle("Zaloguj się", for: [])
            signupModeButton.setTitle("Nie znamy się jeszcze? Zarejestruj mnie", for: [])
        } else {
            signupMode = true
            nicknameTextField.isHidden = false
            infoLabel.text = "Tak, chcę zostać Chemikiem. Podaję moje dane:"
            infoLabel.textColor = UIColor.white
            signupButton.setTitle("Gotowe!", for: [])
            signupModeButton.setTitle("Jestem już Chemikiem! Idę się zalogować", for: [])
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            
            if user != nil {
                
                self.performSegue(withIdentifier: "showElementsViewConroller", sender: self)
                
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        setupTextField(textFieldName: emailTextField, iconFileName: "email_icon.png", height: 16, placeholder:"email")
        setupTextField(textFieldName: passwordTextField, iconFileName: "key_icon.png", height: 20, placeholder:"password")
        setupTextField(textFieldName: nicknameTextField, iconFileName: "student.png", height: 20, placeholder: "nickname")
        
        currentTextFields = [emailTextField, passwordTextField, nicknameTextField]
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        signupButton.backgroundColor = UIColor(white: 1.0, alpha: 0.22)
        signupButton.layer.cornerRadius = 5.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        setupTextFieldBottomLine(textFieldName: emailTextField)
        setupTextFieldBottomLine(textFieldName: passwordTextField)
        setupTextFieldBottomLine(textFieldName: nicknameTextField)
        
    }
    
    func setupTextField(textFieldName: UITextField, iconFileName: String, height: Int, placeholder: String) -> Void {
        
        
        //setting up icon to the left
        let leftImageView = UIImageView()
        let leftImage = UIImage(named: iconFileName)
        leftImageView.image = leftImage
        leftImageView.frame = CGRect(x: 0, y: 0, width: 20, height: height)
        
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        leftView.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        textFieldName.leftViewMode = UITextFieldViewMode.always
        textFieldName.leftView = leftView
        
        // set textfield delegate
        textFieldName.delegate = self
       
        //setting up placeholder text colour
        let placeholderAttributedString = NSAttributedString(string: placeholder, attributes:[NSForegroundColorAttributeName:UIColor(red: 230.0 / 255, green: 230.0 / 255, blue: 230.0 / 255, alpha: 0.4)])
        
        textFieldName.attributedPlaceholder = placeholderAttributedString
        
    }
    
    func setupTextFieldBottomLine(textFieldName: UITextField) -> Void {
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(red: 230.0 / 255, green: 230.0 / 255, blue: 230.0 / 255, alpha: 0.4).cgColor
        border.frame = CGRect(x: 0, y: textFieldName.frame.size.height - width, width: textFieldName.frame.size.width, height: textFieldName.frame.size.height)
        border.borderWidth = width
        textFieldName.layer.addSublayer(border)
        textFieldName.layer.masksToBounds = true


    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if signupMode == false {
            currentTextFields.removeLast()
        }
        let arrayOfTextFields = currentTextFields as NSArray
        
        
        let arrayIndex = arrayOfTextFields.index(of: textField)
        
        if arrayIndex < arrayOfTextFields.count - 1 {
            
            let newTextField = arrayOfTextFields[arrayIndex + 1] as! UITextField
            newTextField.becomeFirstResponder()
            
            //let doneTextField = arrayOfTextFields[arrayIndex] as! UITextField
            //doneTextField.backgroundColor = UIColor.yellow
            
        } else {
            
            textField.resignFirstResponder()
            signMeUp(self)
            ///textField.backgroundColor = UIColor.yellow
        }
        
        
        return true
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }

    
    
}

