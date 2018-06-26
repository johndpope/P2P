//
//  MCSessionManagement.swift
//  P2P
//
//  Created by Roma Babajanyan on 23/06/2018.
//  Copyright © 2018 Roma Babajanyan. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MCSessionManager: MCSession{
    var advertiserAssistant : MCAdvertiserAssistant?
    var index : Int
    var creationDate : NSDate
    var broadcastingDeviceName : String
    
    var displayName: String{
        get{
            return myPeerID.displayName
        }
    }
    
    var peersCount: Int{
        get{
            return self.connectedPeers.count
        }
    }
    
    var uniqueID: String{
        get{
            return "\(displayName)+\(index)+\(creationDate)"
        }
    }
    
    init(peer sessionPeer: MCPeerID, serviceType : String?, delegate sessionDelegate: MCSessionDelegate?, index presentationIndex : Int, creationDate date : NSDate, broadcastingDevice device: String) {
        index = presentationIndex
        creationDate = date
        broadcastingDeviceName = device
        super.init(peer : sessionPeer, securityIdentity : nil, encryptionPreference: .none)
        delegate = sessionDelegate
        
        if serviceType != nil {
            advertiserAssistant = MCAdvertiserAssistant(serviceType: serviceType!, discoveryInfo: ["index" : String(index), "creation_date" : String(creationDate.timeIntervalSince1970), "device" : broadcastingDeviceName, "id" : (UIDevice.current.identifierForVendor?.uuidString)!/*currentDevice().identifierForVendor!.UUIDString]*/], session: self)
            
            advertiserAssistant!.start()
        }
    }
    
    convenience init(peer sessionPeer: MCPeerID, discoveryInfo : [String : String]) {
        let index = Int(discoveryInfo["index"]!)
        let creationDate = NSDate(timeIntervalSince1970: Double(discoveryInfo["creation_date"]!)!)
        let device = discoveryInfo["device"]!
        self.init(peer : sessionPeer, serviceType : nil, delegate : nil, index : index!, creationDate : creationDate, broadcastingDevice : device)
    }
    
    deinit {
        self.disconnect()
        advertiserAssistant?.stop()
        delegate = nil
        print("Session deinitialized")
    }
    
    
}
