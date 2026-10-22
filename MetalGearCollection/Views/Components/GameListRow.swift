import SwiftUI

struct GameListRow: View {
    let game: CatalogGame
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 16) {
            coverPlaceholder
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(game.title.uppercased())
                        .font(MGSTheme.headlineFont)
                        .foregroundStyle(isSelected ? MGSTheme.green : Color.white.opacity(0.9))
                        .lineLimit(1)
                    Text(game.phase.label)
                        .font(MGSTheme.captionFont)
                        .foregroundStyle(phaseColor)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .overlay(
                            Rectangle()
                                .stroke(phaseColor.opacity(0.7), lineWidth: 1)
                        )
                }
                Text("\(game.year)  ·  \(game.platform)  ·  \(backendLabel)")
                    .font(MGSTheme.captionFont)
                    .foregroundStyle(MGSTheme.gray)
                Text(game.synopsis)
                    .font(MGSTheme.bodyFont)
                    .foregroundStyle(Color.white.opacity(0.65))
                    .lineLimit(2)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundStyle(isSelected ? MGSTheme.green : MGSTheme.gray.opacity(0.4))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            Rectangle()
                .fill(isSelected ? MGSTheme.green.opacity(0.12) : Color.clear)
        )
        .overlay(
            Rectangle()
                .stroke(isSelected ? MGSTheme.green.opacity(0.85) : MGSTheme.greenDim.opacity(0.35), lineWidth: isSelected ? 2 : 1)
        )
        .animation(.easeOut(duration: 0.12), value: isSelected)
    }

    private var coverPlaceholder: some View {
        ZStack {
            Rectangle()
                .fill(MGSTheme.bgPanel)
            Rectangle()
                .stroke(MGSTheme.greenDim, lineWidth: 1)
            VStack(spacing: 4) {
                Text("COVER")
                    .font(MGSTheme.captionFont)
                    .foregroundStyle(MGSTheme.greenDim)
                Text(game.platform)
                    .font(MGSTheme.captionFont)
                    .foregroundStyle(MGSTheme.gray)
            }
        }
        .frame(width: 72, height: 96)
    }

    private var backendLabel: String {
        switch game.backend {
        case .retroArch: return "RETROARCH"
        case .pcsx2: return "PCSX2"
        case .none: return "—"
        }
    }

    private var phaseColor: Color {
        switch game.phase {
        case .visualPrototype, .ps1: return MGSTheme.green
        case .classics: return MGSTheme.gray
        case .ps2: return MGSTheme.danger.opacity(0.85)
        }
    }
}
