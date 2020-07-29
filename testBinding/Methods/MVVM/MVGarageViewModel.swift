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
    @Published var cars: [UUID] = []
    @Published var titles: String = ""
    @Published var colors: String = ""
    @Published var engineCCs: String = ""
    @Published var engineModels: String = ""
    @Published var numberOfCars: String = ""

    private var subs = Set<AnyCancellable>()
    private var store: Store
    
    init(store: Store) {
      self.store = store

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


