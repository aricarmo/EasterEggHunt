import ARKit
import SwiftUI
import SceneKit

struct ARViewContainer: UIViewRepresentable {
    
    let targetClue: Clue
    let onClueCentered: () -> Void
    
    func makeUIView(context: Context) -> ARSCNView {
            let arView = ARSCNView()
            let configuration = ARWorldTrackingConfiguration()
        
            configuration.planeDetection = [.horizontal, .vertical]
            arView.session.run(configuration)
            
            let coordinator = context.coordinator
            arView.delegate = coordinator
            coordinator.arView = arView
            coordinator.targetClue = targetClue
            coordinator.onClueCentered = onClueCentered
    
            coordinator.addPostItToScene()
            
            return arView
        }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        
    }
    
    func makeCoordinator() -> ARCoordinator {
        ARCoordinator()
    }
}

class ARCoordinator: NSObject, ARSCNViewDelegate {
    var arView: ARSCNView?
    var targetClue: Clue?
    var onClueCentered: (() -> Void)?
    var postItNode: SCNNode?
    
    private let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)
    private let selectionFeedback = UISelectionFeedbackGenerator()
    
    private var lastHapticTime: TimeInterval = 0
    private var lastDistance: CGFloat = 0
    private var isPostItFound = false
    
    private let postItPositions: [Int: SCNVector3] = [
        1: SCNVector3(0, 1.5, -2),      // Céu (alto)
        2: SCNVector3(0, -0.5, -1.5),   // Chão (baixo)
        3: SCNVector3(1.5, 0.5, -2),    // Direita (rodadinha)
        4: SCNVector3(-2, 0.8, -2.5)    // Esquerda longe
    ]
    
    func addPostItToScene() {
        guard let arView = arView,
              let targetClue = targetClue,
              let position = postItPositions[targetClue.number] else { return }
        
        let plane = SCNPlane(width: 0.15, height: 0.15)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.systemYellow
        material.emission.contents = UIColor.systemYellow.withAlphaComponent(0.2)
        plane.materials = [material]
        
        postItNode = SCNNode(geometry: plane)
        postItNode?.position = position
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = [.Y]
        postItNode?.constraints = [billboardConstraint]
        
        addTextToPostIt()
        
        arView.scene.rootNode.addChildNode(postItNode!)
        
        startCenterDetection()
    }
    
    private func addTextToPostIt() {
        guard let postItNode = postItNode,
              let targetClue = targetClue else { return }
        
        // Criar texto 3D
        let text = SCNText(string: targetClue.emoji, extrusionDepth: 0.01)
        text.font = UIFont.systemFont(ofSize: 0.08)
        text.firstMaterial?.diffuse.contents = UIColor.black
        
        let textNode = SCNNode(geometry: text)
        
        // Centralizar texto
        let (min, max) = textNode.boundingBox
        let width = max.x - min.x
        let height = max.y - min.y
        textNode.position = SCNVector3(-width/2, -height/2, 0.01)
        
        postItNode.addChildNode(textNode)
    }
    
    private func startCenterDetection() {
        lightImpact.prepare()
        mediumImpact.prepare()
        heavyImpact.prepare()
        selectionFeedback.prepare()
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            let distance = self.getDistanceFromCenter()
                        
            self.provideFeedbackBasedOnDistance(distance)
            
            if distance < 50 {
                timer.invalidate()
                self.isPostItFound = true
                self.onClueCentered?()
            }
        }
    }
    
    private func getDistanceFromCenter() -> CGFloat {
        guard let arView = arView,
             let postItNode = postItNode else { return CGFloat.greatestFiniteMagnitude }
       
       let postItScreenPosition = arView.projectPoint(postItNode.position)
       let screenCenter = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)
       let postItPoint = CGPoint(x: CGFloat(postItScreenPosition.x),
                                y: CGFloat(postItScreenPosition.y))
       
       return sqrt(pow(postItPoint.x - screenCenter.x, 2) +
                  pow(postItPoint.y - screenCenter.y, 2))
    }
    
    private func provideFeedbackBasedOnDistance(_ distance: CGFloat) {
        let currentTime = CACurrentMediaTime()
        let veryCloseZone: CGFloat = 80
        let closeZone: CGFloat = 150
        let mediumZone: CGFloat = 250
        let farZone: CGFloat = 400
        
        var feedbackInterval: TimeInterval = 0
        var shouldVibrate = false
        
        switch distance {
        case 0..<veryCloseZone:
            feedbackInterval = 0.1
            shouldVibrate = true
            if currentTime - lastHapticTime >= feedbackInterval {
                heavyImpact.impactOccurred()
            }
            
        case veryCloseZone..<closeZone:
            feedbackInterval = 0.2
            shouldVibrate = true
            if currentTime - lastHapticTime >= feedbackInterval {
                mediumImpact.impactOccurred()
            }
            
        case closeZone..<mediumZone:
            feedbackInterval = 0.4
            shouldVibrate = true
            if currentTime - lastHapticTime >= feedbackInterval {
                lightImpact.impactOccurred()
            }
            
        case mediumZone..<farZone:
            feedbackInterval = 0.8
            shouldVibrate = true
            if currentTime - lastHapticTime >= feedbackInterval {
                selectionFeedback.selectionChanged()
            }
            
        default:
            shouldVibrate = false
        }
        
        if shouldVibrate && currentTime - lastHapticTime >= feedbackInterval {
            lastHapticTime = currentTime
            
            if distance < lastDistance - 20 {
                selectionFeedback.selectionChanged()
            }
        }
        
        lastDistance = distance
    }
}

