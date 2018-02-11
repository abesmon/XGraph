//
//  CG2DView.swift
//  ConnectedGraph
//
//  Created by Алексей Лысенко on 10.02.18.
//  Copyright © 2018 Alexey Lysenko. All rights reserved.
//

import Foundation
import SpriteKit

class CGScene: SKScene {
    var vertexNodes = [SKNode]()
    var edgesJoints = [SKPhysicsJoint]()

    var graph: ConnectedGraph? {
        didSet { redrawGraph() }
    }
    
    private func redrawGraph() {
        vertexNodes.forEach { $0.removeFromParent() }
        edgesJoints.forEach { physicsWorld.remove($0) }

        guard let graph = graph else { return }
        let radius: CGFloat = 50
        graph.vertexes.enumerated().forEach { vertexItem in
            let vertex = vertexItem.element
            let vertexNode = SKShapeNode(circleOfRadius: radius)
            let randPos: Int = vertexItem.offset % 2 == 0 ? 30 : -30
            vertexNode.position = CGPoint(
                x: vertexItem.offset * Int(radius) * 2 + randPos,
                y: vertexItem.offset * Int(radius) * 2 - randPos
            )
            vertexNode.name = vertex.id
            vertexNode.strokeColor = .black
            vertexNode.fillColor = .random()
            vertexNode.glowWidth = 0
            vertexNode.physicsBody = SKPhysicsBody(circleOfRadius: radius)
            
            let vertexGravityField = SKFieldNode.radialGravityField()
            vertexGravityField.strength = 0
            vertexGravityField.name = "gravity"
            vertexNode.addChild(vertexGravityField)
            
            addChild(vertexNode)
            vertexNodes.append(vertexNode)
        }
        
        graph.edges.forEach { edge in
            guard let nodeA = childNode(withName: edge.first),
                let nodeABody = nodeA.physicsBody,
                let nodeB = childNode(withName: edge.second),
                let nodeBBody = nodeB.physicsBody else {
                    assertionFailure("WHOOPS")
                    return
            }
            
            let joint = SKPhysicsJointLimit.joint(withBodyA: nodeABody, bodyB: nodeBBody, anchorA: nodeA.position, anchorB: nodeB.position)
            joint.maxLength = radius * 10
//            joint.damping = 1
//            joint.
            physicsWorld.add(joint)
            edgesJoints.append(joint)
        }
        
        let firstNode = vertexNodes.first!
        (firstNode.childNode(withName: "gravity") as! SKFieldNode).strength = -10
        firstNode.physicsBody?.isDynamic = false
        
//        vertexNodes.last?.physicsBody?.isDynamic = false
    }

    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        let cameraNode = SKCameraNode()
        addChild(cameraNode)
        camera = cameraNode
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        redrawGraph()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}

class CG2DView: SKView {
    var graph: ConnectedGraph? {
        didSet { cgScene.graph = graph }
    }
    var cgScene: CGScene!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        showsFPS = true
        showsFields = true
        showsPhysics = true
        showsNodeCount = true
        cgScene = CGScene(size: frame.size)
        presentScene(cgScene)
        
        let plusButton = UIButton()
        plusButton.frame = CGRect(origin: CGPoint(x: 16, y: 16), size: CGSize(width: 45, height: 45))
        plusButton.setTitle("+", for: .normal)
        plusButton.addTarget(self, action: #selector(plusPressed), for: .touchUpInside)
        addSubview(plusButton)

        let minusButton = UIButton()
        minusButton.frame = CGRect(origin: CGPoint(x: 16, y: 16 + 45 + 16), size: CGSize(width: 45, height: 45))
        minusButton.setTitle("-", for: .normal)
        minusButton.addTarget(self, action: #selector(minusPressed), for: .touchUpInside)
        addSubview(minusButton)
    }
    
    @objc private func plusPressed() {
        scene?.camera?.setScale(scene!.camera!.xScale + 0.1)
    }
    
    @objc private func minusPressed() {
        scene?.camera?.setScale(scene!.camera!.xScale - 0.1)
    }
}
