//
//  NewsfeedCellLayoutCalculator.swift
//  VKFeed
//
//  Created by Максим on 04.06.2023.
//

import Foundation
import UIKit

struct Sizes: FeedCellSizes {
    var postLabelFrame: CGRect
    var moreTextButtonFrame: CGRect
    var attachmentFrame: CGRect
    var bottomViewFrame: CGRect
    var totalHeight: CGFloat
}

protocol FeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, photoAttachments: [FeedCellPhotoAttachmentViewModel], isFullSizedPost: Bool) -> FeedCellSizes
}

final class FeedCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
    
    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    
    func sizes(postText: String?, photoAttachments: [FeedCellPhotoAttachmentViewModel], isFullSizedPost: Bool) -> FeedCellSizes {
        
        var showMoreTextButton = false
        
        let cardViewWidth = screenWidth - Constants.cardInsets.left - Constants.cardInsets.right
        
        var postLabelFrame = CGRect(origin: CGPoint(x: Constants.postLableInsets.left, y: Constants.postLableInsets.top), size: CGSize.zero)
        
        if let text = postText, !text.isEmpty {
            let width = cardViewWidth - Constants.postLableInsets.left - Constants.postLableInsets.right
            var height = text.height(width: width, font: Constants.postLabelFont)
            
            let limitHeight = Constants.postLabelFont.lineHeight * Constants.minifiedPostLimitLines
            
            if !isFullSizedPost && height > limitHeight {
                height = Constants.minifiedPostLines * Constants.postLabelFont.lineHeight
                showMoreTextButton = true
            }
            
            postLabelFrame.size = CGSize(width: width, height: height)
        }
        
        let moreTextButtonSize: CGSize = showMoreTextButton ? Constants.moreTextButtonSize : CGSize.zero
        
        let moreTextButtonOrigin = CGPoint(x: Constants.moreTextButtonInsets.left, y: postLabelFrame.maxY)
        
        let moreTextButtonFrame = CGRect(origin: moreTextButtonOrigin, size: moreTextButtonSize)
        
        let attachmentTop = postLabelFrame.size == CGSize.zero ? Constants.postLableInsets.top : moreTextButtonFrame.maxY + Constants.postLableInsets.bottom
        
        var attachmentFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop), size: CGSize.zero)
        
        if let attachment = photoAttachments.first {
            let ratio = CGFloat(Float(attachment.heigth) / Float(attachment.width))
            if photoAttachments.count == 1 {
                attachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * ratio)
            } else if photoAttachments.count > 1 {
                var photos = [CGSize]()
                for photo in photoAttachments {
                    let photoSize = CGSize(width: CGFloat(photo.width), height: CGFloat(photo.heigth))
                    photos.append(photoSize)
                }
                
                let rowHeight = RowLayout.rowHeightCounter(superViewWidth: cardViewWidth, photosArray: photos)
                attachmentFrame.size = CGSize(width: cardViewWidth, height: rowHeight!)
            }
        }
        
        let bottomViewTop = max(postLabelFrame.maxY, attachmentFrame.maxY)
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTop), size: CGSize(width: cardViewWidth, height: Constants.bottomViewHeight))
        
        let totalHeight = bottomViewFrame.maxY + Constants.cardInsets.bottom
        
        return Sizes(postLabelFrame: postLabelFrame, moreTextButtonFrame: moreTextButtonFrame, attachmentFrame: attachmentFrame, bottomViewFrame: bottomViewFrame, totalHeight: totalHeight)
    }
    
}
