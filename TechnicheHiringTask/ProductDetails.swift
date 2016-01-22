//
//  ProductDetails.swift
//  TechnicheHiringTask
//
//  Created by Vignesh on 22/01/16.
//  Copyright © 2016 Vignesh. All rights reserved.
//

import UIKit

class ProductDetails: NSObject {
    var productName : String
    var productPrice : Int
    var isVeg : Bool = false
    
    init(productDetails : [String : AnyObject]) {
        productName = productDetails["name"] as! String
        productPrice = productDetails["price"] as! Int
        if(productDetails["veg"] as! String == "veg")
        {
            isVeg = true
        }
    }

}
