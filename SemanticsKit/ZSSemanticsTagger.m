//
//  ZSSemanticsTagger.m
//  Logbook
//
//  Created by Steve on 21/7/13.
//  Copyright (c) 2013 MagicalBits. All rights reserved.
//

#import "ZSSemanticsTagger.h"
#import "ZSSemanticsTag.h"

@implementation ZSSemanticsTagger



/**
 Query
 A single tagger instance should only have one tag at an index
 
 Designed to be async and un-reliable
 If called 3 times in a row and the first two didn't complete, it's ok -- just honor the 3rd one
 
 */
- (void)getTagAtIndex: (NSUInteger)index
            withBlock:(void (^)(ZSSemanticsTag *))block {
    
    // if called repeatedly, only honour the last request

    __weak typeof(self)weakSelf = self;
    
    if (self.getTagOperation) {
        [self.getTagOperation cancel];
        self.getTagOperation = nil;
    }
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        __block ZSSemanticsTag *matchingTag;

        [self.tags enumerateObjectsWithOptions:NSEnumerationConcurrent | NSEnumerationReverse
                                    usingBlock:^(ZSSemanticsTag *tag, NSUInteger idx, BOOL *stop) {
                                        // word| also matches (where | is the cursor)
                                        if (NSLocationInRange(index, tag.range) || index == NSMaxRange(tag.range)) {
                                            matchingTag = tag;
                                            *stop = YES;
                                        }
                                    }];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            block(matchingTag);
            
            
        });
    }];
    
    [op setCompletionBlock:^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            weakSelf.getTagOperation = nil;
        });

    }];

    if (self.taggingOperation)
        [op addDependency:self.taggingOperation];
    self.getTagOperation = op;
    
    [self.operationQueue addOperation:op];
}

- (void)generateTagsWithCompletion:(TaggerCompletionBlock)completion {
    NSAssert(NO, @"This is an abstract class. Use a concrete subclass of ZSSemanticsTagger!");
}
 
@end
