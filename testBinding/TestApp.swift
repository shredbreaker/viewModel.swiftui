//
//  testBindingApp.swift
//  testBinding
//
//  Created by Andrei Solovev on 28/7/20.
//

import SwiftUI

// Don't store State or StateObject if you won't want your view to constantly updates on any changes

let store = Store()
@main
struct TestApp: App {

    enum Method: Int, CaseIterable {
        case viewAndModel
        case viewFactory
        case mvvm
        case sharedMVVM
    }
    
    @State var method: Method = .viewFactory
    
    var body: some Scene {
        WindowGroup {
            VStack {
                switch method {
                    case .sharedMVVM: SMGarageView().environmentObject(SMViewModel(store: store))
                    case .viewFactory: ViewFactoryMethod()
                    case .mvvm: MVVMGarageView(viewModel: MVVMGarageView.ViewModel(store: store))
                    case .viewAndModel: GarageView(garage: Binding<Garage>(get: { store.garage }, set: { store.garage = $0 }))
                }
                
                    
                Button(action:{
                    let new = [Car](repeating: Car(title: "Truck", color: "black", engine: Engine(cc: "3000", model: "DDD")), count: 20)
                    store.garage.cars.append(contentsOf: new)
                }) { Text("Add 20 Trucks")}.padding()

                Button(action:{
                    self.nextMethod()
                }) { Text("Method: \(String(describing: method)). Next >").padding() }

            }
        }
    }
    
    func nextMethod() {
        guard let index = Method.allCases.firstIndex(where: { $0 == self.method }), index < Method.allCases.count - 1 else {
            method = Method.allCases[0]
            return
        }
        method = Method.allCases[index+1]
    }
}

struct ViewFactoryMethod: View {
    @StateObject var viewFactory = ViewFactory()

    var body: some View {
        VStack {
            viewFactory.garage(garage: Binding<Garage>(get: { store.garage }, set: { store.garage = $0}))
        }.environmentObject(viewFactory)
    }
}
