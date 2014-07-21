// MVAttachment.h
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

@interface MVAttachment : NSObject

/**
 *  An NSDate object that contains the creation date of the attachment.
 */
@property (nonatomic) NSDate *createdDate;

/**
 *  An NSNumber object that contains the attachment ID.
 */
@property (nonatomic) NSNumber *attachmentID;

/**
 *  An NSURL object that contains the attachment URL.
 */
@property (nonatomic) NSURL *attachmentURL;

/**
 *  An NSNumber object that contains the number of views for the attachment.
 */
@property (nonatomic) NSNumber *viewsCount;

/**
 *  An NSNumber object that contains the size of the attachment (in bytes).
 */
@property (nonatomic) NSNumber *size;

/**
 *  Creates and returns a new MVUser object.
 *
 *  @param dictionary A dictionary that should be used to initialize the new object.
 *
 *  @return An MVAttachment object.
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
