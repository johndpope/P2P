//
//  Delegation.swift
//  P2P
//
//  Created by Roma Babajanyan on 11/07/2018.
//  Copyright © 2018 Roma Babajanyan. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import UIKit

protocol MPCManagerDelegate {
    func foundPeer()
    
    func lostPeer()
    
    func invitationWasReceived(fromPeer: String)
    
    func connectedWithPeer(peerID: MCPeerID)
    
    func recievedData()
    
    func connectionEstablished(peerID: MCPeerID)
    
    func connectionLost()
    
}

protocol MPCConnectionDelegate{
    func connectionLost()
    
}
