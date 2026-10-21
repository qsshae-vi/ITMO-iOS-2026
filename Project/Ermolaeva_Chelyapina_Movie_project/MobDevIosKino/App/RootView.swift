import SwiftUI
import SwiftData

struct RootView: View {
    @StateObject private var router = AppRouter()
    let deps: AppDependencies
    
    var body: some View {
        NavigationStack(path: $router.path) {
            FilmListView(
                viewModel: deps.makeFilmListViewModel(),
                onSelectFilm: { id in
                    router.push(.filmDetail(id: id))
                }
            )
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .filmDetail(let id):
                    OneFilmView(
                        viewModel: deps.makeOneFilmViewModel(filmId: id),
                        onShowFunFact: { 
                            router.push(.funFact(id: id))
                        },
                    )

                case .funFact(let id):
                    FunFactView(
                        viewModel: deps.makeFunFactViewModel(filmId: id)
                    )
                }
            }
        }
    }
}

#Preview {
    RootView(
        deps: AppDependencies(
            container: try! ModelContainer(
                for: CachedFilm.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )
        )
    )
}
