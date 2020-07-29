//
//  MVVMViewFactory.swift
//  testBinding
//
//  Created by Andrey Soloviov on 30/7/20.
//

import SwiftUI

class MVViewFactory: ObservableObject {
  var store: Store

  init(store: Store) {
    self.store = store
  }
}
