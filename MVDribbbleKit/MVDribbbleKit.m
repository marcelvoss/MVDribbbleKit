// MVDribbbleKit.m
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

#import "MVDribbbleKit.h"

static const NSString *baseURL = @"http://api.dribbble.com";

@interface MVDribbbleKit (Private)

- (void)networkOperationWithURL:(NSString *)url parameters:(NSDictionary *)parameters
                        success:(void (^)(NSDictionary *results))success
                        failure:(void (^)(NSError *error, NSHTTPURLResponse *response))failure;

@end

@implementation MVDribbbleKit

#pragma mark - Miscellaneous

- (id)init
{
    self = [super init];
    if (self) {
        _itemsPerPage = @15;
    }
    return self;
}

#pragma mark - Players

- (void)getDetailsForPlayer:(NSString *)playerID
                    success:(void (^) (MVPlayer *))success
                    failure:(FailureHandler)failure
{
    // GET /players/:id
    // http://api.dribbble.com/players/simplebits
    
    [self networkOperationWithURL:[NSString stringWithFormat:@"%@/players/%@", baseURL, playerID] parameters:nil success:^(NSDictionary *results) {
        MVPlayer *player = [[MVPlayer alloc] initWithDictionary:results];
        success(player);
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)getUsersOfType:(UserType)userType forPlayer:(NSString *)playerID page:(NSNumber *)page
               success:(SuccessHandler)success
               failure:(FailureHandler)failure
{
    // GET /players/:id/userType
    // http://api.dribbble.com/players/simplebits/followers
    
    NSString *sourceURL;
    
    switch (userType) {
        case UserTypeFollowers:
            // GET /players/:id/followers
            sourceURL = [NSString stringWithFormat:@"%@/players/%@/followers", baseURL, playerID];
            break;
        case UserTypeFollowing:
            // GET /players/:id/following
            sourceURL = [NSString stringWithFormat:@"%@/players/%@/following", baseURL, playerID];
            break;
        case UserTypeDraftees:
            // GET /players/:id/draftees
            sourceURL = [NSString stringWithFormat:@"%@/players/%@/draftees", baseURL, playerID];
            break;
    }
    
    [self networkOperationWithURL:sourceURL parameters:@{@"page": page, @"per_page": _itemsPerPage} success:^(NSDictionary *results) {
        NSMutableArray *parsedUserArray = [NSMutableArray array];
        NSArray *usersArray = [results objectForKey:@"players"];
        
        for (NSDictionary *userDictionary in usersArray) {
            MVPlayer *player = [[MVPlayer alloc] initWithDictionary:userDictionary];
            [parsedUserArray addObject:player];
        }
        
        success(parsedUserArray);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

#pragma mark - Shots

- (void)getShotWithID:(NSNumber *)shotID
              success:(void (^) (MVShot *))success
              failure:(FailureHandler)failure
{
    // GET /shots/:id
    // http://api.dribbble.com/shots/21603
    
    [self networkOperationWithURL:[NSString stringWithFormat:@"%@/shots/%@", baseURL, shotID] parameters:nil success:^(NSDictionary *results) {
        MVShot *shot = [[MVShot alloc] initWithDictionary:results];
        success(shot);
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)getShotsOnList:(List)list page:(NSNumber *)page
               success:(SuccessHandler)success
               failure:(FailureHandler)failure
{
    // GET /shots/:list
    // http://api.dribbble.com/shots/everyone
    
    NSString *sourceURL;
    
    switch (list) {
        case ListEveryone:
            sourceURL = [NSString stringWithFormat:@"%@/shots/everyone", baseURL];
            break;
        case ListPopular:
            sourceURL = [NSString stringWithFormat:@"%@/shots/popular", baseURL];
            break;
        case ListDebuts:
            sourceURL = [NSString stringWithFormat:@"%@/shots/debuts", baseURL];
            break;
    }
    
    [self networkOperationWithURL:sourceURL parameters:@{@"page": page, @"per_page": _itemsPerPage} success:^(NSDictionary *results) {
        NSMutableArray *parsedShotsArray = [NSMutableArray array];
        NSArray *shotsArray = [results objectForKey:@"shots"];
        
        for (NSDictionary *shotDictionary in shotsArray) {
            MVShot *shot = [[MVShot alloc] initWithDictionary:shotDictionary];
            [parsedShotsArray addObject:shot];
        }
        
        success(parsedShotsArray);

    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)getShotsByPlayer:(NSString *)playerID page:(NSNumber *)page
                      success:(SuccessHandler)success
                      failure:(FailureHandler)failure
{
    // GET /players/:id/shots
    // http://api.dribbble.com/players/simplebits/shots
    
    [self networkOperationWithURL:[NSString stringWithFormat:@"%@/players/%@/shots", baseURL, playerID] parameters:@{@"page": page, @"per_page": _itemsPerPage} success:^(NSDictionary *results) {
        
        NSMutableArray *parsedShotsArray = [NSMutableArray array];
        NSArray *shotsArray = [results objectForKey:@"shots"];
        
        for (NSDictionary *shotDictionary in shotsArray) {
            MVShot *shot = [[MVShot alloc] initWithDictionary:shotDictionary];
            [parsedShotsArray addObject:shot];
        }
        
        success(parsedShotsArray);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)getLikedShotsByPlayer:(NSString *)playerID page:(NSNumber *)page
                      success:(SuccessHandler)success
                      failure:(FailureHandler)failure
{
    // GET /players/:id/shots/likes
    // http://api.dribbble.com/players/frogandcode/shots/likes
    
    [self networkOperationWithURL:[NSString stringWithFormat:@"%@/players/%@/shots/likes", baseURL, playerID] parameters:@{@"page": page, @"per_page": _itemsPerPage} success:^(NSDictionary *results) {
        
        NSMutableArray *parsedLikedShotsArray = [NSMutableArray array];
        NSArray *likedShotsArray = [results objectForKey:@"shots"];
        
        for (NSDictionary *likedShotDictionary in likedShotsArray) {
            MVShot *shot = [[MVShot alloc] initWithDictionary:likedShotDictionary];
            [parsedLikedShotsArray addObject:shot];
        }
        
        success(parsedLikedShotsArray);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)getTimelineOfPlayer:(NSString *)playerID page:(NSNumber *)page
                         success:(SuccessHandler)success
                         failure:(FailureHandler)failure
{
    // GET /players/:id/shots/following
    // http://api.dribbble.com/players/frogandcode/shots/following
    
    [self networkOperationWithURL:[NSString stringWithFormat:@"%@/players/%@/shots/following", baseURL, playerID] parameters:@{@"page": page, @"per_page": _itemsPerPage} success:^(NSDictionary *results) {
        
        NSMutableArray *parsedObjectsArray = [NSMutableArray array];
        NSArray *timelineArray = [results objectForKey:@"shots"];
        
        for (NSDictionary *shotDictionary in timelineArray) {
            MVShot *shot = [[MVShot alloc] initWithDictionary:shotDictionary];
            [parsedObjectsArray addObject:shot];
        }
        
        success(parsedObjectsArray);
        
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

- (void)getResponsesOfType:(RespondType)respondType forShot:(NSNumber *)shotID page:(NSNumber *)page
                   success:(SuccessHandler)success
                   failure:(FailureHandler)failure
{
    NSString *sourceURL = [NSString string];
    
    switch (respondType) {
        case RespondTypeComments:
            // GET /shots/:id/comments
            sourceURL = [NSString stringWithFormat:@"%@/shots/%@/comments", baseURL, shotID];
            break;
        case RespondTypeRebounds:
            // GET /shots/:id/rebounds
            sourceURL = [NSString stringWithFormat:@"%@/shots/%@/rebounds", baseURL, shotID];
            break;
    }
    
    [self networkOperationWithURL:sourceURL parameters:@{@"page": page, @"per_page": _itemsPerPage} success:^(NSDictionary *results) {
        
        NSMutableArray *parsedResponsesArray = [NSMutableArray array];
        
        if ([sourceURL isEqualToString:[NSString stringWithFormat:@"%@/shots/%@/comments", baseURL, shotID]]) {
            // Comments
            
            NSArray *commentsArray = [results objectForKey:@"comments"];
            
            for (NSDictionary *commentDictionary in commentsArray) {
                MVComment *comment = [[MVComment alloc] initWithDictionary:commentDictionary];
                [parsedResponsesArray addObject:comment];
            }
            
        } else if ([sourceURL isEqualToString:[NSString stringWithFormat:@"%@/shots/%@/rebounds", baseURL, shotID]]) {
            // Rebounds
            
            NSArray *reboundsArray = [results objectForKey:@"shots"];
            
            for (NSDictionary *reboundDictionary in reboundsArray) {
                MVShot *rebound = [[MVShot alloc] initWithDictionary:reboundDictionary];
                [parsedResponsesArray addObject:rebound];
            }
        }
        
        success(parsedResponsesArray);

    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        failure(error, response);
    }];
}

@end

@implementation MVDribbbleKit (Private)

#pragma mark - Private Methods

- (void)networkOperationWithURL:(NSString *)url parameters:(NSDictionary *)parameters
                        success:(void (^) (NSDictionary *))success
                        failure:(void (^) (NSError *, NSHTTPURLResponse *))failure
{
    // Append Parameters to URL
    NSNumber *pageNumber = [parameters objectForKey:@"page"];
    NSString *urlWithParameters = [NSString stringWithFormat:@"%@/?page=%@&per_page=%@", url, pageNumber, _itemsPerPage];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    if (_allowsCellularAccess) {
        configuration.allowsCellularAccess = YES;
    } else {
        configuration.allowsCellularAccess = NO;
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    [[session dataTaskWithURL:[NSURL URLWithString:urlWithParameters] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSHTTPURLResponse *convertedResponse = (NSHTTPURLResponse *)response;
            failure(error, convertedResponse);
        } else {
            NSDictionary *serializedResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            success(serializedResults);
        }
    }] resume];
}

@end