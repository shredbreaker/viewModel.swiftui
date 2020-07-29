//
//  GarageViewFactory.swift
//  testBinding
//
//  Created by Andrei Solovev on 28/7/20.
//

import SwiftUI

class ViewFactory: ObservableObject {
    func garage(garage: Binding<Garage>) -> VFGarageView {
        let binding = Binding<Garage>(
            get: { garage.wrappedValue },
            set: { _ in print("Attemp to update it")}
        )
        return VFGarageView(garage: binding)
    }

    func car(car: Binding<Car>) -> VFCarView {
        return VFCarView(car: car)
    }

    func engine(engine: Binding<Engine>) -> VFEngineView {
        return VFEngineView(engine: engine)
    }
}

struct VFGarageView: View {
    @EnvironmentObject var viewFactory: ViewFactory
    @Binding var garage: Garage
    var body: some View {
        VStack {
            List {
                ForEach(garage.cars.indexed, id: \.1.id) { index, car in
                    viewFactory.car(car: $garage.cars[index])
                }
            }
            
//            VStack(alignment: .leading) {
//                Text("Titles: \(garage.titles.joined(separator: ", "))")
//                Text("Colors: \(garage.colors.joined(separator: ", "))")
//                Text("CC: \(garage.engineCCs.joined(separator: ", "))")
//                Text("Models: \(garage.engineModels.joined(separator: ", "))")
//                Button(action:{
//                    let newCar = Car(title: "Ford", color: "gray", engine: Engine(cc: "2000", model: "ABCD"))
//                    garage.cars.append(newCar)
//                }) { Text("Add car")}
//            }.padding().font(.footnote)
        }
    }
}

struct VFCarView: View {
    @EnvironmentObject var viewFactory: ViewFactory
    @Binding var car: Car
    var body: some View {
        VStack {
            HStack {
                TextField("Title", text: $car.title)
                TextField("Color", text: $car.color)
            }
            viewFactory.engine(engine: $car.engine)
        }
    }
}

struct VFEngineView: View {
    @Binding var engine: Engine
    var body: some View {
        HStack {
            TextField("CC", text: $engine.cc)
            TextField("Model", text: $engine.model)
        }
    }
}
