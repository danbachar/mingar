//
//  ARViewController.swift
//  hackaTUM
//
//  Created by Łukasz Zalewski on 11/23/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation
import ARKit
import UIKit
import Vision

class ARViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet private var sceneView: ARSCNView!
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: Decide on it
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration,
                              options: [.resetTracking])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}
