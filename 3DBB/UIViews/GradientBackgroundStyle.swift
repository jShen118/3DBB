//
//  GradientBackgroundStyle.swift
//  3DBB
//
//  Created by Joshua Shen on 6/24/20.
//  Copyright © 2020 Joshua Shen. All rights reserved.
//

import Foundation
import SwiftUI

struct GradientBackgroundStyle: ButtonStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
