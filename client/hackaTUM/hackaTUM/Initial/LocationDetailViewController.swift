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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goToARButton.tintColor = .white
        goToARButton.backgroundColor = .blue
        goToARButton.layer.cornerRadius = 5
        
        imageView.backgroundColor = .red
        
        descrLabel.text = "djkfidhsf jdsdhs jkfdhsk fjdks jfkdsj fkdjs kfjds kfjk jsdk jfdks jfksdj fkdsj kfjsk jfk jsdkfj kdsjf kdsjk fjdksj fksj kfjds kfjdksjfk jdskj"
        descrLabel.numberOfLines = 0;
    }
}
