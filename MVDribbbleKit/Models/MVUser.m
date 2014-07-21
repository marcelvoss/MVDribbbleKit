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

#import "MVUser.h"

@implementation MVUser

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _avatarURL = [NSURL URLWithString:[dictionary objectForKey:@"avatar_url"]];
        _bio = [dictionary objectForKey:@"bio"];
        _createdDate = [dictionary objectForKey:@"created_at"];
        _followersCount = [dictionary objectForKey:@"followers_count"];
        _followingsCount = [dictionary objectForKey:@"following_count"];
        
        _htmlURL = [NSURL URLWithString:[dictionary objectForKey:@"html_url"]];
        _followersURL = [NSURL URLWithString:[dictionary objectForKey:@"followers_url"]];
        _likesURL = [NSURL URLWithString:[dictionary objectForKey:@"likes_url"]];
        
        _userID = [dictionary objectForKey:@"id"];
        _likesCount = [dictionary objectForKey:@"likes_count"];
        
        _location = [dictionary objectForKey:@"location"];
        _name  = [dictionary objectForKey:@"name"];
        _shotsCount  = [dictionary objectForKey:@"shots_count"];
        _shotsURL = [NSURL URLWithString:[dictionary objectForKey:@"shots_url"]];
        _teamsURL = [NSURL URLWithString:[dictionary objectForKey:@"teams_url"]];
        _updatedDate = [dictionary objectForKey:@"updated_at"];
        _username = [dictionary objectForKey:@"username"];
        
        _links = [dictionary objectForKey:@"links"];
        
        if ([[dictionary objectForKey:@"type"] isEqualToString:@"Player"]) {
            _accountType = AccountTypePlayer;
        } else if ([[dictionary objectForKey:@"type"] isEqualToString:@"Team"]) {
            _accountType = AccountTypeTeam;
        }
        
        if ([[dictionary objectForKey:@"pro"] isEqualToNumber:[NSNumber numberWithBool:0]]) {
            _pro = NO;
        } else {
            _pro = YES;
        }
    }
    return self;
}

@end
