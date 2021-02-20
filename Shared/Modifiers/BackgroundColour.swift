//
//  BackgroundColour.swift
//  Bedtime
//
//  Created by Michael Thingnes on 20/02/21.
//

import SwiftUI


struct BackgroundColour: ViewModifier {
    
    let colour: Color
    
    func body(content: Content) -> some View {
        ZStack {
            colour
                .edgesIgnoringSafeArea(.all)
            content
        }
    }
    
}

extension View {
    func backgroundColour(_ colour: Color) -> some View {
        return self.modifier(BackgroundColour(colour: colour))
    }
}
