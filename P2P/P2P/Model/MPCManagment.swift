////
////  MPCManagment.swift
////  P2P
////
////  Created by Roma Babajanyan on 17/06/2018.
////  Copyright © 2018 Roma Babajanyan. All rights reserved.
////
//
//import UIKit
//
//import MultipeerConnectivity
//
//
//protocol MPCManagerDelegate {
//    func foundPeer()
//    
//    func lostPeer()
//    
//    func invitationWasReceived(fromPeer: String)
//    
//    func connectedWithPeer(peerID: MCPeerID)
//}
//
//class MPCManagment: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
//
//    var session: MCSession!
//    
//    var peer: MCPeerID!
//    
//    var browser: MCNearbyServiceBrowser!
//    
//    var advertiser: MCNearbyServiceAdvertiser!
//    
//    var foundPeers = [MCPeerID]()
//    
//    var delegate: MPCManagerDelegate?
//    
//    var invitationHandler: ((Bool, MCSession!)->Void)!
//    
//    override init()
//    {
//        super.init()
//        
//        peer = MCPeerID(displayName: UIDevice.current.name)
//        session = MCSession(peer: peer)
//        session.delegate = self
//        
//        browser = MCNearbyServiceBrowser(peer: peer, serviceType: "cblr-1")
//        browser.delegate = self
//        
//        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: "cblr-1")
//        advertiser.delegate = self
//    }
//    
//    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
//        foundPeers.append(peerID)
//        
//        delegate?.foundPeer()
//    }
//    
//    
//    
//}
