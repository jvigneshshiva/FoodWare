//
//  ReviewCartViewController.swift
//  TechnicheHiringTask
//
//  Created by Vignesh on 22/01/16.
//  Copyright © 2016 Vignesh. All rights reserved.
//

import UIKit

class ReviewCartViewController: UIViewController, ProductDisplayTableViewCellProtocol {
    
    @IBOutlet weak var cartItemsDisplayTableView: UITableView!
    var cartDetails : [ProductDetails : Int] = [:]
    var productDisplayList : [ProductDetails] = []
    
    var isDeliveryAvailable : Bool = false
    var isPickupAvailable : Bool = false
    
    @IBOutlet weak var cartValueLabel: UILabel!
    
    @IBOutlet weak var pickupButton: UIButton!
    @IBOutlet weak var deliveryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickupButton.enabled = isPickupAvailable
        deliveryButton.enabled = isDeliveryAvailable
        reloadData()
    }
    
    class var viewController: ReviewCartViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let reviewCartViewController = storyBoard.instantiateViewControllerWithIdentifier("reviewCartViewController") as! ReviewCartViewController
        return reviewCartViewController
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:CartProductDisplayTableViewCell = tableView.dequeueReusableCellWithIdentifier("cartProductDisplayTableViewCell", forIndexPath: indexPath) as! CartProductDisplayTableViewCell
        let productDetailObject = productDisplayList[indexPath.row]
        cell.configureWithProductDetails(productDetailObject)
        cell.tag = indexPath.row
        var quantity = 0
        let pricePerItem = productDetailObject.productPrice
        if(cartDetails.keys.contains(productDetailObject))
        {
            quantity = cartDetails[productDetailObject]!
        }
        cell.configurePurchaseViewWith(quantity, andPrice : quantity*pricePerItem)
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return productDisplayList.count
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
        cartValueLabel.text = "Rs. \(cartValue)"
    }

    
    func reloadData(){
        productDisplayList = Array(cartDetails.keys)
        cartItemsDisplayTableView.reloadData()
        configureCartPriceView()
    }
    
    @IBAction func changeCard() {
        dismissViewControllerAnimated(true
            , completion: nil)
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}

class CartProductDisplayTableViewCell : UITableViewCell
{
    @IBOutlet weak var vegIndicatorContainerView: UIView!
    @IBOutlet weak var vegIndicatorView: UIView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var purchaseQuantityLabel: UILabel!
    @IBOutlet weak var reduceQuantityButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var quantityPriceLabel: UILabel!
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
    
    func configurePurchaseViewWith(quantity : Int, andPrice price : Int)
    {
        purchaseQuantity = quantity
        if(purchaseQuantity == 0)
        {
            reduceQuantityButton.hidden = true
            purchaseQuantityLabel.hidden = true
            quantityPriceLabel.hidden = true
        }
        else
        {
            reduceQuantityButton.hidden = false
            purchaseQuantityLabel.hidden = false
            quantityPriceLabel.hidden = false
        }
        purchaseQuantityLabel.text = "\(purchaseQuantity)"
        quantityPriceLabel.text = "Rs. \(price)"

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

