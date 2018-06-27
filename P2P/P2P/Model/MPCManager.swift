//
//  MPCManager.swift
//  P2P
//
//  Created by Roma Babajanyan on 19/06/2018.
//  Copyright © 2018 Roma Babajanyan. All rights reserved.
//

// Date sorting, contatins in array


// We h

import UIKit
import MultipeerConnectivity
import os.log

protocol MPCManagerDelegate {
    func foundPeer()
    
    func lostPeer()
    
    func invitationWasReceived(fromPeer: String)
    
    func connectedWithPeer(peerID: MCPeerID)
    
    func recievedData()
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
    
    
    var delegate: MPCManagerDelegate?
    
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
        
        //dump(info!)
        if !foundPeers.contains(peerID){
            foundPeers.append(peerID)

        }
        print(#function)
        print(foundPeers)
        delegate?.foundPeer()
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
        delegate?.lostPeer()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print(#function)
        print(error.localizedDescription)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print(#function)

        self.invitationHandler = invitationHandler
        
        delegate?.invitationWasReceived(fromPeer: peerID.displayName)
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
            delegate?.connectedWithPeer(peerID: peerID)
        case MCSessionState.connecting:
            print("Connecting to session: \(session)")
            
        default:
            print("Did not connect to session: \(session)")
        }
    }
    
    func sendData(image: UIImage, toPeer targetPeer: MCPeerID) -> Bool{
        print()
        print(#function)

        let peersArray = NSArray(object: targetPeer)
        
        if let imageData = UIImagePNGRepresentation(image){
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
