//
//  bettingTableHeader.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/26/22.
//

import UIKit

protocol CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: bettingTableHeader, section: Int)
}

class bettingTableHeader: UITableViewHeaderFooterView {
    var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0
    
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var leagueLabel: UILabel!
    @IBOutlet weak var leagueImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bettingTableHeader.tapHeader(_:))))
            
    
    }
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
            guard let cell = gestureRecognizer.view as? bettingTableHeader else {
                return
            }
            delegate?.toggleSection(self, section: cell.section)
        }
        
        func setCollapsed(_ collapsed: Bool) {
            // Animate the arrow rotation (see Extensions.swf)
            arrowImage.transform = arrowImage.transform.rotated(by: collapsed ? 0.0 : .pi / 2)

        }
}
