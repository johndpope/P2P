//
//  MPCManager.swift
//  P2P
//
//  Created by Roma Babajanyan on 19/06/2018.
//  Copyright © 2018 Roma Babajanyan. All rights reserved.
//
// XUi
// Date sorting, contatins in array

//TODO: Test cases
// Tested case: when one of the devices closes the app, connection ends (but no notification, gotta add this), when returns back to the app, it seems that the new peer in the array establishes the connection, and the new session starts on the background (NEED TO FIND OUT WHETTHER OLD SESSION REMAINS LAUNCHES OR NOT). So it continues to send images correctly. Refactoring of the Multipeer Connectivity is quite done. Wrapped to the MPCManager.swift file. App uses delegation and notification patterns for app work.

// Need to fix that error with ICE etc. UPD: TRY OUT NEW IOS 11.4 VERSION ON BOTH DEVICES
//Figure out how to send videoStream
//Test this thing out on more failure cases. More crititcal ones. UPD: SEE NOTES 

import UIKit
import MultipeerConnectivity
import os.log

protocol MPCManagerDelegate {
    func foundPeer()
    
    func lostPeer()
    
    func invitationWasReceived(fromPeer: String)
    
    func connectedWithPeer(peerID: MCPeerID)
    
    func recievedData()
    
    func connectionEstablished(peerID: MCPeerID)
    
    func connectionLost()
    
    //func connectionPausedAlert()
}

protocol MPCConnectionDelegate{
    func connectionLost()
}

class MPCManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
    
    var session: MCSession!
    var peer: MCPeerID!
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!
    
    
    var foundPeers = [MCPeerID]()
    var invitationHandler: ((Bool, MCSession!)->Void)!
    
    // for handling multiadvertisers issue
    //    var index: Int?
      var creationDate = NSDate()
    //    var broadcastingDeviceName : String
    
    
    var MPCDelegate: MPCManagerDelegate?
    
    var MPCCDelegate: MPCConnectionDelegate?

    override init(){
        super.init()
        
        peer = MCPeerID(displayName: UIDevice.current.name)
        
        session = MCSession(peer: peer)
        session.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: "cblr")
        browser.delegate = self
        
        //advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: "cblr")
        //advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: ["index" : String(index), "creation_date" : String(creationDate.timeIntervalSince1970), "device" : broadcastingDeviceName, "id" : UIDevice.currentDevice().identifierForVendor!.UUIDString], serviceType: <#T##String#>)
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: ["creation_date": String(creationDate.timeIntervalSince1970),"device": UIDevice.current.name, "id": UIDevice.current.identifierForVendor!.uuidString], serviceType: "cblr")
        advertiser.delegate = self
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        // ? guard !foundPeers.contains(peerID) else {return }
        //dump(info!)
        if !foundPeers.contains(peerID){
            foundPeers.append(peerID)
        }
        
        print(#function)
        print(foundPeers)
        MPCDelegate?.foundPeer()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print(#function)
        for peer in foundPeers{
            if peer == peerID{
                if let i = foundPeers.index(of: peer){
                    foundPeers.remove(at: i)
                }
                //foundPeers.remove(at: index)
                //foundPeers.removeAtIndex(index)
                break
            }
        }
        MPCDelegate?.lostPeer()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print(#function)
        print(error.localizedDescription)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print(#function)

        self.invitationHandler = invitationHandler
        
        MPCDelegate?.invitationWasReceived(fromPeer: peerID.displayName)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print(#function)
        print(error.localizedDescription)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print(#function)

        switch  state {
        case MCSessionState.connected:
            print("Connected to session: \(session)")
            // Delegation to the setup view controller to display the alert to the user
            MPCDelegate?.connectionEstablished(peerID: peerID)
            //MPCDelegate?.connectedWithPeer(peerID: peerID)
            
            
        case MCSessionState.connecting:
            print("Connecting to session: \(session)")
            
        case MCSessionState.notConnected:
            print("Not connected to session \(session)")
            MPCCDelegate?.connectionLost()
        }
    }
    
    func sendData(image: UIImage, toPeer targetPeer: MCPeerID) -> Bool{
        print()
        print(#function)

        let peersArray = NSArray(object: targetPeer)
        
        // MARK: - IMAGE COMPRESSION ISSUE
//        if let imageData = UIImagePNGRepresentation(image){
//            do {
//                try session.send(imageData, toPeers: peersArray as! [MCPeerID], with: .reliable)
//            } catch {
//                print("failed send data",error.localizedDescription)
//            }
//            print("true")
//            return true
//        
//        } else {
//            print("false")
//            return false
//        }
        if let imageData = UIImageJPEGRepresentation(image, 0.5){
            do {
                try session.send(imageData, toPeers: peersArray as! [MCPeerID], with: .reliable)
            } catch {
                print("failed send data",error.localizedDescription)
            }
            print("true")
            return true
            
        } else {
            print("false")
            return false
        }

    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print(#function)
        
        //var imageUIImage: UIImage = UIImage(data: data)
        
        guard let imageUIImage = UIImage(data: data) else { return }
        
        
        let name = Notification.Name(rawValue: "Recieved")
        
        NotificationCenter.default.post(name: name, object: imageUIImage)
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
    
}
