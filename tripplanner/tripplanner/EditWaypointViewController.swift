//
//  EditWaypointViewController.swift
//  tripplanner
//
//  Created by Jeroen Ransijn on 14/10/15.
//  Copyright (c) 2015 JeroenRansijn. All rights reserved.
//

import UIKit
import MapKit

class EditWaypointViewController: UIViewController {
    
    var waypoint: Waypoint!
    var rightBarButton: UIBarButtonItem!
    var tableView: UITableView!
//    var searchBar: UISearchBar!
    var mapView: MKMapView!
    var localSearchRequest: MKLocalSearchRequest!
    var localSearch: MKLocalSearch!
    var localSearchResponse: MKLocalSearchResponse!
    var pointAnnotation: MKPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
    var annotation: MKAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .whiteColor()
        self.title = waypoint.name
    
        setupViews()
        
        addPin(waypoint.name!,
            latitude: CLLocationDegrees(waypoint.latitude!),
            longitude: CLLocationDegrees(waypoint.longitude!))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


// MARK: Setup views

extension EditWaypointViewController {
    
    func setupViews() {
        setupNavigationbar()
        setupMapView()
    }
    
    func setupMapView() {
        mapView = MKMapView()
        
        self.view.addSubview(mapView)
        
        mapView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_top)
            make.left.equalTo(self.view.snp_left)
            make.right.equalTo(self.view.snp_right)
            make.bottom.equalTo(self.view.snp_bottom)
        }
        
        // Default location and zoom
        let coordinate = CLLocationCoordinate2D(latitude: 37.78, longitude: 122.42)
        let span = MKCoordinateSpanMake(100, 80)
        let region = MKCoordinateRegionMake(coordinate, span)
        self.mapView.setRegion(region, animated: true)
    }
    
    func setupNavigationbar() {
        rightBarButton = UIBarButtonItem(title: "Delete", style: UIBarButtonItemStyle.Done, target: self, action: Selector("onTapDelete"))
        
        rightBarButton.tintColor = .redColor()

        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func onTapDelete() {
        CoreDataHelper.deleteWaypoint(waypoint)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}


// MARK: Application logic

extension EditWaypointViewController {
    
    func searchForPlaces(query: String) {
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = query
        localSearch = MKLocalSearch(request: localSearchRequest)
        
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil {
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            
            self.addPin(query, latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
        }
    }
    
    func addPin(title: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.pointAnnotation = MKPointAnnotation()
        self.pointAnnotation.title = title
        self.pointAnnotation.coordinate = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude)
        
        self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
        
        mapView.center = self.pinAnnotationView.center
        
        self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        self.mapView.selectAnnotation(self.pointAnnotation, animated: true)
        
        let region = MKCoordinateRegionMakeWithDistance(self.pointAnnotation.coordinate, CLLocationDistance(1000), CLLocationDistance(1000))
        self.mapView.setRegion(region, animated: true)
    }
}