//
//  StatsViewController.swift
//  BrokeBet
//
//  Created by Dane Jensen on 12/10/21.
//

import UIKit

struct Section{
    let title: String
    let options: [String]
    var isOpened = false
    
    init(title: String, options: [String], isOpened : Bool = false){
        self.title = title
        self.options = options
        self.isOpened = isOpened
    }
}

class StatsViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var activeBetsTable: UITableView!
    
    @IBOutlet weak var allBetsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sections = []
        activeBetsTable.delegate = self
        self.activeBetsTable.dataSource = self
        self.activeBetsTable.register(UINib(nibName : "ActiveBetTableViewCell", bundle: nil) , forCellReuseIdentifier: "ActiveBetCell")
        // Do any additional setup after loading the view.
    }
    

   

}
extension StatsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 110 //or whatever you need
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveBetCell", for : indexPath) as! ActiveBetTableViewCell
     
 
        return cell
        }
    
}

