//
//  MenuDetails.swift
//  TechnicheHiringTask
//
//  Created by Vignesh on 22/01/16.
//  Copyright © 2016 Vignesh. All rights reserved.
//

import UIKit

class MenuDetails: NSObject {
    var menuName : String
    var productArray : [ProductDetails] = []
    
    init(menuDetails : [String : AnyObject])
    {
        menuName = menuDetails["name"] as! String
        for anyProduct in menuDetails["products"] as! [[String : AnyObject]]
        {
            let productIdData : [String : AnyObject] = anyProduct["productId"] as! [String : AnyObject]
            let productOptions : [[String : AnyObject]] = productIdData["productOptions"] as! [[String : AnyObject]]
            let productDetails : ProductDetails = ProductDetails(productDetails: productOptions.first!)
            productArray.append(productDetails)
        }
        super.init()
    }

}
