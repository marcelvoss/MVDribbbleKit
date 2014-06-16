//
//  MVPlayer.m
//  DribbbleExample
//
//  Created by Marcel Voß on 15.06.14.
//  Copyright (c) 2014 Marcel Voss. All rights reserved.
//

#import "MVPlayer.h"

@implementation MVPlayer

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _playerID = [dictionary objectForKey:@"id"];
        _name  = [dictionary objectForKey:@"name"];
        _username = [dictionary objectForKey:@"username"];
        _url  = [dictionary objectForKey:@"url"];
        _avatarURL = [dictionary objectForKey:@"avatar_url"];
        _location = [dictionary objectForKey:@"location"];
        _twitterScreenName = [dictionary objectForKey:@"twitter_screen_name"];
        _draftedByPlayerID = [dictionary objectForKey:@"drafted_by_player_id"];
        _shotsCount  = [dictionary objectForKey:@"shots_count"];
        _drafteesCount = [dictionary objectForKey:@"draftees_count"];
        _followersCount = [dictionary objectForKey:@"followers_count"];
        _followingCount = [dictionary objectForKey:@"following_count"];
        _commentsCount = [dictionary objectForKey:@"comments_count"];
        _commentsReceivedCount = [dictionary objectForKey:@"comments_received_count"];
        _likesCount = [dictionary objectForKey:@"likes_count"];
        _likesReceivedCount = [dictionary objectForKey:@"likes_received_count"];
        _reboundsCount = [dictionary objectForKey:@"rebounds_count"];
        _reboundsReceivedCount = [dictionary objectForKey:@"rebounds_received_count"];
        _createdDate = [dictionary objectForKey:@"created_at"];
    }
    return self;
}

@end
