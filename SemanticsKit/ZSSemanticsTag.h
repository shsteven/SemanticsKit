//
//  ZSSemanticsTag.h
//  Logbook
//
//  Created by Steve on 26/7/13.
//  Copyright (c) 2013 MagicalBits. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSInteger ZSSemanticsTagType;

enum ZSSemanticsTagType {
    kMentionTagType = 0,
    kAtCommandTagType = 1,
    kHashtagTagType
//    kTODOCommandTagType,
//    kEventComandTagType
    };

@interface ZSSemanticsTag : NSObject

@property (assign) ZSSemanticsTagType type;

@property (weak) NSTextStorage *textStorage;

@property (assign) NSRange range;

@property (strong) NSTextCheckingResult *textChecingResult;

// Reserved for future use
@property (strong) NSDictionary *userInfo;

// Text for this tag
@property (readonly) NSString *text;


@property (readonly) NSString *currentLine;

@end
