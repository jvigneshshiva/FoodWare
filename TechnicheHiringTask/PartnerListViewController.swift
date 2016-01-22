//
//  ViewController.swift
//  TechnicheHiringTask
//
//  Created by Vignesh on 22/01/16.
//  Copyright © 2016 Vignesh. All rights reserved.
//

import UIKit

class PartnerListViewController: UIViewController, ServerHelperProtocol {
    
    var serverHeler : ServerHelper!

    override func viewDidLoad() {
        super.viewDidLoad()
        serverHeler = ServerHelper()
        serverHeler.fetchPartnersList("", andVenueId: "")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func partnersFetched(partners : [String : AnyObject])
    {
        
    }
    
    func partnersFetchingFailed()
    {
        
    }


}

