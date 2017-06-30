//
//  DetailDialogViewController.swift
//  MessengerQIWI
//
//  Created by Максим on 30.06.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import UIKit

class DetailDialogViewController: UIViewController {
    
    var user: UserInfo?
    
    @IBOutlet weak var historyTableView: UITableView!

    @IBOutlet weak var balanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = user?.username

        // Do any additional setup after loading the view.
    }
    
    /*@IBAction func sendMoney(_ sender: UIButton, forEvent event: UIEvent) {
        self.performSegue(withIdentifier: "sendMoney", sender: user)
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //вызывается при каждом переходе на другой экран по нажатию
        
        print("test4")
        
        if segue.identifier == "sendMoney" {
            let controller = segue.destination as? SendMoneyViewController
            
            controller?.user = self.user
            
            print("user = ", self.user)
            print("contr user = ", controller?.user)

            print("test5")
        }
        
    }

    
    @IBAction func issueInvoice(_ sender: UIButton) {
        
    }
    
    @IBAction func askDebt(_ sender: UIButton) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
