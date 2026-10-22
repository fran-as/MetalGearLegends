import SwiftUI

enum MGSTheme {
    static let bgDeep = Color(red: 0.04, green: 0.06, blue: 0.04)
    static let bgPanel = Color(red: 0.07, green: 0.10, blue: 0.07)
    static let green = Color(red: 0.35, green: 0.85, blue: 0.40)
    static let greenDim = Color(red: 0.18, green: 0.42, blue: 0.22)
    static let gray = Color(red: 0.55, green: 0.58, blue: 0.55)
    static let danger = Color(red: 0.85, green: 0.25, blue: 0.20)
    static let scanline = Color.black.opacity(0.18)

    static let titleFont = Font.system(size: 28, weight: .bold, design: .monospaced)
    static let headlineFont = Font.system(size: 16, weight: .semibold, design: .monospaced)
    static let bodyFont = Font.system(size: 13, weight: .regular, design: .monospaced)
    static let captionFont = Font.system(size: 11, weight: .medium, design: .monospaced)
}

struct ScanlineOverlay: View {
    var body: some View {
        Canvas { context, size in
            let step: CGFloat = 3
            var y: CGFloat = 0
            while y < size.height {
                let rect = CGRect(x: 0, y: y, width: size.width, height: 1)
                context.fill(Path(rect), with: .color(MGSTheme.scanline))
                y += step
            }
        }
        .allowsHitTesting(false)
    }
}
