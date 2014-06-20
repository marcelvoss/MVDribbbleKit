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
#import "MVPlayer.h"
#import "MVComment.h"

typedef NS_ENUM(NSInteger, List) {
    ListDebuts,
    ListEveryone,
    ListPopular,
};

typedef NS_ENUM(NSInteger, UserType) {
    UserTypeFollowers,
    UserTypeFollowing,
    UserTypeDraftees
};

typedef NS_ENUM(NSInteger, RespondType) {
    RespondTypeComments,
    RespondTypeRebounds
};

typedef void (^SuccessHandler) (NSArray *resultsArray);
typedef void (^FailureHandler) (NSError *error, NSHTTPURLResponse *response);

@interface MVDribbbleKit : NSObject

/**
 *  The number of items per page. The default value is 15 and the maximum value is 30.
 */
@property (nonatomic) NSNumber *itemsPerPage;

#pragma mark - Miscellaneous

- (id)init;

#pragma mark - Players

- (void)getDetailsForPlayer:(NSString *)playerID
                    success:(void (^) (MVPlayer *player))success
                    failure:(FailureHandler)failure;

- (void)getUsersOfType:(UserType)userType forPlayer:(NSString *)playerID page:(NSNumber *)page
               success:(SuccessHandler)success
               failure:(FailureHandler)failure;

#pragma mark - Shots

- (void)getShotWithID:(NSNumber *)shotID
              success:(void (^) (MVShot *shot))success
              failure:(FailureHandler)failure;

- (void)getShotsOnList:(List)list page:(NSNumber *)page
               success:(SuccessHandler)success
               failure:(FailureHandler)failure;

- (void)getShotsByPlayer:(NSString *)playerID page:(NSNumber *)page
                 success:(SuccessHandler)success
                 failure:(FailureHandler)failure;

- (void)getLikedShotsByPlayer:(NSString *)playerID page:(NSNumber *)page
                      success:(SuccessHandler)success
                      failure:(FailureHandler)failure;

- (void)getTimelineOfPlayer:(NSString *)playerID page:(NSNumber *)page
                         success:(SuccessHandler)success
                         failure:(FailureHandler)failure;

- (void)getResponsesOfType:(RespondType)respondType forShot:(NSNumber *)shotID page:(NSNumber *)page
                   success:(SuccessHandler)success
                   failure:(FailureHandler)failure;

@end
