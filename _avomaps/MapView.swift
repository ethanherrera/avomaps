//
//  MapView.swift
//  _avomaps
//
//  Created by Ethan Herrera on 3/20/23.
//

import Foundation
import SwiftUI
import GoogleMaps
import Alamofire
import SwiftyJSON

struct MapView: UIViewRepresentable {
    typealias UIViewType = GMSMapView
    
    @Binding var markers: [GMSMarker]
    @Binding var selectedMarker: GMSMarker?
    
    @State var currPolyline: GMSPolyline?
    
    var currentPlace = CustomPlace(title: "Current Location", latitude: 37.87376492136777, longitude: -122.25758337331561, icon: #imageLiteral(resourceName: "CurrentPin.png"), snippet: "Current Location!")
    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: 37.87376492136777, longitude: -122.25758337331561), zoom: 18)
        
        let mapView: GMSMapView = GMSMapView.map(withFrame: .zero, camera: camera)
        
        let startMarker = GMSMarker()
        startMarker.position.latitude = currentPlace.latitude
        startMarker.position.longitude = currentPlace.longitude
        startMarker.title = currentPlace.title
        startMarker.icon = currentPlace.icon
        startMarker.snippet = currentPlace.snippet
        startMarker.map = mapView
        
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        markers.forEach {
            $0.map = uiView
        }
        selectedMarker?.map = uiView
        animateToMarker(map: uiView)
    }
    
    
    private func animateToMarker(map: GMSMapView) {
        guard let newMarker = selectedMarker else {
          return
        }
        
        if map.selectedMarker != newMarker {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                map.selectedMarker = nil
                map.animate(with: GMSCameraUpdate.setTarget(newMarker.position))
                map.animate(toZoom: 15.5)
                map.selectedMarker = newMarker
                drawPath(map: map, destination: newMarker)
            }
        }
    }
    
    private func drawPath(map: GMSMapView, destination: GMSMarker) {
        currPolyline?.map = nil
        
        let origin = "\(currentPlace.latitude),\(currentPlace.longitude)"
        let destination = "\(destination.position.latitude),\(destination.position.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=walking&key=AIzaSyAcRO_jLRE7ylqD1YllL0tNszyoEiMDMO4"
        
        print(url)
        
        AF.request(url).responseJSON { response in
            
            print(response.result as Any)   // result of response serialization
            if let json = try? JSON(data: response.data!){
                let routes = json["routes"].arrayValue
                let routeOverviewPolyline = routes[0]["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = UIColor.green
                polyline.map = map
                currPolyline = polyline
            }
        }
    }
}

