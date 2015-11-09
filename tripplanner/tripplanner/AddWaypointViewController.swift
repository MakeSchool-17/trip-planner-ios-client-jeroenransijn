//
//  AddWaypointViewController.swift
//  
//
//  Created by Jeroen Ransijn on 14/10/15.
//
//

import UIKit
import MapKit
import GoogleMaps

class AddWaypointViewController: UIViewController {
    
    var placesClient: GMSPlacesClient?
    
    var autocompleteTableView: UITableView!
    var autocompleteResults = [GMSAutocompletePrediction]()
    
    var rightBarButton: UIBarButtonItem!
    var leftBarButton: UIBarButtonItem!
    var searchBar: UISearchBar!
    var mapView: MKMapView!
    var localSearchRequest: MKLocalSearchRequest!
    var localSearch: MKLocalSearch!
    var localSearchResponse: MKLocalSearchResponse!
    var pointAnnotation: MKPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
    var annotation: MKAnnotation!
    var trip: Trip!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .whiteColor()
        self.title = "Add waypoint"
        
        placesClient = GMSPlacesClient()
        
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
        setupAutocompleteTableView()
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
        
        rightBarButton.enabled = false
        
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
    
    func setupAutocompleteTableView() {
        autocompleteTableView = UITableView()
        
        autocompleteTableView.rowHeight = 50
        
        autocompleteTableView.hidden = true
        
        autocompleteTableView.delegate = self
        autocompleteTableView.dataSource = self
        autocompleteTableView.scrollEnabled = true
        
        self.view.addSubview(autocompleteTableView)
        
        autocompleteTableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.searchBar.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.right.equalTo(self.view.snp_right)
            make.height.equalTo(autocompleteTableView.rowHeight*5)
        }
    }
    
}

// MARK: event handling

extension AddWaypointViewController {
    
    func onTapRightBarButton() {
        saveWaypoint()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onTapLeftBarButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}


// MARK: Application logic

extension AddWaypointViewController {
    
//    func searchForPlaces(query: String) {
//        localSearchRequest = MKLocalSearchRequest()
//        localSearchRequest.naturalLanguageQuery = query
//        localSearch = MKLocalSearch(request: localSearchRequest)
//        
//        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
//            
//            if localSearchResponse == nil {
//                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
//                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
//                self.presentViewController(alertController, animated: true, completion: nil)
//                return
//            }
//            
//            self.addPin(query, latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
//        }
//    }
    
    func addPin(title: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.pointAnnotation = MKPointAnnotation()
        self.pointAnnotation.title = title
        self.pointAnnotation.coordinate = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude)
        
        self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
        
        let detailButton: UIButton = UIButton(type: UIButtonType.ContactAdd)
        self.pinAnnotationView.canShowCallout = true
        self.pinAnnotationView.userInteractionEnabled = true
        self.pinAnnotationView.rightCalloutAccessoryView = detailButton
        
        detailButton.addTarget(self, action: Selector("onTapRightBarButton"), forControlEvents: .TouchUpInside)
        
        self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        self.mapView.selectAnnotation(self.pointAnnotation, animated: true)
        
        let region = MKCoordinateRegionMakeWithDistance(self.pointAnnotation.coordinate, CLLocationDistance(1000), CLLocationDistance(1000))
        self.mapView.setRegion(region, animated: true)
    }
    
    func saveWaypoint() {
        CoreDataHelper.saveWaypoint(self.trip,
            latitude: Float(self.pointAnnotation.coordinate.latitude),
            longitude: Float(self.pointAnnotation.coordinate.longitude),
            name: self.pointAnnotation.title!)
        // TODO: Implement waypoint save
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addWaypoint(result: GMSAutocompletePrediction) {
        placesClient!.lookUpPlaceID(result.placeID) { (place: GMSPlace?, error: NSError?) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                print("Place name \(place.name)")
                print("Place address \(place.formattedAddress)")
                print("Place placeID \(place.placeID)")
                print("Place attributions \(place.attributions)")
                
                self.addPin(result.attributedFullText.string, latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                
                self.rightBarButton.enabled = true
                
            } else {
                print("No place details for \(result.placeID)")
            }
        }
        
    }
    
}

// MARK: Map delegate

extension AddWaypointViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        saveWaypoint()
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView! {
        return self.pinAnnotationView
    }
    
}

// MARK: Search

extension AddWaypointViewController: UISearchBarDelegate {
    
    func searchGooglePlaces(text: String) {
        // Trim
        let input = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())

        if input == "" {
            return
        }
        
        autocompleteTableView.hidden = false
        
        placesClient?.autocompleteQuery(input, bounds: nil, filter: nil) { (results, error: NSError?) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
            }
            
            self.autocompleteResults = []
            
            for result in results! {
                if let result = result as? GMSAutocompletePrediction {
//                    print("Result \(result.attributedFullText) with placeID \(result.placeID)")
                    self.autocompleteResults.append(result)
                }
            }
            
            
            self.autocompleteTableView.reloadData()
        }
        
    }
    
    func resetSearch() {
//        sections = allSections
//        updateSectionTitles()
//        tableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchGooglePlaces(searchText)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        autocompleteTableView.hidden = true
        searchBar.text = ""
        resetSearch()
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        autocompleteTableView.hidden = true
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        
        searchBar.text = autocompleteResults[0].attributedFullText.string
        
        print("searchButtonClicked")
        
        addWaypoint(autocompleteResults[0])
    
    }
    
}

// MARK: autocomplete table view

extension AddWaypointViewController: UITableViewDelegate, UITableViewDataSource {
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteResults.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("AutocompleteCell") as UITableViewCell?
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "AutocompleteCell")
        }
        
        print(autocompleteResults[indexPath.row].attributedFullText)
        
        cell!.textLabel?.text = autocompleteResults[indexPath.row].attributedFullText.string
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        searchBar.text = autocompleteResults[indexPath.row].attributedFullText.string
        
        searchBar.resignFirstResponder()
        autocompleteTableView.hidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
        addWaypoint(autocompleteResults[indexPath.row])
    }
    
    
}