//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Abdullah on 25/02/2022.
//

import CoreData
import UIKit

class CategoryTableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var CategoryArray = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = CategoryArray[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    @IBAction func addCategoryBressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { _ in
          
            let newItem = Category(context: self.context)
            //    let newItem = item()
            
            if textField.text != "" {
                newItem.name = textField.text!
                self.CategoryArray.append(newItem)
                self.saveCategory()
            }
        }
         
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Write Category to be added"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategory() {
        do {
//
            try context.save()
        
        } catch {
            // print("Error encoding item array, \(error)")
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            CategoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? TodoListViewController
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC?.selectedCategory = CategoryArray[indexpath.row]
        }
    }
}

// MARK: - Search bar methods

extension CategoryTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadCategory()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            let request: NSFetchRequest<Category> = Category.fetchRequest()
            
            request.predicate = NSPredicate(format: "name CONTAINS [cd] %@", searchBar.text!) // [cd] refer to ignor case senstive and french and german signs
            
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
          
            loadCategory(with: request)
        }
    }
}
