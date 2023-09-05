//
//  NewsfeedCell.swift
//  VKFeed
//
//  Created by Максим on 04.06.2023.
//

import Foundation
import UIKit

protocol FeedCellViewModel {
    var iconUrlString: String { get }
    var name: String { get }
    var date: String { get }
    var text: String? { get }
    var likes: String? { get }
    var comments: String? { get }
    var shares: String? { get }
    var views: String? { get }
    var photoAttachments: [FeedCellPhotoAttachmentViewModel] { get }
    var sizes: FeedCellSizes { get }
}

protocol FeedCellSizes {
    var postLabelFrame: CGRect { get }
    var attachmentFrame: CGRect { get }
    var bottomViewFrame: CGRect { get }
    var totalHeight: CGFloat { get }
    var moreTextButtonFrame: CGRect { get }
}

protocol FeedCellPhotoAttachmentViewModel {
    var photoUrlString: String? { get }
    var width: Int { get }
    var heigth: Int { get }
}

class NewsfeedCell: UITableViewCell {
    
    static let reuseId = "NewsfeedCell"
    
    @IBOutlet weak var cardView: UIView! {
        didSet {
            cardView.layer.cornerRadius = 10
            cardView.clipsToBounds = true
        }
    }
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var iconImageView: WebImageView! {
        didSet {
            self.iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
            self.iconImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var postImageView: WebImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func prepareForReuse() {
        iconImageView.set(imageURL: nil)
        postImageView.set(imageURL: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    func set(viewModel: FeedCellViewModel) {
        iconImageView.set(imageURL: viewModel.iconUrlString)
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        postLabel.text = viewModel.text
        likesLabel.text = viewModel.likes
        sharesLabel.text = viewModel.shares
        commentsLabel.text = viewModel.comments
        viewsLabel.text = viewModel.views
        
        postLabel.frame = viewModel.sizes.postLabelFrame
        postImageView.frame = viewModel.sizes.attachmentFrame
        bottomView.frame = viewModel.sizes.bottomViewFrame
        
//        if let photoAttachment = viewModel.photoAttachment {
//            postImageView.set(imageURL: photoAttachment.photoUrlString)
//            postImageView.isHidden = false
//            postImageView.contentMode = .scaleToFill
//        }
//        else {
//            postImageView.isHidden = true
//        }
    }
    
}
