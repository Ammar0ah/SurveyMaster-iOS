//
//  CreateQuestionsTableViewController.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 6/6/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit

class CreateQuestionsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
   
    var pickerData : [String] = [String]()
    var value = "text"
    
    
    
    @IBOutlet var surveyTitleTxt: UITextField!
  
    @IBOutlet var questionsTableView: UITableView!
   
    @IBOutlet var QTypesPickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
    QTypesPickerView.dataSource = self
    QTypesPickerView.delegate = self
          pickerData = ["short text", "slider"]
        questionsTableView.dataSource = self
        questionsTableView.delegate = self
        questionsTableView.register(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "textCell")
          questionsTableView.register(UINib(nibName: "SliderTableViewCell", bundle: nil), forCellReuseIdentifier: "sliderCell")
        questionsTableView.rowHeight = UITableView.automaticDimension
        questionsTableView.estimatedRowHeight = 200
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func AddBtn(_ sender: UIButton) {
        pickerData.append(value)
      
        print(value)
       questionsTableView.reloadData()
      
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.layoutIfNeeded()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       value = pickerData[row]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        value = pickerData[indexPath.row]
        print(pickerData)
        if(value == "short text"){
            
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath)
                as! TextTableViewCell
             cell.selectionStyle =  UITableViewCell.SelectionStyle.none
            return cell
        }
        if (value == "slider"){
            var cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath)
                as! SliderTableViewCell
             cell.selectionStyle =  UITableViewCell.SelectionStyle.none
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: "textCell")
       
    }
    // MARK: - Table view data source

 

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
