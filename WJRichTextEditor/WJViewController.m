//
//  WJViewController.m
//  WJRichTextEditor
//
//  Created by Wojciech Jachowicz on 24.03.2013.
//  Copyright (c) 2013 Wojciech Jachowicz. All rights reserved.
//

#import "WJViewController.h"

#define ACTION_FONT_TYPE 1
#define ACTION_FONT_COLOR 2

@interface WJViewController ()

@property(nonatomic, retain) WJRichTextView * richTextView;
@property(nonatomic, retain) UIActionSheet * actionSheet;
@property(nonatomic, retain) UIPopoverController * popover;
@end

@implementation WJViewController
@synthesize richTextView = _richTextView;
@synthesize actionSheet = _actionSheet;
@synthesize popover = _popover;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.richTextView = [[[WJRichTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)] autorelease];
    [self.view addSubview:_richTextView];
    [_richTextView loadString:@"Test"];
    [self defineBarButtonItems];
}

-(void) defineBarButtonItems
{
    NSMutableArray * items = [NSMutableArray array];
    UIBarButtonItem * btnBold = [[UIBarButtonItem alloc] initWithTitle:@"B" style:UIBarButtonItemStyleBordered target:self action:@selector(onBoldSelected:)];
    UIBarButtonItem * btnItalic = [[UIBarButtonItem alloc] initWithTitle:@"I" style:UIBarButtonItemStyleBordered target:self action:@selector(onItalicSelected:)];
    UIBarButtonItem * btnUnderline = [[UIBarButtonItem alloc] initWithTitle:@"U" style:UIBarButtonItemStyleBordered target:self action:@selector(onUnderlineSelected:)];
    UIBarButtonItem * btnFont = [[UIBarButtonItem alloc] initWithTitle:@"Font" style:UIBarButtonItemStyleBordered target:self action:@selector(onFontSelected:)];
    UIBarButtonItem * btnSize = [[UIBarButtonItem alloc] initWithTitle:@"Size" style:UIBarButtonItemStyleBordered target:self action:@selector(onSizeSelected:)];
    
    [items addObject:btnBold];
    [items addObject:btnItalic];
    [items addObject:btnUnderline];
    [items addObject:btnFont];
    [items addObject:btnSize];
    
    [btnBold release];
    [btnItalic release];
    [btnUnderline release];
    [btnFont release];
    [btnSize release];
    
    self.navigationItem.leftBarButtonItems = items;
}

#pragma mark - BarButtonItems actions

-(void) onBoldSelected:(id) sender
{
    [self dismissPopovers];
    [_richTextView bold];
}

-(void) onItalicSelected:(id) sender
{
    [self dismissPopovers];
    [_richTextView italic];
}

-(void) onUnderlineSelected:(id) sender
{
    [self dismissPopovers];
    [_richTextView underline];
}

-(void) onFontSelected:(id) sender{
    if (!_actionSheet) {
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Font" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Arial",@"Courier",@"Times New Roman", nil];
        _actionSheet.tag = ACTION_FONT_TYPE;
        [_actionSheet showFromBarButtonItem:(UIBarButtonItem *)sender animated:YES];
        [_actionSheet release];
    }
}
-(void) onSizeSelected:(id) sender{
    if (!_popover) {
        [self dismissPopovers];
        WJFontSizeViewController * fontSizeViewController = [[WJFontSizeViewController alloc] init];
        fontSizeViewController.delegate = self;
        fontSizeViewController.contentSizeForViewInPopover = fontSizeViewController.view.frame.size;
        self.popover = [[UIPopoverController alloc] initWithContentViewController:fontSizeViewController];
        _popover.delegate = self;
        [fontSizeViewController release];
        [_popover presentPopoverFromBarButtonItem:(UIBarButtonItem *) sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [_popover release];
    }
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == ACTION_FONT_TYPE)
    {
        NSString * font = [actionSheet buttonTitleAtIndex:buttonIndex];
        [_richTextView changeFontType:font];
    }
}

-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.actionSheet = nil;
}

-(void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    self.popover = nil;
}
-(void) didSelectFontSize:(int)fontSize
{
    [_richTextView changeFontSize:fontSize];
//    [_popover dismissPopoverAnimated:YES];
//    self.popover = nil;
}

-(void) dismissPopovers
{
    if (_actionSheet) {
        [_actionSheet dismissWithClickedButtonIndex:0 animated:NO];
    }
    if (_popover) {
        [_popover dismissPopoverAnimated:NO];
        self.popover = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc
{
    self.actionSheet = nil;
    self.richTextView = nil;
    [super dealloc];
}
@end
