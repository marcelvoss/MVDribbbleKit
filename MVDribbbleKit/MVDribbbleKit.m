// MVDribbbleKit.m
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

#import "MVDribbbleKit.h"

#import <SSKeychain/SSKeychain.h>
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>

@interface MVDribbbleKit (Private)

// Retrieve access token from keychain
- (NSString *)retrieveToken;
- (NSString *)stringForScope:(MVDribbbleScope)scope;

// Used for retrieving resources.
- (void)GETOperationWithURL:(NSString *)url parameters:(NSDictionary *)parameters
                        success:(void (^) (NSDictionary *results, NSHTTPURLResponse *response))success
                        failure:(void (^) (NSError *error, NSHTTPURLResponse *response))failure;

// Used for updating resources, or performing custom actions.
- (void)PUTOperationWithURL:(NSString *)url parameters:(NSDictionary *)parameters
                     success:(void (^) (NSDictionary *results, NSHTTPURLResponse *response))success
                     failure:(void (^) (NSError *error, NSHTTPURLResponse *response))failure;

// Used for creating resources.
- (void)POSTOperationWithURL:(NSString *)url parameters:(NSDictionary *)parameters
                     success:(void (^) (NSDictionary *results, NSHTTPURLResponse *response))success
                     failure:(void (^) (NSError *error, NSHTTPURLResponse *response))failure;

// Used for deleting resources.
- (void)DELETEOperationWithURL:(NSString *)url parameters:(NSDictionary *)parameters
                       success:(void (^) (NSHTTPURLResponse *response))success
                       failure:(void (^) (NSError *error, NSHTTPURLResponse *response))failure;

@end

@implementation MVDribbbleKit

#pragma mark - Miscellaneous

- (instancetype)initWithClientID:(NSString *)clientID secretID:(NSString *)secretID callbackURL:(NSString *)callbackURL
{
    self = [super init];
    if (self) {
        _clientID = clientID;
        _clientSecret = secretID;
        _callbackURL = callbackURL;
    }
    return self;
}

+ (MVDribbbleKit *)sharedManager
{
    static MVDribbbleKit *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MVDribbbleKit new];
        instance.itemsPerPage = @30;
    });
    return instance;
}

#pragma mark - Authorization

// TODO: Needs more error handling
- (void)authorizeWithCompletion:(void (^)(NSError *, BOOL))completion
{
    // GET /oauth/authorize
    // GET https://dribbble.com/oauth/authorize
    
    NSMutableString *urlString;
    
    // Create a scopes string
    if (_scopes == nil) {
        
        // If the _scopes array is empty, it'll automatically use all four scopes
        urlString = [NSMutableString stringWithFormat:@"%@/oauth/authorize?client_id=%@&scope=write+upload+public+comment", kBaseURL, _clientID];
        
    } else {
        NSMutableString *tempString = [NSMutableString stringWithFormat:@"%@/oauth/authorize?client_id=%@&scope=", kBaseURL, _clientID];
        
        for (id scope in _scopes) {
            if (_scopes.lastObject == scope) {
                [tempString appendString:[self stringForScope:(MVDribbbleScope)scope]];
            } else {
                NSString *string = [NSString stringWithFormat:@"%@+", [self stringForScope:(MVDribbbleScope)scope]];
                [tempString appendString:string];
            }
            
        }
        urlString = tempString;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];

    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIViewController *controller = window.rootViewController;
    
    MVAuthBrowser *authBrowser = [[MVAuthBrowser alloc] initWithURL:url];
    authBrowser.callbackURL = [NSURL URLWithString:_callbackURL];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:authBrowser];
    
    [controller presentViewController:navController animated:YES completion:nil];
    
    authBrowser.completionHandler = ^(NSURL *url, NSError *error) {
        // TODO: Remove these calls
        NSLog(@"Error: %@", error);
        NSLog(@"URL: %@", url);
        
        if (error == nil) {
            // POST /oauth/token
            // https://dribbble.com/oauth/token
            
            NSString *urlString = [NSString stringWithFormat:@"%@/oauth/token", kBaseURL];
            
            // Extract the temporary code
            NSString *codeString = [[url query] stringByReplacingOccurrencesOfString:@"code=" withString:@""];
            
            // Exchange the temporary code for an access token
            [self POSTOperationWithURL:urlString parameters:@{@"client_id": _clientID, @"client_secret": _clientSecret, @"code": codeString} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
                
                NSString *accessToken = [results objectForKey:@"access_token"];
                NSLog(@"Your access token: %@", accessToken);
                
                NSError *keychainError = nil;
                [SSKeychain setPassword:accessToken forService:kDribbbbleKeychainService
                                account:kDribbbleAccountName error:&keychainError];
                
                if (keychainError) {
                    completion(nil, NO);
                } else {
                    completion(nil, YES);
                }
                
            } failure:^(NSError *error, NSHTTPURLResponse *response) {
                completion(error, NO);
            }];
        } else {
            completion(error, NO);
        }
    };
}

- (void)setClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret callbackURL:(NSString *)callbackURL
{
    _clientID = clientID;
    _clientSecret = clientSecret;
    _callbackURL = callbackURL;
}

