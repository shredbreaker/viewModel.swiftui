//
//  VCGarageView.swift
//  testBinding
//
//  Created by Andrey Soloviov on 29/7/20.
//

import SwiftUI

struct VCGarageView: View {
  @ObservedObject var viewContext: ViewContext
  
  var body: some View {
    VStack {
      List {
        ForEach(viewContext.cars) {
          viewContext.carView($0)
        }
      }
      
      VStack(alignment: .leading) {
        Text("Update id: \(increasedId())")
        Text("Cars: \(viewContext.numberOfCars)")
        Text("Titles: \(viewContext.titles)")
        Text("Colors: \(viewContext.colors)")
        Text("CC: \(viewContext.engineCCs)")
        Text("Models: \(viewContext.engineModels)")
        Button(action:{
        }) { Text("Add car")}
      }.padding().font(.footnote)
    }.onAppear() {
      print("SMGarageView Appeared")
    }
  }
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
        print("!")
      }
    }
    
    @Published var titles: String = ""
    @Published var colors: String = ""
    @Published var engineCCs: String = ""
    @Published var engineModels: String = ""
    @Published var numberOfCars: String = "" {
      didSet {
        print("set: \(numberOfCars)")
      }
    }
    
    func carView(_ id: UUID) -> some View {
      let viewContext = VCCarView.ViewContext()
      viewContext.viewModel = VCCarViewModel(carId: id, store: store)
      let view = VCCarView(viewContext: viewContext)
      return view      
    }
    
    init() {
      print("VCGarageView.ViewContext init")
    }
    
    deinit {
      print("VCGarageView.ViewContext deinit")
    }
  }
}

protocol VCGarageViewModelProtocol: class {
  var viewContext: VCGarageView.ViewContext? { get set }
}

import Combine
class VCGarageViewModel: VCGarageViewModelProtocol {
  weak var store: Store?

  weak var viewContext: VCGarageView.ViewContext? {
    didSet {
      setup()
    }
  }

  deinit {
    print("VCGarageViewModel deinit")
  }

  var subs = Set<AnyCancellable>()
  init(store: Store) {
    self.store = store
    print("VCGarageViewModel init")
  }
  
  func setup() {
    subs.removeAll()
    guard let store = store else { return }
    
    store.$garage
      .receive(on: RunLoop.main)
      .sink { [weak self] garage in
        guard let vc = self?.viewContext else { return }

        vc.cars = garage.cars.map({ $0.id })
        vc.titles = garage.titles.joined(separator: ", ")
        vc.colors = garage.colors.joined(separator: ", ")
        vc.engineCCs = garage.engineCCs.joined(separator: ", ")
        vc.engineModels = garage.engineModels.joined(separator: ", ")
        vc.numberOfCars = String("\(garage.cars.count)")
        
      }.store(in: &subs)
  }
}
