//
//  _avomapsApp.swift
//  _avomaps
//
//  Created by Ethan Herrera on 3/20/23.
//

import SwiftUI
import GoogleMaps

@main
struct _avomapsApp: App {
    
    init() {
        GMSServices.provideAPIKey("")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
