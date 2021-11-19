//
//  QuizPlayView.swift
//  Practica3
//
//  Created by Ramón Hernández García and Andrés Ripoll Cabrera on 25/10/21.
//

import SwiftUI

struct QuizPlayView: View {
    
    var quizItemIndex: Int
    
    @EnvironmentObject var scoreModel: ScoreModel
    @EnvironmentObject var quizzesModel: QuizzesModel
    @State var answer: String = ""
    @State var showAlert = false
    @State var showAnswer = false
    @State var angle = 0.0
    
    var body: some View {
        VStack {
            titleandstar
            recuadrodetexto
            boton
            Spacer()
            attachment
            Spacer()
            HStack {
                Text("Score: \(scoreModel.acertadas.count)")
                Spacer()
                author
            }
        }
        .navigationBarTitle("Play", displayMode: .inline)
        .padding()
    }
    
    private var quizItem: QuizItem {
        quizzesModel.quizzes[quizItemIndex]
    }
    
    private var recuadrodetexto: some View {
        
        TextField("Respuesta",
                  text: $answer,
                  onCommit: {
                    showAlert = true
                    scoreModel.check(respuesta: answer, quiz: quizItem)
                  }
        )
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .alert(isPresented: $showAlert) {
            let s1 = quizItem.answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            let s2 = answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            
            return Alert(title: Text("Respuesta:"),
                         message: Text(s1 == s2 ? "Correcta" : "Errónea"),
                         dismissButton: .default(Text("Aceptar")))
        }
    }
    
    private var boton: some View {
        Button(action: {
            showAlert = true
            scoreModel.check(respuesta: answer, quiz: quizItem)
        }) {
            Text("Comprobar")
        }
    }
    
    
    private var titleandstar: some View {
        HStack {
            Text(quizItem.question)
                .font(.largeTitle)
            
            Button(action: {
                quizzesModel.toggleFavourite(quizItem: quizItem)
                
                //Hacer una animación cualquiera
                withAnimation(.spring(response: 1, dampingFraction: 0.3, blendDuration: 1)) {
                    angle += 360
                }
            }, label: {
                Image(quizItem.favourite ? "star_yellow" : "star_grey")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .scaledToFit()
                    .saturation(self.showAlert ? 0.1 : 1)
            })
        }
    }
    
    private var author: some View {
        
        let uurl = quizItem.author?.photo?.url
        let univm = NetworkImageViewModel(url: uurl)
        
        return HStack(alignment: .bottom, spacing: 5){
            //Cogemos el nombre de perfil si el nombre de usuario es nulo antes de poner anonimo
            Text(quizItem.author?.username ?? (quizItem.author?.profileName ?? "anonimo"))
                .font(.callout)
                .foregroundColor(.green)
                .saturation(self.showAlert ? 0.1 : 1)
            
            NetworkImageView(viewModel: univm)
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .overlay(Circle().stroke(lineWidth: 3))
                .saturation(self.showAlert ? 0.1 : 1)
                .contextMenu {
                    Button(action: {
                        answer = ""
                    }) {
                        Text("Limpiar respuesta")
                    }
                    Button(action: {
                        answer = quizItem.answer
                    }) {
                        Text("Rellenar respuesta")
                    }
                }
        }
    }
    
    private var attachment: some View {
        
        let aurl = quizItem.attachment?.url
        let anivm = NetworkImageViewModel(url: aurl)
        
        return ZStack {
            NetworkImageView(viewModel: anivm)
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .contentShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 2))
                .shadow(color: .black, radius: 10)
                .saturation(self.showAlert ? 0.1 : 1)
                .rotationEffect(Angle.degrees(angle))
                .onTapGesture(count: 2) {
                    withAnimation {
                        answer = quizItem.answer
                        //El angulo cambia de 0 a 360 y de 360 a 0
                        angle = 360 - angle
                    }
                }
                .animation(.easeInOut, value: self.showAlert)
                .onLongPressGesture(minimumDuration: 0.5) {
                    showAnswer.toggle()
                }
            
            if (showAnswer) {
                HStack {
                    Spacer()
                    Text("Respuesta: \(quizItem.answer)")
                        .font(.system(size: 20))
                        .background(Color.black)
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.01)
                    Spacer()
                }
            }
        }
    }
}
