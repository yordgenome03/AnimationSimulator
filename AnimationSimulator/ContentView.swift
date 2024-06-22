//
//  ContentView.swift
//  AnimationSimulator
//
//  Created by yotahara on 2024/06/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    NavigationLink {
                        RotatingShapesViewSimulator()
                    } label: {
                        Text("Rotating Shapes")
                    }
                }
            }
            .navigationTitle("Animation Simulator")
        }
    }
}


#Preview {
    ContentView()
}
