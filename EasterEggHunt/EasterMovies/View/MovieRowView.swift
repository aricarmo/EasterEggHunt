struct MovieRowView: View {
    let movie: Movie
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.gray.opacity(0.3))
                    .overlay {
                        Image(systemName: "film")
                            .font(.title2)
                            .foregroundStyle(.gray)
                    }
            }
            .frame(width: 60, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                
                Text(movie.overview)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                
                HStack {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                            .font(.caption)
                        
                        Text(String(format: "%.1f", movie.voteAvarage))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    if let releaseDate = movie.releaseDate {
                        Text(String(releaseDate.prefix(4)))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(.gray.opacity(0.2))
                            .clipShape(Capsule())
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}