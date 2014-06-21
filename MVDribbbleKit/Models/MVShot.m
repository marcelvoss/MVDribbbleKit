//
//  MVShot.m
//  DribbbleExample
//
//  Created by Marcel Voß on 15.06.14.
//  Copyright (c) 2014 Marcel Voss. All rights reserved.
//

#import "MVShot.h"

@implementation MVShot

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _shotID = [dictionary objectForKey:@"id"];
        _title = [dictionary objectForKey:@"title"];
        _description = [dictionary objectForKey:@"description"];
        
        _url = [dictionary objectForKey:@"url"];
        _shortURL = [dictionary objectForKey:@"short_url"];
        _imageURL = [dictionary objectForKey:@"image_url"];
        _imageTeaserURL = [dictionary objectForKey:@"image_teaser_url"];
        
        _imageSize = CGSizeMake([[dictionary objectForKey:@"width"] doubleValue],
                                [[dictionary objectForKey:@"height"] doubleValue]);
        
        _viewsCount = [dictionary objectForKey:@"views_count"];
        _likesCount = [dictionary objectForKey:@"likes_count"];
        _commentsCount = [dictionary objectForKey:@"comments_count"];
        _reboundsCount = [dictionary objectForKey:@"rebounds_count"];
        _reboundSourceID = [dictionary objectForKey:@"rebound_source_id"];
        _createdDate = [dictionary objectForKey:@"created_at"];
        
        NSDictionary *playerDictionary = [dictionary objectForKey:@"player"];
        _player = [[MVPlayer alloc] initWithDictionary:playerDictionary];
    }
    return self;
}

@end
