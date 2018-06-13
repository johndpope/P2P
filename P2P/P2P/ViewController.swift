//
//  ViewController.swift
//  P2P
//
//  Created by Roma Babajanyan on 11/06/2018.
//  Copyright © 2018 Roma Babajanyan. All rights reserved.
//

import UIKit

var myIndex = 0
var names = ["IMG_1", "IMG_2", "IMG_3", "IMG_4","IMG_5","IMG_6","IMG_7","IMG_8"]
var img_names = ["Aang","Mike","Chester","Toph","Chester","Avatar", "Toph", "Toph"]
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func Insert_Pressed(_ sender: Any) {
        names.append("IMG_\(names.count+1)")
        img_names.append("TEST\(img_names.count+1)")
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    // Программно тоже задаем высоту каждой ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //Свайп для удаления
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            names.remove(at: indexPath.row)
            tableView.reloadData()
            print(names)
        }
    }
    
    // Работа с ячейкой
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 4
        
        cell.imageLabel.text = img_names[indexPath.row]
        
        cell.imageThumbnail.image = UIImage(named: names[indexPath.row])
        
        cell.imageThumbnail.layer.cornerRadius = cell.imageThumbnail.frame.height / 2
        
        return cell
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}

