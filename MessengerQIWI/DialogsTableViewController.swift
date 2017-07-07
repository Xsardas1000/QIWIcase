//
//  DialogsTableViewController.swift
//  MessengerQIWI
//
//  Created by Максим on 30.06.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class DialogsTableViewController: UITableViewController {
    
    
    //добавить друга (диалог)
    @IBAction func addDialog(_ sender: UIBarButtonItem) {
        
    }
    
    var friends: [UserInfo] = []
    var friendsUIDs: [String] = []
    
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func localTimeZoneAbbreviation() -> String {
        return NSTimeZone.local.abbreviation(for: Date())!
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        

        print("view did load in DialogsTVC")

        
        DataService.dataService.currentUserRef.removeAllObservers()
        loadDataFromDatabase()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friends.count
    }

    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        print("cell", indexPath.row)
        cell.textLabel?.text = self.friends[indexPath.row].username
        

        return cell
    }
    
    func loadDataFromDatabase() {
        DataService.dataService.currentUserRef.child("friends").observe(DataEventType.value, with: { (snapshot) in
            let userUIDs = snapshot.value as? [String : AnyObject] ?? [:]
            
            var friendsUIDs: [String] = []
            for key in userUIDs.keys {
                print("userUID = ", key)
                friendsUIDs.append(key)
            }
            self.friendsUIDs = friendsUIDs
            print("count0 = ", self.friendsUIDs.count)
            
            for key in self.friendsUIDs {
                print("key = ", key)
                DataService.dataService.usersRef.child(key).observe(DataEventType.value, with:  { (snapshot) in
                    let user = snapshot.value as? [String : AnyObject] ?? [:]
                    
                    let newUser: UserInfo = UserInfo(snapshot: user, uid: key)
                    self.friends.append(newUser)
                    self.tableView.reloadData()
                    print("append user", newUser.username!)
                    
                })
            }

        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected ", indexPath.row)
        let cell = tableView.cellForRow(at: indexPath)
        print("name ", self.friends[indexPath.row].username!)
        
        
        //переход на другой экран по segue
        self.performSegue(withIdentifier: "toDialogItem", sender: self.friends[indexPath.row])
        
        //убрать выделение
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //вызывается при каждом переходе на другой экран по нажатию
    
        if segue.identifier == "toDialogItem" {
            let controller = segue.destination as? DetailDialogViewController

            controller?.user = sender as? UserInfo
        }
        
    }

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
