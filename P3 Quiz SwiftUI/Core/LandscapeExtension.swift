//
//  LandscapeExtension.swift
//  Practica1
//
//  Created by Ramón Hernández García and Andrés Ripoll Cabrera on 4/10/21.
//

import SwiftUI

extension View {
    func phoneOnlyStackNavigationView() -> some View {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}
