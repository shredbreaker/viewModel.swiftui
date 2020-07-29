//
//  MVCardViewModel.swift
//  testBinding
//
//  Created by Andrey Soloviov on 30/7/20.
//

import SwiftUI
import Combine

extension MVCardView {
  class ViewModel: ObservableObject {
    private var subs = Set<AnyCancellable>()
    private var store: Store
    private var carId: UUID
    
    var title: Binding<String> = Binding<String>(get: {""}, set: { _ in })
    var color: Binding<String> = Binding<String>(get: {""}, set: { _ in })
    
    init(carId: UUID, store: Store) {
      self.store = store
      self.carId = carId
      
      store.$garage
        .removeDuplicates()
        .receive(on: RunLoop.main)
        .sink { [weak self] garage in
          guard let self = self, let index = self.store.garage.carIndex(id: carId) else { return }
          self.objectWillChange.send()
          self.title = Binding<String>(
            get: { store.garage.cars[index].title },
            set: { store.garage.cars[index].title = $0 }
          )
          
          self.color = Binding<String>(
            get: { store.garage.cars[index].color },
            set: { store.garage.cars[index].color = $0 }
          )
        }.store(in: &subs)

    }
  }
}

