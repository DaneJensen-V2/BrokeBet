//
//  ProfileCollectionViewCell.swift
//  BrokeBet
//
//  Created by Dane Jensen on 11/1/22.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
          backgroundColor = .clear // very important
          layer.masksToBounds = false
          layer.shadowOpacity = 0.23
          layer.shadowRadius = 4
          layer.shadowOffset = CGSize(width: 0, height: 0)
          layer.shadowColor = UIColor.black.cgColor

          // add corner radius on `contentView`
          contentView.backgroundColor = .white
          contentView.layer.cornerRadius = 30
    }
}
