//
//  VCGarageViewContext.swift
//  testBinding
//
//  Created by Andrey Soloviov on 30/7/20.
//

import SwiftUI

protocol VCGarageViewModelProtocol: class {
  var viewContext: VCGarageView.ViewContext? { get set }
}

extension VCGarageView {
  class ViewContext: ObservableObject {
    var viewModel: VCGarageViewModelProtocol? {
      didSet {
        viewModel?.viewContext = self
      }
    }
    
    @Published var cars: [UUID] = [] {
      didSet {
        customPrint("!")
      }
    }
    
    @Published var titles: String = ""
    @Published var colors: String = ""
    @Published var engineCCs: String = ""
    @Published var engineModels: String = ""
    @Published var numberOfCars: String = "" {
      didSet {
        customPrint("set: \(numberOfCars)")
      }
    }
    
    func carView(_ id: UUID) -> some View {
      let viewContext = VCCarView.ViewContext()
      viewContext.viewModel = VCCarViewModel(carId: id, store: AppState.shared.store)
      let view = VCCarView(viewContext: viewContext)
      return view
    }
    
    init() {
      customPrint("VCGarageView.ViewContext init")
    }
    
    deinit {
      customPrint("VCGarageView.ViewContext deinit")
    }
  }
}
