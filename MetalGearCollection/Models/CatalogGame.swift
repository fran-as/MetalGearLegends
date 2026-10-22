import Foundation

enum EmulatorBackend: String, Codable, Hashable {
    case retroArch
    case pcsx2
    case none
}

enum IntegrationPhase: Int, Codable, Comparable, Hashable {
    case visualPrototype = 1
    case ps1 = 2
    case classics = 3
    case ps2 = 4

    static func < (lhs: IntegrationPhase, rhs: IntegrationPhase) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    var label: String {
        switch self {
        case .visualPrototype: return "PHASE 1"
        case .ps1: return "PHASE 2"
        case .classics: return "PHASE 3"
        case .ps2: return "PHASE 4"
        }
    }
}

struct CatalogGame: Identifiable, Hashable {
    let id: String
    let title: String
    let year: Int
    let platform: String
    let backend: EmulatorBackend
    /// RetroArch core identifier or PCSX2 marker — used by later launch wiring.
    let coreHint: String?
    let phase: IntegrationPhase
    let synopsis: String

    var isLaunchReady: Bool { false } // Phase 1: never launch
}

enum GameCatalog {
    static let all: [CatalogGame] = [
        CatalogGame(
            id: "mg-msx2",
            title: "Metal Gear",
            year: 1987,
            platform: "MSX2",
            backend: .retroArch,
            coreHint: "bluemsx",
            phase: .classics,
            synopsis: "Infiltrate Outer Heaven. Solid Snake’s first mission."
        ),
        CatalogGame(
            id: "mg-nes",
            title: "Metal Gear",
            year: 1987,
            platform: "NES",
            backend: .retroArch,
            coreHint: "nestopia",
            phase: .classics,
            synopsis: "The NES port of the original infiltration opus."
        ),
        CatalogGame(
            id: "mg2-msx2",
            title: "Metal Gear 2: Solid Snake",
            year: 1990,
            platform: "MSX2",
            backend: .retroArch,
            coreHint: "bluemsx",
            phase: .classics,
            synopsis: "Zanzibar Land. Radar. The blueprint for stealth."
        ),
        CatalogGame(
            id: "mgs-ps1",
            title: "Metal Gear Solid",
            year: 1998,
            platform: "PlayStation",
            backend: .retroArch,
            coreHint: "pcsx_rearmed",
            phase: .ps1,
            synopsis: "Shadow Moses Island. Tactical Espionage Action."
        ),
        CatalogGame(
            id: "mgs-vr-ps1",
            title: "Metal Gear Solid: VR Missions",
            year: 1999,
            platform: "PlayStation",
            backend: .retroArch,
            coreHint: "pcsx_rearmed",
            phase: .ps1,
            synopsis: "Training ground. Special missions. No distractions."
        ),
        CatalogGame(
            id: "mgs2-ps2",
            title: "Metal Gear Solid 2: Sons of Liberty",
            year: 2001,
            platform: "PlayStation 2",
            backend: .pcsx2,
            coreHint: "pcsx2",
            phase: .ps2,
            synopsis: "Big Shell. Raiden. The legend continues."
        ),
        CatalogGame(
            id: "mgs3-ps2",
            title: "Metal Gear Solid 3: Snake Eater",
            year: 2004,
            platform: "PlayStation 2",
            backend: .pcsx2,
            coreHint: "pcsx2",
            phase: .ps2,
            synopsis: "1964. Naked Snake. Survival and betrayal."
        ),
    ]
}
