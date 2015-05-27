// MVShot.m
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

#import "MVShot.h"

@implementation MVShot

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _attachmentsCount = [self objectForKeyOrNil:dictionary[@"attachments_count"]];
        _attachmentsURL = [self objectForKeyOrNil:[NSURL URLWithString:dictionary[@"attachments_url"]]];
        _bucketsCount = [self objectForKeyOrNil:dictionary[@"buckets_count"]];
        _commentsCount = [self objectForKeyOrNil:dictionary[@"comments_count"]];
        _commentsURL = [self objectForKeyOrNil:[NSURL URLWithString:dictionary[@"comments_url"]]];
        _htmlURL = [self objectForKeyOrNil:[NSURL URLWithString:dictionary[@"html_url"]]];
        _shotID = [self objectForKeyOrNil:dictionary[@"id"]];
        _viewsCount = [self objectForKeyOrNil:dictionary[@"views_count"]];
        _likesCount = [self objectForKeyOrNil:dictionary[@"likes_count"]];
        _likesURL = [self objectForKeyOrNil:[NSURL URLWithString:dictionary[@"likes_url"]]];
        _reboundsCount = [self objectForKeyOrNil:dictionary[@"rebounds_count"]];
        _reboundsURL = [self objectForKeyOrNil:[NSURL URLWithString:dictionary[@"rebounds_url"]]];
        _title = [self objectForKeyOrNil:dictionary[@"title"]];
        _user = [[MVUser alloc] initWithDictionary:dictionary[@"user"]];
        _shotDescription = [self objectForKeyOrNil:dictionary[@"description"]];
        _projectsURL = [self objectForKeyOrNil:[NSURL URLWithString:dictionary[@"projects_url"]]];
        _team = [[MVUser alloc] initWithDictionary:[self objectForKeyOrNil:dictionary[@"team"]]];
        
        
        NSMutableArray *tagsArray = [NSMutableArray array];
        for (NSString *tag in dictionary[@"tags"]) {
            [tagsArray addObject:tag];
        }
        _tags = tagsArray;
        
        
        NSDictionary *images = [self objectForKeyOrNil:dictionary[@"images"]];
        _highDPIImageURL = [NSURL URLWithString:[self objectForKeyOrNil:images[@"hidpi"]]];
        _teaserImageURL = [NSURL URLWithString:[self objectForKeyOrNil:images[@"teaser"]]];
        _normalImageURL = [NSURL URLWithString:[self objectForKeyOrNil:images[@"normal"]]];
        

        ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
        _createdDate = [formatter dateFromString:dictionary[@"created_at"]];
        _updatedDate = [formatter dateFromString:dictionary[@"updated_at"]];
    }
    return self;
}

@end
