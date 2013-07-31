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

- (id)initWithPattern: (NSString *)pattern
          textStorage: (NSTextStorage *)textStorage
                 type: (ZSSemanticsTagType)type;

+ (ZSRegularExpressionTagger *)taggerWithPattern: (NSString *)pattern
                                     textStorage: (NSTextStorage *)textStorage
                                            type: (ZSSemanticsTagType)type;

@end
