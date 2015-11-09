//
//  ViewController.swift
//  tripplanner
//
//  Created by Jeroen Ransijn on 14/10/15.
//  Copyright (c) 2015 JeroenRansijn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var rightBarButton: UIBarButtonItem!
    var tableView: UITableView!
    var trips = [Trip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Planned trips"
        
        
//        populateFakeData()
        setupViews()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        trips = CoreDataHelper.allTrips()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

// MARK: Setup views

extension ViewController {
    
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

extension ViewController {
    
    func onTapRightBarButton() {
        let wrapper = UINavigationController(rootViewController: AddTripViewController())
        
        self.navigationController?.presentViewController(wrapper, animated: true, completion: nil)
    }
    
}

// MARK: Table view

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("TripCell") as? TripTableViewCell
        
        if cell == nil {
            cell = TripTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "TripCell")
        }
        
        
        cell!.textLabel?.text = self.trips[indexPath.row].name
        
        return cell!
    }
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let tripViewController = TripViewController()
        
        // TODO: make this dynamic
        tripViewController.trip = trips[indexPath.row]
        
        self.navigationController?.pushViewController(tripViewController, animated: true)
        
    }
    
}