- (BOOL)isAuthorized
{
    if ([SSKeychain accountsForService:kDribbbbleKeychainService]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)removeAccount
{
    if ([SSKeychain accountsForService:kDribbbbleKeychainService]) {
        NSString *accountUsername = [[SSKeychain accountsForService:kDribbbbleKeychainService][0]
                                     valueForKey:kSSKeychainAccountKey];
        
        NSError *deletionError = nil;
        [SSKeychain deletePasswordForService:kDribbbbleKeychainService account:accountUsername
                                       error:&deletionError];
        
        if (deletionError) {
            NSLog(@"Couldn't delete token");
        }
    }
}

#pragma mark - Users

- (void)isUser:(NSString *)userID followingUser:(NSString *)targetUserID
       success:(void (^)(NSHTTPURLResponse *, BOOL))success
       failure:(FailureHandler)failure
{
    if (userID) {
        // GET /users/:user/following/:target_user
        
        NSString *urlString = [NSString stringWithFormat:@"%@/user/%@/following/%@", kBaseURL, userID, targetUserID];
        
        [self GETOperationWithURL:urlString parameters:@{} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
            
            if (response.statusCode == 204) {
                success(response, YES);
            } else {
                success(response, NO);
            }
            
        } failure:^(NSError *error, NSHTTPURLResponse *response) {
            failure(error, response);
        }];
    } else {
        // GET /user/following/:user
        
        NSString *urlString = [NSString stringWithFormat:@"%@/user/following/%@", kBaseURL, targetUserID];
        
        [self GETOperationWithURL:urlString parameters:@{} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
            
            if (response.statusCode == 204) {
                success(response, YES);
            } else {
                success(response, NO);
            }
            
        } failure:^(NSError *error, NSHTTPURLResponse *response) {
            failure(error, response);
        }];
    }
}

- (void)getDetailsForUser:(NSString *)userID
                    success:(void (^)(MVUser *, NSHTTPURLResponse *))success
                    failure:(FailureHandler)failure
{
    if (userID == nil) {
        // Get details for the authorized player
        // GET /user
        
        [self GETOperationWithURL:[NSString stringWithFormat:@"%@/user", kAPIBaseURL] parameters:@{} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
            
            MVUser *user = [[MVUser alloc] initWithDictionary:results];
            success(user, response);
            
        } failure:^(NSError *error, NSHTTPURLResponse *response) {
            failure(error, response);
        }];
        
    } else {
        // Get details for the specified player
        // GET /users/:user
        
        [self GETOperationWithURL:[NSString stringWithFormat:@"%@/users/%@", kAPIBaseURL, userID] parameters:@{} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
            
            MVUser *user = [[MVUser alloc] initWithDictionary:results];
            success(user, response);
            
        } failure:^(NSError *error, NSHTTPURLResponse *response) {
            failure(error, response);
        }];
    }
}

- (void)getFollowersForUser:(NSString *)userID page:(NSInteger)page
                      success:(SuccessHandler)success
                      failure:(FailureHandler)failure
{
    if (userID == nil) {
        // List the authenticated user's followers:
        // GET /user/followers
        
        NSString *urlString = [NSString stringWithFormat:@"%@/user/followers", kAPIBaseURL];
        
        [self GETOperationWithURL:urlString parameters:@{@"page": [NSNumber numberWithInteger:page]} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
            
            NSMutableArray *parsedResultsArray = [NSMutableArray array];
            
            for (NSDictionary *userDictionary in results) {
                MVUser *user = [[MVUser alloc] initWithDictionary:userDictionary];
                [parsedResultsArray addObject:user];
            }
            
            success(parsedResultsArray, response);
            
        } failure:^(NSError *error, NSHTTPURLResponse *response) {
            failure(error, response);
        }];
        
    } else {
        // List a user's followers:
        // GET /users/:user/followers
        
        NSString *urlString = [NSString stringWithFormat:@"%@/users/%@/followers", kAPIBaseURL, userID];
        
        [self GETOperationWithURL:urlString parameters:@{@"page": [NSNumber numberWithInteger:page]} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
            
            NSMutableArray *parsedResultsArray = [NSMutableArray array];
            
            for (NSDictionary *userDictionary in results) {
                MVUser *user = [[MVUser alloc] initWithDictionary:userDictionary];
                [parsedResultsArray addObject:user];
            }
            
            success(parsedResultsArray, response);
            
        } failure:^(NSError *error, NSHTTPURLResponse *response) {
            failure(error, response);
        }];
    }
}

- (void)getFollowingsForUser:(NSString *)userID page:(NSInteger)page
                       success:(SuccessHandler)success
                       failure:(FailureHandler)failure
{
    if (userID == nil) {
        // List who the authenticated user is following:
        // GET /user/following
        
        NSString *urlString = [NSString stringWithFormat:@"%@/users/following", kAPIBaseURL];
        
        [self GETOperationWithURL:urlString parameters:@{@"page": [NSNumber numberWithInteger:page]} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
            
            NSMutableArray *parsedResultsArray = [NSMutableArray array];
            
            for (NSDictionary *userDictionary in results) {
                MVUser *user = [[MVUser alloc] initWithDictionary:userDictionary];
                [parsedResultsArray addObject:user];
            }
            
            success(parsedResultsArray, response);
            
        } failure:^(NSError *error, NSHTTPURLResponse *response) {
            failure(error, response);
        }];
        
        
    } else {
        // List who a user is following:
        // GET /users/:user/following
        
        NSString *urlString = [NSString stringWithFormat:@"%@/users/%@/following", kAPIBaseURL, userID];
        
        [self GETOperationWithURL:urlString parameters:@{@"page": [NSNumber numberWithInteger:page]} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
            
            NSMutableArray *parsedResultsArray = [NSMutableArray array];
            
            for (NSDictionary *userDictionary in results) {
                MVUser *user = [[MVUser alloc] initWithDictionary:userDictionary];
                [parsedResultsArray addObject:user];
            }
            
            success(parsedResultsArray, response);
            
        } failure:^(NSError *error, NSHTTPURLResponse *response) {
            failure(error, response);
        }];
        
    }
}


