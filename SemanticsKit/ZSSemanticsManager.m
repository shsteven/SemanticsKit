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

@property (strong) ZSRegularExpressionTagger *mentionTagger;
@property (strong) ZSRegularExpressionTagger *atCommandTagger;

@end

@implementation ZSSemanticsManager

- (id)initWithTextStorage: (NSTextStorage *)textStorage {
    self = [self init];
    
    if (self) {
        _textStorage = textStorage;

        self.operationQueue = [[NSOperationQueue alloc] init];
        
        /*
        self.mentionTagger = [[ZSRegularExpressionTagger alloc] initWithPattern:@"@\\w+"
                                                                 operationQueue:self.operationQueue
                                                                    textStorage:self.textStorage
                                                                           type:kMentionTagType];

        // Trailing $ to signal end of line for clarity and readability
        self.atCommandTagger = [[ZSRegularExpressionTagger alloc] initWithPattern:@"^@(\\w+).*$"
                                                                   operationQueue:self.operationQueue
                                                                      textStorage:self.textStorage
                                                                             type:kAtCommandTagType];
        
        _taggers = @[self.mentionTagger, self.atCommandTagger];
         */
        _taggers = @[];
    }

    _textStorage = textStorage;
    
    return self;
}

- (void)getTagsAtIndex: (NSInteger)index
             withBlock: (void (^)(NSArray *))block {
    
    [self.getTagOperation cancel];
    
    tagsAtQueryIndex = [NSMutableArray new];
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        // Kick off async tag querying
        
        [self.taggers enumerateObjectsUsingBlock:^(ZSSemanticsTagger *tagger, NSUInteger idx, BOOL *stop) {
            ZSSemanticsTag *tag = [tagger getTagAtIndex:index];
            if (tag)
                [tagsAtQueryIndex addObject:tag];
        }];
    }];
    
    [op setCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            block(tagsAtQueryIndex);
        });
    }];
    
    self.getTagOperation = op;
    
    [self.operationQueue addOperation:op];
    
}

- (void)addTagger:(ZSSemanticsTagger *)tagger {
    _taggers = [self.taggers arrayByAddingObject:tagger];
}

@end

