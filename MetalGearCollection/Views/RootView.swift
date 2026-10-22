import SwiftUI

enum AppRoute: Equatable {
    case library
    case detail(CatalogGame)
    case comingSoon(CatalogGame)
}

struct RootView: View {
    @EnvironmentObject private var navigator: GameControllerNavigator
    @EnvironmentObject private var menuAudio: MenuAudioPlayer
    @State private var route: AppRoute = .library

    private let games = GameCatalog.all

    var body: some View {
        CodecFrame(title: routeTitle) {
            switch route {
            case .library:
                LibraryView(games: games, onSelect: { game in
                    route = .detail(game)
                })
            case .detail(let game):
                GameDetailView(
                    game: game,
                    onBack: { route = .library },
                    onLaunchStub: { route = .comingSoon(game) }
                )
            case .comingSoon(let game):
                ComingSoonView(game: game, onBack: { route = .detail(game) })
            }
        }
        .overlay(alignment: .bottom) {
            statusBar
        }
        .focusable()
        .onKeyPress(.upArrow) {
            navigator.handleKeyboardFallback(.moveUp)
            return .handled
        }
        .onKeyPress(.downArrow) {
            navigator.handleKeyboardFallback(.moveDown)
            return .handled
        }
        .onKeyPress(.leftArrow) {
            navigator.handleKeyboardFallback(.moveLeft)
            return .handled
        }
        .onKeyPress(.rightArrow) {
            navigator.handleKeyboardFallback(.moveRight)
            return .handled
        }
        .onKeyPress(.return) {
            navigator.handleKeyboardFallback(.confirm)
            return .handled
        }
        .onKeyPress(.escape) {
            navigator.handleKeyboardFallback(.cancel)
            return .handled
        }
        .onReceive(navigator.actions) { action in
            handleGlobal(action)
        }
    }

    private var routeTitle: String {
        switch route {
        case .library: return "CODEC // GAME LIBRARY"
        case .detail: return "CODEC // BRIEFING"
        case .comingSoon: return "CODEC // STANDBY"
        }
    }

    private var statusBar: some View {
        HStack(spacing: 18) {
            Text(controllerLabel)
            Text("·")
            Text(menuAudio.statusMessage)
            Spacer()
            Text("A CONFIRM  ·  B BACK  ·  ↑↓ SELECT")
        }
        .font(MGSTheme.captionFont)
        .foregroundStyle(MGSTheme.gray)
        .padding(.horizontal, 28)
        .padding(.vertical, 10)
        .background(Color.black.opacity(0.65))
    }

    private var controllerLabel: String {
        if let name = navigator.connectedControllerName {
            return "PAD — \(name.uppercased())"
        }
        return "PAD — WAITING (KB FALLBACK)"
    }

    private func handleGlobal(_ action: GameControllerNavigator.Action) {
        if action == .cancel {
            switch route {
            case .library:
                break
            case .detail:
                route = .library
            case .comingSoon(let game):
                route = .detail(game)
            }
        }
    }
}
