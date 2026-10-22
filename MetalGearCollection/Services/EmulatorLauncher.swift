import Combine
import Foundation

/// Stub launcher — Phase 1 never starts an emulator process.
/// Structure is ready for RetroArch / PCSX2 process launch in later phases.
@MainActor
final class EmulatorLauncher: ObservableObject {
    struct LaunchRequest: Equatable {
        let gameID: String
        let backend: EmulatorBackend
        let coreHint: String?
        let romPath: URL?
    }

    enum LaunchResult: Equatable {
        case deferred(reason: String)
        case failed(reason: String)
        // Later: case launched(pid: Int32)
    }

    @Published private(set) var lastResult: LaunchResult?

    func launch(_ game: CatalogGame, romPath: URL? = nil) -> LaunchResult {
        let request = LaunchRequest(
            gameID: game.id,
            backend: game.backend,
            coreHint: game.coreHint,
            romPath: romPath
        )
        _ = request

        let result: LaunchResult = .deferred(
            reason: "\(game.phase.label) — Emulator launch not wired yet. RetroArch/PCSX2 integration begins in Phase 2+."
        )
        lastResult = result
        return result
    }

    /// Future: locate RetroArch.app / PCSX2 and build argv (core, content, --fullscreen, etc.).
    func resolveEmulatorExecutable(for backend: EmulatorBackend) -> URL? {
        switch backend {
        case .retroArch, .pcsx2, .none:
            return nil
        }
    }
}
