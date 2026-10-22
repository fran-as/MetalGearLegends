import SwiftUI

struct ComingSoonView: View {
    let game: CatalogGame
    let onBack: () -> Void

    @EnvironmentObject private var navigator: GameControllerNavigator
    @EnvironmentObject private var emulator: EmulatorLauncher

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("COMING SOON")
                .font(MGSTheme.titleFont)
                .foregroundStyle(MGSTheme.green)
                .tracking(3)

            Text(game.title.uppercased())
                .font(MGSTheme.headlineFont)
                .foregroundStyle(Color.white)

            Text(message)
                .font(MGSTheme.bodyFont)
                .foregroundStyle(MGSTheme.gray)
                .fixedSize(horizontal: false, vertical: true)

            if case let .deferred(reason) = emulator.lastResult {
                Text(reason)
                    .font(MGSTheme.captionFont)
                    .foregroundStyle(MGSTheme.greenDim)
            }

            Spacer()

            Button(action: onBack) {
                HStack {
                    Text("▶ RETURN")
                        .font(MGSTheme.headlineFont)
                        .foregroundStyle(MGSTheme.green)
                    Spacer()
                }
                .padding(12)
                .overlay(
                    Rectangle().stroke(MGSTheme.green, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
            .frame(maxWidth: 320)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.top, 24)
        .padding(.bottom, 48)
        .onAppear {
            navigator.itemCount = 1
            navigator.selectionIndex = 0
        }
        .onReceive(navigator.actions) { action in
            if action == .confirm || action == .cancel {
                onBack()
            }
        }
    }

    private var message: String {
        switch game.phase {
        case .ps1:
            return "Phase 2 will launch this title through RetroArch (PS1 core) with controller passthrough and save wiring."
        case .classics:
            return "Phase 3 will add MSX2 / NES cores via RetroArch for the classic Metal Gear entries."
        case .ps2:
            return "Phase 4 targets PCSX2 for MGS2 / MGS3. Higher setup cost — BIOS and ISOs remain user-provided."
        case .visualPrototype:
            return "Visual prototype only. No emulator process will start in Phase 1."
        }
    }
}
