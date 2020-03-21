//
//  ViewController.swift
//  TODO
//
//  Created by sc on 2020/3/12.
//  Copyright © 2020 Zetech. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class ToDoListViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var selectedCategory : Category?
    
    var todoItems : Results<Item>?
    
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        tableView.rowHeight = 80.0
        
        loadItems()
        
    }
    
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //添加一个生存期在方法内部的新变量，用来在添加项目时候接收用户输入
        var textField = UITextField()
        
        let alert = UIAlertController(title: "添加一个新的ToDo项目", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "添加项目", style: .default, handler: {(action) in
            //用户单击时候执行的代码
            print(textField.text!)
            
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("保存Item错误：\(error)")
                }
            }
            
            self.tableView.reloadData()
            
        })
        alert.addTextField(configurationHandler: {alertTextField in
            alertTextField.placeholder = "创建一个新项目..."
            //让textField指向alertTextField
            textField = alertTextField
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "没有事项"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            print(item.title)
            
            do {
                try realm.write{
                    item.done = !item.done
                }
            } catch {
                print("保存完成状态失败:\(error)")
            }
        }
        

        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()

        //动态取消高亮状态
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Data Load
    
   
    
    //默认值是所有Item,predicate可以没有，默认是按分类筛选
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    


}

//MARK: - UISearchBarDelegate
extension ToDoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[c] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: false)
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
         
        }
    }
}

//MARK: - Swipe Cell Delegate
extension ToDoListViewController : SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else {
            return nil
        }
        
        let deletionAction = SwipeAction(style: .destructive, title: "删除"){
            (action,indexPath) in
            //通过todoItems获取删除的对象
            if let itemForDeletion = self.todoItems?[indexPath.row] {
                do {
                    try self.realm.write{
                        self.realm.delete(itemForDeletion)
                    }
                } catch {
                    print("删除事项失败：\(error)")
                }
            }
        }
        
        //自定义单元格在用户滑动后呈现的外观
        deletionAction.image = UIImage(named: "delete")
        
        return [deletionAction]
        
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    
    
    
}
