//
//  UserViewController.swift
//  hackaTUM
//
//  Created by Artem Evdokimov on 23.11.19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import QuartzCore

class CollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}

class UserViewController: UIViewController, UICollectionViewDataSource {
    
    let reuseIdentifier = "collectionViewCellId"
    
    @IBOutlet weak var placesVisited: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var labelTable: UILabel!
    @IBOutlet weak var profileBg: UIImageView!
    @IBOutlet weak var profileFg: UIImageView!
    @IBOutlet weak var bgggLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileBg.addBlurEffect()
        profileFg.layer.borderWidth = 3
        profileFg.layer.masksToBounds = false
        profileFg.layer.borderColor = UIColor.white.cgColor
        profileFg.layer.cornerRadius = profileFg.frame.height/2
        profileFg.clipsToBounds = true
        
        self.tableView.layer.masksToBounds = true
        self.tableView.layer.borderColor = UIColor.white.cgColor
        self.tableView.layer.borderWidth = 3;
        self.tableView.layer.cornerRadius = 5;
        self.tableView.layer.shadowColor = UIColor.black.cgColor
        self.tableView.layer.shadowOpacity = 1
        self.tableView.layer.shadowOffset = .zero
        self.tableView.layer.shadowRadius = 10
        
        userNameLabel.layer.masksToBounds = true
        userNameLabel.layer.cornerRadius = 5
        
        self.collectionView.layer.borderColor = UIColor.white.cgColor
        self.collectionView.layer.borderWidth = 3;
        self.collectionView.layer.cornerRadius = 5;
        
        bgggLabel.dropShadow()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.placesVisited.text = "PlacesVisited: \(DataHandler.arrDays.count)"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UserViewController: UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataHandler.achivements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        cell.imageView.image = UIImage(named: DataHandler.achivements[indexPath.row])
        
        return cell
    }
}


extension UserViewController: UITableViewDelegate,UITableViewDataSource{
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataHandler.arrDays.count + 1
    }

    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // create a new cell if needed or reuse an old one
        let cellReuseIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

        // set the text from the data model
        if (indexPath.row >= DataHandler.arrDays.count) {
            cell.textLabel?.text = ""
        } else {
            cell.textLabel?.text = DataHandler.arrDays[indexPath.row]
        }

        return cell
    }

    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        let text = cell?.textLabel?.text
        UserDefaults.standard.set(text, forKey: "currentWorldMap")
        print("You tapped cell number \(indexPath.row).")
        NotificationCenter.default.post(name: Notification.Name("loadWorldMap"), object: nil)
    }
}

extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
    
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
    
        self.addSubview(blurEffectView)
    }
}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 8

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
//        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
