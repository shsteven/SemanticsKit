//
//  ZSSemanticsTagger.h
//  Logbook
//
//  Created by Steve on 21/7/13.
//  Copyright (c) 2013 MagicalBits. All rights reserved.
//

/**
 This is an abstract class.
 Use one of it's concrete subclasses.
 
 ZSSemanticsTagger
 Parses text and supply query-able semantics information
 
 Tagger types:
 
 Mention, hashtag, @todo, @event, image
 token (for generating tokens, querying it returns nothing
 
 Proposed tagger types:
 list, quote
 
 */

#import <Foundation/Foundation.h>
#import "ZSSemanticsTag.h"

typedef void(^TaggerCompletionBlock)(id tagger);

@interface ZSSemanticsTagger : NSLayoutManager

@property (assign) ZSSemanticsTagType type;

@property (strong) NSOperationQueue *operationQueue;

// Use operation's dependency to work this out
@property (strong) NSOperation *taggingOperation;
@property (strong) NSOperation *getTagOperation;

#pragma mark - Subclass Override
// Scans the entire string async, generate tags
- (void)generateTagsWithCompletion:(TaggerCompletionBlock)completion;


/**
 Query
 A single tagger instance should only have one tag at an index
 
 Designed to be async and un-reliable
 If called 3 times in a row and the first two didn't complete, it's ok -- just honor the 3rd one
 
 */
- (void)getTagAtIndex: (NSUInteger)index
            withBlock:(void (^)(ZSSemanticsTag *))block;


/**
 All tags
 Can be used when generating indexing tokens
 */
@property (readonly) NSArray *tags;

@end
