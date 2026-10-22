import SwiftUI

/// CODEC-inspired frame: dual panels, frequency ticks, military chrome.
struct CodecFrame<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [MGSTheme.bgDeep, Color.black, MGSTheme.bgDeep],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Subtle radar-ring atmosphere (not a card).
            Circle()
                .stroke(MGSTheme.greenDim.opacity(0.35), lineWidth: 1)
                .frame(width: 520, height: 520)
                .offset(x: 280, y: -40)
                .blur(radius: 0.5)
                .allowsHitTesting(false)

            Circle()
                .stroke(MGSTheme.greenDim.opacity(0.2), lineWidth: 1)
                .frame(width: 720, height: 720)
                .offset(x: 280, y: -40)
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                header
                Rectangle()
                    .fill(MGSTheme.green.opacity(0.55))
                    .frame(height: 1)
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(18)

            ScanlineOverlay()
                .opacity(0.45)
                .ignoresSafeArea()
        }
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 4) {
                Text("METAL GEAR COLLECTION")
                    .font(MGSTheme.titleFont)
                    .foregroundStyle(MGSTheme.green)
                    .shadow(color: MGSTheme.green.opacity(0.35), radius: 6)
                Text(title.uppercased())
                    .font(MGSTheme.captionFont)
                    .foregroundStyle(MGSTheme.gray)
                    .tracking(2)
            }
            Spacer()
            FrequencyTicks()
                .frame(width: 160, height: 36)
        }
        .padding(.bottom, 12)
    }
}

struct FrequencyTicks: View {
    var body: some View {
        TimelineView(.animation(minimumInterval: 0.12)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            Canvas { context, size in
                let bars = 24
                let gap: CGFloat = 2
                let w = (size.width - CGFloat(bars - 1) * gap) / CGFloat(bars)
                for i in 0..<bars {
                    let phase = sin(t * 3.2 + Double(i) * 0.55)
                    let h = size.height * CGFloat(0.25 + 0.75 * abs(phase))
                    let x = CGFloat(i) * (w + gap)
                    let y = (size.height - h) / 2
                    let rect = CGRect(x: x, y: y, width: max(1, w), height: h)
                    context.fill(Path(rect), with: .color(MGSTheme.green.opacity(0.55 + 0.35 * abs(phase))))
                }
            }
        }
    }
}
