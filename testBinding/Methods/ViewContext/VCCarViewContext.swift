//
//  VCCarViewContext.swift
//  testBinding
//
//  Created by Andrey Soloviov on 30/7/20.
//

import SwiftUI

protocol VCCarViewModelProtocol: class {
  var carId: UUID { get }
  var viewContext: VCCarView.ViewContext? { get set }
}


extension VCCarView {
  class ViewContext: ObservableObject {
    var viewModel: VCCarViewModelProtocol? {
      didSet {
        viewModel?.viewContext = self
      }
    }
    
    var title: Binding<String> =
      Binding<String>(
        get: { "1" },
        set: { _ in }
      )
    
    var color: Binding<String> =
      Binding<String>(
        get: { "1" },
        set: { _ in }
      )
  }
  
}
