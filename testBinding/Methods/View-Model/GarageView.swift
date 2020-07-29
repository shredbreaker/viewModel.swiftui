//
//  GarageView.swift
//  testBinding
//
//  Created by Andrei Solovev on 28/7/20.
//

import SwiftUI

struct GarageView: View {
    @Binding var garage: Garage
    var body: some View {
        VStack {
            List {
                ForEach(garage.cars.indexed, id: \.1.id) { index, car in
                    CarView(car: $garage.cars[index])
                }
            }
            
            VStack(alignment: .leading) {
                Text("Titles: \(garage.titles.joined(separator: ", "))")
                Text("Colors: \(garage.colors.joined(separator: ", "))")
                Text("CC: \(garage.engineCCs.joined(separator: ", "))")
                Text("Models: \(garage.engineModels.joined(separator: ", "))")
                Button(action:{
                    let newCar = Car(title: "Ford", color: "gray", engine: Engine(cc: "2000", model: "ABCD"))
                    garage.cars.append(newCar)
                }) { Text("Add car")}
            }.padding().font(.footnote)
        }
    }
}

struct CarView: View {
    @Binding var car: Car
    var body: some View {
        VStack {
            HStack {
                TextField("Title", text: $car.title)
                TextField("Color", text: $car.color)
            }
            EngineView(engine: $car.engine)
        }
    }
}

struct EngineView: View {
    @Binding var engine: Engine
    var body: some View {
        HStack {
            TextField("CC", text: $engine.cc)
            TextField("Model", text: $engine.model)
        }
    }
}
