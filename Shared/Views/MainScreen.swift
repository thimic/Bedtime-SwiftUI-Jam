//
//  MainScreen.swift
//  Bedtime
//
//  Created by Michael Thingnes on 20/02/21.
//

import SwiftUI

struct MainScreen: View {
    var body: some View {
        NavigationView {
            ScheduleView()
                .navigationTitle("Bedtime")
            
            OverView()
//                .padding(.top, -30)
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
