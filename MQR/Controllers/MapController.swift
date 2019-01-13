//
//  ViewController.swift
//  MQR
//
//  Created by Nuri Chun on 9/30/18.
//  Copyright © 2018 tetra. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// ********************************************************************************************************
                                    // **************README**************

// OBVIOUSLY IM STILL FAIRLY NEW TO ALL THIS SO THERE ARE A LOT OF THINGS TO CHANGE. ALSO... LOTS OF THE TIMES MY METHOD OF SETTING UP SOME THINGS (CONTROLLERS, DELEGATES, VIEWS) ARE QUESTIONABLE FOR SURE.

// NOTE (1): MapController.swift is the main controller that presents the MKMapView and holds the instance of MasterSearchResultsController.swift
// which gives access to its containerView, the bottom sheet.

// NOTE (2): There are controllers within controllers in descending order => (1) MapController.swift => MasterSearchResultsController.swift => SearchResultsController.swift

// NOTE (3): MapController.swift holds all controllers together as well as the views.

// NOTE (4): MasterSearchResultsController.swift is the sheet or containerView that pans or transitions between botY, midY, or topY.

// NOTE (5): SearchResultsController.swift has the UITableView and UISearchBar; this controller holds all the UI's delegates.

// NOTE (6): SO IN SHORT. MapController is the glue that holds all things together. MasterSearchResultsController adds functionality or movement to the sheet as well as have the tableView added.
// And SearchResultsController does most of the UI for the sheet/containerView as well as add some of it's basic UI's functionalities/delegates.

// THIS IS FAR FROM COMPLETE AND I WILL DEFINITELY ADD MORE STUFF. I JUST NEED A JOB FAM SO IM JUST POSTING THIS TO SHOW.

                                    // **************END OF README**************
// ********************************************************************************************************

class MapController: UIViewController {
    
    let application = UIApplication.shared
    
    // views
    let dismissHudView = DismissHudView()
    let mileageView = MileageView()
    
    // controllers
    let searchResultsController = SearchResultsController()
    var masterSearchResultsController: MasterSearchResultsController!
    
    var activityIndicatorView = UIActivityIndicatorView()

    let locationManager = CLLocationManager()
    var location: String = ""
    
    private var isPanningThroughMap: Bool = false
    
    var mapView: MKMapView = {
        let mv = MKMapView()
        mv.mapType = .standard
        mv.isZoomEnabled = true
        mv.alpha = 0.75
        return mv
    }()
    
    override var prefersStatusBarHidden: Bool { return false }
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        hideKeyboardWhenTapped()
        setupUI()
        setupDismissHudViewDelegate()
        checkIfLocationServicesEnabled()
    }
    
    // MARK: - viewDidLayoutSubviews()
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        setupMapResultsController()
    }
    
    private func setupMapResultsController() {
        
        if self.masterSearchResultsController != nil { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let resultsController = storyboard.instantiateViewController(withIdentifier: "mapResultsController") as? MasterSearchResultsController
        {
            self.masterSearchResultsController = resultsController
            self.masterSearchResultsController.delegate = self
            self.masterSearchResultsController.view.bounds = self.view.bounds
            self.masterSearchResultsController.view.layer.cornerRadius = 20
            self.masterSearchResultsController.view.clipsToBounds = true
            addChildController()
        }
    }
    
    private func setupUI() {
        mapView.frame = view.frame
        view.addSubview(mapView)
        
        let bottomPadding: CGFloat = view.frame.height / 8
        
        self.mapView.addSubview(mileageView)
        mileageView.anchor(top: nil, left: nil, bottom: mapView.bottomAnchor, right: nil, topPad: 0, leftPad: 0, bottomPad: bottomPadding, rightPad: 0, width: 200, height: 0)
//        mileageView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor).isActive = true
        mileageView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor).isActive = true
        mileageView.alpha = 0.0
        
        self.mapView.addSubview(dismissHudView)
        dismissHudView.centerXAnchor.constraint(equalTo: self.mapView.centerXAnchor).isActive = true
        dismissHudView.anchor(top: nil, left: nil, bottom: mileageView.topAnchor, right: nil, topPad: 0, leftPad: 0, bottomPad: 10, rightPad: 0, width: 100, height: 0)
        
        let panView: UIPanGestureRecognizer = UIPanGestureRecognizer (target: self, action: #selector(handleMapPan))
        self.mapView.addGestureRecognizer(panView)
    }
    
    @objc private func handleMapPan(panRecognizer: UIPanGestureRecognizer) {
        if panRecognizer.state == .changed || panRecognizer.state == .began {
            locationManager.stopUpdatingLocation()
        }
    }
    
    private func addChildController() {
        //        print("view.bounds.height topY: \(view.bounds.height * 0.5 )")
        //        print("view.bounds.height midY: \(view.bounds.height * 1.1 )")
        //        print("view.bounds.height botY: \(view.bounds.height * 1.39 )")
        self.masterSearchResultsController.view.center = CGPoint(x: self.masterSearchResultsController.view.center.x, y: self.view.bounds.height * 1.1)
        add(masterSearchResultsController, containerView: nil)
    }
    
    private func checkIfLocationServicesEnabled() {
        
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManagerDelegate()
            checkAuthorizationStatus()
        } else {
            // Insert an alert here.
            print("Please enable current location through settings.")
        }
    }
    
    private func setupLocationManagerDelegate() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    private func checkAuthorizationStatus() {
        
        switch CLLocationManager.authorizationStatus()  {
            
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerUsersCurrentLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            break
        }
    }
    
    let meters: Double = 1000
    
    private func centerUsersCurrentLocation() {
        if let center = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: center, latitudinalMeters: meters, longitudinalMeters: meters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    var currentLocation: CLLocation?
    var destination: CLLocation?
    var distanceInMiles: Double = 0.0
    
    private func calculateDistance(toDestination destination: CLLocation ) {
        
        let meterPerMile = 0.000621
        
        self.destination = destination
        print("CURRENT: \(currentLocation ?? CLLocation())")
        print("DESTINATION: \(destination)")
        if let distanceInMeters = currentLocation?.distance(from: destination) {
            let miles = distanceInMeters * meterPerMile
            self.distanceInMiles = miles
            print("MILES: \(miles)")
        }
    }
    
    var hasFoundLocation: Bool = false
    
    // This is with animation
    private func showMileage(ifLocationFound locationFound: Bool) {
        
        if locationFound {
            UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveEaseOut, animations: {
                self.mileageView.alpha = 1.0
                self.dismissHudView.alpha = 1.0
                let roundedMileage = String(format: "%.2f", self.distanceInMiles)
                self.mileageView.mileageLabel.text = "\(roundedMileage) mi away"
            }, completion: nil)
        } else {
         // if location has not been found yet then hide and disable view.
            UIView.animate(withDuration: 0.7, delay: 0.0 , options: .curveEaseIn, animations: {
                self.mileageView.alpha = 0.0
                self.dismissHudView.alpha = 0.0
            }, completion: nil)
        }
    }
    
    private func setupDismissHudViewDelegate() {
        dismissHudView.delegate = self
    }
}

