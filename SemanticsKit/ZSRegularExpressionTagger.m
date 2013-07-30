//
//  ZSRegularExpressionTagger.m
//  Logbook
//
//  Created by Steve on 26/7/13.
//  Copyright (c) 2013 MagicalBits. All rights reserved.
//

#import "ZSRegularExpressionTagger.h"

@interface ZSRegularExpressionTagger()  {
    NSMutableArray *tags;
}

@end

@implementation ZSRegularExpressionTagger
@synthesize tags;

- (id)initWithPattern: (NSString *)pattern
       operationQueue: (NSOperationQueue *)operationQueue
          textStorage: (NSTextStorage *)textStorage
                 type: (ZSSemanticsTagType)type {
    self = [super init];
    
    self.type = type;
    
    NSParameterAssert(textStorage);
    NSParameterAssert(operationQueue);
    
    self.operationQueue = operationQueue;
    
    tags = [NSMutableArray new];
    
    [textStorage addLayoutManager:self];
    
    NSError *error;
    _regularExpression = [[NSRegularExpression alloc] initWithPattern:pattern
                                                              options:NSRegularExpressionUseUnicodeWordBoundaries |
                          NSRegularExpressionAnchorsMatchLines |
                          NSRegularExpressionCaseInsensitive
                                                                error:&error];
    
    NSAssert(error == nil, @"Error: %@", error);

    [self generateTagsWithCompletion:nil];
    
    return self;
}

- (void)generateTagsWithCompletion:(TaggerCompletionBlock)completion {
    [self generateTagsForRange:NSMakeRange(0, self.textStorage.string.length)
                withCompletion:completion];
}

- (void)generateTagsForRange: (NSRange)range
              withCompletion:(TaggerCompletionBlock)completion {
    __weak typeof(self)weakSelf = self;
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        [tags removeAllObjects];
        
        [self.regularExpression enumerateMatchesInString:self.textStorage.string
                                                 options:0
                                                   range:range
                                              usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                                  ZSSemanticsTag *newTag = [ZSSemanticsTag new];
                                                  newTag.range = result.range;
                                                  newTag.textChecingResult = result;
                                                  newTag.textStorage = self.textStorage;
                                                  newTag.type = self.type;
                                                  [tags addObject:newTag];
                                              }];

        weakSelf.taggingOperation = nil;
        
    }];
    
    op.completionBlock = ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completion)
                completion(weakSelf);
        });

    };
    
    self.taggingOperation = op;
    
    NSParameterAssert(self.operationQueue);
    
    [self.operationQueue addOperation:op];
    
}



#pragma mark -

// delta = newCharRange.length - oldCharRange.length. >0: insert       < 0: delete

- (void)processEditingForTextStorage:(NSTextStorage *)textStorage
                              edited:(NSTextStorageEditActions)editMask
                               range:(NSRange)newCharRange
                      changeInLength:(NSInteger)delta
                    invalidatedRange:(NSRange)invalidatedCharRange {
#warning TODO: delta update: how to adjust taggers if editing occurs in the middle of a string?
#warning TODO: apply delta to all existing tags that are still valid
//#warning TODO: tie into textStorage's attribute and piggy back on attributeAtIndex? looks unnecessary.
    
    if (self.taggingOperation)
        return;
    
    if (editMask & NSTextStorageEditedCharacters) {
//        NSLog(@"edite range: (%d, %d) changeInLength: %d", newCharRange.location, newCharRange.length, delta);
        
#warning TODO: solve concurrency issue with getTagsAtIndex:
        // 1. Deduce invalidate range based on invalidatedCharRange
        NSRange rangeToRescan = [textStorage.string lineRangeForRange:invalidatedCharRange];

        // Adjust other tags
        [self adjustTagsAfterRange:rangeToRescan delta:delta];
        
        // Invalidate all tags in that range
        [self invalidateTagsInRange:rangeToRescan];
        
        // Rescan that range
        __weak typeof(self)weakSelf = self;
        [self generateTagsForRange:rangeToRescan withCompletion:^(id tagger) {
            // Sort tags by range.location
            [weakSelf sortTags];
        }];
        

        /*
        // DEBUG
        if (self.type == kMentionTagType)
            NSLog(@"delta: %d invalid: %@ new: %@", delta, NSStringFromRange(invalidatedCharRange), NSStringFromRange(newCharRange));
         */
        
        /*
        [self generateTagsWithCompletion:^(id tagger) {
#ifdef DEBUG
//            NSLog(@"tags: %@", [tagger tags]);
#endif
        }];
         */
    }
}

#pragma mark -

- (void)invalidateTagsInRange: (NSRange)range {
    NSMutableArray *invalidatedTags = [NSMutableArray new];
    [self.tags enumerateObjectsWithOptions:NSEnumerationConcurrent
                                usingBlock:^(ZSSemanticsTag *aTag, NSUInteger idx, BOOL *stop) {
                                    if (NSIntersectionRange(aTag.range, range).length) {
                                        [invalidatedTags addObject:aTag];
                                    }
                                }];
    
    [tags removeObjectsInArray:invalidatedTags];
}

- (void)adjustTagsAfterRange: (NSRange)invalidatedRange
                       delta: (NSInteger)delta {
    [self.tags enumerateObjectsWithOptions:NSEnumerationConcurrent
                                usingBlock:^(ZSSemanticsTag *aTag, NSUInteger idx, BOOL *stop) {
                                    if (aTag.range.location >= NSMaxRange(invalidatedRange)) {
                                        NSRange newRange = aTag.range;
                                        newRange.location += delta;
                                        aTag.range = newRange;
                                    }
                                }];
}

- (void)sortTags {
    [tags sortUsingComparator:^NSComparisonResult(ZSSemanticsTag *tag1, ZSSemanticsTag *tag2) {
        if (tag1.range.location < tag2.range.location) return NSOrderedAscending;
        if (tag1.range.location > tag2.range.location) return NSOrderedDescending;
        return NSOrderedSame;
    }];
}

@end
