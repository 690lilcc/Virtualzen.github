import SwiftUI
import GameController

struct ContentView: View {
    @State private var shotTiming: Double = 0.550 // Your Green Window
    @State private var autoGreenEnabled = true
    
    var body: some View {
        VStack(spacing: 30) {
            Text("VirtualZen 2K26")
                .font(.largeTitle)
                .bold()
            
            VStack {
                Text("Shot Timing: \(shotTiming, specifier: "%.3f")s")
                Slider(value: $shotTiming, in: 0.400...0.800)
            }
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(10)

            Toggle("Auto Green Active", isOn: $autoGreenEnabled)
                .padding()

            Text("Instructions: Tap your Shot button once. The app will hold and release it perfectly based on the timing above.")
                .font(.footnote)
                .padding()
        }
    }
    
    // Logic to release the button at the exact millisecond
    func releaseShot() {
        // Start holding button
        print("Holding Shoot...") 
        
        DispatchQueue.main.asyncAfter(deadline: .now() + shotTiming) {
            // Release button
            print("RELEASE! Green Light.")
        }
    }
}
