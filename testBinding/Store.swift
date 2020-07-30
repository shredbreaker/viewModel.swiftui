//
//  Store.swift
//  testBinding
//
//  Created by Andrei Solovev on 28/7/20.
//

import SwiftUI

class Store: ObservableObject {
  
  var queue = DispatchQueue(label: "Background")
  var cars: [UUID] = []
  var titles: String = ""
  var colors: String = ""
  var engineCCs: String = ""
  var engineModels: String = ""
  var numberOfCars: String = ""
  
  @Published var garage = Garage(cars: [
    Car(title: "Mazda 3", color: "red", engine: Engine(cc: "111", model: "AA")),
    Car(title: "BMW",color: "green", engine: Engine(cc: "12", model: "AAA")),
    Car(title: "Mercedes",color: "yellow", engine: Engine(cc: "33", model: "BB")),
  ]) {
    didSet {
      update()
    }
  }
  
  
  init() {
    update()
  }
  
  func add(cars:[Car]) {

    queue.async { [weak self] in
      self?.garage.cars.append(contentsOf: cars)
      self?.update()

      DispatchQueue.main.async {
        self?.objectWillChange.send()
      }
    }
  }
  
  func update() {
    self.cars = self.garage.cars.map({ $0.id })
    self.titles = self.garage.titles.joined(separator: ", ")
    self.colors = self.garage.colors.joined(separator: ", ")
    self.engineCCs = self.garage.engineCCs.joined(separator: ", ")
    self.engineModels = self.garage.engineModels.joined(separator: ", ")
    self.numberOfCars = String("\(self.garage.cars.count)")
  }
  
}

