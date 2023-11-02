//
//  DetailView.swift
//  basicML
//
//  Created by Johnny Slätt on 2023-10-31.
//
import SwiftUI

struct DetailView: View {
    let imageName: String
    @State private var analysisResult: String = "Analyserar..."

    var body: some View {
        VStack {
            Text(analysisResult)
                .padding()
                .onAppear {
                    analyzeImage()
                }
        }
    }

    func analyzeImage() {
        let domodel = DoModel()
        domodel.doImage(with: imageName) { label, probability in
            self.analysisResult = "Etikett: \(label)\nSannolikhet: \(probability)"
        }
    }
}


