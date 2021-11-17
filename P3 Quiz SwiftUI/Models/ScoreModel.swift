//
//  ScoreModel.swift
//  Practica2
//
//  Created by Ramón Hernández García and Andrés Ripoll Cabrera on 25/10/21.
//

import Foundation

class ScoreModel: ObservableObject {
    
    @Published private(set) var acertadas: Set<Int> = []
    @Published private(set) var record: Set<Int> = []
    
    init() {
        if let record = UserDefaults.standard.object(forKey: "record") as? [Int] {
            self.record = Set(record)
        }
    }
    
    func check(respuesta: String, quiz: QuizItem) {
        let r1 = respuesta.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let r2 = quiz.answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if r1 == r2 {
            
            acertadas.insert(quiz.id)
            record.insert(quiz.id)
            
            UserDefaults.standard.set(Array<Int>(record), forKey: "record")
        }
    }
    
    func acertada(_ quizItem: QuizItem) -> Bool {
        return acertadas.contains(quizItem.id)
    }
    
    func limpiar() {
        acertadas = []
    }
}
