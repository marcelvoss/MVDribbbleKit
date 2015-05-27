// MVComment.m
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

#import "MVComment.h"

@implementation MVComment

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        _commentID = [self objectForKeyOrNil:dictionary[@"id"]];
        _body = [self objectForKeyOrNil:dictionary[@"body"]];
        _likesCount = [self objectForKeyOrNil:dictionary[@"likes_count"]];
        _likesURL = [self objectForKeyOrNil:[NSURL URLWithString:dictionary[@"likes_url"]]];
        
        // Parse the date
        // Example: 2014-07-02T15:46:06Z
        ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
        _createdDate = [formatter dateFromString:dictionary[@"created_at"]];
        
        NSDictionary *userDictionary = dictionary[@"user"];
        _user = [[MVUser alloc] initWithDictionary:userDictionary];
        
    }
    return self;
}

@end
