//
//  ContentView.swift
//  _avomaps
//
//  Created by Ethan Herrera on 3/20/23.
//

import SwiftUI
import GoogleMaps

struct ContentView: View {
    static let places = [
        CustomPlace(title: "MLK!", latitude: 37.86948203356192, longitude: -122.2596941602408, icon: #imageLiteral(resourceName: "avoMarker.png"), snippet: "The go to hang out spot for our Codeology members. You will find at least a few of our members mobbing at this location studying or messing around until their next class period."),
        CustomPlace(title: "The Standard", latitude: 37.86887960102724, longitude: -122.25734184447978, icon: #imageLiteral(resourceName: "avoMarker.png"), snippet: "This apartment complex is home to a few of our lovely Codeology members (Eric I love you). You will find that some of our many socials are held here."),
        CustomPlace(title: "Sproul Plaza", latitude: 37.869219109652676, longitude: -122.25924628580795, icon: #imageLiteral(resourceName: "avoMarker.png"), snippet: "During recruitment season, it is quite common to find our cult-like members at a table, bothering the introverted Berkeley student body, talking about applying for a certain club. Interested in Avocados and tech?"),
        CustomPlace(title: "The Glade", latitude: 37.87326638527397, longitude: -122.25943018035494, icon: #imageLiteral(resourceName: "avoMarker.png"), snippet: "The glade serves as a tabling location, where our members run around in an avocado suit recruiting the next newbology. We also hold socials here if the weather allows. Football, American Football, Spikeball, and so many more fun activities have been hosted at this location.")
    ]
    
    @State var markers: [GMSMarker] =
    places.map {
        let marker = GMSMarker()
        marker.position.latitude = $0.latitude
        marker.position.longitude = $0.longitude
        marker.title = $0.title
        marker.icon = $0.icon
        marker.snippet = $0.snippet
        return marker
    }
    @State var selectedMarker: GMSMarker?
    @State var zoomInCenter: Bool = false
    @State var expandList: Bool = false
    @State var yDragTranslation: CGFloat = 0
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                // Map
                MapView(markers: $markers, selectedMarker: $selectedMarker)
                
                let scrollViewHeight: CGFloat = 80
                
                CustomPlacesList(markers: $markers) { (marker) in
                  guard self.selectedMarker != marker else { return }
                  self.selectedMarker = marker
                  self.zoomInCenter = false
                  self.expandList = false
                }  handleAction: {
                  self.expandList.toggle()
                }.background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .offset(
                  x: 0,
                  y: geometry.size.height - (expandList ? scrollViewHeight + 150 : scrollViewHeight)
                )
                .offset(x: 0, y: self.yDragTranslation)
                .animation(.spring())
                .gesture(
                  DragGesture().onChanged { value in
                    self.yDragTranslation = value.translation.height
                  }.onEnded { value in
                    self.expandList = (value.translation.height < -120)
                    self.yDragTranslation = 0
                  }
                )
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
