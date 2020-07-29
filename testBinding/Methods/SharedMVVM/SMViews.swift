//
//  AdoptedMVVM.swift
//  testBinding
//
//  Created by Andrei Solovev on 29/7/20.
//

import SwiftUI

/*
 View should have initial value
 View should be linked to source of truth without keeping local copy
 View should update values through view model
 */

var id = 0
func increasedId() -> Int {
    id += 1
    return id
}
struct SMGarageView: View {
    @EnvironmentObject var viewModel: SMViewModel
    
    init() {
        print("SMGarageView init")
    }
    var body: some View {
        VStack {
            List(viewModel.carIDs) {
                SMCarView(carId: $0)
            }
            
            VStack(alignment: .leading) {
                Text("Update id: \(increasedId())")
                Text("Cars: \(viewModel.numberOfCars)")
                Text("Titles: \(viewModel.titles)")
                Text("Colors: \(viewModel.colors)")
                Text("CC: \(viewModel.engineCCs)")
                Text("Models: \(viewModel.engineModels)")
                Button(action:{
                }) { Text("Add car")}
            }.padding().font(.footnote)
        }.onAppear() {
            print("SMGarageView Appeared")
        }
    }
}

struct SMCarView: View {
    @EnvironmentObject var viewModel: SMViewModel
    let carId: UUID
    
    init(carId: UUID) {
        print("SMCarView init \(carId)")
        self.carId = carId
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Title", text: viewModel.titleForCar(id: carId))
                TextField("Color", text: viewModel.colorForCar(id: carId))
            }
            if let id = viewModel.engineId(for: carId) {
                SMEngineView(engineId: id)
            }
        }.onAppear() {
            print("SMCarView Appeared \(carId)")
        }
    }
}

struct SMEngineView: View {
    @EnvironmentObject var viewModel: SMViewModel
    var engineId: UUID
    
    init(engineId: UUID) {
        print("SMEngineView init \(engineId)")
        self.engineId = engineId
    }
    
    var body: some View {
        HStack {
            TextField("CC", text: viewModel.engineCC(engineId))
            TextField("Model", text: viewModel.engineModel(engineId))
        }.onAppear() {
            print("SMEngineView Appeared \(engineId)")
        }
    }
}

