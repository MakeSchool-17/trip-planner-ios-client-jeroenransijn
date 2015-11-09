//
//  AddTripViewController.swift
//  tripplanner
//
//  Created by Jeroen Ransijn on 14/10/15.
//  Copyright (c) 2015 JeroenRansijn. All rights reserved.
//

import UIKit
import SnapKit

class AddTripViewController: UIViewController {

    var titleTextField: UITextField!
    var rightBarButton: UIBarButtonItem!
    var leftBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = .whiteColor()
        self.title = "Add trip"
        
        setupViews()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        titleTextField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


// MARK: Setup views

extension AddTripViewController {
    
    func setupViews() {
        setupNavigationbar()
        setupTitleTextField()
    }
    
    func setupNavigationbar() {
        rightBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: Selector("onTapRightBarButton"))
        
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        leftBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("onTapLeftBarButton"))
        
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func setupTitleTextField() {
        titleTextField = UITextField()
        
        titleTextField.placeholder = "Trip name"
        titleTextField.borderStyle = UITextBorderStyle.RoundedRect
        
        self.view.addSubview(titleTextField)
        
        titleTextField.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp_topLayoutGuideBottom).offset(20)
            make.left.equalTo(self.view.snp_leftMargin)
            make.right.equalTo(self.view.snp_rightMargin)
        }
    }
    
    func saveTrip() {
        let tripName = titleTextField.text!
        CoreDataHelper.saveTrip(tripName)
    }
    
}

// MARK: Event handling

extension AddTripViewController {
    
    func onTapRightBarButton() {
        
        saveTrip()
        
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onTapLeftBarButton() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}