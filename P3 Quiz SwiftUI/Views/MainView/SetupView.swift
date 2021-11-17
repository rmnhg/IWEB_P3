//
//  SetupView.swift
//  P3 Quiz SwiftUI
//
//  Created by Ramón Hernández García on 07/11/2021.
//

import SwiftUI

struct SetupView: View {
    @EnvironmentObject var quizzesModel: QuizzesModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Servidor")) {
                    TextField("URL Base", text: $quizzesModel.url_base)
                    TextField("Token", text: $quizzesModel.token)
                    Button(action: {
                        quizzesModel.resetEndPoint()
                    }) { Text("Reset") }
                }
                Section(header: Text("Detalles")) {
                    HStack {
                        Text("Versión")
                        Spacer()
                        Text("2021")
                    }
                }
            }
        }
    }
}
