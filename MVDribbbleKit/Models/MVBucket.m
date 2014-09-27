//
//  MVBucket.m
//  DribbbleTest
//
//  Created by Marcel Voß on 27.09.14.
//  Copyright (c) 2014 Marcel Voss. All rights reserved.
//

#import "MVBucket.h"

@implementation MVBucket

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _bucketID = dictionary[@"id"];
        _bucketName = dictionary[@"name"];
        _bucketDescription = dictionary[@"description"];
        _shotsCount = dictionary[@"shots_count"];
        _user = [[MVUser alloc] initWithDictionary:dictionary[@"user"]];
    
        // Parse the date
        // Example: 2014-07-02T15:46:06Z
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
        _createdDate = [formatter dateFromString:[dictionary objectForKey:@"created_at"]];
        _updatedDate = [formatter dateFromString:[dictionary objectForKey:@"updated_at"]];
    }
    return self;
}

@end
