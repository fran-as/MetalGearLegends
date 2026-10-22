import SwiftUI

struct GameDetailView: View {
    let game: CatalogGame
    let onBack: () -> Void
    let onLaunchStub: () -> Void

    @EnvironmentObject private var navigator: GameControllerNavigator
    @EnvironmentObject private var emulator: EmulatorLauncher
    @State private var detailSelection = 0

    private let actions = ["ENGAGE (STUB)", "RETURN TO LIBRARY"]

    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            coverBlock
            VStack(alignment: .leading, spacing: 16) {
                Text(game.title.uppercased())
                    .font(MGSTheme.titleFont)
                    .foregroundStyle(MGSTheme.green)
                Text("\(game.year)  //  \(game.platform)")
                    .font(MGSTheme.bodyFont)
                    .foregroundStyle(MGSTheme.gray)

                Text(game.synopsis)
                    .font(MGSTheme.bodyFont)
                    .foregroundStyle(Color.white.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)

                VStack(alignment: .leading, spacing: 8) {
                    metaRow("PHASE", game.phase.label)
                    metaRow("BACKEND", backendLabel)
                    metaRow("CORE", game.coreHint?.uppercased() ?? "—")
                }
                .padding(.top, 8)

                Spacer(minLength: 20)

                ForEach(Array(actions.enumerated()), id: \.offset) { index, label in
                    Button {
                        activate(index)
                    } label: {
                        HStack {
                            Text(detailSelection == index ? "▶" : " ")
                                .foregroundStyle(MGSTheme.green)
                            Text(label)
                                .font(MGSTheme.headlineFont)
                                .foregroundStyle(detailSelection == index ? MGSTheme.green : Color.white.opacity(0.75))
                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(detailSelection == index ? MGSTheme.green.opacity(0.12) : Color.clear)
                        .overlay(
                            Rectangle()
                                .stroke(detailSelection == index ? MGSTheme.green : MGSTheme.greenDim.opacity(0.4), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.top, 12)
        .padding(.bottom, 40)
        .onAppear {
            navigator.itemCount = actions.count
            navigator.selectionIndex = 0
            detailSelection = 0
        }
        .onChange(of: navigator.selectionIndex) { _, newValue in
            detailSelection = newValue
        }
        .onReceive(navigator.actions) { action in
            switch action {
            case .confirm:
                activate(detailSelection)
            case .cancel:
                onBack()
            default:
                break
            }
        }
    }

    private var coverBlock: some View {
        ZStack {
            Rectangle().fill(MGSTheme.bgPanel)
            Rectangle().stroke(MGSTheme.green.opacity(0.5), lineWidth: 2)
            VStack(spacing: 8) {
                Text("NO COVER")
                    .font(MGSTheme.captionFont)
                    .foregroundStyle(MGSTheme.greenDim)
                Text(game.platform.uppercased())
                    .font(MGSTheme.headlineFont)
                    .foregroundStyle(MGSTheme.gray)
                Text("USER ASSET LATER")
                    .font(MGSTheme.captionFont)
                    .foregroundStyle(MGSTheme.gray.opacity(0.7))
            }
        }
        .frame(width: 220, height: 300)
    }

    private func metaRow(_ key: String, _ value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(key)
                .font(MGSTheme.captionFont)
                .foregroundStyle(MGSTheme.gray)
                .frame(width: 72, alignment: .leading)
            Text(value)
                .font(MGSTheme.bodyFont)
                .foregroundStyle(MGSTheme.green)
        }
    }

    private var backendLabel: String {
        switch game.backend {
        case .retroArch: return "RETROARCH"
        case .pcsx2: return "PCSX2"
        case .none: return "—"
        }
    }

    private func activate(_ index: Int) {
        if index == 0 {
            _ = emulator.launch(game)
            onLaunchStub()
        } else {
            onBack()
        }
    }
}
