//
//  testBindingApp.swift
//  testBinding
//
//  Created by Andrei Solovev on 28/7/20.
//

import SwiftUI

// Don't store State or StateObject if you won't want your view to constantly updates on any changes

func customPrint(_ string: String) {
  
}

class AppState {
  var store = Store()
  static let shared = AppState()
}

let mvViewFactory = MVViewFactory(store: AppState.shared.store)

@main
struct TestApp: App {
  
  enum Method: Int, CaseIterable {
    case viewContext
    case viewAndModel
    case viewFactory
    case mvvm
    case sharedMVVM
  }
  
  @State var method: Method = .mvvm
  
  @State var addCount = 50
  var body: some Scene {
    WindowGroup {
      VStack {
        switch method {
        case .sharedMVVM: SMGarageView().environmentObject(SMViewModel(store: AppState.shared.store))
        case .viewFactory: ViewFactoryMethodView()
        case .mvvm: mvViewFactory.garageView()
//          MVVMGarageView(viewModel: MVVMGarageView.ViewModel(store: store))
        case .viewAndModel: GarageView(garage: Binding<Garage>(get: { AppState.shared.store.garage }, set: { AppState.shared.store.garage = $0 }))
        case .viewContext: getVCGarageView()
        }
        
        
        Button(action:{
          let new = [Any](repeating:"0", count: addCount)
            .map { _ in
              Car(title: "Truck", color: "black", engine: Engine(cc: "3000", model: "DDD"))
            }
          AppState.shared.store.garage.cars.append(contentsOf: new)
          addCount *= 2
        }) { Text("Add \(addCount) Trucks")}.padding()
        
        Button(action:{
          self.nextMethod()
        }) { Text("Method: \(String(describing: method)). Next >").padding() }
        
      }
    }
  }
  
  func getVCGarageView() -> some View {
    let viewContext = VCGarageView.ViewContext()
    viewContext.viewModel = VCGarageViewModel(store: AppState.shared.store)
    let view = VCGarageView(viewContext: viewContext)
    return view
  }
  
  func nextMethod() {
    guard let index = Method.allCases.firstIndex(where: { $0 == self.method }), index < Method.allCases.count - 1 else {
      method = Method.allCases[0]
      return
    }
    method = Method.allCases[index+1]
  }
}


