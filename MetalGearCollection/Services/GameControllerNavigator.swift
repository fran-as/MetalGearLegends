import Combine
import Foundation
import GameController

/// Xbox-ready GameController navigation. Keyboard fallback for debug when no pad is present.
@MainActor
final class GameControllerNavigator: ObservableObject {
    enum Action: Equatable {
        case moveUp
        case moveDown
        case moveLeft
        case moveRight
        case confirm
        case cancel
    }

    @Published private(set) var connectedControllerName: String?
    @Published private(set) var lastAction: Action?
    @Published var selectionIndex: Int = 0
    @Published var itemCount: Int = 0

    /// Fired for each discrete navigation event (D-pad / stick / face buttons).
    let actions = PassthroughSubject<Action, Never>()

    private var observers: [NSObjectProtocol] = []
    private var pollTimer: Timer?
    private var lastStickY: Float = 0
    private var lastStickX: Float = 0
    private var confirmWasPressed = false
    private var cancelWasPressed = false
    private var dpadUp = false
    private var dpadDown = false
    private var dpadLeft = false
    private var dpadRight = false

    private let stickDeadzone: Float = 0.55

    func start() {
        let center = NotificationCenter.default
        observers = [
            center.addObserver(forName: .GCControllerDidConnect, object: nil, queue: .main) { [weak self] _ in
                Task { @MainActor in self?.refreshControllers() }
            },
            center.addObserver(forName: .GCControllerDidDisconnect, object: nil, queue: .main) { [weak self] _ in
                Task { @MainActor in self?.refreshControllers() }
            },
        ]
        GCController.startWirelessControllerDiscovery {}
        refreshControllers()

        pollTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 30.0, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.pollInput() }
        }
    }

    func stop() {
        pollTimer?.invalidate()
        pollTimer = nil
        observers.forEach { NotificationCenter.default.removeObserver($0) }
        observers.removeAll()
        GCController.stopWirelessControllerDiscovery()
    }

    func handleKeyboardFallback(_ action: Action) {
        emit(action)
    }

    func clampSelection() {
        guard itemCount > 0 else {
            selectionIndex = 0
            return
        }
        selectionIndex = min(max(0, selectionIndex), itemCount - 1)
    }

    private func refreshControllers() {
        guard let pad = GCController.controllers().first else {
            connectedControllerName = nil
            return
        }
        connectedControllerName = pad.vendorName ?? pad.productCategory
    }

    private func pollInput() {
        guard let pad = GCController.controllers().first else { return }
        if let extended = pad.extendedGamepad {
            readExtended(extended)
        } else if let micro = pad.microGamepad {
            readMicro(micro)
        }
    }

    private func readExtended(_ pad: GCExtendedGamepad) {
        edgeTrigger(pad.dpad.up.isPressed, was: &dpadUp) { emit(.moveUp) }
        edgeTrigger(pad.dpad.down.isPressed, was: &dpadDown) { emit(.moveDown) }
        edgeTrigger(pad.dpad.left.isPressed, was: &dpadLeft) { emit(.moveLeft) }
        edgeTrigger(pad.dpad.right.isPressed, was: &dpadRight) { emit(.moveRight) }

        let sy = pad.leftThumbstick.yAxis.value
        let sx = pad.leftThumbstick.xAxis.value
        stickEdge(sy, last: &lastStickY, positive: .moveUp, negative: .moveDown)
        stickEdge(sx, last: &lastStickX, positive: .moveRight, negative: .moveLeft)

        edgeTrigger(pad.buttonA.isPressed, was: &confirmWasPressed) { emit(.confirm) }
        edgeTrigger(pad.buttonB.isPressed, was: &cancelWasPressed) { emit(.cancel) }
    }

    private func readMicro(_ pad: GCMicroGamepad) {
        edgeTrigger(pad.dpad.up.isPressed, was: &dpadUp) { emit(.moveUp) }
        edgeTrigger(pad.dpad.down.isPressed, was: &dpadDown) { emit(.moveDown) }
        edgeTrigger(pad.dpad.left.isPressed, was: &dpadLeft) { emit(.moveLeft) }
        edgeTrigger(pad.dpad.right.isPressed, was: &dpadRight) { emit(.moveRight) }
        edgeTrigger(pad.buttonA.isPressed, was: &confirmWasPressed) { emit(.confirm) }
        edgeTrigger(pad.buttonX.isPressed, was: &cancelWasPressed) { emit(.cancel) }
    }

    private func stickEdge(_ value: Float, last: inout Float, positive: Action, negative: Action) {
        if value > stickDeadzone, last <= stickDeadzone {
            emit(positive)
        } else if value < -stickDeadzone, last >= -stickDeadzone {
            emit(negative)
        }
        last = value
    }

    private func edgeTrigger(_ pressed: Bool, was: inout Bool, fire: () -> Void) {
        if pressed, !was { fire() }
        was = pressed
    }

    private func emit(_ action: Action) {
        lastAction = action
        switch action {
        case .moveUp:
            if itemCount > 0 {
                selectionIndex = (selectionIndex - 1 + itemCount) % itemCount
            }
        case .moveDown:
            if itemCount > 0 {
                selectionIndex = (selectionIndex + 1) % itemCount
            }
        case .moveLeft, .moveRight, .confirm, .cancel:
            break
        }
        actions.send(action)
    }
}
