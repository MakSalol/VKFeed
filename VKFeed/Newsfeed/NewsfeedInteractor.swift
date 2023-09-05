//
//  NewsfeedInteractor.swift
//  VKFeed
//
//  Created by Максим on 04.06.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsfeedBusinessLogic {
    func makeRequest(request: Newsfeed.Model.Request.RequestType)
}

class NewsfeedInteractor: NewsfeedBusinessLogic {
    
    var presenter: NewsfeedPresentationLogic?
    var service: NewsfeedService?
    
    
    func makeRequest(request: Newsfeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsfeedService()
        }
        
        switch request {
        case .getNewsFeed:
            service?.getFeed(completion: { [weak self] revealedPostIds, feed in
                self?.presenter?.presentData(response: .presentNewsfeed(feed: feed, revealedPostIds: revealedPostIds))
            })
            
        case .getUser:
            service?.getUser(completion: { [weak self] user in
                self?.presenter?.presentData(response: .presentUserInfo(user: user))
            })
            
        case .revealPostIds(postId: let postId):
            service?.revealPostIds(forPostId: postId, completion: { [weak self] revealedPostIds, feed in
                self?.presenter?.presentData(response: .presentNewsfeed(feed: feed, revealedPostIds: revealedPostIds))
            })
            
        case .getNextBatch:
            self.presenter?.presentData(response: .presentFooterLoader)
            service?.getNextBatch(completion: { [weak self] revealedPostIds, feed in
                self?.presenter?.presentData(response: .presentNewsfeed(feed: feed, revealedPostIds: revealedPostIds))
            })
        }
        
    }
}
