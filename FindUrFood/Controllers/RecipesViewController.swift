//
//  Recipes ViewController.swift
//  FindUrFood
//
//  Created by Abhinay kukkadapu on 12/13/19.
//  Copyright © 2019 Deepthi. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController {
    
    @IBOutlet weak var recipesTableView: UITableView!
    
    var filteredItems = [FoodItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setupUI()
    }
    
    
    func setupUI(){
        self.title = "Recipes"
        self.view.backgroundColor = Colors.groupTableViewBackground
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        
        self.setupTableView()
    }
    
    func setupTableView(){
        self.recipesTableView.register(UINib(nibName: "ItemsTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemsTableViewCell")
        self.recipesTableView.backgroundColor = Colors.clear
        self.recipesTableView.separatorStyle = .none
        self.recipesTableView.estimatedRowHeight = 200
        self.recipesTableView.rowHeight = UITableView.automaticDimension
        let headerView = UIView()
        headerView.backgroundColor = Colors.white
        // self.recipesTableView.tableHeaderView = headerView
        self.recipesTableView.reloadData()
    }
    
    
}

extension RecipesViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.filteredItems.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsTableViewCell", for: indexPath) as! ItemsTableViewCell
        let currentItem = self.filteredItems[indexPath.section]
        cell.itemImage.image = ImageNames.recipeplaceholder
        cell.itemImage.load(url: currentItem.photo)
        cell.itemName.text = currentItem.itemName
        cell.cookBookDetail.text = currentItem.cookBook
        cell.lastMadeDate.text = currentItem.lastMade == "" ? "-" : currentItem.lastMade
        cell.ratingLbl.text = currentItem.rating
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.clipsToBounds = true
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentItem = self.filteredItems[indexPath.section]
        let recipesView = self.storyboard?.instantiateViewController(withIdentifier: "RecipeDetailViewController") as! RecipeDetailViewController
        recipesView.selectedDetailItem = currentItem
        self.navigationController?.pushViewController(recipesView, animated: true)
    }
}
