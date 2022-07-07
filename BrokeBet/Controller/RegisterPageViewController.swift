//
//  RegisterPageViewController.swift
//  BrokeBet
//
//  Created by Dane Jensen on 11/8/21.
//

import UIKit
import Firebase
import BottomHalfModal
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class RegisterPageViewController: UIViewController, SheetContentHeightModifiable {
    let db = Firestore.firestore()

    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var confirmPasswordText: UITextField!
    var sheetContentHeightToModify: CGFloat = 800

    @IBOutlet weak var bottomView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        bottomView.layer.cornerRadius = 20
        registerButton.layer.cornerRadius = 10
        firstNameText.addShadow()
        lastNameText.addShadow()
        emailText.addShadow()
        passwordText.addShadow()
        confirmPasswordText.addShadow()
        adjustFrameToSheetContentHeightIfNeeded()

        // Do any additional setup after loading the view.

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickedOut(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)

    }
    func addNewUser(newUser : BBUser ){
        let user = Auth.auth().currentUser

        try! self.db.collection("Users").document(user!.uid).setData(from : newUser)
             { (error) in
             if let e = error{
                 print("There was an issue saving data to firestore, \(e)")
             }
             else{
                 print("Successfully saved data.")
             }
         }
    }

    @IBAction func registerClicked(_ sender: UIButton) {
        
        if let email = emailText.text, let password = passwordText.text {
      
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    let alert = UIAlertController(title: "Registration Error", message: e.localizedDescription, preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

                    self.present(alert, animated: true)
                    print(e.localizedDescription)
                }
                else{
                    //Navigate to the ChatViewController
                    self.dismiss(animated: true, completion: nil)
                    self.parent?.dismiss(animated: false, completion: nil)
                    dismissParent = true
                    signedIn = true
                    let user = Auth.auth().currentUser

                    let newUser = BBUser(UserID: user!.uid, firstName: self.firstNameText.text!, lastName: self.lastNameText.text!, currentBalance: 1000, activeBets: [], allBets: [], Bets: 0, Won: 0, Lost: 0, Earned: 0)
                     
                    self.addNewUser(newUser: newUser)
                    currentUser = newUser
              
                    
                }
                
                }
            }
        }
            /*
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
          if let e = error{
                let alert = UIAlertController(title: "Registration Error", message: e.localizedDescription, preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

                self.present(alert, animated: true)
                print(e.localizedDescription)
            }
            else{
                //Navigate to the ChatViewController
                self.dismiss(animated: true, completion: nil)
                self.parent?.dismiss(animated: false, completion: nil)
                dismissParent = true
            }
            
            
                

            }
            
            }
        }
    
    */

}
