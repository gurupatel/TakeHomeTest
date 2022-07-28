//
//  MapViewController.swift
//  HomeTest
//
//  Created by Gaurang Patel on 24/07/22.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController
{
    var vehicleArray = [Vehicles]()
    var annotations = [MKAnnotation]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Map View"
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        self.addAnnotationOnMap()
    }
    
    func addAnnotationOnMap() {
        for vehicleObj in vehicleArray {
            let annotation = MKPointAnnotation()
            annotation.title = ""
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(vehicleObj.latitude!), longitude: Double(vehicleObj.longitude!))
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
        
        if let lastAnnotation = annotations.last {
            let region = MKCoordinateRegion(center: lastAnnotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
        }
        
        let overlay = MKPolygon(coordinates: self.getCordinatesOfRectAnnotations(annotationsArray: self.mapView.annotations), count: self.getCordinatesOfRectAnnotations(annotationsArray: self.mapView.annotations).count)
        self.mapView.addOverlay(overlay)
    }
    
    func getCordinatesOfRectAnnotations(annotationsArray:[MKAnnotation]) ->[CLLocationCoordinate2D]{
        let minX : Double = annotationsArray.map({MKMapPoint($0.coordinate).x}).min()!
        let minY : Double = annotationsArray.map({MKMapPoint($0.coordinate).y}).min()!
        let maxX : Double = annotationsArray.map({MKMapPoint($0.coordinate).x}).max()!
        let maxY : Double = annotationsArray.map({MKMapPoint($0.coordinate).y}).max()!
        
        var result : [CLLocationCoordinate2D] = []
        result.append(MKMapPoint(x: minX, y: minY).coordinate)
        result.append(MKMapPoint(x: maxX, y: minY).coordinate)
        result.append(MKMapPoint(x: maxX, y: maxY).coordinate)
        result.append(MKMapPoint(x: minX, y: maxY).coordinate)
        return result
    }
}

extension MapViewController : MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolygonRenderer(overlay: overlay)
        renderer.lineWidth = 1
        renderer.strokeColor = UIColor.red
        return renderer
    }
    
    // Called when the annotation was added
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.animatesDrop = true
            
            let rightButton: AnyObject! = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = rightButton as? UIView
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
}
