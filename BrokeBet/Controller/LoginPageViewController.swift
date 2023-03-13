//
//  LoginViewController.swift
//  BrokeBet
//
//  Created by Dane Jensen on 11/1/21.
//

import UIKit
import BottomHalfModal
import Firebase
public var dismissParent = false

class LoginPageViewController: UIViewController, SheetContentHeightModifiable {
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var clickedOutButton: UIButton!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var loginText: UITextField!
    var sheetContentHeightToModify: CGFloat = 800

    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.layer.cornerRadius = 20
        loginButton.layer.cornerRadius = 10
        adjustFrameToSheetContentHeightIfNeeded()
        usernameText.addShadow()
        loginText.addShadow()

        // Do any additional setup after loading the view.
    }
    @IBAction func clickedOut(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func loginPushed(_ sender: UIButton) {
        if let email = usernameText.text, let password = loginText.text{
        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
            
            if let e = error{
                let alert = UIAlertController(title: "Registration Error", message: e.localizedDescription, preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

                self.present(alert, animated: true)
                print(e.localizedDescription)
            }
            else{
                print("Success")
                signedIn = true
                self.dismiss(animated: true, completion: nil)
                dismissParent = true
                }
            }
        }
    }
    



}
