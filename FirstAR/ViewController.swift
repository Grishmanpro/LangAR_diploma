import UIKit
import SceneKit
import ARKit
import AVFoundation

enum bodyType: Int{
    case box = 1
    case plane = 2
}

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var nameLabel: UILabel!
    
    
    @IBOutlet var sceneView: ARSCNView!
    var planes: OverlayPlane?
    var x: Float = 0.0
    var y: Float = 0.0
    var z: Float = 0.0
    let synthesizer = AVSpeechSynthesizer()
    
    let url = Bundle.main.url(forResource: "poly", withExtension: "usdz")!
    let cup = Bundle.main.url(forResource: "caffe_latte", withExtension: "usdz")!
    lazy var object1 = SCNNode()
    lazy var cupScene1 = SCNNode()
    
    let cameraNode = SCNNode()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //базовые настройки
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        //объявление сцены
        let scene = SCNScene()
        sceneView.scene = scene
        
        sceneView.layer.cornerRadius = 35
        
        nameLabel.text = "test test"
        
        //асинхронный процесс создания объектов сцен
        DispatchQueue.global(qos: .background).async { [self] in
               guard let objectScene = try? SCNScene(url: url, options: nil),
                     let cupScene = try? SCNScene(url: cup, options: nil)
               else { return }
               
               let object = objectScene.rootNode
               let cupNode = cupScene.rootNode
               
               object.scale = SCNVector3(0.5, 0.5, 0.5)
               cupNode.scale = SCNVector3(0.005, 0.005, 0.005)
               
               object1 = object
               cupScene1 = cupNode
           }
        
        registerGestureRecognizer()
    }
    
        func registerGestureRecognizer(){
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
            tapGestureRecognizer.numberOfTapsRequired = 1
            self.sceneView.addGestureRecognizer(tapGestureRecognizer)
            
        }
  
        @objc func tapped(recognizer: UIGestureRecognizer){
            
            guard let sceneView = recognizer.view as? SCNView else { return }
            
            let touchLocation = recognizer.location(in: sceneView)
            let hitResults = sceneView.hitTest(touchLocation, options: [:])

            object1.position = SCNVector3(-0.04, y, -0.05)
            cupScene1.position = SCNVector3( -0.02, y, -0.05)
            
            self.sceneView.scene.rootNode.addChildNode(cupScene1)
            self.sceneView.scene.rootNode.addChildNode(object1)
            
            if let hitResult = hitResults.first,let nodeName = hitResult.node.name {
                    let nodeString = String(nodeName.prefix(nodeName.count))
                nameLabel.text = nodeString
                    speak(nodeString)
                    print(nodeName)
            } else {return}
            
        }

        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            guard let planeAnchor = anchor as? ARPlaneAnchor, planes == nil
                   else { return }
                   let planeNode = OverlayPlane(anchor: planeAnchor)
                   x = anchor.transform.columns.3.y
                   y = anchor.transform.columns.3.y
                   z = anchor.transform.columns.3.y
                   planes = planeNode
                   node.addChildNode(planeNode)
        }
    
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor){
                   DispatchQueue.main.async { [self] in
                       guard let currentPlane = planes,currentPlane.anchor.identifier == anchor.identifier,
                             let newAnchor = anchor as? ARPlaneAnchor
                       else { return }
                       currentPlane.update(anchor: newAnchor)
                   }
               }
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            let configuration = ARWorldTrackingConfiguration() //отслеживание мира
            configuration.planeDetection = .horizontal
            sceneView.session.run(configuration)
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            sceneView.session.pause()
        }
    
        //все слово
        func speak(_ string: String) {
            let speaky = AVSpeechUtterance(string: string)
            speaky.voice = AVSpeechSynthesisVoice(language: "en-US")
            speaky.voice = AVSpeechSynthesisVoice(identifier: "male")
            speaky.rate = 0.4
            speaky.volume = 20.0// Change the rate if desired.
            synthesizer.speak(speaky)
        }
        
        //по буквам
        func spellOut(_ string: String) {
            for char in string {
                let utterance = AVSpeechUtterance(string: String(char))
                utterance.rate = AVSpeechUtteranceDefaultSpeechRate // Change the rate if desired.
                utterance.pitchMultiplier = 15.5 // Change the pitch if desired.
                utterance.volume = 5.0 // Change the volume if desired.
                utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // Change the language if desired.
                utterance.preUtteranceDelay = 0.1 // Add a delay between letters if desired.
                synthesizer.speak(utterance)
            }
        }
    
    
    
    }
