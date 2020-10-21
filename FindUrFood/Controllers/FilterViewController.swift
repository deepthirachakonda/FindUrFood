//
//  FilterViewController.swift
//  FindUrFood
//
//  Created by Abhinay kukkadapu on 12/13/19.
//  Copyright © 2019 Deepthi. All rights reserved.
//

import UIKit



var foodItemsList = [FoodItem]()
var selectedItems = [FoodItem]()
class FilterViewController: UIViewController {
    @IBOutlet weak var vegButton: UIButton!
    @IBOutlet weak var nonVegButton: UIButton!
    @IBOutlet weak var ingredientsTF: UITextField!
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var prepareTimeTF: UITextField!
    @IBOutlet weak var dishTypeTF: UITextField!
    @IBOutlet weak var feelingLuckyButton: UIButton!
    
    
    var pickerView = UIPickerView()
    
    var selectedPrepareTime = 0
    var selectedDishType = ""
    var dishTypes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        selectedItems.removeAll()
        foodItemsList.removeAll()
        self.setupUI()
        self.loadFoodItems()
        selectedItems.removeAll()
    }
    
    
    func setupUI(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true
        self.title = "Filter"
        
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        
        
        self.pickerView.delegate = self
        
        self.setupTextfields(textfield: self.prepareTimeTF)
        self.setupTextfields(textfield: self.ingredientsTF)
        self.setupTextfields(textfield: self.dishTypeTF)
        self.prepareTimeTF.keyboardType = .numberPad
        self.dishTypeTF.inputView = self.pickerView
        self.dishTypeTF.tintColor = .clear
        self.addDoneButtonOnKeyboard(textfield: self.prepareTimeTF)
        self.addDoneButtonOnKeyboard(textfield: self.dishTypeTF)
        
        self.setupRightViewIcon(image: ImageNames.downArrow, textField: self.dishTypeTF)
        self.setupRightViewIcon(image: ImageNames.expand, textField: self.ingredientsTF)
        
        self.SubmitButton.setTitleColor(Colors.white, for: .normal)
        self.SubmitButton.backgroundColor = Colors.link_color
        self.SubmitButton.layer.cornerRadius = 15
        self.SubmitButton.layer.masksToBounds = true
        
        self.feelingLuckyButton.setTitleColor(Colors.white, for: .normal)
        self.feelingLuckyButton.backgroundColor = Colors.system_orange
        self.feelingLuckyButton.layer.cornerRadius = 15
        self.feelingLuckyButton.layer.masksToBounds = true
        
        self.setupBarButtons()
    }
    
    func setupTextfields(textfield:UITextField){
        textfield.layer.cornerRadius = 10
        textfield.layer.masksToBounds = true
        textfield.layer.borderColor = Colors.lightGray.cgColor
        textfield.layer.borderWidth = 1.0
        textfield.delegate = self
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield.frame.height))
        textfield.leftView = paddingView
        textfield.leftViewMode = .always
    }
    
    private func setupRightViewIcon(image:UIImage,textField:UITextField){
        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        textField.rightView = imageView
        textField.rightViewMode = .always
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
    
    func setupBarButtons(){
        let logoutButton = UIBarButtonItem(image: ImageNames.logout, style: .plain, target: self, action: #selector(self.logoutClicked))
        let addRecipeButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addRecipeClicked))
        self.navigationItem.rightBarButtonItem = logoutButton
        self.navigationItem.leftBarButtonItem = addRecipeButton
    }
    
    @objc func addRecipeClicked(sender:UIBarButtonItem){
        self.view.endEditing(true)
        let addRecipeView = self.storyboard?.instantiateViewController(withIdentifier: "AddRecipeViewController") as! AddRecipeViewController
        let rootView = UINavigationController(rootViewController: addRecipeView)
        self.present(rootView, animated: true, completion: nil)
    }
    
    @objc func logoutClicked(sender:UIBarButtonItem){
        self.view.endEditing(true)
        let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .destructive, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { action in
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: LoginViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        })
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if selectedItems.count > 0 {
            var filteredItems = [FoodItem]()
            if self.selectedPrepareTime != 0 {
                filteredItems = selectedItems.filter({$0.prepareTime <= self.selectedPrepareTime })
                
                if self.selectedDishType != "" {
                    filteredItems = filteredItems.filter({$0.type == self.selectedDishType})
                }
            }else{
                filteredItems = selectedItems
                if self.selectedDishType != "" {
                    filteredItems = filteredItems.filter({$0.type == self.selectedDishType})
                }
            }
            
            let recipesView = self.storyboard?.instantiateViewController(withIdentifier: "RecipesViewController") as! RecipesViewController
            recipesView.filteredItems = filteredItems
            self.navigationController?.pushViewController(recipesView, animated: true)
            
        }else{
            CommonAlertView.shared.showAlert("No ingredients", "Please add atleast one ingredient", .normal)
        }
    }
    
    @IBAction func feelingLuckyClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        let randomItems = foodItemsList.randomElements(elements: 6)
        let recipesView = self.storyboard?.instantiateViewController(withIdentifier: "RecipesViewController") as! RecipesViewController
        recipesView.filteredItems = Array(randomItems)
        self.navigationController?.pushViewController(recipesView, animated: true)
    }
}



