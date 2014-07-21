// MVComment.h
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

@interface MVComment : NSObject

/**
 *  An NSNumber object that contains the comment ID.
 */
@property (nonatomic) NSNumber *commentID;

/**
 *  An NSString object that contains the comment.
 */
@property (nonatomic, copy) NSString *body;

/**
 *  An NSNumber object that contains the amount of likes for the comment.
 */
@property (nonatomic) NSNumber *likesCount;

/**
 *  An NSURL object that contains the likes URL.
 */
@property (nonatomic) NSURL *likesURL;

/**
 *  An NSDate object that contains the creation date of the comment.
 */
@property (nonatomic) NSDate *createdDate;

/**
 *  An MVUser object that contains all information for the author of the comment.
 */
@property (nonatomic) MVUser *user;

/**
 *  Creates and returns a new MVUser object.
 *
 *  @param dictionary A dictionary that should be used to initialize the new object.
 *
 *  @return An MVComment object.
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
