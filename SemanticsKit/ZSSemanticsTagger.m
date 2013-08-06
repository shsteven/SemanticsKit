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

- (ZSSemanticsTag *)getTagInString: (NSString *)string
                           atIndex: (NSInteger)index {
    NSAssert(NO, @"This is an abstract class. Use a concrete subclass of ZSSemanticsTagger!");
    return nil;
}

- (void)generateTagsWithCompletion:(TaggerCompletionBlock)completion {
    NSAssert(NO, @"This is an abstract class. Use a concrete subclass of ZSSemanticsTagger!");
}
 
@end
