
//
//  Created by Abdullah on 09/02/2022.

//

import RealmSwift
import UIKit

class TodoListViewController: UITableViewController {
    let realm = try! Realm()

    var itemArray: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item["title"] as! String

            cell.accessoryType = item.done ? .checkmark : .none

        } else {
            cell.textLabel?.text = "no items in this cat"
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row] {
            //   var itemstate = item["done"]  as! Bool
            //      print(itemstate)
            do {
                try realm.write {
                    item["done"] as! Int == 0 ? (item["done"] = true) : (item["done"] = false)
//                    if itemstate == false{
//                        item["done"] = true
//                    }else{
//                        item["done"] = false
//                    }
                }
            } catch {
                print("error saving don state \(error)")
            }
        }

        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Task", style: .default) { _ in

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        if textField.text != "" {
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    }
                } catch {
                    print("error saving items \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Write task to be added"
            textField = alertTextField
        }
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // another way for swipe to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = itemArray?[indexPath.row]
            deleteData(item: item!)

            tableView.reloadData()
        }
    }

    func saveData(item: Item) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }

    func deleteData(item: Item) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }

    func loadItems() {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true).sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
    }
}

// MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            itemArray = itemArray?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
    }
}
