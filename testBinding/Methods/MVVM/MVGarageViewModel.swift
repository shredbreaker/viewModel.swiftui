//
//  GarageViewModels.swift
//  testBinding
//
//  Created by Andrei Solovev on 28/7/20.
//

import SwiftUI
import Combine


extension MVGarageView {
  class ViewModel: ObservableObject {
    var cars: [UUID] = []
    var titles: String = ""
    var colors: String = ""
    var engineCCs: String = ""
    var engineModels: String = ""
    var numberOfCars: String = ""
    
    private var subs = Set<AnyCancellable>()
    private var store: Store
    
    init(store: Store) {
      self.store = store
      
      setup(garage: store.garage)
      
      store.$garage
        .removeDuplicates()
        .receive(on: RunLoop.main)
        .sink { [weak self] garage in
          self?.setup(garage: garage)
        }.store(in: &subs)
    }
    
    func setup(garage: Garage) {
      self.objectWillChange.send()
      self.cars = garage.cars.map({ $0.id })
      self.titles = garage.titles.joined(separator: ", ")
      self.colors = garage.colors.joined(separator: ", ")
      self.engineCCs = garage.engineCCs.joined(separator: ", ")
      self.engineModels = garage.engineModels.joined(separator: ", ")
      self.numberOfCars = String("\(garage.cars.count)")
    }
    
  }
}