- (void)followUserWithID:(NSString *)userID
                   success:(void (^)(NSHTTPURLResponse *))success
                   failure:(FailureHandler)failure
{
    // Follow a user
    // PUT /users/:user/follow
    
    NSString *urlString = [NSString stringWithFormat:@"%@/users/%@/follow", kAPIBaseURL, userID];
    
    [self PUTOperationWithURL:urlString parameters:nil success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        NSLog(@"%@ %@", results, response);
        success(response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)unfollowUserWithID:(NSString *)userID
                     success:(void (^)(NSHTTPURLResponse *))success
                     failure:(FailureHandler)failure
{
    // Unfollow a user
    // DELETE /users/:user/follow
    
    NSString *urlString = [NSString stringWithFormat:@"%@/users/%@/follow", kAPIBaseURL, userID];
    
    [self DELETEOperationWithURL:urlString parameters:nil success:^(NSHTTPURLResponse *response) {
        
        success(response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}


#pragma mark - Teams

- (void)getTeamsForUserWithID:(NSString *)userID page:(NSInteger)page
                        success:(SuccessHandler)success
                        failure:(FailureHandler)failure
{
    if (userID == nil) {
        // List the authenticated user's teams:
        // GET /user/teams
        
        NSString *urlString = [NSString stringWithFormat:@"%@/user/teams", kAPIBaseURL];
        
        [self GETOperationWithURL:urlString parameters:@{@"page": [NSNumber numberWithInteger:page]} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
            
            NSMutableArray *parsedResultsArray = [NSMutableArray array];
            
            for (NSDictionary *userDictionary in results) {
                MVUser *user = [[MVUser alloc] initWithDictionary:userDictionary];
                [parsedResultsArray addObject:user];
            }
            
            success(parsedResultsArray, response);
            
        } failure:^(NSError *error, NSHTTPURLResponse *response) {
            failure(error, response);
        }];
        
    } else {
        // List a user's teams:
        // GET /users/:user/teams
        
        NSString *urlString = [NSString stringWithFormat:@"%@/users/%@/teams", kAPIBaseURL, userID];
        
        [self GETOperationWithURL:urlString parameters:@{@"page": [NSNumber numberWithInteger:page]} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
            
            NSMutableArray *parsedResultsArray = [NSMutableArray array];
            
            for (NSDictionary *userDictionary in results) {
                MVUser *user = [[MVUser alloc] initWithDictionary:userDictionary];
                [parsedResultsArray addObject:user];
            }
            
            success(parsedResultsArray, response);
            
        } failure:^(NSError *error, NSHTTPURLResponse *response) {
            failure(error, response);
        }];
        
    }
}

#pragma mark - Shots

- (void)getShotsOnList:(MVDribbbleList)list
                  date:(NSDate *)date
                  sort:(MVDribbbleSort)sorting
             timeframe:(MVDribbbleTimeframe)timeframe
                  page:(NSInteger)page
               success:(SuccessHandler)success
               failure:(FailureHandler)failure
{
    // List shots
    // GET /shots
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shots", kAPIBaseURL];
    
    NSString *listString;
    switch (list) {
        case MVDribbbleListAnimated:
            listString = @"animated";
            break;
        case MVDribbbleListDebuts:
            listString = @"debuts";
            break;
        case MVDribbbleListPlayoffs:
            listString = @"playoffs";
            break;
        case MVDribbbleListRebounds:
            listString = @"rebounds";
            break;
        case MVDribbbleListTeams:
            listString = @"teams";
            break;
        case MVDribbbleListAll:
            listString = @"all";
            break;
        default:
            listString = @"all";
            break;
    }
    
    NSString *sortingString;
    switch (sorting) {
        case MVDribbbleSortPopularity:
            sortingString = @"popularity";
            break;
        case MVDribbbleSortComments:
            sortingString = @"comments";
            break;
        case MVDribbbleSortViews:
            sortingString = @"views";
            break;
        case MVDribbbleSortRecent:
            sortingString = @"recent";
            break;
        default:
            sortingString = @"popularity";
            break;
    }
    
    NSString *timeframeString;
    switch (timeframe) {
        case MVDribbbleTimeframeWeek:
            timeframeString = @"week";
            break;
        case MVDribbbleTimeframeMonth:
            timeframeString = @"month";
            break;
        case MVDribbbleTimeframeYear:
            timeframeString = @"year";
            break;
        case MVDribbbleTimeframeEver:
            timeframeString = @"ever";
            break;
        default:
            timeframeString = nil;
            break;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    [self GETOperationWithURL:urlString parameters:@{@"list": listString, @"sort": sortingString, @"page": [NSNumber numberWithInteger:page], @"timeframe": timeframeString} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        NSMutableArray *parsedResultsArray = [NSMutableArray array];
        for (NSDictionary *dictionary in results) {
            
            MVShot *shot = [[MVShot alloc] initWithDictionary:dictionary];
            [parsedResultsArray addObject:shot];
            
        }
        success(parsedResultsArray, response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)getShotWithID:(NSInteger)shotID
              success:(void (^)(MVShot *, NSHTTPURLResponse *))success
              failure:(FailureHandler)failure
{
    // Get a shot
    // GET /shots/:id
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shots/%@", kAPIBaseURL, @(shotID)];
    
    [self GETOperationWithURL:urlString parameters:nil success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        MVShot *shot = [[MVShot alloc] initWithDictionary:results];
        success(shot, response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

// Should be done
// Can't really test it
- (void)createShotWithTitle:(NSString *)title image:(NSData *)imageData description:(NSString *)description
                       tags:(NSArray *)tags team:(NSInteger)teamID reboundTo:(NSInteger)reboundShot
                    success:(void (^)(MVShot *, NSHTTPURLResponse *))success
                    failure:(FailureHandler)failure
{
    // Create a shot
    // POST /shots
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shots", kAPIBaseURL];
    
    [self POSTOperationWithURL:urlString parameters:@{@"title": title, @"description": description, @"tags": tags, @"image": imageData, @"team_id": [NSNumber numberWithInteger:teamID], @"rebound_source_id": [NSNumber numberWithInteger:reboundShot]} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        MVShot *shot = [[MVShot alloc] initWithDictionary:results];
        success(shot, response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

// Should be done
// Can't really test it
- (void)updateShotWithID:(NSInteger)shotID title:(NSString *)title description:(NSString *)description
                    tags:(NSArray *)tags teamID:(NSInteger)teamID
                 success:(void (^)(MVShot *, NSHTTPURLResponse *))success
                 failure:(FailureHandler)failure
{
    // Update a shot
    // PUT /shots/:id
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shots/%ld", kAPIBaseURL, (long)shotID];
    
    [self PUTOperationWithURL:urlString parameters:@{@"title": title, @"description": description, @"tags": tags, @"team_id": [NSNumber numberWithInteger:teamID]} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        MVShot *shot = [[MVShot alloc] initWithDictionary:results];
        success(shot, response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)deleteShotWithID:(NSInteger)shotID
                 success:(void (^)(NSHTTPURLResponse *))success
                 failure:(FailureHandler)failure
{
    // Delete a shot
    // DELETE /shots/:id
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shots/%@", kAPIBaseURL, @(shotID)];
    
    [self DELETEOperationWithURL:urlString parameters:nil success:^(NSHTTPURLResponse *response) {
        
        success(response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)getShotsByUser:(NSString *)userID page:(NSInteger)page
                      success:(SuccessHandler)success
                      failure:(FailureHandler)failure
{
    // List shots for a user
    
    if (userID == nil) {
        // GET /user/shots
        
        NSString *urlString = [NSString stringWithFormat:@"%@/users/shots", kAPIBaseURL];
        
        [self GETOperationWithURL:urlString parameters:@{@"page": [NSNumber numberWithInteger:page]} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
            
            NSMutableArray *parsedResultsArray = [NSMutableArray array];
            for (NSDictionary *dictionary in results) {
                MVShot *shot = [[MVShot alloc] initWithDictionary:dictionary];
                [parsedResultsArray addObject:shot];
            }
            
            success(parsedResultsArray, response);
            
        } failure:^(NSError *error, NSHTTPURLResponse *response) {
            failure(error, response);
        }];
    } else {
        // GET /users/:user/shots
        
        NSString *urlString = [NSString stringWithFormat:@"%@/users/%@/shots", kAPIBaseURL, userID];
        
        [self GETOperationWithURL:urlString parameters:@{@"page": [NSNumber numberWithInteger:page]} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
            
            NSMutableArray *parsedResultsArray = [NSMutableArray array];
            for (NSDictionary *dictionary in results) {
                MVShot *shot = [[MVShot alloc] initWithDictionary:dictionary];
                [parsedResultsArray addObject:shot];
            }
            
            success(parsedResultsArray, response);
            
        } failure:^(NSError *error, NSHTTPURLResponse *response) {
            failure(error, response);
        }];
    }
}

- (void)getLikedShotsByUser:(NSString *)userID page:(NSInteger)page
                      success:(SuccessHandler)success
                      failure:(FailureHandler)failure
{
    // List shot likes for a user
    
    if (userID == nil) {
        // GET /user/likes
        
        NSString *urlString = [NSString stringWithFormat:@"%@/user/likes", kAPIBaseURL];
        
        [self GETOperationWithURL:urlString parameters:@{@"page": [NSNumber numberWithInteger:page]} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
            
            NSLog(@"%@", results);
            
            NSMutableArray *parsedResultsArray = [NSMutableArray array];
            for (NSDictionary *dictionary in results) {
                MVShot *shot = [[MVShot alloc] initWithDictionary:dictionary];
                [parsedResultsArray addObject:shot];
            }
            
            success(parsedResultsArray, response);
            
        } failure:^(NSError *error, NSHTTPURLResponse *response) {
            failure(error, response);
        }];
        
    } else {
        // GET /users/:user/likes
        
        NSString *urlString = [NSString stringWithFormat:@"%@/user/%@/likes", kAPIBaseURL, userID];
        
        [self GETOperationWithURL:urlString parameters:@{@"page": [NSNumber numberWithInteger:page]} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
            
            NSMutableArray *parsedResultsArray = [NSMutableArray array];
            for (NSDictionary *dictionary in results) {
                MVShot *shot = [[MVShot alloc] initWithDictionary:dictionary];
                [parsedResultsArray addObject:shot];
            }
            
            success(parsedResultsArray, response);
            
        } failure:^(NSError *error, NSHTTPURLResponse *response) {
            failure(error, response);
        }];
    }
}

// TODO: Missing
- (void)getTimelineOfUser:(NSString *)userID page:(NSInteger)page
                         success:(SuccessHandler)success
                         failure:(FailureHandler)failure
{
    // GET /user/following/shots
    
}

- (void)getLikesForShot:(NSInteger)shotID page:(NSInteger)page
                success:(SuccessHandler)success
                failure:(FailureHandler)failure
{
    // List the likes for a shot
    // GET /shots/:id/likes
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shots/%@/likes", kAPIBaseURL, @(shotID)];
    
    [self GETOperationWithURL:urlString parameters:@{@"page": [NSNumber numberWithInteger:page]} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        NSMutableArray *likesArray = [NSMutableArray array];
        for (NSDictionary *dictionary in results) {
            MVLike *like = [[MVLike alloc] initWithDictionary:dictionary];
            [likesArray addObject:like];
        }
        
        success(likesArray, response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)likeShotWithID:(NSInteger)shotID
               success:(void (^)(MVLike *, NSHTTPURLResponse *))success
               failure:(FailureHandler)failure
{
    // Like a shot
    // POST /shots/:id/like
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shots/%@/like", kAPIBaseURL, @(shotID)];
    
    [self POSTOperationWithURL:urlString parameters:@{@"id": [NSNumber numberWithInteger:shotID]} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        MVLike *like = [[MVLike alloc] initWithDictionary:results];
        success(like, response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)unlikeShotWithID:(NSInteger)shotID
                 success:(void (^)(NSHTTPURLResponse *))success
                 failure:(FailureHandler)failure
{
    // Unlike a shot
    // DELETE /shots/:id/like
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shots/%@/like", kAPIBaseURL, @(shotID)];
    
    [self DELETEOperationWithURL:urlString parameters:nil success:^(NSHTTPURLResponse *response) {
        
        success(response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)isShotLiked:(NSInteger)shotID
            success:(LikeHandler)success
            failure:(FailureHandler)failure
{
    // Check if you like a shot
    // GET /shots/:id/like
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shots/%ld/like", kAPIBaseURL, shotID];
    
    [self GETOperationWithURL:urlString parameters:@{} success:^(NSDictionary *results, NSHTTPURLResponse *response) {

        MVLike *like = [[MVLike alloc] initWithDictionary:results];
        success(like, response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

#pragma mark - Attachments

- (void)getAttachmentsForShot:(NSInteger)shotID page:(NSInteger)page
                      success:(SuccessHandler)success
                      failure:(FailureHandler)failure
{
    // List attachments for a shot
    // GET /shots/:id/attachments
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shots/%@/attachments", kAPIBaseURL, @(shotID)];
    
    [self GETOperationWithURL:urlString parameters:@{@"page": [NSNumber numberWithInteger:page]} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        NSMutableArray *attachmentsArray = [NSMutableArray array];
        for (NSDictionary *dictionary in results) {
            MVAttachment *attachment = [[MVAttachment alloc] initWithDictionary:dictionary];
            [attachmentsArray addObject:attachment];
        }
        
        success(attachmentsArray, response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)getAttachmentWithID:(NSInteger)attachmentID onShot:(NSInteger)shotID
                    success:(void (^)(MVAttachment *, NSHTTPURLResponse *))success
                    failure:(FailureHandler)failure
{
    // Get a single attachme
    // GET /shots/:shot/attachments/:id
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shots/%@/attachments/%@", kAPIBaseURL, @(shotID), @(attachmentID)];
    
    [self GETOperationWithURL:urlString parameters:nil success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        MVAttachment *attachment = [[MVAttachment alloc] initWithDictionary:results];
        success(attachment, response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}


- (void)createAttachmentForShot:(NSInteger)shotID fromData:(NSData *)attachmentData
                        success:(void (^)(MVAttachment *, NSHTTPURLResponse *))success
                        failure:(FailureHandler)failure
{
    // Create an attachment
    // POST /shots/:shot/attachments
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/attachment", kAPIBaseURL, @(shotID)];
    
    [self POSTOperationWithURL:urlString parameters:@{@"file": attachmentData} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        MVAttachment *attachment = [[MVAttachment alloc] initWithDictionary:results];
        success(attachment, response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)deleteAttachmetWithID:(NSInteger)attachmentID onShot:(NSInteger)shotID
                      success:(void (^)(NSHTTPURLResponse *))success
                      failure:(FailureHandler)failure
{
    // Delete an attachment
    // DELETE /shots/:shot/attachments/:id
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shots/%@/attachments/%@", kAPIBaseURL, @(shotID), @(attachmentID)];
    
    [self DELETEOperationWithURL:urlString parameters:nil success:^(NSHTTPURLResponse *response) {
    
        success(response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

#pragma mark - Comments

- (void)getCommentsForShot:(NSInteger)shotID page:(NSInteger)page
                   success:(SuccessHandler)success
                   failure:(FailureHandler)failure
{
    // List comments for a shot
    // GET /shots/:shot/comments
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shots/%@/comments", kAPIBaseURL, @(shotID)];
    
    [self GETOperationWithURL:urlString parameters:@{@"page": [NSNumber numberWithInteger:page]} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        NSMutableArray *commentArray = [NSMutableArray array];
        for (NSDictionary *dictionary in results) {
            MVComment *comment = [[MVComment alloc] initWithDictionary:dictionary];
            [commentArray addObject:comment];
        }
        
        success(commentArray, response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)getLikesForCommentWithID:(NSInteger)commentID onShot:(NSInteger)shotID page:(NSInteger)page
                         success:(SuccessHandler)success
                         failure:(FailureHandler)failure
{
    // List likes for a comment
    // GET /shots/:shot/comments/:id/likes
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shots/%@/comments/%@/likes", kAPIBaseURL, @(shotID), @(commentID)];
    
    [self GETOperationWithURL:urlString parameters:@{@"page": [NSNumber numberWithInteger:page]} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        NSMutableArray *parsedResultsArray = [NSMutableArray array];
        for (NSDictionary *dictionary in results) {
            MVLike *like = [[MVLike alloc] initWithDictionary:dictionary];
            [parsedResultsArray addObject:like];
        }
        
        success(parsedResultsArray, response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)createCommentForShot:(NSInteger)shotID body:(NSString *)body
                     success:(void (^) (MVComment *, NSHTTPURLResponse *))success
                     failure:(FailureHandler)failure
{
    // Create a comment
    // POST /shots/:shot/comments
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shots/%@/comments", kAPIBaseURL, @(shotID)];
    
    [self POSTOperationWithURL:urlString parameters:@{@"body": body} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        MVComment *comment = [[MVComment alloc] initWithDictionary:results];
        success(comment, response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)getCommentWithID:(NSInteger)commentID onShot:(NSInteger)shotID
                 success:(void (^)(MVComment *, NSHTTPURLResponse *))success
                 failure:(FailureHandler)failure
{
    // GET /shots/:shot/comments/:id
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shots/%@/comments/%@", kAPIBaseURL, @(shotID), @(commentID)];
    
    [self GETOperationWithURL:urlString parameters:@{} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        MVComment *comment = [[MVComment alloc] initWithDictionary:results];
        success(comment, response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)updateCommentWithID:(NSInteger)commentID onShot:(NSInteger)shotID body:(NSString *)body
                    success:(void (^)(MVComment *, NSHTTPURLResponse *))success
                    failure:(FailureHandler)failure
{
    // Update a comment
    // PUT /shots/:shot/comments/:id
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shots/%@/comments/%@", kAPIBaseURL, @(shotID), @(commentID)];
    
    [self PUTOperationWithURL:urlString parameters:@{@"body": body} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        MVComment *comment= [[MVComment alloc] initWithDictionary:results];
        success(comment, response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
    
}

- (void)likeCommentWithID:(NSInteger)commentID onShot:(NSInteger)shotID
                  success:(void (^)(MVLike *, NSHTTPURLResponse *))success
                  failure:(FailureHandler)failure
{
    // Like a comment
    // POST /shots/:shot/comments/:id/like
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shots/%@/comments/%@/like", kAPIBaseURL, @(shotID), @(commentID)];
    
    [self POSTOperationWithURL:urlString parameters:@{@"shot_id": [NSNumber numberWithInteger:shotID], @"comment_id": [NSNumber numberWithInteger:commentID]} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        MVLike *like = [[MVLike alloc] initWithDictionary:results];
        success(like, response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)unlikeCommentWithID:(NSInteger)commentID onShot:(NSInteger)shotID
                    success:(void (^)(NSHTTPURLResponse *))success
                    failure:(FailureHandler)failure
{
    // Unlike a comment
    // DELETE /shots/:shot/comments/:id/like
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shots/%@/comments/%@/like", kAPIBaseURL, @(shotID), @(commentID)];
    
    [self DELETEOperationWithURL:urlString parameters:nil success:^(NSHTTPURLResponse *response) {
        
        success(response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)checkIfCommentIsLiked:(NSInteger)commentID onShot:(NSInteger)shotID
                      success:(void (^)(MVLike *, NSHTTPURLResponse *))success
                      failure:(FailureHandler)failure
{
    // GET /shots/:shot/comments/:id/like
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shots/%@/comments/%@/like", kAPIBaseURL, @(shotID), @(commentID)];
    
    [self GETOperationWithURL:urlString parameters:@{} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

#pragma mark - Rebounds

- (void)getReboundsForShot:(NSInteger)shotID page:(NSInteger)page
                   success:(SuccessHandler)success
                   failure:(FailureHandler)failure
{
    // List rebounds for a shot
    // GET /shots/:id/rebounds
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shots/%@/rebounds", kAPIBaseURL, @(shotID)];
    
    [self GETOperationWithURL:urlString parameters:@{@"page": [NSNumber numberWithInteger:page]} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        NSMutableArray *reboundsArray = [NSMutableArray array];
        
        for (NSDictionary *dictionary in results) {
            MVShot *shot = [[MVShot alloc] initWithDictionary:dictionary];
            [reboundsArray addObject:shot];
        }
        
        success(reboundsArray, response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

#pragma mark - Buckets

- (void)getBucketWithID:(NSInteger)bucketID
                success:(void (^)(MVBucket *, NSHTTPURLResponse *))success
                failure:(FailureHandler)failure
{
    // GET /buckets/:id
    
    NSString *urlString = [NSString stringWithFormat:@"%@/buckets/%@", kAPIBaseURL, @(bucketID)];
    
    [self GETOperationWithURL:urlString parameters:@{} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        MVBucket *bucket = [[MVBucket alloc] initWithDictionary:results];
        success(bucket, response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)createBucketWithName:(NSString *)bucketName description:(NSString *)bucketDescription
                     success:(void (^)(MVBucket *, NSHTTPURLResponse *))success
                     failure:(FailureHandler)failure
{
    // POST /buckets
    
    NSString *urlString = [NSString stringWithFormat:@"%@/buckets", kAPIBaseURL];
    
    [self POSTOperationWithURL:urlString parameters:@{@"name": bucketName, @"description": bucketDescription} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        MVBucket *bucket = [[MVBucket alloc] initWithDictionary:results];
        success(bucket, response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)updateBucketWithID:(NSInteger)bucketID name:(NSString *)bucketName description:(NSString *)bucketDescription
                   success:(void (^)(MVBucket *, NSHTTPURLResponse *))success
                   failure:(FailureHandler)failure
{
    // PUT /buckets/:id
    
    NSString *urlString = [NSString stringWithFormat:@"%@/buckets/%@", kAPIBaseURL, @(bucketID)];
    
    [self PUTOperationWithURL:urlString parameters:@{@"name": bucketName, @"description": bucketDescription} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        MVBucket *bucket = [[MVBucket alloc] initWithDictionary:results];
        success(bucket, response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)deleteBucketWithID:(NSInteger)bucketID
                   success:(void (^)(NSHTTPURLResponse *))success
                   failure:(FailureHandler)failure
{
    // DELETE /buckets/:id
    
    NSString *urlString = [NSString stringWithFormat:@"%@/buckets/%@", kAPIBaseURL, @(bucketID)];
    
    [self DELETEOperationWithURL:urlString parameters:nil success:^(NSHTTPURLResponse *response) {
        
        success(response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)getShotsInBucket:(NSInteger)bucketID page:(NSInteger)page
                 success:(SuccessHandler)success
                 failure:(FailureHandler)failure
{
    // GET /bucket/:id/shots
    
    NSString *urlString = [NSString stringWithFormat:@"%@/buckets/%@/shots", kAPIBaseURL, @(bucketID)];
    
    [self GETOperationWithURL:urlString parameters:@{@"page": [NSNumber numberWithInteger:page]} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        NSMutableArray *shotsArray = [NSMutableArray array];
        
        for (NSDictionary *dictionary in results) {
            MVShot *shot = [[MVShot alloc] initWithDictionary:dictionary];
            [shotsArray addObject:shot];
        }
        
        success(shotsArray, response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)addShotToBucket:(NSInteger)shotID bucket:(NSInteger)bucketID
                success:(void (^) (NSHTTPURLResponse *response))success
                failure:(FailureHandler)failure
{
    // PUT /buckets/:id/shots
    
    NSString *urlString = [NSString stringWithFormat:@"%@/buckets/%@/shots", kAPIBaseURL, @(bucketID)];
    
    [self PUTOperationWithURL:urlString parameters:@{@"shot_id": [NSNumber numberWithInteger:shotID]} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        success(response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

// FIXME: Doesn't work
- (void)removeShotFromBucket:(NSInteger)shotID bucket:(NSInteger)bucketID
                     success:(void (^) (NSHTTPURLResponse *response))success
                     failure:(FailureHandler)failure
{
    // DELETE /buckets/:id/shots
    
    NSString *urlString = [NSString stringWithFormat:@"%@/buckets/%@/shots", kAPIBaseURL, @(bucketID)];
    
    [self DELETEOperationWithURL:urlString parameters:@{@"shot_id": [NSNumber numberWithInteger:shotID]} success:^(NSHTTPURLResponse *response) {
        
        
        NSLog(@"%@", response);
        NSLog(@"success");
        success(response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
        NSLog(@"%@", response);
        NSLog(@"error");
    }];
}

#pragma mark - Projects

- (void)getProjectWithID:(NSInteger)projectID
                 success:(void (^)(MVProject *, NSHTTPURLResponse *))success
                 failure:(FailureHandler)failure
{
    // GET /projects/:id
    
    NSString *urlString = [NSString stringWithFormat:@"%@/projects/%@", kAPIBaseURL, @(projectID)];
    
    [self GETOperationWithURL:urlString parameters:@{} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        MVProject *project = [[MVProject alloc] initWithDictionary:results];
        success(project, response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)getShotsInProject:(NSInteger)projectID
                  success:(SuccessHandler)success
                  failure:(FailureHandler)failure
{
    // GET /project/:id/shots
    
    NSString *urlString = [NSString stringWithFormat:@"%@/projects/%@/shots", kAPIBaseURL, @(projectID)];
    
    [self GETOperationWithURL:urlString parameters:@{} success:^(NSDictionary *results, NSHTTPURLResponse *response) {
        
        NSMutableArray *shotsArray = [NSMutableArray array];
        
        for (NSDictionary *dictionary in results) {
            MVShot *shot = [[MVShot alloc] initWithDictionary:dictionary];
            [shotsArray addObject:shot];
        }
        
        success(shotsArray, response);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

@end

@implementation MVDribbbleKit (Private)

#pragma mark - Private Methods

- (NSString *)retrieveToken
{
    if ([SSKeychain accountsForService:kDribbbbleKeychainService]) {
        NSString *accountUsername = [[SSKeychain accountsForService:kDribbbbleKeychainService][0]
                                     valueForKey:kSSKeychainAccountKey];
        
        return [SSKeychain passwordForService:kDribbbbleKeychainService account:accountUsername];
    } else {
       return nil;
    }
}

- (NSString *)stringForScope:(MVDribbbleScope)scope
{
    if (scope == MVDribbbleScopeComment) {
        return @"comment";
    } else if (scope == MVDribbbleScopePublic) {
        return @"public";
    } else if (scope == MVDribbbleScopeUpload) {
        return @"upload";
    } else if (scope == MVDribbbleScopeWrite) {
        return @"write";
    }
    return nil;
}

// FIXME: Needs fixed networking methods
// FIXME: Make it easier to use parameters because appending them to the urlString isn't nice enough
- (void)GETOperationWithURL:(NSString *)url parameters:(NSDictionary *)parameters
                        success:(void (^) (NSDictionary *, NSHTTPURLResponse *))success
                        failure:(void (^) (NSError *, NSHTTPURLResponse *))failure
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSString *tempTokenString = [NSString stringWithFormat:@"Bearer %@", [self retrieveToken]];
    configuration.HTTPAdditionalHeaders = @{@"Content-Type": @"application/json; charset=utf-8",
                                            @"Authorization": tempTokenString};
    
    if (_allowsCellularAccess) {
        configuration.allowsCellularAccess = YES;
    } else {
        configuration.allowsCellularAccess = NO;
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSMutableString *finalMutableString = [NSMutableString stringWithFormat:@"%@?", url];
    
    if (parameters) {
        // Itterate over the parameters dictionary
        for (id key in parameters) {
            id value = parameters[key];
            [finalMutableString appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
        }
    } else {
        finalMutableString = [url copy];
    }
    
    if (parameters[@"page"]) {
        // Append itemsPerPage
        [finalMutableString appendString:[NSString stringWithFormat:@"per_page=%@", [_itemsPerPage stringValue]]];
    }
    
    NSLog(@"%@", finalMutableString);
    
    [[session dataTaskWithURL:[NSURL URLWithString:finalMutableString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *convertedResponse = (NSHTTPURLResponse *)response;
        
        if (error == nil) {
            NSError *jsonError = nil;
            NSDictionary *serializedResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonError == nil) {
                success(serializedResults, convertedResponse);
            } else {
                failure(jsonError, nil);
            }
        } else {
            failure(error, convertedResponse);
        }
    }] resume];
}

- (void)PUTOperationWithURL:(NSString *)url parameters:(NSDictionary *)parameters
                    success:(void (^)(NSDictionary *, NSHTTPURLResponse *))success
                    failure:(void (^)(NSError *, NSHTTPURLResponse *))failure
{
    NSString *tempTokenString = [NSString stringWithFormat:@"Bearer %@", [self retrieveToken]];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPAdditionalHeaders = @{@"Content-Type": @"application/json; charset=utf-8", @"Authorization": tempTokenString};
    
    if (_allowsCellularAccess) {
        configuration.allowsCellularAccess = YES;
    } else {
        configuration.allowsCellularAccess = NO;
    }
    
    NSDictionary *tempParameters = [NSDictionary dictionary];
    
    if (parameters == nil) {
        tempParameters = @{@"": @""};
    } else {
        tempParameters = parameters;
    }
    
    NSError *error = nil;
    NSData *parameterData = [NSJSONSerialization dataWithJSONObject:tempParameters options:0 error:&error];
    
    if (error == nil) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        request.HTTPMethod = @"PUT";
    
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
        [[session uploadTaskWithRequest:request fromData:parameterData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
            NSHTTPURLResponse *convertedResponse = (NSHTTPURLResponse *)response;
            
            if (error == nil) {
                NSError *jsonError = nil;
                NSDictionary *serializedResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                
                if (jsonError == nil) {
                    success(serializedResults, convertedResponse);
                } else {
                    failure(error, nil);
                }
                
            } else {
                failure(error, convertedResponse);
            }
            
        }] resume];
    } else {
        failure(error, nil);
    }
}

// TODO: Clean this up
- (void)POSTOperationWithURL:(NSString *)url parameters:(NSDictionary *)parameters
                     success:(void (^)(NSDictionary *, NSHTTPURLResponse *))success
                     failure:(void (^)(NSError *, NSHTTPURLResponse *))failure
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSString *tempTokenString = [NSString stringWithFormat:@"Bearer %@", [self retrieveToken]];
    
    if ([self retrieveToken] == nil) {
        configuration.HTTPAdditionalHeaders = @{@"Content-Type": @"application/json; charset=utf-8"};
    } else {
        configuration.HTTPAdditionalHeaders = @{@"Content-Type": @"application/json; charset=utf-8", @"Authorization": tempTokenString};
    }
    
    if (_allowsCellularAccess) {
        configuration.allowsCellularAccess = YES;
    } else {
        configuration.allowsCellularAccess = NO;
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSDictionary *tempParameters = [NSDictionary dictionary];
    
    if (parameters == nil) {
        tempParameters = @{@"": @""};
    } else {
        tempParameters = parameters;
    }
    
    NSError *error = nil;
    NSData *parameterData = [NSJSONSerialization dataWithJSONObject:tempParameters options:0 error:&error];
    
    if (error == nil) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        request.HTTPMethod = @"POST";
        
        [[session uploadTaskWithRequest:request fromData:parameterData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSHTTPURLResponse *convertedResponse = (NSHTTPURLResponse *)response;
            
            if (error == nil) {
                NSError *jsonError = nil;
                NSDictionary *serializedResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                
                if (jsonError == nil) {
                    success(serializedResults, convertedResponse);
                } else {
                    failure(error, nil);
                }
                
            } else {
                failure(error, convertedResponse);
            }
            
       }] resume];
    } else {
        failure(error, nil);
    }
}

// FIXME: Doesn't work correctly
- (void)DELETEOperationWithURL:(NSString *)url parameters:(NSDictionary *)parameters
                       success:(void (^)(NSHTTPURLResponse *))success
                       failure:(void (^)(NSError *, NSHTTPURLResponse *))failure
{
    NSString *tempTokenString = [NSString stringWithFormat:@"Bearer %@", [self retrieveToken]];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPAdditionalHeaders = @{@"Authorization": tempTokenString};
    
    if (_allowsCellularAccess) {
        configuration.allowsCellularAccess = YES;
    } else {
        configuration.allowsCellularAccess = NO;
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"DELETE";
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *convertedResponse = (NSHTTPURLResponse *)response;
        
        if (error == nil) {
            success(convertedResponse);
        } else {
            failure(error, convertedResponse);
        }
  
    }] resume];
}

@end