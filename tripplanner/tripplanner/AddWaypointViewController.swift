//
//  AddWaypointViewController.swift
//  
//
//  Created by Jeroen Ransijn on 14/10/15.
//
//

import UIKit
import MapKit

class AddWaypointViewController: UIViewController {

    var rightBarButton: UIBarButtonItem!
    var leftBarButton: UIBarButtonItem!
    var tableView: UITableView!
    var searchBar: UISearchBar!
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
        self.title = "Add waypoint"
        
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

// MARK: Setup views

extension AddWaypointViewController {
    
    func setupViews() {
        setupSearchBar()
        setupMapView()
        setupNavigationbar()
    }
    
    func setupMapView() {
        mapView = MKMapView()
        
        mapView.delegate = self
        
        self.view.addSubview(mapView)
        
        mapView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.searchBar.snp_bottom)
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
        rightBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: Selector("onTapRightBarButton"))
        
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        leftBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("onTapLeftBarButton"))
        
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func setupSearchBar() {
        searchBar = UISearchBar()
        
        searchBar.delegate = self
        
        searchBar.placeholder = "Search locations"
        
        self.view.addSubview(searchBar)
        
        searchBar.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp_topLayoutGuideBottom)
            make.left.equalTo(self.view.snp_left)
            make.right.equalTo(self.view.snp_right)
        }
        
    }
    
}

// MARK: event handling

extension AddWaypointViewController {
    
    func onTapRightBarButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onTapLeftBarButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}


// MARK: Application logic

extension AddWaypointViewController {
    
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
        
        let detailButton: UIButton = UIButton.buttonWithType(UIButtonType.ContactAdd) as! UIButton
        self.pinAnnotationView.canShowCallout = true
        self.pinAnnotationView.userInteractionEnabled = true
        self.pinAnnotationView.rightCalloutAccessoryView = detailButton
        
        self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        self.mapView.selectAnnotation(self.pointAnnotation, animated: true)
        
        let region = MKCoordinateRegionMakeWithDistance(self.pointAnnotation.coordinate, CLLocationDistance(1000), CLLocationDistance(1000))
        self.mapView.setRegion(region, animated: true)
    }
    
    func saveWaypoint() {
        // TODO: Implement waypoint save
        self.navigationController?.popViewControllerAnimated(true)
    }
}

// MARK: Map delegate

extension AddWaypointViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        saveWaypoint()
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        return self.pinAnnotationView
    }
    
}

// MARK: Search

extension AddWaypointViewController: UISearchBarDelegate {
    
    func searchLibrary(text: String) {
        // Trim
        text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
//        if text == "" {
//            return resetSearch()
//        }
//        
//        for (key, mySection) in allSections {
//            sections[key] = mySection.filter { (item) -> Bool in
//                return item.title.rangeOfString(text, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil || item.artist.rangeOfString(text, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil
//            }
//            
//            if sections[key]?.count == 0 {
//                sections[key] = nil
//            }
//            
//        }
//        
//        updateSectionTitles()
//        
//        tableView.reloadData()
    }
    
    func resetSearch() {
//        sections = allSections
//        updateSectionTitles()
//        tableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchLibrary(searchText)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        resetSearch()
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        
        if searchBar.text != "" {
            // Only search when not empty string
            searchForPlaces(searchBar.text)
        }
        
    }
    
}