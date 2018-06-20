//
//  SetUpViewController.swift
//  P2P
//
//  Created by Roma Babajanyan on 19/06/2018.
//  Copyright © 2018 Roma Babajanyan. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class SetUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MPCManagerDelegate, MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
    }
    
    
    var isAdvertising: Bool!
    
    func invitationWasReceived(fromPeer: String) {
        let allert = UIAlertController(title: "", message: "\(fromPeer) wants to share an image with you", preferredStyle: .alert)
        
        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.appDelegate.mpcManager.invitationHandler(true, self.appDelegate.mpcManager.session)
        }
        
        let declineAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
            self.appDelegate.mpcManager.invitationHandler(false, nil)
        }
        
        allert.addAction(acceptAction)
        allert.addAction(declineAction)
        
        OperationQueue.main.addOperation { () -> Void in
            self.present(allert, animated: true, completion: nil)
        }
    }
    
    func connectedWithPeer(peerID: MCPeerID) {
        OperationQueue.main.addOperation {
            self.performSegue(withIdentifier: "mainPhotoSegue", sender: self)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    func foundPeer() {
        print(#function)
        
        tableView.reloadData()
        print("done")
    }
    
    
    func lostPeer() {
        tableView.reloadData()
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        appDelegate.mpcManager.delegate = self
        appDelegate.mpcManager.browser.startBrowsingForPeers()
        
        appDelegate.mpcManager.advertiser.startAdvertisingPeer()
        isAdvertising = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.mpcManager.foundPeers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peerCell") as! SetUpCellTableViewCell
        
        //cell.imageLabel.text
        
        cell.nameLabel.text = appDelegate.mpcManager.foundPeers[indexPath.row].displayName
        cell.cellImageView.image = #imageLiteral(resourceName: "user")
        cell.cellView.layer.cornerRadius = cell.frame.height / 4
        cell.cellImageView.layer.cornerRadius = cell.cellImageView.frame.height / 2
        //print(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    @IBAction func startstopAdvertising(_ sender: Any) {
        let actionSheet = UIAlertController(title: "", message: "Change Visibility", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        var actionTitle: String
        if isAdvertising == true {
            actionTitle = "Make me invisible to others"
        }
        else{
            actionTitle = "Make me visible to others"
        }
        
        let visibilityAction: UIAlertAction = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default) { (alertAction) -> Void in
            if self.isAdvertising == true {
                self.appDelegate.mpcManager.advertiser.stopAdvertisingPeer()
            }
            else{
                self.appDelegate.mpcManager.advertiser.startAdvertisingPeer()
            }
            
            self.isAdvertising = !self.isAdvertising
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
            
        }
        
        actionSheet.addAction(visibilityAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPeer = appDelegate.mpcManager.foundPeers[indexPath.row] as MCPeerID
        
        appDelegate.mpcManager.browser.invitePeer(selectedPeer, to: appDelegate.mpcManager.session, withContext: nil, timeout: 20)
    }
    

}
