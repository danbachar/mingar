//
//  MapViewController.swift
//  hackaTUM
//
//  Created by Łukasz Zalewski on 11/23/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Stored properties
    private var places: [POI] = []
    private let locationManager = CLLocationManager()
    private var currentRadius = 100.0
    private var isFirstLocalization = true
    private var counter = 2
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 0
        locationManager.activityType = .automotiveNavigation
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        self.mapView.isUserInteractionEnabled = false
        self.mapView.isZoomEnabled = false
        self.mapView.isScrollEnabled = false
        self.mapView.isPitchEnabled = false
        self.mapView.isRotateEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell") else {
            log.error("Couldn't dequeue a reusable cell")
            return UITableViewCell()
        }
        cell.textLabel?.text = places[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Instantiate a popover view controller and populate it with data retrieved from the server
        // Anchor the popover to the cell from the table, arrow pointing to the left
        guard let popoverContent = self.storyboard?.instantiateViewController(identifier: "locationDetail") as? LocationDetailViewController else {
            log.error("Failed instantiating a storyboard")
            return
        }
        
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 300, height: 600)
        guard let selectedCell = tableView.cellForRow(at: indexPath) else {
            log.error("Could not retrieve the selected cell")
            return
        }
        popover?.sourceView = selectedCell
        popover?.sourceRect = selectedCell.bounds
        popover?.permittedArrowDirections = .left
        
        self.present(nav, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        log.info("Deselected")
    }
    
    private func updatePlaces() {
        log.info("Fetching the POIs for radius: \(currentRadius)")
        DataHandler.getAllPOI(in: 25000, long: 11.65112, lat: 48.24883).observe(with: {
            switch $0 {
            case let .success(tasks):
                self.places = tasks
                self.redrawMap()
            case let .failure(error):
                log.error(error.localizedDescription)
            }
        })
    }
    
    private func redrawMap() {
        _ = self.places.map { poi in
            log.info("New annotation for poi")
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(poi.lat, poi.long)
            annotation.title = poi.title
            self.mapView.addAnnotation(annotation)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Only called when the app first relocalizes the location
        if isFirstLocalization {
            guard let currentLocation = locations.first?.coordinate else {
                log.error("Could not retrieve current location")
                return
            }
            
            let region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(currentLocation.latitude,
                                                                               currentLocation.longitude),
                                            latitudinalMeters: currentRadius*2,
                                            longitudinalMeters: currentRadius*2);

            // Zoom the map to point to the current region
            mapView.setRegion(region, animated: true)
            // Do not set the region manually after the first localization is completed
            isFirstLocalization = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log.error(error.localizedDescription)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        let span = mapView.region.span
        let center = mapView.region.center

        let loc1 = CLLocation(latitude: center.latitude - span.latitudeDelta * 0.5, longitude: center.longitude)
        let loc2 = CLLocation(latitude: center.latitude + span.latitudeDelta * 0.5, longitude: center.longitude)
        let loc3 = CLLocation(latitude: center.latitude, longitude: center.longitude - span.longitudeDelta * 0.5)
        let loc4 = CLLocation(latitude: center.latitude, longitude: center.longitude + span.longitudeDelta * 0.5)

        // Screen height in meters on map
        let metersInLatitude = loc1.distance(from: loc2)
        // Screen width in meters on map
//        let metersInLongitude = loc3.distance(from: loc4)
        
        let radius = metersInLatitude / 2.0
//        log.info("currentRadius: \(currentRadius), radius: \(radius)")
        if radius / currentRadius > 2.0 {
            // If the new radius is 2 times bigger than the previous one, fetch the data for a bigger area
            self.currentRadius = radius
            if !isFirstLocalization {
                updatePlaces()
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        counter = counter - 1
        // TODO: Change it after fixing the long localization
        if counter == 0 {
            self.mapView.isUserInteractionEnabled = true
            self.mapView.isZoomEnabled = true
            self.mapView.isScrollEnabled = true
            self.mapView.isPitchEnabled = true
            self.mapView.isRotateEnabled = true

            updatePlaces()
            
            self.currentRadius = 100.0
        }
    }
}