extension FilterViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.ingredientsTF {
            self.dishTypeTF.resignFirstResponder()
            self.prepareTimeTF.resignFirstResponder()
            let ingredientsView = self.storyboard?.instantiateViewController(withIdentifier: "IngredientsViewController") as! IngredientsViewController
            ingredientsView.selectedPrepareTime = self.selectedPrepareTime
            ingredientsView.selectedDishType = self.selectedDishType
            ingredientsView.onDoneBlock =  { result in
                let ingredients = selectedItems.map({$0.ingredients}).joined(separator: ",")
                self.ingredientsTF.text = ingredients
            }
            let rootView = UINavigationController(rootViewController: ingredientsView)
            self.present(rootView, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.prepareTimeTF {
            self.selectedPrepareTime = Int(self.prepareTimeTF.text!) ?? 0
            selectedItems.removeAll()
            self.ingredientsTF.text = ""
        }
    }
}

extension FilterViewController : UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dishTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currentItem = self.dishTypes[row]
        return currentItem
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currentItem = self.dishTypes[row]
        self.dishTypeTF.text = currentItem
        self.selectedDishType = currentItem
        selectedItems.removeAll()
        self.ingredientsTF.text = ""
    }
}

extension FilterViewController {
    
    func loadFoodItems(){
        let fileName = "FoodItems"
        let url = Bundle.main.url(forResource: fileName, withExtension: "json")!
        print("Json file == ",url.path)
        do {
            let jsonData = try Data(contentsOf: url)
            var jsonArray = try JSONSerialization.jsonObject(with: jsonData) as! [[String: Any]]
            
            let newItems = self.loadNewFoodItems()
            if newItems.count > 0 {
                jsonArray.append(contentsOf: newItems)
            }
            print("Total Items == ",jsonArray.count)
            self.saveFoodItems(jsonData: jsonArray)
        }
        catch {
            print(error)
        }
    }
    
    func loadNewFoodItems() -> [[String: Any]]{
        var jsonArray = [[String: Any]]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fileurl = URL(fileURLWithPath: appDelegate.newRecipesJsonPath)
        
        do {
            let jsonData = try Data(contentsOf: fileurl)
            jsonArray = try JSONSerialization.jsonObject(with: jsonData) as! [[String: Any]]
            print("New Items == ",jsonArray.count)
        }
        catch {
            print(error.localizedDescription)
        }
        return jsonArray
    }
    
    func saveFoodItems(jsonData:[[String:Any]]){
        
        for item in jsonData {
            
            let foodItem = FoodItem()
            
            if let name = item["Name"] as? String {
                foodItem.itemName = name
            }
            if let rating = item["Rating"] as? String {
                foodItem.rating = rating
            }
            if let easeOfPrepare = item["Ease of Prep"] as? String {
                foodItem.easeOfPrepare = easeOfPrepare
            }
            if let notes = item["Notes"] as? String {
                foodItem.notes = notes
            }
            if let dishType = item["Type"] as? String {
                foodItem.type = dishType
            }
            if let prepareTime = item["Prep Time"] as? Int {
                foodItem.prepareTime = prepareTime
            }
            if let photo = item["Photo"] as? String {
                foodItem.photo = photo
            }
            if let cookbook = item["Cookbook"] as? String {
                foodItem.cookBook = cookbook
            }
            if let page = item["Page #"] as? String {
                foodItem.page = page
            }
            if let ingredients = item["Ingredients"] as? String {
                foodItem.ingredients = ingredients
            }
            if let slowCooker = item["Slowcooker"] as? String {
                foodItem.slowCooker = slowCooker
            }
            if let link = item["Link"] as? String {
                foodItem.link = link
            }
            if let lastMade = item["Last Made"] as? String {
                foodItem.lastMade = lastMade
            }
            if let makeItNext = item["Make It Next"] as? String {
                foodItem.makeItNext = makeItNext
            }
            if foodItem.ingredients != "" {
                foodItemsList.append(foodItem)
                
                if !self.dishTypes.contains(foodItem.type) {
                    self.dishTypes.append(foodItem.type)
                }
            }
        }
        
        self.pickerView.reloadAllComponents()
    }
    
}

extension Array {
    mutating func randomElements(elements n: Int) -> ArraySlice<Element> {
        assert(n <= self.count)
        for i in stride(from: self.count - 1, to: self.count - n - 1, by: -1) {
            let randomIndex = Int(arc4random_uniform(UInt32(i + 1)))
            self.swapAt(i, randomIndex)
        }
        return self.suffix(n)
    }
}
