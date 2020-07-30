//
//  MVCardView.swift
//  testBinding
//
//  Created by Andrey Soloviov on 30/7/20.
//

import SwiftUI

extension MVViewFactory {
  func carView(carId: UUID) -> some View {
    let viewModel = MVCardView.ViewModel(carId: carId, store: store)
    return MVCardView(viewModel: viewModel)
  }
}

struct MVCardView: View {
  @ObservedObject var viewModel: ViewModel
//  @EnvironmentObject var viewFactory: MVViewFactory

  var body: some View {
    VStack {
      HStack {
        TextField("Title", text: viewModel.title)
        TextField("Color", text: viewModel.color)
      }.onAppear() {
        customPrint("SMCarView Appeared")
      }
      
      //      if let id = viewModel.engineId(for: carId) {
      //        SMEngineView(engineId: id)
      //      }
    }
  }
}
