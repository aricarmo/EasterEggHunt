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
