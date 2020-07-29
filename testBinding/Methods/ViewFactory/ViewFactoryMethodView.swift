//
//  ViewFactoryMethod.swift
//  testBinding
//
//  Created by Andrey Soloviov on 30/7/20.
//

import SwiftUI

struct ViewFactoryMethodView: View {
  @StateObject var viewFactory = VFViewFactory()
  
  var body: some View {
    VStack {
      viewFactory.garage(store: AppState.shared.store)
    }.environmentObject(viewFactory)
  }
}
