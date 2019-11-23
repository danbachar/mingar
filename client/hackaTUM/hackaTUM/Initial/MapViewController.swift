//
//  MapViewController.swift
//  hackaTUM
//
//  Created by Łukasz Zalewski on 11/23/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation
import UIKit

class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    private let places = ["Marienplatz", "Karlsplatz", "Alpspitze"]
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
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
        cell.textLabel?.text = places[indexPath.row]
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
//        popover?.delegate = self
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
}


////
////  MapViewController.swift
////  hackaTUM
////
////  Created by Łukasz Zalewski on 11/23/19.
////  Copyright © 2019 TUM. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    // MARK: - IBOutlets
//    @IBOutlet private weak var tableView: UITableView!
//
//    private let places = ["Marienplatz", "Karlsplatz", "Alpspitze"]
//
//    // MARK: - Lifecycle methods
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.dataSource = self
//        tableView.delegate = self
//    }
//
//    // MARK: - UITableViewDataSource methods
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return places.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell") else {
//            log.error("Couldn't dequeue a reusable cell")
//            return UITableViewCell()
//        }
//        cell.textLabel?.text = places[indexPath.row]
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // Instantiate a popover view controller and populate it with data retrieved from the server
//        // Anchor the popover to the cell from the table, arrow pointing to the left
//        guard let popoverContent = self.storyboard?.instantiateViewController(identifier: "locationDetail") as? LocationDetailViewController else {
//            log.error("Failed instantiating a storyboard")
//            return
//        }
//
//        let nav = UINavigationController(rootViewController: popoverContent)
//        nav.modalPresentationStyle = .popover
//        let popover = nav.popoverPresentationController
//        popoverContent.preferredContentSize = CGSize(width: 300, height: 600)
////        popover?.delegate = self
//        guard let selectedCell = tableView.cellForRow(at: indexPath) else {
//            log.error("Could not retrieve the selected cell")
//            return
//        }
//        popover?.sourceView = selectedCell
//        popover?.sourceRect = selectedCell.bounds
//        popover?.permittedArrowDirections = .left
//
//        self.present(nav, animated: true, completion: nil)
//    }
//
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        log.info("Deselected")
//    }
//}
//
