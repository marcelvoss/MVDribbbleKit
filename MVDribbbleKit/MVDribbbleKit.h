// MVDribbbleKit.h
//
// Copyright (c) 2014 Marcel Voss
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

#import "MVShot.h"
#import "MVLike.h"
#import "MVUser.h"
#import "MVComment.h"
#import "MVAttachment.h"

#import "MVConstants.h"
#import "MVAuthBrowser.h"

typedef NS_ENUM(NSInteger, List) {
    ListAnimated,
    ListDebuts,
    ListPlayoffs,
    ListRebounds,
    ListTeams
};

typedef NS_ENUM(NSInteger, UserType) {
    UserTypeFollowers,
    UserTypeFollowing,
    UserTypeDraftees
};

typedef void (^SuccessHandler) (NSArray *resultsArray, NSHTTPURLResponse *response);
typedef void (^FailureHandler) (NSError *error, NSHTTPURLResponse *response);

@interface MVDribbbleKit : NSObject

@property (nonatomic) NSNumber *itemsPerPage;
@property (nonatomic) BOOL allowsCellularAccess;

@property (nonatomic) NSArray *scopes;

@property (nonatomic, copy) NSString *clientID;
@property (nonatomic, copy) NSString *clientSecret;
@property (nonatomic, copy) NSString *callbackURL;

@property (nonatomic, copy) NSString *accessToken;

#pragma mark - Miscellaneous

+ (MVDribbbleKit *)sharedInstance;
- (instancetype)initWithClientID:(NSString *)clientID secretID:(NSString *)secretID callbackURL:(NSString *)callbackURL;

#pragma mark - Authorization

- (void)authorizeWithCompletion:(void (^) (NSError *error, NSString *accessToken))completion;
- (void)setClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret callbackURL:(NSString *)callbackURL;

#pragma mark - Users

// If playerID is nil, return the authenticated player
- (void)getDetailsForUser:(NSString *)userID
                    success:(void (^) (MVUser *user, NSHTTPURLResponse *response))success
                    failure:(FailureHandler)failure;

- (void)getFollowersForUser:(NSString *)userID page:(NSInteger)page
                      success:(SuccessHandler)success
                      failure:(FailureHandler)failure;

- (void)getFollowingsForUser:(NSString *)userID page:(NSInteger)page
                      success:(SuccessHandler)success
                      failure:(FailureHandler)failure;

- (void)followUserWithID:(NSString *)userID
                   success:(void (^) (NSHTTPURLResponse *response))success
                   failure:(FailureHandler)failure;

- (void)unfollowUserWithID:(NSString *)userID
                     success:(void (^) (NSHTTPURLResponse *response))success
                     failure:(FailureHandler)failure;

#pragma mark - Teams

// If playerID is nil, use the authenticated player
- (void)getTeamsForUserWithID:(NSString *)userID page:(NSInteger)page
                        success:(SuccessHandler)success
                        failure:(FailureHandler)failure;

#pragma mark - Shots

- (void)getShotWithID:(NSInteger)shotID
              success:(void (^) (MVShot *shot, NSHTTPURLResponse *response))success
              failure:(FailureHandler)failure;

// TODO: Needs optimization
- (void)createShotWithTitle:(NSString *)title image:(NSData *)imageData
                description:(NSString *)description tags:(NSArray *)tags team:(NSInteger)teamID reboundTo:(NSInteger)reboundShot
                    success:(void (^) (MVShot *shot, NSHTTPURLResponse *response))success
                    failure:(FailureHandler)failure;

- (void)updateShotWithID:(NSInteger)shotID title:(NSString *)title
             description:(NSString *)description tags:(NSArray *)tags teamID:(NSInteger)teamID
                 success:(void (^) (MVShot *shot, NSHTTPURLResponse *respose))success
                 failure:(FailureHandler)failure;

// TODO: Still missing
- (void)getShotsOnList:(List)list page:(NSInteger)page
               success:(SuccessHandler)success
               failure:(FailureHandler)failure;

- (void)getShotsByUser:(NSString *)userID page:(NSInteger)page
                 success:(SuccessHandler)success
                 failure:(FailureHandler)failure;

- (void)getLikedShotsByUser:(NSString *)userID page:(NSInteger)page
                      success:(SuccessHandler)success
                      failure:(FailureHandler)failure;

// TODO: Needs a new name
- (void)getTimelineOfUser:(NSString *)userID page:(NSInteger)page
                         success:(SuccessHandler)success
                         failure:(FailureHandler)failure;

- (void)getLikesForShot:(NSInteger)shotID page:(NSInteger)page
                success:(SuccessHandler)success
                failure:(FailureHandler)failure;

- (void)likeShotWithID:(NSInteger)shotID
               success:(void (^) (MVLike *like, NSHTTPURLResponse *response))success
               failure:(FailureHandler)failure;

- (void)unlikeShotWithID:(NSInteger)shotID
                 success:(void (^) (NSHTTPURLResponse *response))success
                 failure:(FailureHandler)failure;

- (void)deleteShotWithID:(NSInteger)shotID
                 success:(void (^) (NSHTTPURLResponse *response))success
                 failure:(FailureHandler)failure;

#pragma mark - Attachments

- (void)getAttachmentsForShot:(NSInteger)shotID page:(NSInteger)page
                      success:(SuccessHandler)success
                      failure:(FailureHandler)failure;

- (void)getAttachmentWithID:(NSInteger)attachmentID onShot:(NSInteger)shotID
                    success:(void (^) (MVAttachment *attachment, NSHTTPURLResponse *response))success
                    failure:(FailureHandler)failure;

- (void)createAttachmentForShot:(NSInteger)shotID fromData:(NSData *)attachmentData
                        success:(void (^) (MVAttachment *attachment, NSHTTPURLResponse *response))success
                        failure:(FailureHandler)failure;

- (void)deleteAttachmetWithID:(NSInteger)attachmentID onShot:(NSInteger)shotID
                      success:(void (^) (NSHTTPURLResponse *response))success
                      failure:(FailureHandler)failure;

#pragma mark - Comments

- (void)getCommentsForShot:(NSInteger)shotID page:(NSInteger)page
                   success:(SuccessHandler)success
                   failure:(FailureHandler)failure;

- (void)getLikesForCommentWithID:(NSInteger)commentID onShot:(NSInteger)shotID page:(NSInteger)page
                         success:(SuccessHandler)success
                         failure:(FailureHandler)failure;

- (void)createCommentForShot:(NSInteger)shotID body:(NSString *)body
                     success:(void (^) (MVComment *comment, NSHTTPURLResponse *response))success
                     failure:(FailureHandler)failure;

// FIXME: Doesn't work
- (void)updateCommentWithID:(NSInteger)commentID onShot:(NSInteger)shotID body:(NSString *)body
                    success:(void (^) (MVComment *comment, NSHTTPURLResponse *response))success
                    failure:(FailureHandler)failure;

- (void)likeCommentWithID:(NSInteger)commentID onShot:(NSInteger)shotID
                  success:(void (^) (MVLike *like, NSHTTPURLResponse *response))success
                  failure:(FailureHandler)failure;

- (void)unlikeCommentWithID:(NSInteger)commentID onShot:(NSInteger)shotID
                  success:(void (^) (NSHTTPURLResponse *response))success
                  failure:(FailureHandler)failure;

#pragma mark - Rebounds

- (void)getReboundsForShot:(NSInteger)shotID page:(NSInteger)page
                   success:(SuccessHandler)success
                   failure:(FailureHandler)failure;

@end
