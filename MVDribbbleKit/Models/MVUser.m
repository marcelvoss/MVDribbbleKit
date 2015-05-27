// MVPlayer.m
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

#import "MVUser.h"

@implementation MVUser

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        _avatarURL = [NSURL URLWithString:dictionary[@"avatar_url"]];
        _bio = dictionary[@"bio"];
        _followersCount = dictionary[@"followers_count"];
        _followingsCount = dictionary[@"following_count"];
        
        _htmlURL = [NSURL URLWithString:dictionary[@"html_url"]];
        _followersURL = [NSURL URLWithString:dictionary[@"followers_url"]];
        _followingURL = [NSURL URLWithString:dictionary[@"following_url"]];
        _likesURL = [NSURL URLWithString:dictionary[@"likes_url"]];
        
        _userID = dictionary[@"id"];
        _likesCount = dictionary[@"likes_count"];
        
        _location = dictionary[@"location"];
        _name  = dictionary[@"name"];
        _shotsCount  = dictionary[@"shots_count"];
        _shotsURL = [NSURL URLWithString:dictionary[@"shots_url"]];
        _teamsURL = [NSURL URLWithString:dictionary[@"teams_url"]];
        _username = dictionary[@"username"];
        
        _links = dictionary[@"links"];
        
        if ([dictionary[@"type"] isEqualToString:@"Player"]) {
            _accountType = AccountTypePlayer;
        } else if ([dictionary[@"type"] isEqualToString:@"Team"]) {
            _accountType = AccountTypeTeam;
        }
        
        if ([dictionary[@"pro"] isEqualToNumber:[NSNumber numberWithBool:0]]) {
            _pro = NO;
        } else {
            _pro = YES;
        }
        
        ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
        _createdDate = [formatter dateFromString:dictionary[@"created_at"]];
        _updatedDate = [formatter dateFromString:dictionary[@"updated_at"]];
    }
    return self;
}

@end
