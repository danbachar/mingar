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
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    
    // MARK: - Stored properties
    private let locationManager = CLLocationManager()
    private var currentRadius = 100.0
    private var isFirstLocalization = true
    private var counter = 2
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.isHidden = true
        visualEffect.alpha = 0.0
        mapView.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 0
        locationManager.activityType = .fitness
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
        return DataHandler.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell") else {
            log.error("Couldn't dequeue a reusable cell")
            return UITableViewCell()
        }
        cell.textLabel?.text = DataHandler.places[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Instantiate a popover view controller and populate it with data retrieved from the server
        // Anchor the popover to the cell from the table, arrow pointing to the left
        guard let popoverContent = self.storyboard?.instantiateViewController(identifier: "locationDetail") as? LocationDetailViewController else {
            log.error("Failed instantiating a storyboard")
            return
        }
        
        // Pass the selected POI to detail view controller
        popoverContent.selectedPOI = DataHandler.places[indexPath.row]
        
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Places close to you"
        } else {
            return ""
        }
    }
    
    private func updatePlaces() {
        log.info("Fetching the POIs for radius: \(currentRadius)")
        
        // Get the latest location
        guard let location = locationManager.location else {
            log.error("no coordinate found")
            return
        }
        
        DataHandler.getAllPOI(in: currentRadius, long: location.coordinate.longitude, lat: location.coordinate.latitude).observe(with: {
            switch $0 {
            case let .success(tasks):
                DataHandler.places = tasks
                self.redrawMap()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case let .failure(error):
                log.error(error.localizedDescription)
            }
        })
    }
    
    private func redrawMap() {
        _ = DataHandler.places.map { poi in
//            log.info("New annotation for poi")
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
                                            latitudinalMeters: currentRadius * 2.0,
                                            longitudinalMeters: currentRadius * 2.0);

            // Zoom the map to point to the current region
            mapView.setRegion(region, animated: true)
            // Show the tableView
            UIView.animate(withDuration: 1.0) {
                self.visualEffect.alpha = 1.0
            }
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

        // Screen height in meters on map
        let metersInLatitude = loc1.distance(from: loc2)
        
        // Get the new radius
        let radius = metersInLatitude / 2.0

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
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let title = view.annotation?.title else {
            return
        }
        
        guard let index = (DataHandler.places.firstIndex(where: { poi in
            poi.title == title
        })) else {
            return
        }
        
        let indexPath = IndexPath(item: index, section: 0)
        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        
        guard let coordinate = view.annotation?.coordinate else {
            return
        }
        
        mapView.setCenter(coordinate, animated: true)
        
        tableView(self.tableView, didSelectRowAt: indexPath)
    }
}
