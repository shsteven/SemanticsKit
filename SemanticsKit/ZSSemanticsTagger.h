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

typedef void(^TaggerCompletionBlock)(NSArray *tags);

@interface ZSSemanticsTagger : NSObject

@property (assign) ZSSemanticsTagType type;

#pragma mark - Subclass Override

- (ZSSemanticsTag *)getTagInString: (NSString *)string
                           atIndex: (NSInteger)index;

// Only use this when we need all the tags at once
- (void)generateTagsWithCompletion:(TaggerCompletionBlock)completion;


@end
