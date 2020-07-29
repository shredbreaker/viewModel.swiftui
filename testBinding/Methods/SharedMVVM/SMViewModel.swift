//
//  SMVVMViewModel.swift
//  testBinding
//
//  Created by Andrei Solovev on 29/7/20.
//

import SwiftUI
import Combine

extension UUID: Identifiable {
    public var id: UUID {
        return self
    }
}

// SwiftUI doesn't matter if View uses any @Published properties of ObservableObject. If any @Published properties updates it will trigger View to update.
class SMViewModel: ObservableObject {
    private var store = Store()
    let id = UUID()

    @Published private var garage: Garage

    var carIDs: [UUID] {
        return garage.cars.map { $0.id }
    }
    var titles: String {
        return garage.titles.joined(separator: ", ")
    }

    var colors: String {
        return garage.colors.joined(separator: ", ")
    }

    var engineCCs: String {
        return garage.engineCCs.joined(separator: ", ")
    }

    var engineModels: String {
        return garage.engineModels.joined(separator: ", ")
    }
    
    var numberOfCars: String {
        return String("\(garage.cars.count)")
    }
    
    func engineId(for carId: UUID) -> UUID? {
        return garage.cars.first(where: { $0.id == carId })?.engine.id
    }
    
    deinit {
        customPrint("SMViewModel deinit \(id)")
    }
    
    init(store: Store) {
        customPrint("SMViewModel init \(id)")
        self.store = store
        garage = store.garage
        store.$garage
            .receive(on: RunLoop.main)
            .assign(to: $garage)
    }
}

extension SMViewModel {
    func titleForCar(id: UUID) -> Binding<String> {
        let store = self.store
        return Binding<String>(
            get: {
                store.garage.car(id: id)?.title ?? ""
            },
            set: {
                if var car = store.garage.car(id: id) {
                    car.title = $0
                    store.garage.update(car: car)
                }
            })
    }
    
    func colorForCar(id: UUID) -> Binding<String> {
        let store = self.store
        return Binding<String>(
            get: {
                store.garage.car(id: id)?.color ?? ""
            },
            set: {
                if var car = store.garage.car(id: id) {
                    car.color = $0
                    store.garage.update(car: car)
                }
            })
    }
    
    func engineCC(_ id: UUID) -> Binding<String> {
        let store = self.store
        return Binding<String>(
            get: {
                store.garage.engine(id: id)?.cc ?? ""
            },
            set: {
                if var engine = store.garage.engine(id: id) {
                    engine.cc = $0
                    store.garage.update(engine: engine)
                }
            })
    }
    
    func engineModel(_ id: UUID) -> Binding<String> {
        let store = self.store
        return Binding<String>(
            get: {
                store.garage.engine(id: id)?.model ?? ""
            },
            set: {
                if var engine = store.garage.engine(id: id) {
                    engine.model = $0
                    store.garage.update(engine: engine)
                }
            })
    }

}
