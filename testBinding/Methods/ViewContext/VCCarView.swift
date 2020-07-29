//
//  VCCarView.swift
//  testBinding
//
//  Created by Andrey Soloviov on 29/7/20.
//

import SwiftUI

struct VCCarView: View {
  @ObservedObject var viewContext: ViewContext

  var body: some View {
    VStack {
      HStack {
        TextField("Title", text: viewContext.title)
        TextField("Color", text: viewContext.color)
      }
      
//      if let id = viewModel.engineId(for: carId) {
//        SMEngineView(engineId: id)
//      }
    }.onAppear() {
      customPrint("SMCarView Appeared")
    }
  }
}
