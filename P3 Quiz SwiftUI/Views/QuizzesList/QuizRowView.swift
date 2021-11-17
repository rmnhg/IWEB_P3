//
//  QuizRowView.swift
//  Practica2
//
//  Created by Ramón Hernández García and Andrés Ripoll Cabrera on 25/10/21.
//

import SwiftUI

struct QuizRowView: View {
    
    var quizItem: QuizItem
    
    var body: some View {
        
        let aurl = quizItem.attachment?.url
        let anivm = NetworkImageViewModel(url: aurl)
        
        let uurl = quizItem.author?.photo?.url
        let univm = NetworkImageViewModel(url: uurl)
        
        HStack {
            NetworkImageView(viewModel: anivm)
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(lineWidth: 3))
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Image(quizItem.favourite ? "star_yellow" : "star_grey")
                        .resizable()
                        .frame(width: 30, height:30)
                        .scaledToFit()
                        .foregroundColor(.white)
                        .padding()
                    
                    Spacer()
                    HStack(alignment: .center, spacing: 5){
                        //Cogemos el nombre de perfil si el nombre de usuario es nulo antes de poner anonimo
                        Text(quizItem.author?.username ?? (quizItem.author?.profileName ?? "anonimo"))
                            .font(.callout)
                            .foregroundColor(.green)
                        
                        NetworkImageView(viewModel: univm)
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(lineWidth: 2))
                    }
                    
                }
                Text(quizItem.question)
                    .font(.headline)
                    .padding()
            }
        }
    }
}
