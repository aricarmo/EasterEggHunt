import SwiftUI

@MainActor
public final class ActionManager: ObservableObject {
    
    public init() {}
    
    public func execute(_ actionData: ActionData?) {
        guard let actionData = actionData else { return }
        
        switch actionData.type {
        case "open_url":
            handleOpenURL(data: actionData.data)
        default:
            print("Action desconhecida: \(actionData.type)")
        }
    }
    
    func handleOpenURL(data: [String: AnyCodable]?) {
        guard let data = data,
              let anyCodableUrl = data["url"],
              let urlString = anyCodableUrl.value as? String,
              let url = URL(string: urlString) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
}
