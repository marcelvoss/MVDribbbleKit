// MVPlayer.m
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

#import "MVPlayer.h"

@implementation MVPlayer

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        _playerID = [dictionary objectForKey:@"id"];
        _name  = [dictionary objectForKey:@"name"];
        _username = [dictionary objectForKey:@"username"];
        
        _url  = [NSURL URLWithString:[dictionary objectForKey:@"url"]];
        _avatarURL = [NSURL URLWithString:[dictionary objectForKey:@"avatar_url"]];
        
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
        
        // Parse the date
        // Example: 2014/07/17 14:24:35 -0400
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss ZZZZ";
        _createdDate = [formatter dateFromString:[dictionary objectForKey:@"created_at"]];
        
    }
    return self;
}

@end
