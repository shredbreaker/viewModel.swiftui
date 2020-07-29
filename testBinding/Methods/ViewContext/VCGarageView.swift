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
      
      VStack(alignment: .leading) {
        Text("Update id: \(increasedId())")
        Text("Cars: \(viewContext.numberOfCars)")
        Text("Titles: \(viewContext.titles)")
        Text("Colors: \(viewContext.colors)")
        Text("CC: \(viewContext.engineCCs)")
        Text("Models: \(viewContext.engineModels)")
        Button(action:{
        }) { Text("Add car")}
        
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(viewContext.cars) {
            viewContext.carView($0)
          }
        }.padding(.all, 10)
      }
      
      

      }.padding().font(.footnote)
    }.onAppear() {
      customPrint("SMGarageView Appeared")
    }
  }
}





