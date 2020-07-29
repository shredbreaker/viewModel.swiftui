//
//  Models.swift
//  testBinding
//
//  Created by Andrei Solovev on 28/7/20.
//

import Foundation

struct Garage: Identifiable {
    let id = UUID()
    var cars: [Car]
}

extension Garage: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(cars)
    }
    
    func car(id: UUID) -> Car? {
        return cars.first(where: { $0.id == id })
    }
    
    mutating func update(car: Car) {
        if let index = cars.firstIndex(where: { $0.id == car.id}) {
            cars[index] = car
        }
    }
    
    func engine(id: UUID) -> Engine? {
        cars.first(where: { $0.engine.id == id })?.engine
    }

    mutating func update(engine: Engine) {
        if let index = cars.firstIndex(where: { $0.engine.id == engine.id}) {
            cars[index].engine = engine
        }
    }

}


struct Car: Identifiable {
    var id = UUID()
    var title: String
    var color: String
    var engine: Engine
}

extension Car: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(color)
        hasher.combine(engine)
    }
}


struct Engine: Identifiable {
    var id = UUID()
    var cc: String
    var model: String
}

extension Engine: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(cc)
        hasher.combine(model)
    }
}

extension Garage {
    var titles: [String] {
        Array(Set(cars.map({$0.title}))).sorted()
    }
    
    var colors: [String]  {
        Array(Set(cars.map({$0.color}))).sorted()
    }
    
    var engineCCs: [String]  {
        Array(Set(cars.map({$0.engine.cc}))).sorted()
    }
    var engineModels: [String]  {
        Array(Set(cars.map({$0.engine.model}))).sorted()
    }
}

