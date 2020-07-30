//
//  MVGarageView.swift
//  testBinding
//
//  Created by Andrey Soloviov on 30/7/20.
//

import SwiftUI

extension MVViewFactory {
  func garageView() -> some View {
    let viewModel = MVGarageView.ViewModel(store: store)
    return MVGarageView(viewModel: viewModel)
  }
}

struct MVGarageView: View {
  @ObservedObject var viewModel: ViewModel
    
  var body: some View {
    VStack {
      
      VStack(alignment: .leading) {
        Text("Update id: \(increasedId())")
        Text("Cars: \(viewModel.numberOfCars)")
        Text("Titles: \(viewModel.titles)")
        Text("Colors: \(viewModel.colors)")
        Text("CC: \(viewModel.engineCCs)")
        Text("Models: \(viewModel.engineModels)")
        Button(action:{
        }) { Text("Add car")}
        
        ScrollView {
          LazyVStack(alignment: .leading) {
            ForEach(viewModel.cars) {
              mvViewFactory.carView(carId: $0)
            }
          }.padding(.all, 10)
        }
        
        
        
      }.padding().font(.footnote)
    }.onAppear() {
      customPrint("SMGarageView Appeared")
    }
  }
}
