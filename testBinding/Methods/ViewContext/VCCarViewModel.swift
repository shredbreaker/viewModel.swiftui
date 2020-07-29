//
//  VCCarViewModel.swift
//  testBinding
//
//  Created by Andrey Soloviov on 30/7/20.
//

import SwiftUI
import Combine

class VCCarViewModel: VCCarViewModelProtocol {
  let carId: UUID
  weak var store: Store?
  
  weak var viewContext: VCCarView.ViewContext? {
    didSet {
      setup()
    }
  }
  
  deinit {
    customPrint("VCCarViewModel deinit")
  }
  
  var subs = Set<AnyCancellable>()
  init(carId: UUID, store: Store) {
    self.carId = carId
    self.store = store
  }
  
  func setup() {
    subs.removeAll()
    guard let store = store else { return }
    
    
    update()
    
    store.$garage
      .removeDuplicates()
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        self?.update()
        
      }.store(in: &subs)
  }
  
  func update() {
    guard let store = self.store, let viewContext = self.viewContext, let index = store.garage.carIndex(id: self.carId) else { return }
    
    viewContext.objectWillChange.send()
    
    viewContext.title = Binding<String>(
      get: { store.garage.cars[index].title },
      set: { store.garage.cars[index].title = $0 }
    )
    
    viewContext.color = Binding<String>(
      get: { store.garage.cars[index].color },
      set: { store.garage.cars[index].color = $0 }
    )
    
  }
}
