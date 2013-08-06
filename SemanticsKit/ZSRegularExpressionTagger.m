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
//          textStorage: (NSTextStorage *)textStorage
                 type: (ZSSemanticsTagType)type {
    self = [super init];
    
    self.type = type;
    
//    NSParameterAssert(textStorage);
    
//    [textStorage addLayoutManager:self];
    
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
//                                     textStorage: (NSTextStorage *)textStorage
                                            type: (ZSSemanticsTagType)type {
    ZSRegularExpressionTagger *tagger = [[ZSRegularExpressionTagger alloc] initWithPattern:pattern
//                                                                               textStorage:textStorage
                                                                                      type:type];
    
    return tagger;
}


/*
// Get all tags in one shot
- (void)generateTagsWithCompletion:(TaggerCompletionBlock)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        NSArray *tags = [self generateTagsForRange:NSMakeRange(0, self.textStorage.string.length)];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            completion(tags);
        });
    });

}
*/

- (ZSSemanticsTag *)getTagInString: (NSString *)string
                           atIndex: (NSInteger)index {
    
    __block ZSSemanticsTag *matchingTag;
    
    NSRange range = [string lineRangeForRange:NSMakeRange(index, 0)];
    
    [self.regularExpression enumerateMatchesInString:string
                                             options:NSRegularExpressionCaseInsensitive
                                               range:range
                                          usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                              if (NSLocationInRange(index, result.range) || index == NSMaxRange(result.range)) {
                                                  ZSSemanticsTag *newTag = [ZSSemanticsTag new];
                                                  newTag.range = result.range;
                                                  newTag.textChecingResult = result;
                                                  newTag.string = string;
                                                  newTag.type = self.type;

                                                  matchingTag = newTag;
                                                  
                                                  *stop = YES;
                                              }
                               

                                          }];


    return matchingTag;

}


#pragma mark - Workhorse
/*
- (NSArray *)generateTagsForRange: (NSRange)range {
    
    NSMutableArray *tags = [NSMutableArray new];

    // In case the string had changed, previous call becomes invalid
    
#warning TODO: fix isse with async + underlying string changed
//    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSRange safeRange = NSIntersectionRange(range, NSMakeRange(0, self.textStorage.string.length));
        
        [self.regularExpression enumerateMatchesInString:self.textStorage.string
                                                 options:0
                                                   range:safeRange
                                              usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                                  ZSSemanticsTag *newTag = [ZSSemanticsTag new];
                                                  newTag.range = result.range;
                                                  newTag.textChecingResult = result;
                                                  newTag.textStorage = self.textStorage;
                                                  newTag.type = self.type;
                                                  [tags addObject:newTag];
                                              }];
//    });
    

    
    return tags;
}
*/

@end

