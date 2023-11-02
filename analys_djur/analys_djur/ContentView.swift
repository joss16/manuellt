//

import SwiftUI

struct ContentView: View {
    let buttonNames = ["hb", "hy", "tg"]
    @State private var selectedImageName: String?
    @State private var analysisResult: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("Djur för analys")

                ForEach(buttonNames, id: \.self) { name in
                    Button(action: {
                        self.selectedImageName = name
                        analyzeImage(named: name)
                    }) {
                        Image(name)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                            .padding()
                            .border(Color.green, width: 2)
                    }
                }

                // Visa analysresultat
                if let selectedImageName = selectedImageName {
                    Text("Resultat för \(selectedImageName): \(analysisResult)")
                        .padding()
                }
            }
            .padding()
        }
    }

    func analyzeImage(named imageName: String) {
        let domodel = DoModel()
        domodel.doImage(with: imageName) { label, probability in
            self.analysisResult = "Etikett: \(label), Sannolikhet: \(probability)"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
