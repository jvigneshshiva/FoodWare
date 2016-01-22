//
//  ServerHelper.swift
//  TechnicheHiringTask
//
//  Created by Vignesh on 22/01/16.
//  Copyright © 2016 Vignesh. All rights reserved.
//

import UIKit

public protocol ServerHelperProtocol : NSObjectProtocol {
    func partnersFetched(partners : [[String : AnyObject]])
    func partnersFetchingFailed()
    
}

class ServerHelper: NSObject {
    
    var delegate : ServerHelperProtocol!
    
    func fetchPartnersListForPartnerCategory(partnerCategory : String, andVenueId venueId : String)
    {
        let baseUrlString = "http://52.11.109.130:4000/getpartnersforpartnercategory"
        let manager = AFHTTPRequestOperationManager();
        let params = [ "partnerCategory" : partnerCategory , "venueId" : venueId];
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>;
        manager.POST(baseUrlString, parameters: params, success: {
            (operation : AFHTTPRequestOperation!, responseObject) in
            let responseDictionary : [String : AnyObject] = responseObject as! [String : AnyObject]
            self.delegate.partnersFetched(responseDictionary["partners"] as! [[String : AnyObject]])
            }, failure: {
                (operation, error) in
                print("Fetching PartnersPartners Error: " + error.description)
                self.delegate.partnersFetchingFailed()
        })
        
        
    }
    
    
    
}
