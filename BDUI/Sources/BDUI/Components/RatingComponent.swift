import SwiftUI

public struct RatingComponent: View {
    let properties: ComponentProperties
    
    public var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<Int(properties.maxRating ?? 5), id: \.self) { index in
                Image(systemName: index < Int(properties.rating ?? 0) ? "star.fill" : "star")
                    .foregroundColor(Color(hex: properties.color ?? "#FFD700"))
            }
            
            Text(String(format: "%.1f", properties.rating ?? 0))
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(hex: properties.color ?? "#FFD700"))
        }
        .applyCommonModifiers(properties: properties)
    }
}
