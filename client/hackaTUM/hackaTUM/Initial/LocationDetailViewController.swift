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

////
////  LocationDetailViewController.swift
////  hackaTUM
////
////  Created by Łukasz Zalewski on 11/23/19.
////  Copyright © 2019 TUM. All rights reserved.
////
//
//import Foundation
//import UIKit
//import MapKit
//
//struct Response: Decodable {
//    let pois: [POI]
//
//}
//

//
//
//class LocationDetailViewController: UIViewController {
////    @IBOutlet weak var imageView: UIImageView!
////    @IBOutlet weak var titleLabel: UILabel!
////    @IBOutlet weak var typeLabel: UILabel!
////    @IBOutlet weak var rankingLabel: UILabel!
////    @IBOutlet weak var textViewView: UIView!
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
////        let textView = UITextView(frame: CGRect(x: 0.0, y: 0.0, width: 250.0, height: 100.0))
////
////        textView.center = self.view.center
////        textView.textAlignment = NSTextAlignment.justified
////
////        // Update UITextView font size and colour
////        textView.font = UIFont.systemFont(ofSize: 16)
////
////        // Make UITextView web links clickable
////        textView.isSelectable = false
////        textView.isEditable = false
////        textView.dataDetectorTypes = UIDataDetectorTypes.link
////
////        textView.text = "dsofjdsiu fiuzsd jfsj k dsofjdsiu fiuzsd jfsj k dsofjdsiu fiuzsd jfsj k dsofjdsiu fiuzsd jfsj k dsofjdsiu fiuzsd jfsj k dsofjdsiu fiuzsd jfsj k dsofjdsiu fiuzsd jfsj k dsofjdsiu fiuzsd jfsj k dsofjdsiu fiuzsd jfsj k dsofjdsiu fiuzsd jfsj k "
////        self.view.addSubview(textView)
////        /////////
////        var titlee = ""
////
//////        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {return}
//////        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//////        guard let dataResponse = data,
//////                  error == nil else {
//////                  print(error?.localizedDescription ?? "Response Error")
//////                  return }
//////            do {
//////                //here dataResponse received from a network request
//////                let jsonResponse = try JSONSerialization.jsonObject(with:
//////                                       dataResponse, options: [])
//////                guard let jsonArray = jsonResponse as? [[String: Any]] else {
//////                      return
//////                }
//////                print(jsonArray)
//////                //Now get title value
//////                guard let title = jsonArray[0]["title"] as? String else { return }
//////                titlee = title
//////                print(title)
//////             } catch let parsingError {
//////                print("Error", parsingError)
//////           }
//////        }
//////        task.resume()
////
////        print(titlee)
////        titleLabel.text = titlee
//    }
//}