// MARK: - MasterSearchResultsDelegate

extension MapController: MasterSearchResultsDelegate {
    
    func updateMapResults(frame: CGRect) {
        DispatchQueue.main.async {
        }
    }
    
    func updateContainersCenter(cgPoint: CGPoint) {
        self.masterSearchResultsController.view.center = cgPoint
        add(masterSearchResultsController, containerView: nil)
    }
    
    func updateMapView(withAlpha alpha: CGFloat) { mapView.alpha = alpha }
    
    func startActivityIndicator() {
        let activityIndicatorViewStyle = UIActivityIndicatorView.Style.white
        let activityIndicatorView = UIActivityIndicatorView(style: activityIndicatorViewStyle)
        
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = .blue
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        self.mapView.addSubview(activityIndicatorView)
        self.activityIndicatorView = activityIndicatorView
    }
    
    func searchFor(selectedRow location: String?) {
        if let location = location {
            startActivityIndicator()
            SearchRequestMananger.shared.startSearchRequest(forLocation: location, withMapView: self.mapView, withIndicatorView: activityIndicatorView) { destination in
                if let destination = destination {
                    self.calculateDistance(toDestination: destination)
                    self.hasFoundLocation = true
                    self.showMileage(ifLocationFound: self.hasFoundLocation)
                    self.locationManager.stopUpdatingLocation()
                }
            }
        }
    }
    
    func searchResult(withSearchBar text: String?) {
        startActivityIndicator()
        SearchRequestMananger.shared.startSearchRequest(forLocation: text, withMapView: self.mapView, withIndicatorView: activityIndicatorView)
        { destination in
            if let destination = destination {
                self.calculateDistance(toDestination: destination)
                self.hasFoundLocation = true
                self.showMileage(ifLocationFound: self.hasFoundLocation)
                self.locationManager.stopUpdatingLocation()
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension MapController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // This is current location of users.
        guard let updatedLocation = locations.last else { return }
        currentLocation = updatedLocation
        
        let lat = updatedLocation.coordinate.latitude
        let long = updatedLocation.coordinate.longitude
        
        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: meters, longitudinalMeters: meters)
        
        mapView.setRegion(region, animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorizationStatus()
    }
}

// MARK: - MKMapViewDelegate

extension MapController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - DismissHudViewDelegate

extension MapController: DismissHudViewDelegate {
    
    func dismissTapped() {
        print("dismiss")
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveEaseOut, animations: {
            self.dismissHudView.alpha = 0.0
            self.mileageView.alpha = 0.0
        }, completion: nil)
    }
}




























