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
    kHashtagTagType,
    kMarkdownImageTagType
//    kTODOCommandTagType,
//    kEventComandTagType
    };

@interface ZSSemanticsTag : NSObject

@property (assign) ZSSemanticsTagType type;

// We need to hold on the string, as long as the tag is still in use
@property (strong) NSString *string;

// Full range detected by regex, including any control symbols such as @, @todo
@property (assign) NSRange range;

// The range in which text doesn't contain control symbyl such as @, and is useful for searching / comparison
@property (assign) NSRange effectiveRange;

@property (strong) NSTextCheckingResult *textChecingResult;

// Reserved for future use
@property (strong) NSDictionary *userInfo;

// Text for this tag
@property (readonly) NSString *text;


//@property (readonly) NSString *currentLine;

@end
