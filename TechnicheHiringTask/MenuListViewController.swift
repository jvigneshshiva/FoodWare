//
//  MenuListViewController.swift
//  TechnicheHiringTask
//
//  Created by Vignesh on 22/01/16.
//  Copyright © 2016 Vignesh. All rights reserved.
//

import UIKit

class MenuListViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, ProductDisplayTableViewCellProtocol {
    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var menuListDisplayCollectionView: UICollectionView!
    
    @IBOutlet weak var productDisplayTableView: UITableView!
    
    @IBOutlet weak var cartValueLabel: UILabel!
    var menuDetailsArray : [MenuDetails] = []
    var productDisplayList : [ProductDetails] = []
    var selectedMenu : MenuDetails!
    
    var cartDetails : [ProductDetails : Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMenuListForPartner()
    }
    
    func fetchedMenu(menuInfoArray : [[String : AnyObject]])
    {
        for anyMenu in menuInfoArray
        {
            let menuDetails : MenuDetails = MenuDetails(menuDetails: anyMenu)
            menuDetailsArray.append(menuDetails)
        }
        selectedMenu = menuDetailsArray.first
        reloadData()
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:ProductDisplayTableViewCell = tableView.dequeueReusableCellWithIdentifier("productDisplayTableViewCell", forIndexPath: indexPath) as! ProductDisplayTableViewCell
        let productDetailObject = productDisplayList[indexPath.row]
        cell.configureWithProductDetails(productDetailObject)
        cell.tag = indexPath.row
        var quantity = 0
        if(cartDetails.keys.contains(productDetailObject))
        {
            quantity = cartDetails[productDetailObject]!
        }
        cell.configurePurchaseViewWith(quantity)
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return productDisplayList.count
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return menuDetailsArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell:MenuTypeDisplayCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("MenuTypeDisplayCollectionViewCell", forIndexPath: indexPath) as! MenuTypeDisplayCollectionViewCell
        let menuDetails = menuDetailsArray[indexPath.row]
        cell.menuLabel.text = menuDetails.menuName
        if(menuDetails == selectedMenu)
        {
            cell.selectionIndicationView.hidden = false
        }
        else
        {
            cell.selectionIndicationView.hidden = true
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let menuDetails = menuDetailsArray[indexPath.row]
        selectedMenu = menuDetails
        reloadData()
    }
    
    func reloadData(){
        productDisplayList = selectedMenu.productArray
        productDisplayTableView.reloadData()
        menuListDisplayCollectionView.reloadData()
        configureCartPriceView()
    }

    
    func fetchMenuListForPartner()
    {
        let baseUrlString = "http://52.11.109.130:4000/getmenu"
        let manager = AFHTTPRequestOperationManager();
        let params = [ "partnerId" : "566c4f14229f07d370ed7deb"];
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>;
        manager.POST(baseUrlString, parameters: params, success: {
            (operation : AFHTTPRequestOperation!, responseObject) in
            self.fetchedMenu(responseObject as! [[String : AnyObject]])
            }, failure: {
                (operation, error) in
                print("Fetching PartnersPartners Error: " + error.description)
        })
        
    }
    
    func quantityChanged(quantity: Int, withTag tag: Int) {
        let productDetailObject = productDisplayList[tag]
        if(quantity > 0)
        {
            cartDetails[productDetailObject] = quantity
        }
        else
        {
            cartDetails.removeValueForKey(productDetailObject)
        }
        reloadData()
    }
    
    func configureCartPriceView(){
        var cartValue = 0
        for productDetail in cartDetails.keys
        {
            let quantity = cartDetails[productDetail]
            let pricePerQuantity = productDetail.productPrice
            cartValue += quantity!*pricePerQuantity
        }
        if(cartValue > 0)
        {
            priceView.hidden = false
            cartValueLabel.text = "Rs. \(cartValue)"
        }
        else
        {
            priceView.hidden = true
        }
    }

    

}

class MenuTypeDisplayCollectionViewCell : UICollectionViewCell{
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var selectionIndicationView: UIView!
}

public protocol ProductDisplayTableViewCellProtocol : NSObjectProtocol
{
    func quantityChanged(quantity : Int, withTag tag : Int)
}


class ProductDisplayTableViewCell : UITableViewCell
{
    @IBOutlet weak var vegIndicatorContainerView: UIView!
    @IBOutlet weak var vegIndicatorView: UIView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var purchaseQuantityLabel: UILabel!
    @IBOutlet weak var reduceQuantityButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    
    var delegate : ProductDisplayTableViewCellProtocol!
    
    var purchaseQuantity : Int = 0
    
    func configureWithProductDetails(product : ProductDetails)
    {
        vegIndicatorContainerView.layer.borderColor = UIColor.redColor().CGColor
        vegIndicatorView.backgroundColor = UIColor.redColor()
        if (product.isVeg)
        {
            vegIndicatorContainerView.layer.borderColor = UIColor.greenColor().CGColor
            vegIndicatorView.backgroundColor = UIColor.greenColor()
        }
        productNameLabel.text = product.productName
        priceLabel.text = "Rs. \(product.productPrice)"
    }
    
    func configurePurchaseViewWith(quantity : Int)
    {
        purchaseQuantity = quantity
        if(purchaseQuantity == 0)
        {
            reduceQuantityButton.hidden = true
            purchaseQuantityLabel.hidden = true
        }
        else
        {
            reduceQuantityButton.hidden = false
            purchaseQuantityLabel.hidden = false
        }
        purchaseQuantityLabel.text = "\(purchaseQuantity)"
    }
    
    @IBAction func quantityChanged(sender: AnyObject) {
        if(sender.tag == 0)
        {
            purchaseQuantity++
        }
        else
        {
            purchaseQuantity--
        }
        delegate.quantityChanged(purchaseQuantity, withTag: self.tag)
        
    }
    
    
}

