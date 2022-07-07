//
//  LoginViewController.swift
//  BrokeBet
//
//  Created by Dane Jensen on 11/1/21.
//

import UIKit
import BottomHalfModal

class LoginViewController: UIViewController, SheetContentHeightModifiable {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    var sheetContentHeightToModify: CGFloat = 800
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 10
        registerButton.layer.cornerRadius = 10

        adjustFrameToSheetContentHeightIfNeeded()
        

        // Do any additional setup after loading the view.
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if(dismissParent == true){
                
                self.dismiss(animated: true, completion: nil)
                dismissParent = false
                timer.invalidate()
            }
            
        }
    }
    

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "LoginPage")
        presentBottomHalfModal(vc!, animated: true, completion: nil)
    }
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "RegisterPage")
        presentBottomHalfModal(vc!, animated: true, completion: nil)
    }
    @IBAction func clickedOutside(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIView {
func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 1.0),
                   shadowOpacity: Float = 0.3,
                   shadowRadius: CGFloat = 1.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = false
    }
}
