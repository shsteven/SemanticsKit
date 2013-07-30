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
    }

    _textStorage = textStorage;
    
    return self;
}

- (void)getTagsAtIndex: (NSInteger)index
             withBlock: (void (^)(NSArray *))block {
    
    /*
     If async becomes an issue, enable this block
    if (taggersPendingCallback.count)
        [taggersPendingCallback enumerateObjectsUsingBlock:^(ZSSemanticsTagger *tagger, NSUInteger idx, BOOL *stop) {
            [tagger.getTagOperation cancel];
            tagger.getTagOperation = nil;
        }];
     */
    
    // Discard any previous attempt
    tagsAtQueryIndex = [NSMutableArray new];
    taggersPendingCallback = [self.taggers mutableCopy];
    
    // Kick off async tag querying
    // Callback when all taggers completes getTagAtIndex
    [self.taggers enumerateObjectsUsingBlock:^(ZSSemanticsTagger *tagger, NSUInteger idx, BOOL *stop) {
       [tagger getTagAtIndex:index
                   withBlock:^(ZSSemanticsTag *aTag) {
                       if (aTag)
                           [tagsAtQueryIndex addObject:aTag];
                       [taggersPendingCallback removeObject:tagger];
                       
                       if (!taggersPendingCallback.count)
                           block(tagsAtQueryIndex);
                   }];
    }];
    
}

@end
