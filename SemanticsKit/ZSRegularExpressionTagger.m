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

- (NSArray *)tags {
    return tags;
}

- (void)generateTagsWithCompletion:(TaggerCompletionBlock)completion {
    __weak typeof(self)weakSelf = self;;
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        [tags removeAllObjects];
        
        [self.regularExpression enumerateMatchesInString:self.textStorage.string
                                                 options:0
                                                   range:NSMakeRange(0, self.textStorage.string.length)
                                              usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                                  ZSSemanticsTag *newTag = [ZSSemanticsTag new];
                                                  newTag.range = result.range;
                                                  newTag.textChecingResult = result;
                                                  newTag.textStorage = self.textStorage;
                                                  newTag.type = self.type;
                                                  [tags addObject:newTag];
                                              }];

    }];
    
    op.completionBlock = ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completion)
                completion(weakSelf);
            weakSelf.taggingOperation = nil;
        });

    };
    
    self.taggingOperation = op;
    
    NSParameterAssert(self.operationQueue);
    
    [self.operationQueue addOperation:op];
    
}


#pragma mark -

- (void)processEditingForTextStorage:(NSTextStorage *)textStorage
                              edited:(NSTextStorageEditActions)editMask
                               range:(NSRange)newCharRange
                      changeInLength:(NSInteger)delta
                    invalidatedRange:(NSRange)invalidatedCharRange {
#warning TODO: delta update: how to adjust taggers if editing occurs in the middle of a string?
#warning TODO: apply delta to all existing tags that are still valid
//#warning TODO: tie into textStorage's attribute and piggy back on attributeAtIndex? looks unnecessary.
    
    if (editMask & NSTextStorageEditedCharacters) {
//        NSLog(@"edite range: (%d, %d) changeInLength: %d", newCharRange.location, newCharRange.length, delta);
        
        // Deduce invalidate range based on invalidatedCharRange
        // Invalidate all tags in that range
        // Rescan that range
        // Sort tags by range.location
        
        [self generateTagsWithCompletion:^(id tagger) {
#ifdef DEBUG
//            NSLog(@"tags: %@", [tagger tags]);
#endif
        }];
    }
}

@end
