//
//  MVLikedShot.h
//  Pods
//
//  Created by Alkim Gozen on 06/06/15.
//
//

#import <MVDribbbleKit/MVDribbbleKit.h>

@interface MVLikedShot : MVModel
@property (nonatomic) NSDate *createdDate;
@property (nonatomic) NSNumber *likeID;
@property (nonatomic) MVShot *shot;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
