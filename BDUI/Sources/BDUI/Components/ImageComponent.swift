import SwiftUI

public struct ImageComponent: View {
    let properties: ComponentProperties
    
    public var body: some View {
        AsyncImage(url: URL(string: properties.imageUrl ?? "")) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                )
        }
        .frame(height: properties.height)
        .applyCommonModifiers(properties: properties)
    }
}
