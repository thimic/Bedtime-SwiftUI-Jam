//
//  Components.swift
//  Bedtime
//
//  Created by Michael Thingnes on 20/02/21.
//

import SwiftUI

struct Cell<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            content
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(Color(UIColor.tertiarySystemBackground))
        .cornerRadius(10)
    }
}

struct Block<Content: View>: View {
    let header: Text?
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.header = nil
        self.content = content()
    }
    
    init(header: Text, @ViewBuilder content: () -> Content) {
        self.header = header
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let header = header {
                header
                    .font(.title2)
                    .bold()
            }
            content
        }
        .padding(.vertical)
    }
}

struct TimeCell: View {
    
    let name: String
    let iconName: String
    let time: DateComponents?
    var alarm: Bool = true
    var description: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 2) {
                Image(systemName: iconName)
                Text(name.uppercased())
            }
            .font(Font.system(.caption).weight(.semibold))
            .foregroundColor(.gray)
            
            Text(time?.timeString ?? "Not Set")
                .font(Font.system(.title2, design: .rounded).weight(.bold))
                .foregroundColor(time != nil && alarm ? .primary : .gray)
            
            if let description = description {
                Text(description)
                    .font(Font.system(.caption).weight(.semibold))
                    .foregroundColor(.gray)
            }
        }
        .padding(.trailing)
        .fixedSize()

    }
}
