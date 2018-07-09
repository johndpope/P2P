//
//  MViewController.swift
//  P2P
//
//  Created by Roma Babajanyan on 04/07/2018.
//  Copyright © 2018 Roma Babajanyan. All rights reserved.
//

import UIKit
import MultipeerConnectivity


var myIndex = 0
var tableData = CustomData()

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    let recievedName = Notification.Name(rawValue: "Recieved")
    
    var current: UIImage?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func foundPeer() {
        //tblPeers.reloadData()
    }
    
    
    func lostPeer() {
        //tblPeers.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    //var imagePicker: UIImagePickerController!
    var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
         NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.recieved(_:)), name: recievedName, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - NIL ISSUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let previewVC = segue.destination as? PopOutPreviewController{
                print(current ?? "NIIIIIL")
            if let img = current{
                previewVC.imageSheet?.image = img
            }
                //previewVC.imageSheet?.image = current!
        }
    }
    
    @objc func recieved(_ notification: NSNotification){
        let recievedImage = notification.object as! UIImage
        //print(recievedImage,"\n\n\n\n\n\n\n\n\n")
        current = recievedImage
        //print(current)
        tableData.data.append(cellData(image: recievedImage, name: "IMG_\(tableData.data.count + 1)"))
        
        //performSegue(withIdentifier: "modalySegue", sender: self)
        DispatchQueue.main.async {
            //let recievedImage = notification.object as! UIImage
            
            //            tableData.data.append(cellData(image: recievedImage, name: "IMG_\(tableData.data.count + 1)"))
            self.tableView.reloadData()
        }
     
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TABBLEVIEW
    // Setting up a tableview with customview cells
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    //Deletion functions
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let share = UITableViewRowAction(style: .normal, title: "Share") { (action, index) in
            print("share swipe tapped")
            // prepareData()
            let image = tableData.data[indexPath.row].image
            //let dataImage = self.encodeImage(image: image!)
            self.appDelegate.mpcManager.sendData(image: image!, toPeer: self.appDelegate.mpcManager.foundPeers[0])
            //self.sendImage(image!)
            
        }
        
        let del = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            tableData.data.remove(at: indexPath.row)
            // data.data[indexPath.row].image - image access
            // data.data[indexPath.row].name - name access
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return [share,del]
    }
    
    // Getting the cell and configuring it
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "customPhotoCell")  as! MainTableViewCell
        
        cell.cellLabel.text = tableData.data[indexPath.row].name
        cell.cellImage.image = tableData.data[indexPath.row].image
        cell.cellImage.layer.cornerRadius = cell.cellImage.frame.height / 2
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 3

        
        return cell
    }

    // MARK: IMAGEPICKING
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imagePicked = info[UIImagePickerControllerOriginalImage]{
            let img = imagePicked as! UIImage
            tableData.data.append(cellData.init(image: img, name: "IMG_\(tableData.data.count+1)"))
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        //print(data)
        updateTableView()
        
    }
    
    // MARK: REFRESH
    func updateTableView(){
        tableView.reloadData()
    }
    
    // MARK: UIIMAGE to DATA
    func encodeImage(image: UIImage) -> Data{
        let imageData: Data = UIImagePNGRepresentation(image)!
        return imageData
    }
    
    
    //MARK: TOOLBAR ACTIONS
    @IBAction func addTapped(_ sender: Any) {
        picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func refreshTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func setTapped(_ sender: Any) {
        //disconnect from the session. Unwind to the setUp Screen
    }
    
    
    
    
    
    
    
    
    
    
    

}