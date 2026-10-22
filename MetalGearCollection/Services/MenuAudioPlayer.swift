import AVFoundation
import Combine
import Foundation

/// Plays user-provided menu ambient audio when present; otherwise stays silent.
@MainActor
final class MenuAudioPlayer: ObservableObject {
    @Published private(set) var isPlaying = false
    @Published private(set) var statusMessage = "AUDIO — STANDBY"

    private var player: AVAudioPlayer?

    /// Search order for a user-supplied loop (not shipped with the app).
    private var candidateURLs: [URL] {
        let home = FileManager.default.homeDirectoryForCurrentUser
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        let names = ["menu_ambient.mp3", "menu_ambient.m4a", "menu_ambient.wav", "codec_theme.mp3"]

        var urls: [URL] = []
        if let support {
            let dir = support.appendingPathComponent("MetalGearCollection/Audio", isDirectory: true)
            urls += names.map { dir.appendingPathComponent($0) }
        }
        let docs = home.appendingPathComponent("Documents/MetalGearCollection/Audio", isDirectory: true)
        urls += names.map { docs.appendingPathComponent($0) }

        if let bundled = Bundle.main.resourceURL {
            urls += names.map { bundled.appendingPathComponent($0) }
        }
        return urls
    }

    func startIfAvailable() {
        stop()
        guard let url = candidateURLs.first(where: { FileManager.default.fileExists(atPath: $0.path) }) else {
            statusMessage = "AUDIO — NO FILE (silent)"
            isPlaying = false
            return
        }

        do {
            let audio = try AVAudioPlayer(contentsOf: url)
            audio.numberOfLoops = -1
            audio.volume = 0.55
            audio.prepareToPlay()
            audio.play()
            player = audio
            isPlaying = true
            statusMessage = "AUDIO — \(url.lastPathComponent)"
        } catch {
            statusMessage = "AUDIO — SKIP (\(error.localizedDescription))"
            isPlaying = false
            player = nil
        }
    }

    func stop() {
        player?.stop()
        player = nil
        isPlaying = false
    }
}
