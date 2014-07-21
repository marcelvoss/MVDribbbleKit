// MVShot.h
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

#import <Foundation/Foundation.h>

#import "MVUser.h"

@interface MVShot : NSObject

/**
 *  An NSNumber object that contains the number of attachments.
 */
@property (nonatomic) NSNumber *attachmentsCount;

/**
 *  An NSURL object that contains the URL to the attachments.
 */
@property (nonatomic) NSURL *attachmentsURL;

/**
 *  An NSNumber object that contains the buckets count.
 */
@property (nonatomic) NSNumber *bucketsCount;

/**
 *  An NSNumber object that contains the number of comments that are available for the shot.
 */
@property (nonatomic) NSNumber *commentsCount;

/**
 *  An NSURL object that contains the URL to the comments.
 */
@property (nonatomic) NSURL *commentsURL;

/**
 *  An NSDate object that contains the creation date of the shot.
 */
@property (nonatomic) NSDate *createdDate;

/**
 *  An NSString object that contains the description for the shot.
 */
@property (nonatomic, copy) NSString *description;

/**
 *  An NSURL object that contains the URL to the shot.
 */
@property (nonatomic) NSURL *htmlURL;

/**
 *  An NSNumber object that contains the shot ID.
 */
@property (nonatomic) NSNumber *shotID;

/**
 *  An NSNumber object that contains the number of likes for the shot.
 */
@property (nonatomic) NSNumber *likesCount;

/**
 *  An NSURL object to the likes.
 */
@property (nonatomic) NSURL *likesURL;

/**
 *  An NSNumber object that contains the number of rebounds that are available for this shot.
 */
@property (nonatomic) NSNumber *reboundsCount;

/**
 *  An NSURL object that contains the URL to the rebounds.
 */
@property (nonatomic) NSURL *reboundsURL;

/**
 *  An array that contains all available tags for the shot (as NSString objects).
 */
@property (nonatomic) NSArray *tags;

/**
 *  An NSString object that contains the title of the shot.
 */
@property (nonatomic, copy) NSString *title;

/**
 *  An NSDate object that contains the date of the last update to the shot.
 */
@property (nonatomic) NSDate *updatedDate;

/**
 *  An NSNumber object that contains the views count.
 */
@property (nonatomic) NSNumber *viewsCount;

/**
 *  An MVUser object that contains all information for the team that published this shot (if available).
 */
@property (nonatomic) MVUser *team;

/**
 *  An MVUser object that contains all information for the user who published the shot.
 */
@property (nonatomic) MVUser *user;

/**
 *  A dictionary that contains links for all available images. Possible keys are 'hidpi', 'teaser' and 'normal'.
 */
@property (nonatomic) NSDictionary *images;

/**
 *  Creates and returns a new MVUser object.
 *
 *  @param dictionary A dictionary that should be used to initialize the new object.
 *
 *  @return An MVShot object.
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
