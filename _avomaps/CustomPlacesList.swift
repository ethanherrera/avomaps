//
//  CustomPlacesList.swift
//  new_avomaps
//
//  Created by Ethan Herrera on 3/20/23.
//

import SwiftUI
import GoogleMaps

struct CustomPlacesList: View {
      @Binding var markers: [GMSMarker]
      var buttonAction: (GMSMarker) -> Void
      var handleAction: () -> Void

      var body: some View {
        GeometryReader { geometry in
          VStack(spacing: 0) {
            // List Handle
            HStack(alignment: .center) {
              Rectangle()
                .frame(width: 25, height: 4, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .cornerRadius(10)
                .opacity(0.25)
                .padding(.vertical, 8)
            }
            .frame(width: geometry.size.width, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .onTapGesture {
              handleAction()
            }

            // List of Places
            List {
                ForEach(0..<self.markers.count) { id in
                  let marker = self.markers[id]
                  Button(action: {
                    buttonAction(marker)
                  }) {
                    Text(marker.title ?? "")
                  }
                }
            }.frame(maxWidth: .infinity)
          }
        }
      }
}
