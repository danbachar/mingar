//
//  LocationDetailViewController.swift
//  hackaTUM
//
//  Created by Łukasz Zalewski on 11/23/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation
import UIKit

class LocationDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var goToARButton: UIButton!
    @IBOutlet weak var descrLabel: UILabel!
    
    var selectedPOI: POI?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let selectedPOI = selectedPOI else {
            log.error("No POI selected")
            return
        }
        
        goToARButton.tintColor = .white
        goToARButton.backgroundColor = .blue
        goToARButton.layer.cornerRadius = 5
        
        imageView.backgroundColor = .red
        
        descrLabel.text = selectedPOI.description
        descrLabel.numberOfLines = 0;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailAR" {
            guard let nav = segue.destination as? UINavigationController else {
                log.error("ZLE KURWA jest")
                return
            }
            
            guard let dest = nav.viewControllers.first as? ARViewController else {
                log.error("Wrong destination of the segue")
                return
            }
            
            dest.detailedPOI = selectedPOI
            
        }
    }
}
