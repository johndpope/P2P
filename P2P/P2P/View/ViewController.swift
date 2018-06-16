//
//  ViewController.swift
//  P2P
//
//  Created by Roma Babajanyan on 11/06/2018.
//  Copyright © 2018 Roma Babajanyan. All rights reserved.
//


//todo fix auto delete when out of image viewing
import UIKit

var myIndex = 0
var data = Data()

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Setting up a tableview with customview cells
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.data.count
    }
    
    // Программно тоже задаем высоту каждой ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    //Deletion functions
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            data.data.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    // Getting the cell and configuring it
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        
        cell.imageLabel.text = data.data[indexPath.row].name
        cell.imageThumbnail.image = data.data[indexPath.row].image
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 4
        cell.imageThumbnail.layer.cornerRadius = cell.imageThumbnail.frame.height / 2
        
        return cell
    }
    
    
// Image picking functions
    @IBAction func pressedAdd(_ sender: UIButton) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func InsertPressed(_ sender: UIButton) {
        data.data.append(cellData.init(image: #imageLiteral(resourceName: "IMG_5"), name: "Chester"))
        
        //print(data)
        update()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        let imagePicked = info[UIImagePickerControllerOriginalImage] as! UIImage
        data.data.append(cellData.init(image: imagePicked, name: "IMG_\(data.data.count+1)"))

        //print(data)
        update()
        
    }
    
    /*Other useful functions*/
//    
//    // White out the status bar
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    func update(){
        tableView.reloadData()
    }

    
    
}

