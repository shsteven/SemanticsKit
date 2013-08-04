//
//  ZSRegularExpressionTagger.m
//  Logbook
//
//  Created by Steve on 26/7/13.
//  Copyright (c) 2013 MagicalBits. All rights reserved.
//

#import "ZSRegularExpressionTagger.h"

@interface ZSRegularExpressionTagger()

@end

@implementation ZSRegularExpressionTagger

- (id)initWithPattern: (NSString *)pattern
          textStorage: (NSTextStorage *)textStorage
                 type: (ZSSemanticsTagType)type {
    self = [super init];
    
    self.type = type;
    
    NSParameterAssert(textStorage);
    
    [textStorage addLayoutManager:self];
    
    NSError *error;
    _regularExpression = [[NSRegularExpression alloc] initWithPattern:pattern
                                                              options:NSRegularExpressionUseUnicodeWordBoundaries |
                          NSRegularExpressionAnchorsMatchLines |
                          NSRegularExpressionCaseInsensitive
                                                                error:&error];
    
    NSAssert(error == nil, @"Error: %@", error);
    
    return self;
}

+ (ZSRegularExpressionTagger *)taggerWithPattern: (NSString *)pattern
                                     textStorage: (NSTextStorage *)textStorage
                                            type: (ZSSemanticsTagType)type {
    ZSRegularExpressionTagger *tagger = [[ZSRegularExpressionTagger alloc] initWithPattern:pattern
                                                                               textStorage:textStorage
                                                                                      type:type];
    
    return tagger;
}


// Get all tags in one shot
- (void)generateTagsWithCompletion:(TaggerCompletionBlock)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        NSArray *tags = [self generateTagsForRange:NSMakeRange(0, self.textStorage.string.length)];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            completion(tags);
        });
    });

}

- (ZSSemanticsTag *)getTagAtIndex: (NSInteger)index {
    
    __block ZSSemanticsTag *matchingTag;

    NSRange range = [self.textStorage.string lineRangeForRange:NSMakeRange(index, 0)];
    
    NSArray *tagsInRange = [self generateTagsForRange:range];
    
    [tagsInRange enumerateObjectsWithOptions:NSEnumerationConcurrent | NSEnumerationReverse
                                usingBlock:^(ZSSemanticsTag *tag, NSUInteger idx, BOOL *stop) {
                                    // word| also matches (where | is the cursor)
                                    if (NSLocationInRange(index, tag.range) || index == NSMaxRange(tag.range)) {
                                        matchingTag = tag;
                                        *stop = YES;
                                    }
                                }];
    
    return matchingTag;

}


#pragma mark - Workhorse

- (NSArray *)generateTagsForRange: (NSRange)range {
    
    // In case the string had changed, previous call becomes invalid
    if (NSMaxRange(range) > self.textStorage.string.length) return @[];
    
    NSMutableArray *tags = [NSMutableArray new];
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
    
    return tags;
}

@end
