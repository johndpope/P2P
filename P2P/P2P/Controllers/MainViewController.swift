//
//  MViewController.swift
//  P2P
//
//  Created by Roma Babajanyan on 04/07/2018.
//  Copyright © 2018 Roma Babajanyan. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import OpalImagePicker

var myIndex = 0
var tableData = CustomData()

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate, MPCConnectionDelegate, StreamDelegate, OpalImagePickerControllerDelegate{

    let recievedName = Notification.Name(rawValue: "Recieved")
    let endName = Notification.Name(rawValue: "END")
    
    var current: UIImage?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var tableView: UITableView!
    //var imagePicker: UIImagePickerController!
    var picker = UIImagePickerController()
    var imagePicker = OpalImagePickerController()
    //imagePicker.imagePickerDelegate = self
    //present(imagePicker, animated: true, completion: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.mpcManager.MPCCDelegate = self
        
        
        picker.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
         NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.recieved(_:)), name: recievedName, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.end(_:)), name: endName, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func recieved(_ notification: NSNotification){
        print(#function)
        let recievedImage = notification.object as! UIImage
        //print(recievedImage,"\n\n\n\n\n\n\n\n\n")
        current = recievedImage
        //print(current)
//        tableData.data.append(cellData(image: recievedImage, name: "IMG_\(tableData.data.count + 1)"))
        
        //performSegue(withIdentifier: "modalySegue", sender: self)
        DispatchQueue.main.async {
            //let recievedImage = notification.object as! UIImage
            tableData.data.append(cellData(image: recievedImage, name: "\(tableData.data.count + 1)"))
            

            //            tableData.data.append(cellData(image: recievedImage, name: "IMG_\(tableData.data.count + 1)"))
            self.tableView.reloadData()
        }
        
        
    }
    
    @objc func end(_ notification: NSNotification){
        print("\n\n",#function,"\n\n")
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                self.appDelegate.mpcManager.session.disconnect()
            }
        }

    }
    
    
    //    func foundPeer() {
    //        //tblPeers.reloadData()
    //    }
    //
    //
    //    func lostPeer() {
    //        //tblPeers.reloadData()
    //    }
    
    func connectionLost(){
        print(#function)
        let connectionAllert = UIAlertController(title: "Session Ended", message: "Connection was lost", preferredStyle: .alert)
        
        let reconnectButton = UIAlertAction(title: "Reconnect", style: .default) { (reconnectAlert) in
            self.dismiss(animated: true)
        }
        
        connectionAllert.addAction(reconnectButton)
        
        OperationQueue.main.addOperation {
            self.present(connectionAllert, animated: true, completion: nil)
        }
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
        return 60.0
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
        
        let save = UITableViewRowAction(style: .normal, title: "Save") { (save, index) in
            UIImageWriteToSavedPhotosAlbum(tableData.data[indexPath.row].image!, nil, nil, nil)
        }
        
        return [share,del,save]
    }
    
    // Getting the cell and configuring it
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "customPhotoCell")  as! MainTableViewCell
        
        cell.cellLabel.text = tableData.data[indexPath.row].name
        cell.cellImage.image = tableData.data[indexPath.row].image

        return cell
    }

    // MARK: IMAGEPICKING
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imagePicked = info[UIImagePickerControllerOriginalImage]{
            let img = imagePicked as! UIImage
            tableData.data.append(cellData.init(image: img, name: "\(tableData.data.count + 1)"))
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        //print(data)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    @IBAction func unwindSetUp(_segue: UIStoryboardSegue){
        
    }
    
    @IBAction func addNewPeers(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: REFRESH
    func updateTableView(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: UIIMAGE to DATA
    func encodeImage(image: UIImage) -> Data{
        let imageData: Data = UIImagePNGRepresentation(image)!
        return imageData
    }
    
    
    //MARK: TOOLBAR ACTIONS
    @IBAction func addTapped(_ sender: Any) {
//        picker = UIImagePickerController()
//        picker.delegate = self
//        picker.allowsEditing = false
//        picker.sourceType = .photoLibrary
//
//        present(picker, animated: true, completion: nil)
        imagePicker = OpalImagePickerController()
        imagePicker.imagePickerDelegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        DispatchQueue.main.async {
            for image in images{
                tableData.data.append(cellData(image: image, name: "\(tableData.data.count+1)"))
            }
        }

        
        imagePicker.dismiss(animated: true, completion: nil)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        
    }
    
    
    
    @IBAction func refreshTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
//
//    @IBAction func unwindSetUpSegue(segue:UIStoryboardSegue) {
//        //disconnect from the session.
//        //Unwind to the setUp Screen. 1st stop
//        performSegue(withIdentifier: "unwindToSetUp", sender: nil)
//    }
//
    @IBAction func doneTapped(_ sender: Any) {
        self.appDelegate.mpcManager.sendSignalToEnd("ABORT", toPeer: self.appDelegate.mpcManager.foundPeers[0])
        
        dismiss(animated: true) {
            print("bye bye")
            
            self.appDelegate.mpcManager.session.disconnect()
        }
        
    }
    
    func startOutputStream(_ output: OutputStream) {
        output.delegate = self
    }
    
    
    
    
    
    
    
    
    
    

}
