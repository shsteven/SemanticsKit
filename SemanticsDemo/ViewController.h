//
//  ViewController.h
//  SemanticsDemo
//
//  Created by Steve on 30/7/13.
//  Copyright (c) 2013 MagicalBits. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZSSemanticsManager;

@interface ViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textView;


@property (strong, nonatomic) ZSSemanticsManager *semanticsManager;

@end
