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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
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
        
        titleLabel.text = selectedPOI.title
        typeLabel.text = "Nice monument"
        
        descrLabel.text = selectedPOI.description
        descrLabel.numberOfLines = 0;
        
        self.traitCollectionDidChange(self.traitCollection)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            self.view.backgroundColor = .black
        } else {
            self.view.backgroundColor = .white
        }
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
