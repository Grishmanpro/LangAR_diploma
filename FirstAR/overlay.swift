import Foundation
import ARKit
import SceneKit


class OverlayPlane: SCNNode{
    
    var anchor: ARPlaneAnchor
    var planeGeometry: SCNPlane!
    var width: SCNText!
    var height: SCNText!
    var mainNode: SCNNode!
    
    init(anchor: ARPlaneAnchor) {
        self.anchor = anchor
        super.init()
        setup()
    }
    
    func update(anchor: ARPlaneAnchor){
        self.planeGeometry.width = CGFloat(anchor.planeExtent.width)
        self.planeGeometry.height = CGFloat(anchor.planeExtent.height)
        self.position =  SCNVector3(x: anchor.center.x, y: 0, z: anchor.center.z)
        self.width.string = "Width: \(anchor.planeExtent.width)"
        self.height.string = "Height: \(anchor.planeExtent.height)"
        
        let planeNode = self.childNodes.first!
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
    }
    
    func setup(){
                //параметры текста - ширина
        self.width = SCNText(string: "Width: ", extrusionDepth: 1.0)
        width.firstMaterial?.diffuse.contents = UIColor.black
        let widthNode = SCNNode(geometry: width)
        widthNode.scale = SCNVector3(x: 0.002, y: 0.002, z: 0.002)
        widthNode.position = SCNVector3(x: 0, y: 0, z: anchor.planeExtent.width/2)
        //widthNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi/2.0), 1.0, 0.0, 0.0)
        
        //параметры текста - высота
        self.height = SCNText(string: "Height: ", extrusionDepth: 1.0)
        height.firstMaterial?.diffuse.contents = UIColor.black
        let heightNode = SCNNode(geometry: height)
        heightNode.scale = SCNVector3(x: 0.002, y: 0.002, z: 0.002)
        heightNode.position = SCNVector3(x: -(anchor.planeExtent.height/2), y: 0, z: 0)
        //heightNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi/2.0), 1.0, 0.0, 0.0)
        
        //параметры плоскости
        self.planeGeometry =  SCNPlane(width: 0.5, height: 0.5)
        print(self.anchor.planeExtent.width)
        print(self.anchor.planeExtent.height)
       
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.gray
        self.planeGeometry.materials = [material]
        self.planeGeometry.firstMaterial?.transparency = 0.8
    
        let planeNode = SCNNode(geometry: self.planeGeometry)
        planeNode.name = "Plane"
        planeNode.position = SCNVector3(x: anchor.center.x, y: 0, z: anchor.center.z)
        print(anchor.center.x)
        print(anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi/2.0), 1.0, 0.0, 0.0)
        //planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1, 0, 0)
        
        
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
        
        planeNode.physicsBody?.categoryBitMask = bodyType.plane.rawValue
        

       // self.addChildNode(widthNode)
       // self.addChildNode(heightNode)
        self.addChildNode(planeNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
