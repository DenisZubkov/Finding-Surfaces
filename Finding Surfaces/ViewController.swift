//
//  ViewController.swift
//  Finding Surfaces
//
//  Created by Denis Zubkov on 17/09/2018.
//  Copyright © 2018 Denis Zubkov. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        configuration.planeDetection = [.horizontal]
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    func createFloor(planeAnchor: ARPlaneAnchor) -> SCNNode {
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        
        
        let geometry = SCNPlane(width: width, height: height)
        
        let node = SCNNode()
        node.geometry = geometry
        
        node.eulerAngles.x = -Float.pi / 2
        node.opacity = 0.25
        node.name = "Floor"
        return node
    }
    
    func createBox() -> SCNNode {
        let codeBox = SCNNode()
        codeBox.position = SCNVector3(0, 0, 0)
        let box = SCNBox(width: 0.3, height: 0.3, length: 1, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        codeBox.geometry = box
        return codeBox
    }
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let plainAnchor = anchor as? ARPlaneAnchor else { return }
        
        let floor = createFloor(planeAnchor: plainAnchor)
        node.addChildNode(floor)
        
        
    }
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let plainAnchor = anchor as? ARPlaneAnchor,
        let floor = node.childNodes.first,
        let geometry = floor.geometry as? SCNPlane
            else { return }
        let boxNode = createBox()
        floor.addChildNode(boxNode)
        geometry.width = CGFloat(plainAnchor.extent.x)
        geometry.height = CGFloat(plainAnchor.extent.z)
        
        floor.position = SCNVector3(plainAnchor.center.x, 0, plainAnchor.center.z)
        
        
    }
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
