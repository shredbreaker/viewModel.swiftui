//
//  VCGarageViewModel.swift
//  testBinding
//
//  Created by Andrey Soloviov on 30/7/20.
//

import SwiftUI
import Combine

class VCGarageViewModel: VCGarageViewModelProtocol {
  weak var store: Store?
  
  weak var viewContext: VCGarageView.ViewContext? {
    didSet {
      setup()
    }
  }
  
  deinit {
    customPrint("VCGarageViewModel deinit")
  }
  
  var subs = Set<AnyCancellable>()
  init(store: Store) {
    self.store = store
    customPrint("VCGarageViewModel init")
  }
  
  func setup() {
    subs.removeAll()
    guard let store = store else { return }
    
    update()
    
    store.$garage
      .receive(on: RunLoop.main)
      .removeDuplicates()
      .sink { [weak self] garage in
        self?.update()
      }.store(in: &subs)
  }
  
  func update() {
    guard let garage = store?.garage, let vc = viewContext else { return }
    
    //    DispatchQueue.global(qos: .background).async {
    let cars = garage.cars.map({ $0.id })
    let titles = garage.titles.joined(separator: ", ")
    let colors = garage.colors.joined(separator: ", ")
    let engineCCs = garage.engineCCs.joined(separator: ", ")
    let engineModels = garage.engineModels.joined(separator: ", ")
    let numberOfCars = String("\(garage.cars.count)")
    
    vc.objectWillChange.send()
    vc.cars = cars
    vc.titles = titles
    vc.colors = colors
    vc.engineCCs = engineCCs
    vc.engineModels = engineModels
    vc.numberOfCars = numberOfCars
    //    }
  }
}
