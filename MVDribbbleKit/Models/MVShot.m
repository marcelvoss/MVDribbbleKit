// MVShot.m
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

#import "MVShot.h"

@implementation MVShot

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _attachmentsCount = [dictionary objectForKey:@"attachments_count"];
        _attachmentsURL = [NSURL URLWithString:[dictionary objectForKey:@"attachments_url"]];
        _bucketsCount = [dictionary objectForKey:@"buckets_count"];
        _commentsCount = [dictionary objectForKey:@"comments_count"];
        _commentsURL = [NSURL URLWithString:[dictionary objectForKey:@"comments_url"]];
        _createdDate = [dictionary objectForKey:@"created_at"];
        _htmlURL = [NSURL URLWithString:[dictionary objectForKey:@"html_url"]];
        _shotID = [dictionary objectForKey:@"id"];
        _viewsCount = [dictionary objectForKey:@"views_count"];
        _likesCount = [dictionary objectForKey:@"likes_count"];
        _likesURL = [NSURL URLWithString:[dictionary objectForKey:@"likes_url"]];
        _reboundsCount = [dictionary objectForKey:@"rebounds_count"];
        _reboundsURL = [NSURL URLWithString:[dictionary objectForKey:@"rebounds_url"]];
        _title = [dictionary objectForKey:@"title"];
        _updatedDate = [dictionary objectForKey:@"updated_at"];
        _user = [[MVUser alloc] initWithDictionary:[dictionary objectForKey:@"user"]];
        _shotDescription = [dictionary objectForKey:@"description"];
        _images = [dictionary objectForKey:@"images"];
        
        if ([dictionary objectForKey:@"team"] == [NSNull null]) {
            _team = nil;
        } else {
            _team = [[MVUser alloc] initWithDictionary:[dictionary objectForKey:@"team"]];
        }
        
        NSMutableArray *tagsArray = [NSMutableArray array];
        for (NSString *tag in [dictionary objectForKey:@"tags"]) {
            [tagsArray addObject:tag];
        }
        _tags = tagsArray;
    }
    return self;
}

@end
