//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Abdullah on 25/02/2022.
//

import RealmSwift
// import CoreData
import UIKit

class CategoryTableViewController: UITableViewController {
    let realm = try! Realm()
    var CategoryArray: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // print(CategoryArray!)
//        cell.textLabel?.text = CategoryArray?[indexPath.row].name ?? "no cat"
        cell.textLabel?.text = CategoryArray?[indexPath.row]["name"] as? String ?? "No categories added yet"

        return cell
    }
    
    @IBAction func addCategoryBressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { _ in
          
//            let newItem = Category(context: self.context)
            let newCategory = Category()
            
            if textField.text != "" {
                newCategory.name = textField.text!
//                self.CategoryArray.append(newCategory)
                self.save(category: newCategory)
            }
        }
         
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Write Category to be added"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func save(category: Category) {
        do {
//
            try realm.write {
                realm.add(category)
            }
        
        } catch {
            // print("Error encoding item array, \(error)")
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory() {
        CategoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? TodoListViewController
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC?.selectedCategory = CategoryArray?[indexpath.row]
        }
    }
}

// MARK: - Search bar methods

//
extension CategoryTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadCategory()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            CategoryArray = CategoryArray?.filter("name CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
            tableView.reloadData()
        }
    }
}
