//
//  MVProject.h
//  DribbbleTest
//
//  Created by Marcel Voß on 28.09.14.
//  Copyright (c) 2014 Marcel Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MVUser.h"

@interface MVProject : NSObject


@property (nonatomic) NSNumber *projectID;
@property (nonatomic) NSString *projectName;
@property (nonatomic) NSString *projectDescription;
@property (nonatomic) NSNumber *shotsCount;
@property (nonatomic) NSDate *createdDate;
@property (nonatomic) NSDate *updatedDate;

@property (nonatomic) MVUser *user;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
