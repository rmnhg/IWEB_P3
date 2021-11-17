//
//  ContentView.swift
//  Practica2
//
//  Created by Ramón Hernández García and Andrés Ripoll Cabrera on 25/10/21.
//

import SwiftUI
import Combine


struct QuizzesListView: View {
    @EnvironmentObject var quizzesModel: QuizzesModel
    @State var verTodo: Bool = true
    @State var showAlert: Bool = false
    @EnvironmentObject var scoreModel: ScoreModel
    
    var body: some View {
        NavigationView {
            List {
                Text("Record: \(scoreModel.record.count)")
                Toggle("Ver quizzes", isOn: $verTodo.animation())
                ForEach(quizzesModel.quizzes.indices, id: \.self) { index in
                    if (verTodo || !scoreModel.acertada(quizzesModel.quizzes[index])) {
                        NavigationLink(destination: QuizPlayView(quizItemIndex: index)) {
                            QuizRowView(quizItem: quizzesModel.quizzes[index])
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Práctica 3: Quiz SwiftUI"))
            .navigationBarItems(leading: Text("").font(.callout),
                                trailing: Button(action: {
                                    quizzesModel.download()
                                    scoreModel.limpiar()
                                }) {
                                    Label("Reload", systemImage: "arrow.triangle.2.circlepath")
                                })
        }
        .onReceive(quizzesModel.$errorAlert, perform: { error in
            showAlert = error != nil
        })
        .alert(isPresented: $showAlert) {
                   Alert(title: Text("Alerta"),
                                 message: Text(quizzesModel.errorAlert!),
                                 dismissButton: .default(Text("Ok")))
        }
        //Para adaptar la vista en el formato horizontal
        .phoneOnlyStackNavigationView()
    }
}
