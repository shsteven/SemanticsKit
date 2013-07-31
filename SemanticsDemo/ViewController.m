//
//  ViewController.m
//  SemanticsDemo
//
//  Created by Steve on 30/7/13.
//  Copyright (c) 2013 MagicalBits. All rights reserved.
//

#import "ViewController.h"
#import "ZSSemanticsKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.semanticsManager = [[ZSSemanticsManager alloc] initWithTextStorage:self.textView.textStorage];
    [self.semanticsManager addTagger:[ZSRegularExpressionTagger taggerWithPattern:@"@\\w+"
                                                                      textStorage:self.semanticsManager.textStorage
                                                                             type:kMentionTagType]];
    
    [self.semanticsManager addTagger:[ZSRegularExpressionTagger taggerWithPattern:@"^@(\\w+).*$"
                                                                      textStorage:self.semanticsManager.textStorage
                                                                             type:kAtCommandTagType]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)textViewDidChangeSelection:(UITextView *)textView {
#ifdef DEBUG
    NSInteger index = textView.selectedRange.location;
    [self.semanticsManager getTagsAtIndex:index withBlock:^(NSArray *tags) {
        if (tags.count)
            NSLog(@"tags at index %d: %@", index, tags);
    }];
#endif
}

@end
