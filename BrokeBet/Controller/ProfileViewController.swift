//
//  ProfileViewController.swift
//  BrokeBet
//
//  Created by Dane Jensen on 11/1/22.
//

import UIKit

class ProfileViewController: UIViewController {
    let profileOptions = ["Change Username", "Password Reset", "Change Email"]
    let screenSize: CGRect = UIScreen.main.bounds

    @IBOutlet weak var profileCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        profileCollection.delegate = self
        profileCollection.dataSource = self
        // Do any additional setup after loading the view.
    }
    

   

}
extension ProfileViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reusableCell", for: indexPath as IndexPath) as! ProfileCollectionViewCell
        
        cell.cellLabel.text = profileOptions[indexPath.row]
        cell.layer.cornerRadius = 30
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            cell.contentView.layer.masksToBounds = true
        
    }
    
}
extension ProfileViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let dimensions = (screenSize.width - 30 - 20) / 2
        return CGSize(width: dimensions, height: dimensions)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 20
    }
    
}
