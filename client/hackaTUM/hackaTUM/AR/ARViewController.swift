//
//  ARViewController.swift
//  hackaTUM
//
//  Created by Łukasz Zalewski on 11/23/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import ARCoreLocation
import CoreLocation
import SpriteKit
import ARKit

class ARViewController: UIViewController {
    // MARK: - Dependencies
    var landmarker: ARLandmarker!
    var detailedPOI: POI?
    
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the ARLandmarker
        self.landmarker = ARLandmarker(view: ARSKView(),
                                       scene: InteractiveScene(),
                                       locationManager: CLLocationManager())
        
        // Configure Landmarker
        landmarker.delegate = self
        landmarker.maximumVisibleDistance = 200 // Only show landmarks within 200m from user.
        
        // The landmarker can scale views so that closer ones appear larger than further ones. This scaling is linear
        // from 0 to `maxViewScaleDistance`.
        // For example, with `minViewScale` at `0.5` and `maxViewScaleDistance` at `1000`, a landmark 500 meters away
        // appears at a scale of `0.75`. A landmark 1000 meters or more away appears at a scale of `0.5`. A landmark
        // 0 meters away appears full scale (`1.0`).
        landmarker.minViewScale = 0.5 // Shrink distant landmark views to half size
        landmarker.maxViewScaleDistance = 75 // Show landmarks 75m or further at the smallest size
        
        landmarker.worldRecenteringThreshold = 30 // Recalculate the landmarks whenever the user moves 30 meters.
        landmarker.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation // You'll usually want the best accuracy you can get.
        
        // Show all the landmarks, even when they are overlapping. Another common option is to show just the nearest
        // ones (`.showNearest`). If landmark views overlap, `.showNearest` will hide the landmarks that are further
        // away.
        landmarker.overlappingLandmarksStrategy = .showAll
//        landmarker.beginEvaluatingOverlappingLandmarks(atInterval: 1.0) // Set how often to check for overlapping landmarks.
        
        view.addSubview(landmarker.view)
        
        // Add all the necessary landmarks
        placeLandmarks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        landmarker.view.frame = view.bounds
        landmarker.scene.size = view.bounds.size
    }
    
    private func placeLandmarks() {
        log.info("Placing all the landmarks")
        // Retrieve the current location, to get the altitude for every point
        guard let location = landmarker.locationManager.location else {
            log.error("Couldn't retrieve the current location")
            return
        }

        guard let image = UIImage(named: "placeholder") else {
            log.error("Error while loading placeholder image")
            return
        }
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        label.backgroundColor = .white
        label.layer.cornerRadius = 20
        label.layer.borderColor = UIColor.cyan.cgColor
        label.layer.borderWidth = 10
        label.text = "Placeholder"
        label.textAlignment = .center
        label.textColor = .black
        label.layer.masksToBounds = true
        
        // If we want to display a detail POI, make other landmarks less visible by applying some translucent effects on them
        if detailedPOI == nil {
            _ = DataHandler.places.map({ poi in
                let cllocation = CLLocation(coordinate: CLLocationCoordinate2DMake(poi.lat, poi.long),
                                            altitude: location.altitude,
                                            horizontalAccuracy: location.horizontalAccuracy,
                                            verticalAccuracy: location.verticalAccuracy,
                                            timestamp: location.timestamp)
                
//                guard let image = UIImage(named: "placeholder") else {
//                    log.error("Error while loading placeholder image")
//                    return
//                }
//                landmarker.addLandmark(image: image, at: cllocation, completion: nil)
                label.text = poi.title
                landmarker.addLandmark(view: label, at: cllocation, completion: nil)
            })
        } else {
            guard let detailedPOI = detailedPOI else {
                log.error("You suck")
                return
            }
            _ = DataHandler.places.map({ poi in
                let cllocation = CLLocation(coordinate: CLLocationCoordinate2DMake(poi.lat, poi.long),
                                            altitude: location.altitude,
                                            horizontalAccuracy: location.horizontalAccuracy,
                                            verticalAccuracy: location.verticalAccuracy,
                                            timestamp: location.timestamp)
                
//                guard let image = UIImage(named: "placeholder") else {
//                    log.error("Error while loading placeholder image")
//                    return
//                }
//
//                let imageView = UIImageView(image: image)
//                if poi.id != detailedPOI.id {
//                    imageView.alpha = 0.3
//                }
                
                if poi.id != detailedPOI.id {
                    label.alpha = 0.3
                }
                label.text = poi.title
//                landmarker.addLandmark(view: imageView, at: cllocation, completion: nil)
                landmarker.addLandmark(view: label, at: cllocation, completion: nil)
            })
        }
        
        
        
        //        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        //        label.translatesAutoresizingMaskIntoConstraints = false
        //        view.translatesAutoresizingMaskIntoConstraints = false
        //        label.text = "Some location"
        //        label.textColor = .green
        //        label.font = UIFont(name: "TrebuchetMS-Bold", size: 18)
        //
        //        let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        //        view.backgroundColor = .white
        //        view.layer.borderColor = UIColor.black.cgColor
        //        view.layer.borderWidth = 2
        //        view.layer.cornerRadius = 15
        //
        //        view.addSubview(label)
        //
        //        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func format(distance: CLLocationDistance) -> String {
        return String(format: "%.2f km away", distance / 1000)
    }
}

extension ARViewController: ARLandmarkerDelegate {
    func landmarkDisplayer(_ landmarkDisplayer: ARLandmarker, didTap landmark: ARLandmark) {
        log.info(landmark.image)
        log.info("Tapped a landmark")
        guard let placeholder = UIImage(named: "placeholder") else {
            return
        }
        
    }
    
    func landmarkDisplayer(_ landmarkDisplayer: ARLandmarker, willUpdate landmark: ARLandmark, for location: CLLocation) -> UIView? {
//        guard let model = landmark.model else {
//            return nil
//        }
//        let markView = reusableMarker
//        markView.set(name: model.name, detail: format(distance: location.distance(from: landmark.location)))
//
//        return markView
        return nil
    }
    
    func landmarkDisplayer(_ landmarkDisplayer: ARLandmarker, didFailWithError error: Error) {
        print("Failed! Error: \(error)")
    }
}
