//
//  MVLikedShot.m
//  Pods
//
//  Created by Alkim Gozen on 06/06/15.
//
//

#import "MVLikedShot.h"

@implementation MVLikedShot
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _likeID = [self objectForKeyOrNil:dictionary[@"id"]];
        _shot = [[MVShot alloc] initWithDictionary:dictionary[@"shot"]];
        
        ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
        _createdDate = [formatter dateFromString:dictionary[@"created_at"]];
    }
    return self;
}
@end
