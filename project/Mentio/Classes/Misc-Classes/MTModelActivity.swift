//
//  MTModelActivity.swift
//  Mentio
//
//  Created by Martin Hartl on 25/08/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

import UIKit

class MTModelActivity: NSObject, UIActivityItemSource {
    
    var model: MTModelProtocol
    
    var sharedBy: String
    var title: String
    
    var microBlogPostString: String = ""
    var emailShareString: String = ""
        lazy var shareUrlString: NSURL = NSURL(string: "")!
    
    init(model: MTModelProtocol) {
        self.model = model
        sharedBy = NSLocalizedString("shared by", comment: "shared by")
        title = "\(model.protArtistName) - \(model.protTitle)"
        super.init()
        
        shareUrlString = MTModelActivity.createShareUrl(model.protCollectionViewUrl)
        microBlogPostString = "\(title)) \(shareUrlString) \(sharedBy) @MentioApp"
        emailShareString = "<html><body><a href='\(shareUrlString)'>\(title)</a> <br></br>\(sharedBy) <a href='http://mentioapp.com'>Mentio App</a></body></html>"
    }
    
    
    func activityViewControllerPlaceholderItem(activityViewController: UIActivityViewController) -> AnyObject {
        return NSURL(string: model.protCollectionViewUrl)!
    }
    
    func activityViewController(activityViewController: UIActivityViewController, itemForActivityType activityType: String) -> AnyObject? {
        switch activityType {
        case UIActivityTypePostToTwitter:
            return microBlogPostString
        case UIActivityTypePostToFacebook:
            return microBlogPostString
        case UIActivityTypeMail:
            return emailShareString
        case UIActivityTypeAddToReadingList:
            return shareUrlString
        case UIActivityTypeAirDrop:
            return shareUrlString
        case UIActivityTypePostToTencentWeibo:
            return microBlogPostString
        case UIActivityTypeCopyToPasteboard:
            return shareUrlString
        case UIActivityTypeMessage:
            return microBlogPostString
        default:
            return self.shareUrlString
        }
    }
    
    func activityViewController(activityViewController: UIActivityViewController, subjectForActivityType activityType: String?) -> String {
        return self.microBlogPostString
    } 
    
    
    class func createShareUrl(url: String) -> NSURL {
        var affiliateToken = NSUserDefaults.standardUserDefaults().objectForKey(MTAffiliateTokenKeyConstant) as String?
        var urlString: String = ""
        
        if affiliateToken == nil || affiliateToken! == "" {
            affiliateToken = NSBundle.mainBundle().objectForInfoDictionaryKey("itunesURLExtension") as String?
        }
        
        if let uAffiliateToken = affiliateToken {
            urlString = "\(url)&at=\(uAffiliateToken)"
        }
        
        return NSURL(string: urlString)!
    }
    
    
}
