//
//  SearchRequestManager.swift
//  MQR
//
//  Created by Nuri Chun on 1/6/19.
//  Copyright © 2019 tetra. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class SearchRequestMananger {
    
    static let shared = SearchRequestMananger()
    
    let application = UIApplication.shared
    
    func startSearchRequest(forLocation location: String?, withMapView mapView: MKMapView, withIndicatorView activityIndicatorView : UIActivityIndicatorView, completion: @escaping (_ destination: CLLocation?) -> Void) {
        
        if let location = location {
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = location
            
            let localSearch = MKLocalSearch(request: searchRequest)
            localSearch.start { (response, err) in
                
                activityIndicatorView.stopAnimating()
                activityIndicatorView.hidesWhenStopped = true
                self.application.endIgnoringInteractionEvents()
                
                if let err = err { print("Error: \(err.localizedDescription)") }
                
                if let response = response {
                    
                    // Passing the response?
                    let latitude = response.boundingRegion.center.latitude
                    let longitude = response.boundingRegion.center.longitude
                    
                    let destination: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
                    
                    let annotations = mapView.annotations
                    mapView.removeAnnotations(annotations)
                    
                    let pointAnnotation = MKPointAnnotation()
                    pointAnnotation.title = location
                    
                    let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    pointAnnotation.coordinate = center
                    mapView.addAnnotation(pointAnnotation)
                    
                    // lower delta value = higher zoom
                    // higher delta value = lower zoom
                    
                    let constantDelta = 0.05
                    let span = MKCoordinateSpan(latitudeDelta: constantDelta, longitudeDelta: constantDelta)
                    let region = MKCoordinateRegion(center: center, span: span)
                    
                    DispatchQueue.main.async {
                        completion(destination)
                        mapView.setRegion(region, animated: true)
                        
                    }
                    
                } else { print("No Result Found...") }
            }
        }
    }

}




