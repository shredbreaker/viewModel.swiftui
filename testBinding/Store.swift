//
//  Store.swift
//  testBinding
//
//  Created by Andrei Solovev on 28/7/20.
//

import SwiftUI

class Store: ObservableObject {
    @Published var garage = Garage(cars: [
        Car(title: "Mazda 3", color: "red", engine: Engine(cc: "111", model: "AA")),
        Car(title: "BMW",color: "green", engine: Engine(cc: "12", model: "AAA")),
        Car(title: "Mercedes",color: "yellow", engine: Engine(cc: "33", model: "BB")),
    ])
    
    
}
