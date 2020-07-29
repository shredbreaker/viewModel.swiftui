//
//  GarageViewModels.swift
//  testBinding
//
//  Created by Andrei Solovev on 28/7/20.
//

import SwiftUI
import Combine
struct MVVMGarageView: View {
    @StateObject var viewModel: ViewModel    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.garage.cars.indexed, id: \.1.id) { index, car in
                    MVVMCarView(car: $viewModel.garage.cars[index])
                }
            }

            VStack(alignment: .leading) {
                Text("Titles: \(viewModel.garage.titles.joined(separator: ", "))")
                Text("Colors: \(viewModel.garage.colors.joined(separator: ", "))")
                Text("CC: \(viewModel.garage.engineCCs.joined(separator: ", "))")
                Text("Models: \(viewModel.garage.engineModels.joined(separator: ", "))")
                Button(action:{
                    let newCar = Car(title: "Ford", color: "gray", engine: Engine(cc: "2000", model: "ABCD"))
                    viewModel.garage.cars.append(newCar)
                }) { Text("Add car")}
            }.padding().font(.footnote)
        }.onAppear {
            print("MVVMGarageView Appeared")
        }
    }
}

extension MVVMGarageView {
    class ViewModel: ObservableObject {
        var store: Store
        let id = UUID()
        
        @Published var garage: Garage {
            didSet {
                store.garage = garage
            }
        }

        var subs = Set<AnyCancellable>()

        func set(car: Car) {
            if let index = garage.cars.firstIndex(where: {$0.id == car.id}) {
                garage.cars[index] = car
            }
        }
        
        deinit {
            print("MVVMGarageView deinit \(id)")
        }
        init(store: Store) {
            print("MVVMGarageView init \(id)")
            self.store = store
            garage = store.garage
            
            store.$garage
                .removeDuplicates()
                .receive(on: RunLoop.main)
                .assign(to: \.garage, on: self)
                .store(in: &subs)
        }
    }
}


struct MVVMCarView: View {
    @Binding var car: Car
    init(car: Binding<Car>) {
        print("MVVMCarView init \(car.id)")
        _car = car
    }

    var body: some View {
        VStack {
            HStack {
                TextField("Title", text: $car.title)
                TextField("Color", text: $car.color)
            }
            MVVMEngineView(engine: $car.engine)
        }.onAppear {
            print("MVVMCarView Appeared \(car.id)")
        }
    }
}

struct MVVMEngineView: View {
    @Binding var engine: Engine
    init(engine: Binding<Engine>) {
        print("MVVMEngineView init \(engine.id)")
        _engine = engine
    }
    var body: some View {
        HStack {
            TextField("CC", text: $engine.cc)
            TextField("Model", text: $engine.model)
        }.onAppear {
            print("MVVMEngineView Appeared \(engine.id)")
        }
    }
}
