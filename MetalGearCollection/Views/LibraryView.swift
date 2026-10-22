import SwiftUI

struct LibraryView: View {
    let games: [CatalogGame]
    let onSelect: (CatalogGame) -> Void

    @EnvironmentObject private var navigator: GameControllerNavigator

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text("// SELECT MISSION")
                    .font(MGSTheme.captionFont)
                    .foregroundStyle(MGSTheme.green)
                    .tracking(1.5)

                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(Array(games.enumerated()), id: \.element.id) { index, game in
                                GameListRow(game: game, isSelected: index == navigator.selectionIndex)
                                    .id(index)
                                    .onTapGesture {
                                        navigator.selectionIndex = index
                                        onSelect(game)
                                    }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .onChange(of: navigator.selectionIndex) { _, newValue in
                        withAnimation(.easeOut(duration: 0.15)) {
                            proxy.scrollTo(newValue, anchor: .center)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)

            briefingPanel
                .frame(width: 300)
        }
        .padding(.top, 8)
        .padding(.bottom, 36)
        .onAppear {
            navigator.itemCount = games.count
            navigator.clampSelection()
        }
        .onReceive(navigator.actions) { action in
            if action == .confirm, games.indices.contains(navigator.selectionIndex) {
                onSelect(games[navigator.selectionIndex])
            }
        }
    }

    private var briefingPanel: some View {
        let game = games.indices.contains(navigator.selectionIndex) ? games[navigator.selectionIndex] : nil
        return VStack(alignment: .leading, spacing: 14) {
            Text("// BRIEFING")
                .font(MGSTheme.captionFont)
                .foregroundStyle(MGSTheme.green)
                .tracking(1.5)

            if let game {
                Text(game.title)
                    .font(MGSTheme.headlineFont)
                    .foregroundStyle(Color.white)
                Text("\(game.year) · \(game.platform)")
                    .font(MGSTheme.bodyFont)
                    .foregroundStyle(MGSTheme.gray)
                Text(game.synopsis)
                    .font(MGSTheme.bodyFont)
                    .foregroundStyle(Color.white.opacity(0.75))
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 12)

                Text("ENGINE")
                    .font(MGSTheme.captionFont)
                    .foregroundStyle(MGSTheme.gray)
                Text(engineLine(game))
                    .font(MGSTheme.bodyFont)
                    .foregroundStyle(MGSTheme.green)

                Text("STATUS")
                    .font(MGSTheme.captionFont)
                    .foregroundStyle(MGSTheme.gray)
                    .padding(.top, 6)
                Text("\(game.phase.label) — VISUAL PROTOTYPE")
                    .font(MGSTheme.bodyFont)
                    .foregroundStyle(MGSTheme.greenDim)
            } else {
                Text("NO SIGNAL")
                    .font(MGSTheme.headlineFont)
                    .foregroundStyle(MGSTheme.danger)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .background(MGSTheme.bgPanel.opacity(0.85))
        .overlay(
            Rectangle()
                .stroke(MGSTheme.greenDim.opacity(0.6), lineWidth: 1)
        )
    }

    private func engineLine(_ game: CatalogGame) -> String {
        switch game.backend {
        case .retroArch:
            return "RETROARCH / \(game.coreHint?.uppercased() ?? "CORE")"
        case .pcsx2:
            return "PCSX2"
        case .none:
            return "—"
        }
    }
}
