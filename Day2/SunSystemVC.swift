//
//  SunSystemVC.swift
//  Day2
//
//  Created by lingda on 2017/9/24.
//  Copyright © 2017年 btc. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
class SunSystemVC: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    //地球饶太阳轨道
    lazy var sunEarthOrbitNode: SCNNode = {
        let node = SCNNode()
        node.geometry = SCNBox(width: 1.32, height: 0, length: 1.32, chamferRadius: 0)
        node.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/earth/orbit.png")
        node.geometry?.firstMaterial?.diffuse.mipFilter = SCNFilterMode.linear
        node.geometry?.firstMaterial?.lightingModel = SCNMaterial.LightingModel.constant
        return node
    }()
    
    //太阳节点
    lazy var sunNode: SCNNode = {
        let node = SCNNode()
        node.position = SCNVector3(0.5,0,-0.5)
        node.geometry = SCNSphere(radius: 0.1)
        node.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/earth/sun.jpg")
        node.geometry?.firstMaterial?.multiply.contents = UIImage(named: "art.scnassets/earth/sun.jpg")
        node.geometry?.firstMaterial?.multiply.intensity = 0.5
        node.geometry?.firstMaterial?.lightingModel = SCNMaterial.LightingModel.constant
        //因为太阳的自转动画是通过拉扯做出来的，下面4句是为了在拉扯过程不断的将图片铺满整个太阳，可以注释看下效果
        node.geometry?.firstMaterial?.multiply.wrapS = .`repeat`
        node.geometry?.firstMaterial?.multiply.wrapT = .`repeat`
        node.geometry?.firstMaterial?.diffuse.wrapS = .`repeat`
        node.geometry?.firstMaterial?.diffuse.wrapT = .`repeat`
        return node
    }()
    
    
    //地球虚拟节点
    lazy var earthVirtualNode: SCNNode = {
        let node = SCNNode()
        node.position = SCNVector3(0.6,0,0)
        return node
    }()

    //地球节点
    lazy var earthNode: SCNNode = {
        let node = SCNNode()
        node.geometry = SCNSphere(radius: 0.04)
        node.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/earth/earth-diffuse-mini.jpg")
        node.geometry?.firstMaterial?.emission.contents = UIImage(named: "art.scnassets/earth/earth-emissive-mini.jpg")
        node.geometry?.firstMaterial?.specular.contents = UIImage(named: "art.scnassets/earth/earth-specular-mini.jpg")
        node.geometry?.firstMaterial?.shininess = 0.1
        node.geometry?.firstMaterial?.diffuse.intensity = 0.5
        return node
    }()
    
    //月球公转的虚拟节点
    lazy var moonRevolutionVirtualNode: SCNNode = {
        let node = SCNNode()
        return node
    }()
    
    
    //月球节点
    lazy var moonNode: SCNNode = {
        let node = SCNNode()
        node.geometry = SCNSphere(radius: 0.02)
        node.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/earth/moon.jpg")
        node.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/earth/moon.jpg")
        node.geometry?.firstMaterial?.specular.contents = UIColor.lightGray
        node.position = SCNVector3(0.12,0,0)
        return node
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addNode()
        addAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.run(ARWorldTrackingConfiguration())
    }
    
    //添加节点
    func addNode() {
        sunNode.addChildNode(sunEarthOrbitNode)
        earthVirtualNode.addChildNode(earthNode)
        earthVirtualNode.addChildNode(moonRevolutionVirtualNode)
        moonRevolutionVirtualNode.addChildNode(moonNode)
        sunNode.addChildNode(earthVirtualNode)
        sceneView.scene.rootNode.addChildNode(sunNode)
    }
    //添加动画
    func addAnimation() {
        //太阳自转(这种自转是图片扯动的假象，可以看起来像熔岩流动)
        let sunRotation = CABasicAnimation(keyPath: "contentsTransform")
        sunRotation.repeatCount = Float.greatestFiniteMagnitude
        sunRotation.duration = 10.0
        sunRotation.fromValue = NSValue(caTransform3D: CATransform3DConcat(CATransform3DMakeTranslation(0, 0, 0),CATransform3DMakeTranslation(3, 3, 3)))
        sunRotation.toValue = NSValue(caTransform3D: CATransform3DConcat(CATransform3DMakeTranslation(1, 0, 0),CATransform3DMakeTranslation(5, 5, 5)))
        sunNode.geometry?.firstMaterial?.diffuse.addAnimation(sunRotation, forKey: "sunRotation")
        //地球公转  这里设置太阳转动，因为地球是直接添加到太阳节点，所以太阳自转的时候，地球也会以太阳为中心公转
        sunNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 1)))
        //月球公转 同上理
        moonRevolutionVirtualNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 0.3)))
        //地球自转
        earthNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 1)))
        //月球自转
        moonNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 1)))
        
    }
}



//太阳光节点  加了不好看  但是代码留着
//lazy var sunLightNode: SCNNode = {
//    let node = SCNNode()
//    node.light = SCNLight()
//    node.light?.color = UIColor.red
//    node.light?.type = SCNLight.LightType.omni
//    node.light?.attenuationEndDistance = 0.8
//    node.light?.attenuationStartDistance = 0.4
//    SCNTransaction.begin()
//    SCNTransaction.animationDuration = 1
//    do {
//        node.light?.color = UIColor.white
//
//    }
//    SCNTransaction.commit()
//    return node
//}()

