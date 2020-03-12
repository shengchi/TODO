//
//  ViewController.swift
//  TODO
//
//  Created by sc on 2020/3/12.
//  Copyright © 2020 Zetech. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["购买水杯","吃药","修改密码"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //添加一个生存期在方法内部的新变量，用来在添加项目时候接收用户输入
        var textField = UITextField()
        
        let alert = UIAlertController(title: "添加一个新的ToDo项目", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "添加项目", style: .default, handler: {action in
            //用户单击时候执行的代码
            print(textField.text!)
            self.itemArray.append(textField.text!)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        //标志的切换
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        //动态取消高亮状态
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    


}

