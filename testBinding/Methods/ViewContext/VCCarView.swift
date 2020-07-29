//
//  VCCarView.swift
//  testBinding
//
//  Created by Andrey Soloviov on 29/7/20.
//

import SwiftUI

struct VCCarView: View {
  @ObservedObject var viewContext: ViewContext

  var body: some View {
    VStack {
      HStack {
        TextField("Title", text: viewContext.title)
        TextField("Color", text: viewContext.color)
      }
      
//      if let id = viewModel.engineId(for: carId) {
//        SMEngineView(engineId: id)
//      }
    }.onAppear() {
      print("SMCarView Appeared")
    }
  }
}

extension VCCarView {
  class ViewContext: ObservableObject {
    var viewModel: VCCarViewModelProtocol? {
      didSet {
        viewModel?.viewContext = self
      }
    }

    var title: Binding<String> =
      Binding<String>(
        get: { "1" },
        set: { _ in }
      )
    
    var color: Binding<String> =
      Binding<String>(
        get: { "1" },
        set: { _ in }
      )
  }

}

protocol VCCarViewModelProtocol: class {
  var carId: UUID { get }
  var viewContext: VCCarView.ViewContext? { get set }
}

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
    print("VCCarViewModel deinit")
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
