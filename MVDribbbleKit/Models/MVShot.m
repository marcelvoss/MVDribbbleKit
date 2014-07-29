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
        
        _shotID = [dictionary objectForKey:@"id"];
        _title = [dictionary objectForKey:@"title"];
        _shotDescription = [dictionary objectForKey:@"description"];
        
        _url = [NSURL URLWithString:[dictionary objectForKey:@"url"]];
        _shortURL = [NSURL URLWithString:[dictionary objectForKey:@"short_url"]];
        _imageURL = [NSURL URLWithString:[dictionary objectForKey:@"image_url"]];
        _imageTeaserURL = [NSURL URLWithString:[dictionary objectForKey:@"image_teaser_url"]];
        
        _imageSize = CGSizeMake([[dictionary objectForKey:@"width"] doubleValue],
                                [[dictionary objectForKey:@"height"] doubleValue]);
        
        _viewsCount = [dictionary objectForKey:@"views_count"];
        _likesCount = [dictionary objectForKey:@"likes_count"];
        _commentsCount = [dictionary objectForKey:@"comments_count"];
        _reboundsCount = [dictionary objectForKey:@"rebounds_count"];
        _reboundSourceID = [dictionary objectForKey:@"rebound_source_id"];
        
        // Parse the date
        // Example: 2014/07/17 14:24:35 -0400
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss ZZZZ";
        _createdDate = [formatter dateFromString:[dictionary objectForKey:@"created_at"]];
        
        NSDictionary *playerDictionary = [dictionary objectForKey:@"player"];
        _player = [[MVPlayer alloc] initWithDictionary:playerDictionary];
        
    }
    return self;
}

@end
