//
//  ViewController.swift
//  CoreDataSyncCloudKit
//
//  Created by danny santoso on 26/12/20.
//

import UIKit
import CoreData

extension UIViewController {
    func getViewContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let container = appDelegate?.persistentContainer
        return container!.viewContext
    }
}

class ViewController: UIViewController {
    
    var userEntity: [User] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableCell")
        
        reload()
    }
    
    func alertView(user:[User], index: Int) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "UPDATE", message: "Enter an Update", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = "Some default text"
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            self.update(user: user, name: textField?.text ?? "", index: index)
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchWithPredicate(){
        //For fetching data with predicate
        userEntity = User.fetchQuery(viewContext: self.getViewContext(), name: "danny")
    }
    
    func fetch(){
        //For Fetching All Data
        userEntity = User.fetchAll(viewContext: self.getViewContext())
    }

    func save(){
        //For Save Data
        _ = User.save(viewContext: self.getViewContext(), image: (UIImage(named: "imageProfile.png")?.pngData())!, name: "danny", date: Date())
        tableView.reloadData()
    }
    
    func update(user: [User], name: String, index: Int) {
        //For Update Data
        User.update(viewContext: self.getViewContext(), image: (UIImage(named: "imageProfile.png")?.pngData())!, name: name, date: Date(), user: user, index: index)
        tableView.reloadData()
    }
    
    func delete(user:[User], index: Int){
        //For Delete Data
        User.delete(viewContext: self.getViewContext(), user: user, index: index)
    }
    
    func reload(){
        fetch()
        tableView.reloadData()
    }
    
    @IBAction func addButton(_ sender: Any) {
        save()
        reload()
    }
}

//MARK: - Extension for Table

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEntity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableViewCell
        
        if let image = userEntity[indexPath.row].image {
            cell.userImage.image = UIImage(data: image)
            cell.nameLbl.text = userEntity[indexPath.row].name
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            delete(user: userEntity, index: indexPath.row)
            
            userEntity.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        alertView(user: userEntity, index: indexPath.row)
    }
}
