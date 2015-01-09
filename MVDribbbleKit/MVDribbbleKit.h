// MVDribbbleKit.h
//
// Copyright (c) 2014-2015 Marcel Voss
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
#import "MVBucket.h"
#import "MVProject.h"

#import "MVConstants.h"
#import "MVAuthBrowser.h"

typedef NS_ENUM(NSInteger, List) {
    ListAnimated,
    ListDebuts,
    ListPlayoffs,
    ListRebounds,
    ListTeams,
    ListAll
};

typedef NS_ENUM(NSInteger, SortType) {
    SortTypePopularity,
    SortTypeComments,
    SortTypeViews,
    SortTypeRecent
};

typedef NS_ENUM(NSInteger, UserType) {
    UserTypeFollowers,
    UserTypeFollowing,
    UserTypeDraftees
};

typedef void (^SuccessHandler) (NSArray *resultsArray, NSHTTPURLResponse *response);
typedef void (^ShotHandler) (MVShot *shot, NSHTTPURLResponse *response);
typedef void (^LikeHandler) (MVLike *like, NSHTTPURLResponse *response);
typedef void (^ProjectHandler) (MVProject *project, NSHTTPURLResponse *response);
typedef void (^UserHandler) (MVUser *user, NSHTTPURLResponse *response);
typedef void (^BucketHandler) (MVBucket *bucket, NSHTTPURLResponse *response);
typedef void (^AttachmentHandler) (MVAttachment *attachment, NSHTTPURLResponse *response);
typedef void (^CommentHandler) (MVComment *comment, NSHTTPURLResponse *response);

typedef void (^FailureHandler) (NSError *error, NSHTTPURLResponse *response);

/** Objective-C wrapper for the Dribbble API. See http://developer.dribbble.com/v1/ and https://github.com/marcelvoss/MVDribbbleKit for more information. */
@interface MVDribbbleKit : NSObject

/**
 Number of items per page.
 */
@property (nonatomic) NSNumber *itemsPerPage;

/**
 Boolean that specifies whether to allow cellular access.
 */
@property (nonatomic) BOOL allowsCellularAccess;

/**
 Dribbble API scope. By default "write", "public", "comment", and "upload are selected.
 */
@property (nonatomic) NSArray *scopes;

/**
 Application Client ID.
 */
@property (nonatomic, copy) NSString *clientID;

/**
 Client secret.
 */
@property (nonatomic, copy) NSString *clientSecret;

/**
 Callback URL.
 */
@property (nonatomic, copy) NSString *callbackURL;

/**
 API access token.
 */
@property (nonatomic, copy) NSString *accessToken;

#pragma mark - Miscellaneous

/**
 Shared manager.
 */
+ (MVDribbbleKit *)sharedManager;

/**
 Initialize MVDribbbleKit.
 @param clientID Client ID.
 @param secretID Client Secret.
 @param callbackURL Callback URL.
 */
- (instancetype)initWithClientID:(NSString *)clientID secretID:(NSString *)secretID callbackURL:(NSString *)callbackURL;

#pragma mark - Authorization

/**
 Authorize the user.
 @param completion Block that returns error, access token.
 */
- (void)authorizeWithCompletion:(void (^) (NSError *error, NSString *accessToken))completion;

/**
 Set MVDribbbleKit parameters.
 @param clientID Client ID.
 @param secretID Client Secret.
 @param callbackURL Callback URL.
 */
- (void)setClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret callbackURL:(NSString *)callbackURL;

#pragma mark - Users

