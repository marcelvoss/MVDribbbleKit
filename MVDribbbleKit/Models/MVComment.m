//
//  MVComment.m
//  DribbbleExample
//
//  Created by Marcel Voß on 15.06.14.
//  Copyright (c) 2014 Marcel Voss. All rights reserved.
//

#import "MVComment.h"

@implementation MVComment

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _commentID = [dictionary objectForKey:@"id"];
        _body = [dictionary objectForKey:@"body"];
        _likesCount = [dictionary objectForKey:@"likes_count"];
        _createdDate = [dictionary objectForKey:@"created_at"];
        
        NSDictionary *playerDictionary = [dictionary objectForKey:@"player"];
        _player = [[MVPlayer alloc] initWithDictionary:playerDictionary];
    }
    return self;
}

@end
