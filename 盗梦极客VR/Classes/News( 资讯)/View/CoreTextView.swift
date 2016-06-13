//
//  CoreTextView.swift
//  盗梦极客VR
//
//  Created by wl on 6/9/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit
import DTCoreText

var imageSizes : [NSURL:CGSize] = [NSURL:CGSize]()

protocol CoreTextViewDelegate : class {
    func coreTextView(textView: CoreTextView, linkDidTap link:NSURL)
    func coreTextView(textView: CoreTextView, newImageSizeDidCache size:CGSize)
}

class CoreTextView: DTAttributedTextContentView, DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate {
    
    weak var linkDelegate : CoreTextViewDelegate?
    private var imageViews = [DTLazyImageView]()
    
    override var bounds : CGRect {
        didSet {
            self.relayoutText()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Fix warning when layer is to high
        CoreTextView.setLayerClass(NSClassFromString("DTTiledLayerWithoutFade"))
    }
    
    func linkDidTap(sender: DTLinkButton) {
        if let url = sender.URL {
            linkDelegate?.coreTextView(self, linkDidTap: url)
        }
    }
    
    func attributedTextContentView(attributedTextContentView: DTAttributedTextContentView!, viewForAttributedString string: NSAttributedString!, frame: CGRect) -> UIView! {
        
        let attributes = string.attributesAtIndex(0, effectiveRange: nil)
        let url = attributes[DTLinkAttribute] as? NSURL
        let identifier = attributes[DTGUIDAttribute] as? String
        
        let button = DTLinkButton(frame: frame)
        button.URL = url
        button.GUID = identifier
        button.minimumHitSize = CGSizeMake(25, 25)
        button.addTarget(self, action: #selector(CoreTextView.linkDidTap(_:)), forControlEvents: .TouchUpInside)
        
        return button
    }
    
    func attributedTextContentView(attributedTextContentView: DTAttributedTextContentView!, viewForAttachment attachment: DTTextAttachment!, frame: CGRect) -> UIView! {
        if let attachment = attachment as? DTImageTextAttachment {
            let size = self.aspectFitSizeForURL(attachment.contentURL)
            let aspectFrame = CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height)
            
            let imageView = DTLazyImageView(frame: aspectFrame)
            
            imageView.delegate = self
            imageView.url = attachment.contentURL
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.clipsToBounds = true
            imageView.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
            imageView.shouldShowProgressiveDownload = true
            imageViews.append(imageView)
            return imageView
        }
        return nil
    }
    
    // MARK: DTLazyImageViewDelegate
    func lazyImageView(lazyImageView: DTLazyImageView!, didChangeImageSize size: CGSize) {
        
        let url = lazyImageView.url
        let pred = NSPredicate(format: "contentURL == %@", url)
        
        if let layoutFrame = self.layoutFrame {
            var attachments = layoutFrame.textAttachmentsWithPredicate(pred)
            
            var needsNotifyNewImageSize = false
            for i in 0 ..< attachments.count {
                if let one = attachments[i] as? DTImageTextAttachment {
                    one.originalSize = aspectFitImageSize(size)
                    if let cachedSize = imageSizes[one.contentURL] {
                        if !CGSizeEqualToSize(cachedSize, size) {
                            needsNotifyNewImageSize = true
                            self.linkDelegate?.coreTextView(self, newImageSizeDidCache: size)
                        }
                    } else {
                        needsNotifyNewImageSize = true
                    }
                    imageSizes[one.contentURL] = size
                }
            }
            self.layouter = nil
            self.relayoutText()
            if needsNotifyNewImageSize {
                self.linkDelegate?.coreTextView(self, newImageSizeDidCache: size)
            }
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        
        var size = super.intrinsicContentSize()
//        print(size)
//        if let layoutFrame = self.layoutFrame {
//            for attachments in layoutFrame.textAttachments() {
//                if let attachment = attachments as? DTImageTextAttachment {
//                    
//                    size.height += self.aspectFitSizeForURL(attachment.contentURL).height
//                    
//                }
//            }
//        }
        size.height += 15
        return size
    }
    
    func aspectFitSizeForURL(url: NSURL) -> CGSize {
        let imageSize = imageSizes[url] ?? CGSizeMake(4, 3)
        return self.aspectFitImageSize(imageSize)
    }
    
    func aspectFitImageSize(size : CGSize) -> CGSize {
        if CGSizeEqualToSize(size, CGSizeZero) {
            return size
        }
        return CGSizeMake(40, 40)
//        return CGSizeMake(self.bounds.size.width, self.bounds.size.width/size.width * size.height)
    }
    
    deinit {
        for imageView in imageViews {
            imageView.delegate = nil
        }
    }
}