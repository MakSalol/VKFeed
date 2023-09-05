import UIKit

class NewsfeedService {

    var authService: AuthService
    var networking: Networking
    var fetcher: DataFetcher
    
    private var revealedPostIds = [Int]()
    private var feedResponse: FeedResponse?
    private var newFromInProcess: String?
    
    init() {
        self.authService = AppDelegate.shared().authService
        self.networking = NetworkService(authService: authService)
        self.fetcher = NetworkDataFetcher(networking: networking)
    }
    
    func getFeed(completion: @escaping ([Int], FeedResponse) -> Void) {
        fetcher.getFeed(nextBatchFrom: nil) { [weak self] feedResponse in
            self?.feedResponse = feedResponse
            guard let feedResponse = self?.feedResponse else { return }
            completion(self!.revealedPostIds, feedResponse)
        }
    }
    
    func getUser(completion: @escaping (UserResponse?) -> Void) {
        fetcher.getUser { userResponse in
            completion(userResponse)
        }
    }
    
    func revealPostIds(forPostId postId: Int, completion: @escaping ([Int], FeedResponse) -> Void) {
        revealedPostIds.append(postId)
        guard let feedResponse = self.feedResponse else { return }
        completion(revealedPostIds, feedResponse)
    }
    
    func getNextBatch(completion: @escaping ([Int], FeedResponse) -> Void) {
        newFromInProcess = feedResponse?.nextFrom
        fetcher.getFeed(nextBatchFrom: newFromInProcess) { [weak self] feedResponse in
            guard let feedResponse = feedResponse else { return }
            guard self?.feedResponse?.nextFrom != feedResponse.nextFrom else { return }
            
            if self?.feedResponse == nil {
                self?.feedResponse = feedResponse
            } else {
                self?.feedResponse?.items.append(contentsOf: feedResponse.items)
                self?.feedResponse?.nextFrom = feedResponse.nextFrom
                
                var profiles = feedResponse.profiles
                if let oldProfiles = self?.feedResponse?.profiles {
                    let allProfilesFiltered = oldProfiles.filter { oldProfile in
                        !feedResponse.profiles.contains(where: { $0.id == oldProfile.id })
                    }
                    profiles.append(contentsOf: allProfilesFiltered)
                }
                self?.feedResponse?.profiles = profiles
                
                var groups = feedResponse.groups
                if let oldProfiles = self?.feedResponse?.groups {
                    let allGroupsFiltered = oldProfiles.filter { oldGroup in
                        !feedResponse.profiles.contains(where: { $0.id == oldGroup.id })
                    }
                    groups.append(contentsOf: allGroupsFiltered)
                }
                self?.feedResponse?.groups = groups
            }
            
            guard let feedResponse = self?.feedResponse else { return }
            completion(self!.revealedPostIds, feedResponse)
        }
    }
}
