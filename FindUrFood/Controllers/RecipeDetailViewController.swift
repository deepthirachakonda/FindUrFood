//
//  RecipeDetailViewController.swift
//  FindUrFood
//
//  Created by Abhinay kukkadapu on 12/13/19.
//  Copyright © 2019 Deepthi. All rights reserved.
//

import UIKit


class RecipeDetail {
     var titleName = ""
       var data = ""
       init(titleValue:String,dataValue:String) {
           self.titleName = titleValue
           self.data = dataValue
       }
}
class RecipeDetailViewController: UIViewController {
    
    @IBOutlet weak var recipeDetailTableView: UITableView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    
    
    var headerView: UIView!
    var headerHeight:CGFloat = 200.0
    
    var selectedDetailItem = FoodItem()
    var recipeDetails = [RecipeDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupUI()
    }
    
    func setupUI(){
        
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        self.setupTableView()
        self.updateData()
        self.setupRecipeDetailsData()
    }
    
    func setupTableView(){
        self.recipeDetailTableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
        
        self.recipeDetailTableView.estimatedRowHeight = 200
        self.recipeDetailTableView.rowHeight = UITableView.automaticDimension
        
        headerView = recipeDetailTableView.tableHeaderView
        recipeDetailTableView.tableHeaderView = nil
        recipeDetailTableView.addSubview(headerView)
        recipeDetailTableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
        recipeDetailTableView.contentOffset = CGPoint(x: 0, y: -headerHeight)
        updateHeaderView()
        self.recipeDetailTableView.reloadData()
    }
    
    func updateHeaderView() {
        if headerView != nil {
            var headerRect = CGRect(x: 0, y: -headerHeight, width: recipeDetailTableView.bounds.width, height: headerHeight)
            if recipeDetailTableView.contentOffset.y < -headerHeight {
                headerRect.origin.y = recipeDetailTableView.contentOffset.y
                headerRect.size.height = -recipeDetailTableView.contentOffset.y
            }
            headerView.frame = headerRect
        }
    }
    
    func updateData(){
        self.itemNameLbl.backgroundColor = Colors.black.withAlphaComponent(0.4)
        self.headerImageView.image = ImageNames.recipeplaceholder
        self.headerImageView.load(url: self.selectedDetailItem.photo)
        self.itemNameLbl.text = self.selectedDetailItem.itemName
        self.ratingLbl.text = self.selectedDetailItem.rating
    }
    
    func setupRecipeDetailsData(){
        let ingredients = RecipeDetail(titleValue: "Ingredients", dataValue: self.selectedDetailItem.ingredients)
        let cookBook = RecipeDetail(titleValue: "Cookbook", dataValue: self.selectedDetailItem.cookBook)
        let prepTime = RecipeDetail(titleValue: "Prep Time", dataValue: String(self.selectedDetailItem.prepareTime))
        let foodType = RecipeDetail(titleValue: "Dish Type", dataValue: self.selectedDetailItem.type)
        let easeOfPrep = RecipeDetail(titleValue: "Ease of Prep", dataValue: self.selectedDetailItem.easeOfPrepare)
        let webLink = RecipeDetail(titleValue: "Link", dataValue: self.selectedDetailItem.link)
        let lastMade = RecipeDetail(titleValue: "Last Made", dataValue: self.selectedDetailItem.lastMade)
        let notes = RecipeDetail(titleValue: "Notes", dataValue: self.selectedDetailItem.notes)
        
        self.recipeDetails.append(ingredients)
        self.recipeDetails.append(cookBook)
        self.recipeDetails.append(prepTime)
        self.recipeDetails.append(foodType)
        self.recipeDetails.append(easeOfPrep)
        if webLink.data != "" {
        self.recipeDetails.append(webLink)
        }
        self.recipeDetails.append(lastMade)
        self.recipeDetails.append(notes)
        
        self.recipeDetailTableView.reloadData()
    }
    
    
}

extension RecipeDetailViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipeDetails.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        let currentItem = self.recipeDetails[indexPath.row]
        // cell.indentationLevel = 2
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        cell.textLabel?.textColor = Colors.darkGray
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        
        cell.textLabel?.text = currentItem.titleName
        cell.detailTextLabel?.text = currentItem.data
        
        if currentItem.titleName == "Link" {
            cell.detailTextLabel?.textColor = Colors.link_color
        }else{
            cell.detailTextLabel?.textColor = Colors.black
        }
      
        if cell.detailTextLabel?.text == "" {
            cell.detailTextLabel?.text = "-"
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentItem = self.recipeDetails[indexPath.row]
        if currentItem.titleName == "Link" {
            if self.selectedDetailItem.link != "" {
                guard let url = URL(string: self.selectedDetailItem.link) else { return }
                UIApplication.shared.open(url)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
}
