//
//  ZSRegularExpressionTagger.h
//  Logbook
//
//  Created by Steve on 26/7/13.
//  Copyright (c) 2013 MagicalBits. All rights reserved.
//

#import "ZSSemanticsTagger.h"

@interface ZSRegularExpressionTagger : ZSSemanticsTagger

@property (strong) NSRegularExpression *regularExpression;

// Optional
@property (weak) NSOperationQueue *operationQueue;

- (id)initWithPattern: (NSString *)pattern
                 type: (ZSSemanticsTagType)type;

+ (ZSRegularExpressionTagger *)taggerWithPattern: (NSString *)pattern
                                            type: (ZSSemanticsTagType)type;

@end
