//
//  ServerHelper.swift
//  TechnicheHiringTask
//
//  Created by Vignesh on 22/01/16.
//  Copyright © 2016 Vignesh. All rights reserved.
//

import UIKit

public protocol ServerHelperProtocol : NSObjectProtocol {
    func partnersFetched(partners : [String : AnyObject])
    func partnersFetchingFailed()
    
}

class ServerHelper: NSObject {
    
    var delegate : ServerHelperProtocol!
    
    func fetchPartnersList(partnerCategory : String, andVenueId venueId : String)
    {
        let requestContents : [String : AnyObject] = [ "partnerCategory" : "565fde4def8e1f999f8b7ef4" , "venueId" : "566c484f229f07d370ed7ddf"]
        let requestData = try! NSJSONSerialization.dataWithJSONObject(requestContents, options: [NSJSONWritingOptions(rawValue: 0)])
        let storeURL : NSURL = NSURL(string: "http://52.11.109.130:4000/getpartnersforpartnercategory")!
        let storeRequest : NSMutableURLRequest = NSMutableURLRequest(URL: storeURL)
        storeRequest.HTTPMethod = "POST"
        storeRequest.HTTPBody = requestData
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(storeRequest, completionHandler: {data, response, error -> Void in
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
            if let parseJSON = json {
                print("Fetched Partners \(parseJSON)")
            }
            else {
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Data Error Error: \(jsonStr)")
            }
            
        })
        
        task.resume();
    }
    

}
