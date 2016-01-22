//
//  ViewController.swift
//  TechnicheHiringTask
//
//  Created by Vignesh on 22/01/16.
//  Copyright © 2016 Vignesh. All rights reserved.
//

import UIKit

class PartnerListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var partnerDetailsArray : [PartnerDetails] = []

    @IBOutlet weak var partnerDetailDisplayTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPartnersListForPartnerCategory("565fde4def8e1f999f8b7ef4", andVenueId: "566c484f229f07d370ed7ddf")
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func partnersFetched(partners : [[String : AnyObject]])
    {
        for partner in partners
        {
            let partnerDetail : PartnerDetails = PartnerDetails(partnerDetails: partner)
            partnerDetailsArray.append(partnerDetail)
        }
        partnerDetailDisplayTableView.reloadData()
    }
    
    func partnersFetchingFailed()
    {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return partnerDetailsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:PartnerDetailDisplayTableViewCell = tableView.dequeueReusableCellWithIdentifier("partnerDetailDisplayTableViewCell", forIndexPath: indexPath) as! PartnerDetailDisplayTableViewCell
        let partnerDetailObject = partnerDetailsArray[indexPath.row]
        cell.configureWithPartnerDetails(partnerDetailObject)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let partnerDetailObject = partnerDetailsArray[indexPath.row]
        let menuListVc : MenuListViewController = MenuListViewController.viewController
        menuListVc.partnerDetails = partnerDetailObject
        presentViewController(menuListVc, animated: true, completion: nil)
    }
    
    func fetchPartnersListForPartnerCategory(partnerCategory : String, andVenueId venueId : String)
    {
        let baseUrlString = "http://52.11.109.130:4000/getpartnersforpartnercategory"
        let manager = AFHTTPRequestOperationManager();
        let params = [ "partnerCategory" : partnerCategory , "venueId" : venueId];
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>;
        manager.POST(baseUrlString, parameters: params, success: {
            (operation : AFHTTPRequestOperation!, responseObject) in
            let responseDictionary : [String : AnyObject] = responseObject as! [String : AnyObject]
            self.partnersFetched(responseDictionary["partners"] as! [[String : AnyObject]])
            }, failure: {
                (operation, error) in
                print("Fetching PartnersPartners Error: " + error.description)
                self.partnersFetchingFailed()
        })
        
    }



}

class PartnerDetailDisplayTableViewCell: UITableViewCell{
    
    @IBOutlet weak var partnerNameLabel: UILabel!
    @IBOutlet weak var partnerDescriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    func configureWithPartnerDetails(partnerDetailObject :PartnerDetails)
    {
        partnerNameLabel.text = partnerDetailObject.partnerName
        partnerDescriptionLabel.text = partnerDetailObject.partnerDescription
        let urlString : String = "http://52.11.109.130:4000/files/\(partnerDetailObject.imageId)"
        downloadImage(urlString)
    }
    
    func downloadImage(url : String)
    {
        let operation = AFHTTPRequestOperation(request: NSURLRequest(URL: NSURL(string: url)!));
        operation.setCompletionBlockWithSuccess(
            {(operation : AFHTTPRequestOperation!, responseObject) in
                self.iconImageView.image = UIImage(data: responseObject as! NSData)
            }, failure: {
                (operation, error) in
                print("Error: " + error.description)
        })
        operation.start()
    }
    
}

