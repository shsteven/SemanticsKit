//
//  ZSSemanticsManager.h
//  Logbook
//
//  Created by Steve on 21/7/13.
//  Copyright (c) 2013 MagicalBits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSSemanticsTagger;
@class ZSRegularExpressionTagger;

@interface ZSSemanticsManager : NSObject

@property (strong) NSTextStorage *textStorage;

@property (strong) NSOperationQueue *operationQueue;

@property (strong) NSOperation *getTagOperation;

@property (strong) NSArray *taggers;



- (id)initWithTextStorage: (NSTextStorage *)textStorage;

- (void)addTagger: (ZSSemanticsTagger *)tagger;

/**
 Designed to be async and un-reliable
 If called 3 times in a row and the first two didn't complete, it's ok -- just honor the 3rd one
 
 */
- (void)getTagsAtIndex: (NSInteger)index
             withBlock: (void (^)(NSArray *))block;


@end

