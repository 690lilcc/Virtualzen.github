import Foundation
import GameController

class ControllerManager: ObservableObject {
    @Published var isConnected = false
    var holdTime: Double = 0.58 // Default to "Push" timing
    
    init() {
        NotificationCenter.default.addObserver(forName: .GCControllerDidConnect, object: nil, queue: .main) { _ in
            self.isConnected = true
            self.setupController(GCController.controllers().first!)
        }
    }
    
    func setupController(_ controller: GCController) {
        controller.extendedGamepad?.buttonWest.pressedChangedHandler = { (button, value, pressed) in
            if pressed { self.executeRhythmShot(controller: controller) }
        }
    }
    
    func executeRhythmShot(controller: GCController) {
        let gamepad = controller.extendedGamepad
        gamepad?.rightThumbstick.yAxis.value = -1.0 // Pull Down
        
        DispatchQueue.main.asyncAfter(deadline: .now() + holdTime) {
            gamepad?.rightThumbstick.yAxis.value = 1.0 // Flick Up
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                gamepad?.rightThumbstick.yAxis.value = 0.0 // Reset
            }
        }
    }
}
import SwiftUI

struct ContentView: View {
    @StateObject var manager = ControllerManager()
    @State private var selectedCue = 0.58
    
    var body: some View {
        NavigationView {
            Form {
                Section("Status") {
                    Label(manager.isConnected ? "Controller Active" : "Searching...", 
                          systemImage: manager.isConnected ? "checkmark.circle.fill" : "wave.3.right")
                        .foregroundColor(manager.isConnected ? .green : .orange)
                }
                
                Section("2K26 Rhythm Settings") {
                    Picker("Visual Cue", selection: $selectedCue) {
                        Text("Jump").tag(0.45)
                        Text("Push").tag(0.58)
                        Text("Release").tag(0.65)
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Virtual Zen")
            .onChange(of: selectedCue) { newValue in manager.holdTime = newValue }
        }
    }
}

