//
//  MainView.swift
//  P3 Quiz SwiftUI
//
//  Created by Ramón Hernández García and Andrés Ripoll Cabrera on 07/11/2021.
//

import SwiftUI
import Combine

struct MainView: View {
    @EnvironmentObject var quizzesModel: QuizzesModel
    @State var showAlert = false
    
    var body: some View {
        TabView {
            QuizzesListView()
                .tabItem {
                    Label("Jugar", systemImage: "q.circle")
                }
            SetupView()
                .tabItem {
                    Label("Ajustes", systemImage: "gearshape")
                }
            
        }
    }
}