/**
 Get details for user. If userID is nil, return the authenticated user.
 @param userID ID of the user.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the MVUser and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)getDetailsForUser:(NSString *)userID
                    success:(UserHandler)success
                    failure:(FailureHandler)failure;

/**
 Get followers for user.
 @param page Results page.
 @param userID ID of the user.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the list of results and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)getFollowersForUser:(NSString *)userID page:(NSInteger)page
                      success:(SuccessHandler)success
                      failure:(FailureHandler)failure;

/**
 Get users followed by a user.
 @param page Results page.
 @param userID ID of the user.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the list of results and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)getFollowingsForUser:(NSString *)userID page:(NSInteger)page
                      success:(SuccessHandler)success
                      failure:(FailureHandler)failure;

/**
 Follow a user.
 @param userID ID of the user.
 @param success Block to be executed when the request finishes successfully. This block takes one argument: the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)followUserWithID:(NSString *)userID
                   success:(void (^) (NSHTTPURLResponse *response))success
                   failure:(FailureHandler)failure;

/**
 Unfollow a user.
 @param userID ID of the user.
 @param success Block to be executed when the request finishes successfully. This block takes one argument: the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)unfollowUserWithID:(NSString *)userID
                     success:(void (^) (NSHTTPURLResponse *response))success
                     failure:(FailureHandler)failure;

#pragma mark - Teams

/**
 Get teams for a user. If userID is nil, use the authenticated user.
 @param userID ID of the user.
 @param page Results page.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the list of results and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)getTeamsForUserWithID:(NSString *)userID page:(NSInteger)page
                        success:(SuccessHandler)success
                        failure:(FailureHandler)failure;

#pragma mark - Shots

/**
 List shots.
 @param date Limit the timeframe to a specific date.
 @param sorting Limit results to a specific `SortType` (SortTypePopularity, SortTypeComments, SortTypeViews, SortTypeRecent).
 @param page Results page.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the list of results and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)getShotsOnList:(List)list date:(NSDate *)date sort:(SortType)sorting  page:(NSInteger)page
               success:(SuccessHandler)success
               failure:(FailureHandler)failure;

/**
 Get a shot.
 @param shotID ID of the shot.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the MVShot and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)getShotWithID:(NSInteger)shotID
              success:(ShotHandler)success
              failure:(FailureHandler)failure;

/**
 Create a shot.
 @param title Title of the shot.
 @param imageData Image of the shot.
 @param description Description of the shot.
 @param tags Tags for the shot.
 @param teamID ID of the team to associate the shot with.
 @param reboundShot ID of the shot that the new shot is a rebound of.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the MVShot and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
// TODO: Needs optimization
- (void)createShotWithTitle:(NSString *)title image:(NSData *)imageData
                description:(NSString *)description tags:(NSArray *)tags team:(NSInteger)teamID reboundTo:(NSInteger)reboundShot
                    success:(ShotHandler)success
                    failure:(FailureHandler)failure;

/**
 Update a shot.
 @param shotID ID of the shot.
 @param title Title of the shot.
 @param description Description of the shot.
 @param tags Tags for the shot.
 @param teamID ID of the team to associate the shot with.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the MVShot and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)updateShotWithID:(NSInteger)shotID title:(NSString *)title
             description:(NSString *)description tags:(NSArray *)tags teamID:(NSInteger)teamID
                 success:(ShotHandler)success
                 failure:(FailureHandler)failure;

/**
 Delete a shot.
 @param shotID ID of the shot.
 @param success Block to be executed when the request finishes successfully. This block takes one argument: the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
// TODO: Debug this
- (void)deleteShotWithID:(NSInteger)shotID
                 success:(void (^) (NSHTTPURLResponse *response))success
                 failure:(FailureHandler)failure;

// TODO: Still missing


/*
 Get shots for user.
 @param userID ID of the user.
 @param page Results page.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the list of results and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)getShotsByUser:(NSString *)userID page:(NSInteger)page
                 success:(SuccessHandler)success
                 failure:(FailureHandler)failure;

/*
 Get shots liked by user.
 @param userID ID of the user.
 @param page Results page.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the list of results and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)getLikedShotsByUser:(NSString *)userID page:(NSInteger)page
                      success:(SuccessHandler)success
                      failure:(FailureHandler)failure;

/**
 Get timeline for user.
 @param userID ID of the user.
 @param page Results page.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the list of results and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
// TODO: Needs a new name
- (void)getTimelineOfUser:(NSString *)userID page:(NSInteger)page
                         success:(SuccessHandler)success
                         failure:(FailureHandler)failure;

#pragma mark - Likes

/**
 List the likes for a shot.
 @param shotID ID of the shot.
 @param page Results page.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the list of results and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)getLikesForShot:(NSInteger)shotID page:(NSInteger)page
                success:(SuccessHandler)success
                failure:(FailureHandler)failure;

/**
 Like a shot. Liking a shot requires the user to be authenticated with the "write" scope.
 @param shotID ID of the shot.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the MVLike and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)likeShotWithID:(NSInteger)shotID
               success:(LikeHandler)success
               failure:(FailureHandler)failure;

/**
 Unlike a shot. Liking a shot requires the user to be authenticated with the "write" scope.
 @param shotID ID of the shot.
 @param success Block to be executed when the request finishes successfully. This block takes one argument: the request response. 
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)unlikeShotWithID:(NSInteger)shotID
                 success:(void (^) (NSHTTPURLResponse *response))success
                 failure:(FailureHandler)failure;

/**
 Check if shot is liked.
 @param shotID ID of the shot.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the MVLike and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)checkIfShotIsLiked:(NSInteger)shotID
                   success:(LikeHandler)success
                   failure:(FailureHandler)failure;


#pragma mark - Attachments

/**
 Get attachments for shot.
 @param shotID ID of the shot.
 @param page Results page.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the list of results and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)getAttachmentsForShot:(NSInteger)shotID page:(NSInteger)page
                      success:(SuccessHandler)success
                      failure:(FailureHandler)failure;

/**
 Get attachment for shot.
 @param attachmentID ID of the attachment
 @param shotID ID of the shot.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the MVAttachment and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)getAttachmentWithID:(NSInteger)attachmentID onShot:(NSInteger)shotID
                    success:(AttachmentHandler)success
                    failure:(FailureHandler)failure;

/**
 Create attachment for shot.
 @param shotID ID of the shot.
 @param attachmentData Image for the attachment.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the MVAttachment and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)createAttachmentForShot:(NSInteger)shotID fromData:(NSData *)attachmentData
                        success:(AttachmentHandler)success
                        failure:(FailureHandler)failure;

/**
 Delete attachment for shot.
 @param attachmentID ID of the attachment
 @param shotID ID of the shot.
 @param success Block to be executed when the request finishes successfully. This block takes one argument: the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)deleteAttachmetWithID:(NSInteger)attachmentID onShot:(NSInteger)shotID
                      success:(void (^) (NSHTTPURLResponse *response))success
                      failure:(FailureHandler)failure;

#pragma mark - Comments

/**
 Get comments for shot.
 @param shotID ID of the shot.
 @param page Results page.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the list of results and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)getCommentsForShot:(NSInteger)shotID page:(NSInteger)page
                   success:(SuccessHandler)success
                   failure:(FailureHandler)failure;

/**
 Get likes for comments.
 @param commentID ID of the comment.
 @param shotID ID of the shot.
 @param page Results page.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the list of results and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)getLikesForCommentWithID:(NSInteger)commentID onShot:(NSInteger)shotID page:(NSInteger)page
                         success:(SuccessHandler)success
                         failure:(FailureHandler)failure;

/**
 Add a comment for shot.
 @param shotID ID of the shot.
 @param body Comment body.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the MVComment and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)createCommentForShot:(NSInteger)shotID body:(NSString *)body
                     success:(CommentHandler)success
                     failure:(FailureHandler)failure;

/**
 Get comment.
 @param commentID ID of the comment.
 @param shotID ID of the shot.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the MVComment and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)getCommentWithID:(NSInteger)commentID onShot:(NSInteger)shotID
                 success:(CommentHandler)success
                 failure:(FailureHandler)failure;

/**
 Update comment.
 @param commentID ID of the comment.
 @param shotID ID of the shot.
 @param body Comment body.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the MVComment and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
// FIXME: Doesn't work
- (void)updateCommentWithID:(NSInteger)commentID onShot:(NSInteger)shotID body:(NSString *)body
                    success:(CommentHandler)success
                    failure:(FailureHandler)failure;

/**
 Like a comment.
 @param commentID ID of the comment.
 @param shotID ID of the shot.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the MVLike and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)likeCommentWithID:(NSInteger)commentID onShot:(NSInteger)shotID
                  success:(LikeHandler)success
                  failure:(FailureHandler)failure;

/**
 Unlike a comment.
 @param commentID ID of the comment.
 @param shotID ID of the shot.
 @param success Block to be executed when the request finishes successfully. This block takes one argument: the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)unlikeCommentWithID:(NSInteger)commentID onShot:(NSInteger)shotID
                  success:(void (^) (NSHTTPURLResponse *response))success
                  failure:(FailureHandler)failure;

/**
 Check if comment is liked.
 @param commentID ID of the comment.
 @param shotID ID of the shot.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the MVLike and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)checkIfCommentIsLiked:(NSInteger)commentID onShot:(NSInteger)shotID
                      success:(LikeHandler)success
                      failure:(FailureHandler)failure;

#pragma mark - Rebounds

/**
 Get rebounds for shot.
 @param shotID ID of the shot.
 @param page Results page.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the list of results and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)getReboundsForShot:(NSInteger)shotID page:(NSInteger)page
                   success:(SuccessHandler)success
                   failure:(FailureHandler)failure;

#pragma mark - Buckets

/**
 Get bucket.
 @param bucketID ID of the bucket.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the MVBucket and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)getBucketWithID:(NSInteger)bucketID
                success:(BucketHandler)success
                failure:(FailureHandler)failure;

/**
 Create bucket.
 @param bucketName Name of the bucket.
 @param description Description of the bucket.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the MVBucket and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)createBucketWithName:(NSString *)bucketName description:(NSString *)bucketDescription
                     success:(BucketHandler)success
                     failure:(FailureHandler)failure;

/**
 Update bucket
 @param bucketID ID of the bucket.
 @param bucketName Name of the bucket.
 @param description Description of the bucket.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the MVBucket and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)updateBucketWithID:(NSInteger)bucketID name:(NSString *)bucketName description:(NSString *)bucketDescription
                   success:(BucketHandler)success
                   failure:(FailureHandler)failure;

/**
 Delete bucket.
 @param bucketID ID of the bucket.
 @param success Block to be executed when the request finishes successfully. This block takes one argument: the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)deleteBucketWithID:(NSInteger)bucketID
                   success:(void (^) (NSHTTPURLResponse *response))success
                   failure:(FailureHandler)failure;

/**
 Get shots in bucklet.
 @param bucketID ID of the bucket.
 @param page Results page.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the list of results and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)getShotsInBucket:(NSInteger)bucketID page:(NSInteger)page
                 success:(SuccessHandler)success
                 failure:(FailureHandler)failure;

/**
 Add shot to bucket.
 @param shotID ID of the shot.
 @param bucketID ID of the bucket.
 @param success Block to be executed when the request finishes successfully. This block takes one argument: the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)addShotToBucket:(NSInteger)shotID bucket:(NSInteger)bucketID
                success:(void (^) (NSHTTPURLResponse *response))success
                failure:(FailureHandler)failure;

/**
 Remove shot from bucket.
 @param shotID ID of the shot.
 @param bucketID ID of the bucket.
 @param success Block to be executed when the request finishes successfully. This block takes one argument: the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)removeShotFromBucket:(NSInteger)shotID bucket:(NSInteger)bucketID
                     success:(void (^) (NSHTTPURLResponse *response))success
                     failure:(FailureHandler)failure;

#pragma mark - Projects

/**
 Get project.
 @param projectID ID of the project.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the MVProject and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)getProjectWithID:(NSInteger)projectID
                 success:(ProjectHandler)success
                 failure:(FailureHandler)failure;

/**
 Get shots in project.
 @param projectID ID of the project.
 @param success Block to be executed when the request finishes successfully. This block takes two arguments: the list of results and the request response.
 @param failure Block to be executed when the request finishes unsuccessfully. This block takes two arguments: the error and the request response.
 */
- (void)getShotsInProject:(NSInteger)projectID
                  success:(SuccessHandler)success
                  failure:(FailureHandler)failure;

@end
