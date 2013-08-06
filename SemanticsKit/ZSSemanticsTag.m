//
//  ZSSemanticsTag.m
//  Logbook
//
//  Created by Steve on 26/7/13.
//  Copyright (c) 2013 MagicalBits. All rights reserved.
//

#import "ZSSemanticsTag.h"

@implementation ZSSemanticsTag

- (NSString *)text {
    return [self.string substringWithRange:self.range];
}

/*
- (NSString *)currentLine {
    NSRange lineRange = [self.string lineRangeForRange:self.range];
    NSString *text = [self.textStorage.string substringWithRange:lineRange];
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    return text;
}
 */

- (NSString *)description {
    if (self.type == kAtCommandTagType) return [NSString stringWithFormat:@"command: %@",self.text];
    if (self.type == kMentionTagType) return [NSString stringWithFormat:@"mention: %@",self.text];

    return [NSString stringWithFormat:@"%d: %@", self.type, self.text];
}

@end
