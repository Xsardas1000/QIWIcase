//
//  DetailDialogViewController.swift
//  MessengerQIWI
//
//  Created by Максим on 30.06.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import UIKit
import Firebase

class DetailDialogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user: UserInfo?
    var requests: [Request] = []
    var chosenRequest: Request?
    var balance: Int = 0
    
    @IBOutlet weak var historyTableView: UITableView!

    @IBOutlet weak var balanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = user?.username
        
        DataService.dataService.currentUserRef.removeAllObservers()

        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        print("userUID = ", user!.uid!)
        print("currentUserUID = ", DataService.dataService.currentUserUID)
        loadDialogFromDatabase()

    }
    
    /*@IBAction func sendMoney(_ sender: UIButton, forEvent event: UIEvent) {
        self.performSegue(withIdentifier: "sendMoney", sender: user)
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "sendMoney" {
            let controller = segue.destination as? SendMoneyViewController
            
            controller?.user = self.user

        } else if segue.identifier == "setDebt" {
            let controller = segue.destination as? SetDebtViewController
            controller?.user = self.user
            
        } else if segue.identifier == "askMoney" {
            let controller = segue.destination as? AskMoneyViewController
            controller?.user = self.user

        } else if segue.identifier == "toRequest" {
            
            let controller = segue.destination as? RequestDetailViewController
            controller?.user = self.user
            controller?.request = self.chosenRequest
        }

        
    }
    
    func updateBalance() {
        balance = 0
        for request in self.requests {
            if request.accepted == false {
                continue
            }
            if  (request.receiverUID == DataService.dataService.currentUserUID && request.type == Request.RequestType.SetDebt) || (request.senderUID == DataService.dataService.currentUserUID && request.type == Request.RequestType.AskMoney) {
                balance -= Int(request.amount!)!
            } else {
                balance += Int(request.amount!)!
            }
        }
        balanceLabel.text = String(balance)
    }
    
    
    func loadDialogFromDatabase() {
        DataService.dataService.currentUserRef.child("requests").observe(DataEventType.value, with: { (snapshot) in
            let requests = snapshot.value as? [String : AnyObject] ?? [:]
            for request in requests {
                if (request.value["receiverUID"] as! String)  == self.user?.uid {
                    let newRequest = Request(snapshot: request.value as! [String : AnyObject] )
                    self.requests.append(newRequest)
                    //print("true1")
                }
            }
            //print("num of requests after loading1", self.requests.count)
            self.historyTableView.reloadData()
        })
        
        DataService.dataService.currentUserRef.child("reseptions").observe(DataEventType.value, with: { (snapshot) in
            let requests = snapshot.value as? [String : AnyObject] ?? [:]
            for request in requests {
                if (request.value["senderUID"] as! String)  == self.user?.uid {
                    let newRequest = Request(snapshot: request.value as! [String : AnyObject] )
                    self.requests.append(newRequest)
                    //print("true2")
                }
            }
            //print("num of requests after loading2", self.requests.count)
            self.updateBalance()
            self.historyTableView.reloadData()
        })
        
        print("num of requests after loading3", self.requests.count)

    }
    
    
    //MARK: - UITableViewDataSourse
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("num of requests in table", requests.count)
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "histCell", for: indexPath)
        as! histTableViewCell
     
        let request = self.requests[indexPath.row]
        //print("cell", request.type!)
        
        cell.amountMoney.text = request.amount
        cell.date.text = request.date
        
        cellCheckbox(cell: cell, isAccepted: request.accepted!)
        
        //пришел запрос setDebt или отправлен запрос askMoney
        if  (request.receiverUID == DataService.dataService.currentUserUID && request.type == Request.RequestType.SetDebt) || (request.senderUID == DataService.dataService.currentUserUID && request.type == Request.RequestType.AskMoney) {
            cell.backgroundColor = UIColor.red
        } else {
            cell.backgroundColor = UIColor.green
        }
        
        return cell
     }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? histTableViewCell
        print("type ", self.requests[indexPath.row].type!)
        let request = self.requests[indexPath.row]
        
        if request.receiverUID == DataService.dataService.currentUserUID {
            print("can accept request from ", request.senderUID!)
            self.chosenRequest = request
            
            //переход на другой экран по segue
            self.performSegue(withIdentifier: "toRequest", sender: nil)
        }
        
        //убрать выделение
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    

    
    func cellCheckbox(cell: UITableViewCell, isAccepted: Bool){
        if !isAccepted {
            cell.accessoryType = UITableViewCellAccessoryType.detailButton
        
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
    }

    
}
