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
      
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(viewContext.cars) {
            viewContext.carView($0)
          }
        }.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
      }
      Spacer()
      
      
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
    
    update()
    
    store.$garage
      .receive(on: RunLoop.main)
      .removeDuplicates()
      .sink { [weak self] garage in
        self?.update()
      }.store(in: &subs)
  }
  
  func update() {
    guard let garage = store?.garage else { return }
    
    DispatchQueue.global(qos: .background).async {
      let cars = garage.cars.map({ $0.id })
      let titles = garage.titles.joined(separator: ", ")
      let colors = garage.colors.joined(separator: ", ")
      let engineCCs = garage.engineCCs.joined(separator: ", ")
      let engineModels = garage.engineModels.joined(separator: ", ")
      let numberOfCars = String("\(garage.cars.count)")
      
      DispatchQueue.main.async { [weak self] in
        guard let vc = self?.viewContext else { return }
        vc.objectWillChange.send()
        vc.cars = cars
        vc.titles = titles
        vc.colors = colors
        vc.engineCCs = engineCCs
        vc.engineModels = engineModels
        vc.numberOfCars = numberOfCars
      }
    }
  }
}

