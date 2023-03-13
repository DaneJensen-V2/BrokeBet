//
//  LeaderboardViewController.swift
//  BrokeBet
//
//  Created by Dane Jensen on 10/31/22.
//

import UIKit

class LeaderboardViewController: UIViewController {

    @IBOutlet weak var leaderboardTable: UITableView!
    @IBOutlet weak var timeFrameSegment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leaderboardTable.delegate = self

        leaderboardTable.dataSource = self
        let unselectedText = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let selectedText = [NSAttributedString.Key.foregroundColor: UIColor(named: "DarkLogoColor")]

        timeFrameSegment.setTitleTextAttributes(unselectedText, for: .normal)
        timeFrameSegment.setTitleTextAttributes(selectedText, for: .selected)
        
        leaderboardTable.register(UINib(nibName: "LeaderboardTableViewCell", bundle: nil), forCellReuseIdentifier: "leaderboardCell")
        leaderboardTable.separatorStyle = .none

     }


    

}
extension LeaderboardViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell") as! LeaderboardTableViewCell
        cell.positionLabel.text = String(indexPath.row + 1)
        
        let position = indexPath.row
        if position == 0 {
            cell.positionTop.constant = 4
            cell.positionLabel.backgroundColor = .clear
            cell.trophyImage.image = UIImage(systemName: "trophy.fill")
            cell.trophyImage.tintColor = UIColor(named: "Trophy-1")
        }
        
        else if position == 1{
            cell.positionTop.constant = 4
            cell.positionLabel.backgroundColor = .clear
            cell.trophyImage.image = UIImage(systemName: "trophy.fill")
            cell.trophyImage.tintColor = UIColor(named: "Trophy-2")

        }
        
        else if position == 2 {
            cell.positionTop.constant = 4
            cell.trophyImage.image = UIImage(systemName: "trophy.fill")
            cell.positionLabel.backgroundColor = .clear
            cell.trophyImage.tintColor = UIColor(named: "Trophy-3")

        }
        
        else{
            cell.trophyImage.image = UIImage()
            cell.positionTop.constant = 11
            cell.positionLabel.backgroundColor = UIColor(named: "Trophy-Gray")
            cell.positionLabel.layer.masksToBounds = true
            cell.positionLabel.layer.cornerRadius = 15
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // this will turn on `masksToBounds` just before showing the cell
        cell.contentView.layer.masksToBounds = true
    }

    
}
