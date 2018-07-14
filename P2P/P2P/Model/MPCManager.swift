//  MPCManager.swift
//  P2P
//
//  Created by Roma Babajanyan on 19/06/2018.
//  Copyright © 2018 Roma Babajanyan. All rights reserved.
//

// Need to fix that error with ICE etc. UPD: TRY OUT NEW IOS 11.4 VERSION ON BOTH DEVICES
// UPD: Error remains when both devices run latest 11.4
// Figure out how to send videoStream

import UIKit
import MultipeerConnectivity
import os.log

let name = "log.txt"


class MPCManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, StreamDelegate {
   
    // MARK: - PROPERTIES
    var MPCDelegate: MPCManagerDelegate?
    var MPCCDelegate: MPCConnectionDelegate?
    
    var session: MCSession!
    var peer: MCPeerID!
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!
    
    var foundPeers = [MCPeerID]()
    var invitationHandler: ((Bool, MCSession!)->Void)!
    

    override init(){
        print(#function,"\n")
        super.init()
        
        peer = MCPeerID(displayName: UIDevice.current.name)
        
        session = MCSession(peer: peer)
        session.delegate = self
        
        print(session)
        print("\n")
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: "cblr")
        browser.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: "cblr")
        advertiser.delegate = self
    }
    
    
    //MARK: - BROWSER METHODS
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
                print(#function)

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
    
    //MARK: - advertiser methods
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print(#function)

        self.invitationHandler = invitationHandler
        
        MPCDelegate?.invitationWasReceived(fromPeer: peerID.displayName)
    }
    
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print(#function)
        print(error.localizedDescription)
    }
    
    //MARK: - SESSION METHODS
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print(#function)
        
        //var logInfo = #function + "\n\n"
        
        switch  state {
        case MCSessionState.connected:
            print("Connected to session: \(session)")
//            logInfo = logInfo + "Connected to session: \(session)\n\n"
//            Loger.log(info: logInfo, name: name)
            MPCDelegate?.connectionEstablished(peerID: peerID)
            //initOuputStream(session) //
            
        case MCSessionState.connecting:
            print("Connecting to session: \(session)")
//            logInfo = logInfo + "Connecting to session: \(session) \n\n"
//            Loger.log(info: logInfo, name: name)
        case MCSessionState.notConnected:
            print("Not connected to session \(session)")
//            logInfo = logInfo + "Not connected to session \(session)\n\n"
//            Loger.log(info: logInfo, name: name)
            MPCCDelegate?.connectionLost()
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print(#function)
        
        //var imageUIImage: UIImage = UIImage(data: data)
        // TODO: - FIX THE END SIGNAL TO THE IMG OR CORRECT HANDLING IN THIS METHOD
        if let endSignal = String(data: data, encoding: String.Encoding.utf8) as String! {
            print("suka naxui",
                  
                  endSignal)
            let endRecieved = Notification.Name(rawValue: "\(endSignal)")
            NotificationCenter.default.post(name: endRecieved, object: endSignal)
        }
        
        if let imageUIImage = UIImage(data: data) {
            //print("Image recieved")
            let imgRecieved = Notification.Name(rawValue: "Recieved")
            NotificationCenter.default.post(name: imgRecieved, object: imageUIImage)
        }//else{
//            print("abort signal recieved")
//            let endSignal = String(data: data, encoding: String.Encoding.utf8) as String!
//            print(endSignal!)
//            let endRecieved = Notification.Name(rawValue: "\(endSignal!)")
//            NotificationCenter.default.post(name: endRecieved, object: endSignal!)
//            return
//        }

    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
//        stream.delegate = self
//        stream.schedule(in: .main, forMode: .defaultRunLoopMode)
//        stream.open()
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
    
    
    //MARK: - OPTIONAL. HELPFUL METHODS
    func initOuputStream(_ session: MCSession){
        do{
            let output = try session.startStream(withName: "photo", toPeer: foundPeers.first!)
            MPCCDelegate?.startOutputStream(output)
            output.schedule(in: RunLoop.main, forMode: .defaultRunLoopMode)
            output.open()
            
          } catch{
            print(error)
          }
    }
    
    func sendSignalToEnd(_ signal: String, toPeer targetPeer: MCPeerID){
        print(#function)
        print("still sending abort signal")
        let data = Data(signal.utf8)
        let peersArray = NSArray(object: targetPeer)
        print("yjyg")
        
        do{
            try session.send(data, toPeers: peersArray as! [MCPeerID], with: .reliable)
            print("guck")
        } catch{
            print("error")
            print(error.localizedDescription)
        }
        
    }
    
    func sendData(image: UIImage, toPeer targetPeer: MCPeerID) -> Bool{
        print()
        print(#function)

        let peersArray = NSArray(object: targetPeer)

        if let imageData = UIImageJPEGRepresentation(image, 0.15){
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
}
