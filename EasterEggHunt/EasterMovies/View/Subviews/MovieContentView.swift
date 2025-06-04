
struct MovieContentView: View {
    let movies: [Movie]
    
    var body: some View {
        VStack {
            Text("Filmes perfeitos para assistir na Páscoa!")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundStyle(.secondary)
            
            if movies.isEmpty {
                EmptyStateView()
            } else {
                List(movies) { movie in
                    MovieRowView(movie: movie)
                }
                .listStyle(.insetGrouped)
            }
        }
    }
}