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
      print("MVGarageView.ViewModel init() \(UUID().uuidString)")
      
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
      self.cars = store.cars
      self.titles = store.titles
      self.colors = store.colors
      self.engineCCs = store.engineCCs
      self.engineModels = store.engineModels
      self.numberOfCars = store.numberOfCars
    }
    
  }
}



