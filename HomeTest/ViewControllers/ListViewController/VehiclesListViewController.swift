//
//  VehiclesListViewController.swift
//  HomeTest
//
//  Created by Gaurang Patel on 24/07/22.
//

import Foundation
import UIKit
import ProgressHUD

class VehiclesListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var vehicleArray = [Vehicles]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Vehicles List"
        
        ProgressHUD.show("Loading...")
        self.getVehiclesListFromServer()
    }
    
    func getVehiclesListFromServer() {
        
        VehicleServices.shared.callGetListAPI(completion: {jsonDictionary, error in
           
            ProgressHUD.dismiss()
            
            if (error == nil) {
                //API response successful
                if (jsonDictionary != nil) {
                    let poiListObj = jsonDictionary!["poiList"] as? NSArray
                    if (poiListObj != nil && poiListObj!.count > 0) {
                        for index in 0..<poiListObj!.count {
                            let vehicleObj = poiListObj![index] as? NSDictionary
                            let vehicle = Vehicles(json: vehicleObj)
                            self.vehicleArray.append(vehicle)
                        }
                    }
                }

                self.tableView.reloadData()
            }
            else {
                //API has some error
                debugPrint("Error : \(error?.localizedDescription ?? "")")
            }
        })
    }
}

extension VehiclesListViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        cell.selectionStyle = .gray
        cell.accessoryType = .disclosureIndicator
        
        let vehicleObj = vehicleArray[indexPath.row]
        
        cell.lblType.text = vehicleObj.type!
        cell.lblLatitude.text = String(format: "%f", (vehicleObj.latitude)!)
        cell.lblLongitude.text = String(format: "%f", (vehicleObj.longitude)!)
        cell.lblState.text = vehicleObj.state!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "MapStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MapView") as? MapViewController
        vc!.vehicleArray = vehicleArray
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
