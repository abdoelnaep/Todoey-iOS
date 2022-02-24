
//
//  Created by Abdullah on 09/02/2022.

//

import UIKit

class TodoListViewController: UITableViewController {
//    var itemArray = ["Find Mike", "Buy Eggos", "Destory Demogorgon"]
    var itemArray = [item]()

    let defauls = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let newItem = item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//
//        let newItem2 = item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//
//        let newItem3 = item()
//        newItem3.title = "Destory Demogorgon"
//        itemArray.append(newItem3)
//
        loadItems()
//        if let items = defauls.array(forKey: "todoListArray") as? [item] {
//            itemArray = items
//        }
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        // another way below to do it
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveData()
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
      
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Task", style: .default) { _ in
          
            let newItem = item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            self.saveData()
            
//            self.defauls.set(self.itemArray, forKey: "todoListArray")
        }
         
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Write task to be added"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        print("cool")
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
}
