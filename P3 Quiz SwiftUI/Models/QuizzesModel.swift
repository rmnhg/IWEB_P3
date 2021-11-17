//
//  QuizzesModel.swift
//  P1 Quiz SwiftUI
//
//  Created by Santiago Pavón Gómez on 17/09/2021.
//

import Foundation
import Combine

class QuizzesModel: ObservableObject {
    
    // Los datos
    @Published private(set) var quizzes = [QuizItem]()
    
//    let TOKEN = "e176550118dd9de9e5f0"//"d283b3d85b2d2778acba"
//    let URL_BASE = "https://core.dit.upm.es/api"
    // Session
    private let session = URLSession.shared

    // URL del servidor Quiz.
    @Published var url_base: String

    // Token de acceso
    @Published var token: String

    @Published var errorAlert: String?
    
    var subscribers: Set<AnyCancellable> = []

    init() {
        url_base = UserDefaults.standard.string(forKey: "url_base") ?? ""
        token = UserDefaults.standard.string(forKey: "token") ?? ""

        download()
       
        $url_base.sink { url_base in
                    UserDefaults.standard.set(url_base, forKey: "url_base")
                    UserDefaults.standard.synchronize()
        }.store(in: &subscribers)

        $url_base.sink { token in
                    UserDefaults.standard.set(token, forKey: "token")
                    UserDefaults.standard.synchronize()
        }.store(in: &subscribers)
    }

    func resetEndPoint() {
        url_base = "https://core.dit.upm.es/api"
        token = "e176550118dd9de9e5f0"
    }
    
    func load() {
        guard let jsonURL = Bundle.main.url(forResource: "p1_quizzes", withExtension: "json") else {
            self.errorAlert(errorMsg: "Internal error: No encuentro p1_quizzes.json")
            return
        }
        
        do {
            let data = try Data(contentsOf: jsonURL)
            let decoder = JSONDecoder()
            
//            if let str = String(data: data, encoding: String.Encoding.utf8) {
//                print("Quizzes ==>", str)
//            }
            
            let quizzes = try decoder.decode([QuizItem].self, from: data)
            
            self.quizzes = quizzes

            print("Quizzes cargados")
        } catch {
            self.errorAlert(errorMsg: "Algo chungo ha pasado: \(error)")
        }
    }
    
    func download() {
        let urlStr = "\(url_base)/quizzes/random10wa?token=\(token)"
        print("URL: \(urlStr)")
        //Me fijo que en el urlStr no haya espacios ni nada raro, sino habría que procesar la string
        guard let url = URL(string: urlStr) else {
            self.errorAlert(errorMsg: "Error: no se ha podido crear la URL de petición.\n Se cargará la lista por defecto del archivo JSON")
            load()
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil,
               (response as! HTTPURLResponse).statusCode == 200,
               let data = data { //Como tiene el mismo nombre, a partir de las llaves data es el tipo no opcional
                do {
                    let quizzes = try JSONDecoder().decode([QuizItem].self, from: data)
                    DispatchQueue.main.async {
                        self.quizzes = quizzes
                    }
                    
                } catch {
                    self.errorAlert(errorMsg: "Error: no se ha podido procesar el JSON de respuesta: \(error).\n Se cargará la lista por defecto del archivo JSON")
                    self.load()
                }
            } else {
                self.errorAlert(errorMsg: "Error: no se ha podido crear la petición HTTP.\n Se cargará la lista por defecto del archivo JSON")
                self.load()
            }
        }
            .resume()
    }

    func toggleFavourite(quizItem: QuizItem) {
        guard let index = quizzes.firstIndex(where: { qi in
            qi.id == quizItem.id
        }) else {
            self.errorAlert(errorMsg: "Error: ha habido un fallo buscando el quiz que está modificando")
            return
        }
        let urlStr = "\(url_base)/users/tokenOwner/favourites/\(quizItem.id)?token=\(token)"
        print("URL: \(urlStr)")
        //Me fijo que en el urlStr no haya espacios ni nada raro, sino habría que procesar la string
        guard let url = URL(string: urlStr) else {
            self.errorAlert(errorMsg: "Error: no se ha podido crear la URL de petición")
            return
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = quizItem.favourite ? "DELETE" : "PUT"
        req.addValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        
        URLSession.shared.uploadTask(with: req, from: Data()) { _, res, error in
            if error == nil,
               (res as! HTTPURLResponse).statusCode == 200 {
                DispatchQueue.main.sync {
                    self.quizzes[index].favourite.toggle()
                }
               } else {
                self.errorAlert(errorMsg: "Error: no se ha podido marcar o desmarcar este quiz como favorito")
            }
        }
        .resume()
    }
    
    func errorAlert(errorMsg: String) {
        print(errorMsg)
        errorAlert = errorMsg
    }
}
