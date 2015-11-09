//
//  TripViewController.swift
//  
//
//  Created by Jeroen Ransijn on 14/10/15.
//
//

import UIKit

class TripViewController: UIViewController {
    
    var rightBarButton: UIBarButtonItem!
    var tableView: UITableView!
    var trip: Trip!
    var waypoints = [Waypoint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = .whiteColor()
        self.title = trip.name
        
        setupViews()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        waypoints = CoreDataHelper.allWaypoints(trip)
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

// MARK: Setup views

extension TripViewController {
    
    func setupViews() {
        setupNavigationbar()
        setupTableView()
    }
    
    func setupNavigationbar() {
        rightBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("onTapRightBarButton"))
        
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    
    func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        
        self.view.addSubview(tableView)
        
        tableView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.bottom.equalTo(self.view.snp_bottom)
            make.top.equalTo(self.snp_topLayoutGuideTop)
        }
    }
}

// MARK: Event handling

extension TripViewController {
    
    func onTapRightBarButton() {
        let addWaypointVC = AddWaypointViewController()
        addWaypointVC.trip = trip
        let wrapper = UINavigationController(rootViewController: addWaypointVC)
        self.navigationController?.presentViewController(wrapper, animated: true, completion: nil)
    }
    
}

// MARK: Table view

extension TripViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return waypoints.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("TripCell") as? TripTableViewCell
        
        if cell == nil {
            cell = TripTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "TripCell")
        }
        
        cell!.textLabel?.text = waypoints[indexPath.row].name
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let editWaypointViewController = EditWaypointViewController()
        
        editWaypointViewController.waypoint = self.waypoints[indexPath.row]
        
        self.navigationController?.pushViewController(editWaypointViewController, animated: true)
    }
    
}
