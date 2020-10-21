//
//  IngredientsViewController.swift
//  FindUrFood
//
//  Created by Abhinay kukkadapu on 12/13/19.
//  Copyright © 2019 Deepthi. All rights reserved.
//

import UIKit

class IngredientsViewController: UIViewController {
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    var onDoneBlock : ((Bool) -> Void)?
    
    var newSelectedItems = [FoodItem]()
    var filteredItems = [FoodItem]()
    var selectedPrepareTime = 0
    var selectedDishType = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupUI()
    }
    
    func setupUI(){
        
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        self.title = "Ingredients"
        
        
        if self.selectedPrepareTime != 0 {
            filteredItems = foodItemsList.filter({$0.prepareTime <= self.selectedPrepareTime })
            if self.selectedDishType != "" {
                filteredItems = filteredItems.filter({$0.type == self.selectedDishType})
            }
        }else{
            filteredItems = foodItemsList
            if self.selectedDishType != "" {
                filteredItems = filteredItems.filter({$0.type == self.selectedDishType})
            }
        }
        
        self.newSelectedItems = selectedItems
        self.setupTableView()
        self.setupBarButtons()
    }
    
    func setupTableView(){
        self.ingredientsTableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
        self.ingredientsTableView.estimatedRowHeight = 200
        self.ingredientsTableView.rowHeight = UITableView.automaticDimension
        self.ingredientsTableView.reloadData()
    }
    
    func setupBarButtons(){
        let closeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.closeButtonClicked))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonClicked))
        self.navigationItem.leftBarButtonItem = closeButton
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func closeButtonClicked(sender:UIBarButtonItem){
        self.newSelectedItems.removeAll()
        self.dismiss(animated: true, completion: nil)
    }
    @objc func doneButtonClicked(sender:UIBarButtonItem){
       // if self.newSelectedItems.count > 0 {
            selectedItems = self.newSelectedItems // .append(contentsOf: self.newSelectedItems)
       // }
        onDoneBlock?(true)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension IngredientsViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        let currentItem = filteredItems[indexPath.row]
        cell.textLabel?.text = currentItem.itemName
        cell.detailTextLabel?.text = currentItem.ingredients
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        
        let isSelected = self.newSelectedItems.filter({$0.itemName == currentItem.itemName}).count > 0
        
        if isSelected {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentItem = filteredItems[indexPath.row]
        
        let isSelected = self.newSelectedItems.filter({$0.itemName == currentItem.itemName}).count > 0
        if isSelected {
            self.newSelectedItems.removeAll(where: {$0.itemName == currentItem.itemName})
        }else{
            self.newSelectedItems.append(currentItem)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    
}
