import SwiftUI

@main
struct MetalGearCollectionApp: App {
    @StateObject private var controllerNavigator = GameControllerNavigator()
    @StateObject private var menuAudio = MenuAudioPlayer()
    @StateObject private var emulatorLauncher = EmulatorLauncher()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(controllerNavigator)
                .environmentObject(menuAudio)
                .environmentObject(emulatorLauncher)
                .frame(minWidth: 960, minHeight: 640)
                .preferredColorScheme(.dark)
                .onAppear {
                    controllerNavigator.start()
                    menuAudio.startIfAvailable()
                }
                .onDisappear {
                    menuAudio.stop()
                    controllerNavigator.stop()
                }
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 1280, height: 800)
    }
}
