//
//  AddRecipeViewController.swift
//  FindUrFood
//
//  Created by Abhinay kukkadapu on 12/13/19.
//  Copyright © 2019 Deepthi. All rights reserved.
//

import UIKit

class AddRecipeItem {
    var titleName = ""
    var data = ""
    init(titleValue:String,dataValue:String) {
        self.titleName = titleValue
        self.data = dataValue
    }
}

class AddRecipeViewController: UIViewController {
    
    @IBOutlet weak var addRecipeTableView: UITableView!
    
    var datePicker = UIDatePicker()
    var currentTextField : UITextField?
    
    var addRecipeItems = [AddRecipeItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupUI()
    }
    
    func setupUI(){
        self.title = "Add Recipe"
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        
        self.setupRecipeData()
        self.setupDatePicker()
        self.setupTableView()
        self.setupBarButtons()
        
        NotificationCenter.default.addObserver( self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow( note:NSNotification )
    {
        // read the CGRect from the notification (if any)
        if let newFrame = (note.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
            let insets = UIEdgeInsets( top: 0, left: 0, bottom: newFrame.height, right: 0 )
            addRecipeTableView.contentInset = insets
            addRecipeTableView.scrollIndicatorInsets = insets
        }
    }
    
    func setupTableView(){
        self.addRecipeTableView.register(UINib(nibName: "SingleLineTFCell", bundle: nil), forCellReuseIdentifier: "SingleLineTFCell")
        self.addRecipeTableView.keyboardDismissMode = .interactive
        self.addRecipeTableView.rowHeight = 100
        self.addRecipeTableView.reloadData()
    }
    
    func setupBarButtons(){
        let closeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.closeButtonClicked))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.doneButtonClicked))
        self.navigationItem.leftBarButtonItem = closeButton
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func closeButtonClicked(sender:UIBarButtonItem){
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    @objc func doneButtonClicked(sender:UIBarButtonItem){
        self.view.endEditing(true)
        let validName = self.addRecipeItems[0].data != ""
        let validIngredients = self.addRecipeItems[1].data != ""
        
        if validName && validIngredients {
            self.savenewRecipeToLocalFile()
        }else{
            CommonAlertView.shared.showAlert("Fill data", "Please fill name and ingredients", .normal)
        }
    }
    
    func setupDatePicker(){
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
    }
    func updateDate(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        self.addRecipeItems[9].data = formatter.string(from: datePicker.date)
        
        if currentTextField != nil {
            currentTextField?.text = formatter.string(from: datePicker.date)
        }
    }
    
    @objc func datePickerChanged(sender: UIDatePicker) {
        updateDate()
    }
    
    func setupRecipeData(){
        let nameValue = AddRecipeItem(titleValue: "Name", dataValue: "")
        let ingredients = AddRecipeItem(titleValue: "Ingredients", dataValue: "")
        let ratingValue = AddRecipeItem(titleValue: "Rating", dataValue: "")
        let easeOfPrepValue = AddRecipeItem(titleValue: "Ease of Prep", dataValue: "")
        let notesValue = AddRecipeItem(titleValue: "Notes", dataValue: "")
        let typeValue = AddRecipeItem(titleValue: "Type", dataValue: "")
        let prepTimeValue = AddRecipeItem(titleValue: "Prep Time", dataValue: "")
        let photoValue = AddRecipeItem(titleValue: "Photo Link", dataValue: "")
        let cookbookValue = AddRecipeItem(titleValue: "Cookbook", dataValue: "")
        let linkValue = AddRecipeItem(titleValue: "Link", dataValue: "")
        let lastMadeValue = AddRecipeItem(titleValue: "Last Made", dataValue: "")
        
        self.addRecipeItems.append(nameValue)
        self.addRecipeItems.append(ingredients)
        self.addRecipeItems.append(typeValue)
        self.addRecipeItems.append(easeOfPrepValue)
        self.addRecipeItems.append(prepTimeValue)
        self.addRecipeItems.append(notesValue)
        self.addRecipeItems.append(cookbookValue)
        self.addRecipeItems.append(photoValue)
        self.addRecipeItems.append(linkValue)
        self.addRecipeItems.append(lastMadeValue)
        self.addRecipeItems.append(ratingValue)
        
        
    }
    
    func savenewRecipeToLocalFile(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        _ = "FoodItems"
        // let url = Bundle.main.url(forResource: fileName, withExtension: "json")!
        let fileurl = URL(fileURLWithPath: appDelegate.newRecipesJsonPath)
        do {
            let jsonData = try Data(contentsOf: fileurl)
            
            let jsonArray = try JSONSerialization.jsonObject(with: jsonData) as! [[String: Any]]
            print(jsonArray.count)
            
            self.saveNewRecipe(oldData: jsonArray, fileurl: fileurl)
        }
        catch {
            print(error.localizedDescription)
            self.saveNewRecipe(oldData: [[String: Any]](), fileurl: fileurl)
        }
    }
    
    
    func saveNewRecipe(oldData: [[String: Any]],fileurl:URL){
        
        var jsonArray = oldData
        do {
            var newRecipeDict = [String:Any]()
            newRecipeDict["Name"] = self.addRecipeItems[0].data
            newRecipeDict["Ingredients"] = self.addRecipeItems[1].data
            newRecipeDict["Type"] = self.addRecipeItems[2].data
            newRecipeDict["Ease of Prep"] = self.addRecipeItems[3].data
            newRecipeDict["Prep Time"] = Int(self.addRecipeItems[4].data) ?? 0
            newRecipeDict["Notes"] = self.addRecipeItems[5].data
            newRecipeDict["Cookbook"] = self.addRecipeItems[6].data
            newRecipeDict["Photo"] = self.addRecipeItems[7].data
            newRecipeDict["Link"] = self.addRecipeItems[8].data
            newRecipeDict["Last Made"] = self.addRecipeItems[9].data
            newRecipeDict["Rating"] = self.getRating()
            newRecipeDict["Page #"] = ""
            newRecipeDict["Slowcooker"] = ""
            newRecipeDict["Make It Next"] = ""
            
            jsonArray.append(newRecipeDict)
            
            
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .init(rawValue: 0))
            try jsonData.write(to: fileurl)
            
            self.saveFoodItems(newItem: newRecipeDict)
            self.dismiss(animated: true, completion: nil)
            CommonAlertView.shared.showAlert("New recipe added", "", .normal)
        }
            
        catch {
            
        }
    }
    
    func getJsonString(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func saveFoodItems(newItem:[String:Any]){
        
        
        
        let foodItem = FoodItem()
        
        if let name = newItem["Name"] as? String {
            foodItem.itemName = name
        }
        if let rating = newItem["Rating"] as? String {
            foodItem.rating = rating
        }
        if let easeOfPrepare = newItem["Ease of Prep"] as? String {
            foodItem.easeOfPrepare = easeOfPrepare
        }
        if let notes = newItem["Notes"] as? String {
            foodItem.notes = notes
        }
        if let type = newItem["Type"] as? String {
            foodItem.type = type
        }
        if let prepareTime = newItem["Prep Time"] as? Int {
            foodItem.prepareTime = prepareTime
        }
        if let photo = newItem["Photo"] as? String {
            foodItem.photo = photo
        }
        if let cookbook = newItem["Cookbook"] as? String {
            foodItem.cookBook = cookbook
        }
        if let page = newItem["Page #"] as? String {
            foodItem.page = page
        }
        if let ingredients = newItem["Ingredients"] as? String {
            foodItem.ingredients = ingredients
        }
        if let slowCooker = newItem["Slowcooker"] as? String {
            foodItem.slowCooker = slowCooker
        }
        if let link = newItem["Link"] as? String {
            foodItem.link = link
        }
        if let lastMade = newItem["Last Made"] as? String {
            foodItem.lastMade = lastMade
        }
        if let makeItNext = newItem["Make It Next"] as? String {
            foodItem.makeItNext = makeItNext
        }
        if foodItem.ingredients != "" {
            foodItemsList.append(foodItem)
        }
        
    }
    
    func loadFoodItems(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fileurl = URL(fileURLWithPath: appDelegate.newRecipesJsonPath)
        do {
            let jsonData = try Data(contentsOf: fileurl)
            let jsonArray = try JSONSerialization.jsonObject(with: jsonData) as! [[String: Any]]
            
            print(jsonArray.count)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func getRating() -> String{
        if let ratingValue = Int(self.addRecipeItems[10].data) {
            if ratingValue == 0 {
                return ""
            }else if ratingValue == 1{
                return "⭐"
            }else if ratingValue == 2{
                return "⭐⭐"
            }else if ratingValue == 3{
                return "⭐⭐⭐"
            }else if ratingValue == 4{
                return "⭐⭐⭐⭐"
            }
            else{
                return "⭐⭐⭐⭐⭐"
            }
        }
        return ""
    }
    
}


extension AddRecipeViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addRecipeItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleLineTFCell", for: indexPath) as! SingleLineTFCell
        let currentItem = self.addRecipeItems[indexPath.row]
        cell.singleLineTF.delegate = self
        cell.singleLineTF.tag = indexPath.row
        
        cell.titleLbl.text = currentItem.titleName
        cell.singleLineTF.text = currentItem.data
        cell.singleLineTF.placeholder = currentItem.titleName
        cell.singleLineTF.inputView = nil
        cell.singleLineTF.inputAccessoryView = nil
        
        if currentItem.titleName == "Prep Time" || currentItem.titleName == "Rating" {
            cell.singleLineTF.keyboardType = .numberPad
            self.addDoneButtonOnKeyboard(textfield: cell.singleLineTF)
        }else if currentItem.titleName == "Last Made" {
            cell.singleLineTF.inputView = self.datePicker
            self.addDoneButtonOnKeyboard(textfield: cell.singleLineTF)
        }
        else{
            cell.singleLineTF.keyboardType = .default
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func addDoneButtonOnKeyboard(textfield:UITextField){
        let toolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonAction))
        //  UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexibleSpace, doneButton]
        toolbar.items = items
        toolbar.sizeToFit()
        
        textfield.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction(){
        self.view.endEditing(true)
        
    }
}

extension AddRecipeViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.addRecipeItems[textField.tag].data = textField.text ?? ""
        currentTextField = nil
    }
    
}
