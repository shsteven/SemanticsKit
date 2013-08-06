//
//  ZSSemanticsManager.m
//  Logbook
//
//  Created by Steve on 21/7/13.
//  Copyright (c) 2013 MagicalBits. All rights reserved.
//

#import "ZSSemanticsManager.h"
#import "ZSSemanticsTagger.h"
#import "ZSRegularExpressionTagger.h"

@interface ZSSemanticsManager() {
    NSMutableArray *tagsAtQueryIndex;
    NSMutableArray *taggersPendingCallback;
}

@end

@implementation ZSSemanticsManager

- (id)initWithTextStorage: (NSTextStorage *)textStorage {
    self = [self init];
    
    if (self) {

        self.operationQueue = [[NSOperationQueue alloc] init];

        _taggers = @[];
    }
    
    return self;
}

- (void)getTagsInString: (NSString *)string
                atIndex: (NSInteger)index
              withBlock: (void (^)(NSArray *))block {
    
    // Sanity check: invalid index
    if (!NSLocationInRange(index - 1, NSMakeRange(0, string.length))) return;
    
    [self.operationQueue cancelAllOperations];
    
    ZSSemanticsGetTagOperation *op = [ZSSemanticsGetTagOperation new];

    op.string = string;
    op.index = index;

    op.taggers = self.taggers;
    
    op.successBlock = block;
    
    [self.operationQueue addOperation:op];
    
}

- (void)addTagger:(ZSSemanticsTagger *)tagger {
    _taggers = [self.taggers arrayByAddingObject:tagger];
}

@end

@implementation ZSSemanticsGetTagOperation

- (void)main {
    tagsAtQueryIndex = [NSMutableArray new];
    
    if (self.isCancelled) return;
    [self.taggers enumerateObjectsUsingBlock:^(ZSSemanticsTagger *tagger, NSUInteger idx, BOOL *stop) {
        if (self.isCancelled) return;
        ZSSemanticsTag *tag = [tagger getTagInString:self.string
                                             atIndex:self.index];
        if (tag)
            [tagsAtQueryIndex addObject:tag];
    }];

    if (self.isCancelled) return;
    
    if (self.successBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.successBlock(tagsAtQueryIndex);
        });
    }
}

@end