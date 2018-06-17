//
//  ViewController.swift
//  P2P
//
//  Created by Roma Babajanyan on 11/06/2018.
//  Copyright © 2018 Roma Babajanyan. All rights reserved.
//

import UIKit
import MultipeerConnectivity

var myIndex = 0
var tableData = CustomData()


/*var imageData: Data = UIImagePNGRepresentation(image)
 var imageUIImage: UIImage = UIImage(data: imageData)*/

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate, MCBrowserViewControllerDelegate, MCSessionDelegate {
    

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state{
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName) ")
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName) ")
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName) ")
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {

        let image: UIImage = UIImage(data: data)!
        
        tableData.data.append(cellData.init(image: image, name: "IMG_ \(tableData.data.count+1)"))
        
        DispatchQueue.main.async {
            self.updateTableView()
        }
        
        
    }
    
    func sendImage(_ image: Data){
        if mcSession.connectedPeers.count > 0{
            do{
                try mcSession.send(image, toPeers: mcSession.connectedPeers, with: .reliable)
                print("Count state in send",mcSession.connectedPeers.count)
            }catch{
                fatalError("Unable to send data")
            }
        }else{
            print("You are not connected to another devices")
        }
    }

    //---------------------------------------------------------------------------------------------------------------------------
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)

    }
    
    @IBOutlet weak var tableView: UITableView!
    var imagePicker: UIImagePickerController!
    
    var mcSession: MCSession!
    var peerID: MCPeerID!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
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
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.delete) {
//            // handle delete (by removing the data from your array and updating the tableview)
//            data.data.remove(at: indexPath.row)
//            tableView.reloadData()
//        }
//    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let share = UITableViewRowAction(style: .normal, title: "Share") { (action, index) in
            print("share swipe tapped")
            // prepareData()
            let image = tableData.data[indexPath.row].image
            let dataImage = self.encodeImage(image: image!)
            
            self.sendImage(dataImage)
            
        }
        
        let del = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            tableData.data.remove(at: indexPath.row)
            // data.data[indexPath.row].image - image access
            // data.data[indexPath.row].name - name access
            self.updateTableView()
        }
        
        return [share,del]
    }
    
    func encodeImage(image: UIImage) -> Data{
        let imageData: Data = UIImagePNGRepresentation(image)!
        return imageData
    }

    // Getting the cell and configuring it
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        
        cell.imageLabel.text = tableData.data[indexPath.row].name
        cell.imageThumbnail.image = tableData.data[indexPath.row].image
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 4
        cell.imageThumbnail.layer.cornerRadius = cell.imageThumbnail.frame.height / 2
        
        return cell
    }
    
    // MARK: - BUTTONS
    
    @IBAction func setupTapped(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Connection", message: "Host or join session", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Host", style: .default, handler: {
            (action: UIAlertAction) in
            self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "CBLR", discoveryInfo: nil, session:self.mcSession)
            self.mcAdvertiserAssistant.start()
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Join", style: .default, handler: {
            (action: UIAlertAction) in
            let mcBrowser = MCBrowserViewController(serviceType: "CBLR", session: self.mcSession)
            mcBrowser.delegate = self
            
            self.present(mcBrowser, animated: true, completion: nil)
            
            }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
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
        
        tableData.data.append(cellData.init(image: #imageLiteral(resourceName: "IMG_5"), name: "Chester"))
        
        //print(data)
        updateTableView()
    }
    
    
    // MARK: IMAGEPICKING
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        let imagePicked = info[UIImagePickerControllerOriginalImage] as! UIImage
        tableData.data.append(cellData.init(image: imagePicked, name: "IMG_\(tableData.data.count+1)"))
        //print(data)
        updateTableView()
        
    }
    
    func updateTableView(){
        tableView.reloadData()
    }
    

}

