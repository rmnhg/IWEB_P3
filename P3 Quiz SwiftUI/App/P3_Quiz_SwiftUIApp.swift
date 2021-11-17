//
//  Practica2App.swift
//  Practica1
//
//  Created by Ramón Hernández García and Andrés Ripoll Cabrera on 25/10/21.
//

import SwiftUI

@main
struct Practica3App: App {
    
    let quizzesModel = QuizzesModel()
    let scoreModel = ScoreModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(quizzesModel)
                .environmentObject(scoreModel)
            
        }
    }
}
