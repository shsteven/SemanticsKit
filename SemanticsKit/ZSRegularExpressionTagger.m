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
                 type: (ZSSemanticsTagType)type {
    self = [super init];
    
    self.type = type;
    
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
                                            type: (ZSSemanticsTagType)type {
    ZSRegularExpressionTagger *tagger = [[ZSRegularExpressionTagger alloc] initWithPattern:pattern
                                                                                      type:type];
    
    return tagger;
}

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

@end

