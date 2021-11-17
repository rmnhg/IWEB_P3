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
    var subscriber: AnyCancellable?

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
        .onReceive(quizzesModel.$errorAlert, perform: { error in
            showAlert = error != nil
        })
        .alert(isPresented: $showAlert) {
                   Alert(title: Text("Alerta"),
                                 message: Text(quizzesModel.errorAlert!),
                                 dismissButton: .default(Text("Ok")))
        }
    }
}
