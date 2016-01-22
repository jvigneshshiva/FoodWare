//
//  PartnerDetails.swift
//  TechnicheHiringTask
//
//  Created by Vignesh on 22/01/16.
//  Copyright © 2016 Vignesh. All rights reserved.
//

import Foundation


class PartnerDetails: NSObject {
    
    enum PaymentModes : Int {
        case Cash
        case Online
    }
    
    var partnerId : String
    var coupons :  [String]
    var partnerName : String
    var partnerDescription : String
    var availablePaymentModes : [PaymentModes]
    var imageId : String
    var isDeliveryAvailable : Bool
    var isPickupAvailable : Bool
    
    init(partnerDetails : [String : AnyObject]) {
        partnerId = partnerDetails["_id"] as! String
        coupons = partnerDetails["coupons"] as! [String]
        partnerDescription = partnerDetails["description"] as! String
        partnerName = partnerDetails["name"] as! String
        var paymentModeMappingDictionary : [String : PaymentModes] = ["cash" : .Cash , "online" : .Online]
        availablePaymentModes = []
        if let paymentOptionsDictionary = partnerDetails["paymentOptions"] as? [String : Bool]
        {
            for payOption in paymentOptionsDictionary.keys
            {
                if(paymentOptionsDictionary[payOption] == true)
                {
                    availablePaymentModes.append(paymentModeMappingDictionary[payOption]!)
                }
            }
        }
        let deliveryOptions = partnerDetails["deliveryOptions"] as! [String : Bool]
        isDeliveryAvailable = deliveryOptions["delivey"]!
        isPickupAvailable = deliveryOptions["pickup"]!
        imageId = partnerDetails["image"] as! String
        super.init()

    }
    
    
}
