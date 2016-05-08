//
//  LRInputViewController.m
//  LocationReminder
//
//  Created by Suchita. on 28/03/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import "LRInputViewController.h"
#import "LRReminderViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LRInputViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;

@end

@implementation LRInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(self.isInputTitle) {
        [self.inputTextView setHidden:YES];
        [self.inputTextField setHidden:NO];
        [self.inputTextField becomeFirstResponder];
        [self.inputTextField setText:self.reminderTitle];
    } else {
        [self.inputTextView setHidden:NO];
        [self.inputTextField setHidden:YES];
        [self.inputTextView becomeFirstResponder];
        [self.inputTextView setText:self.reminderNote];
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTheInput:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    // Do any additional setup after loading the view from its nib.
    self.inputTextView.layer.cornerRadius = 7.0f;
    self.inputTextView.layer.borderWidth = 1.0f;
    self.inputTextView.layer.borderColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.15].CGColor;
}

-(IBAction)saveTheInput:(id)sender
{
    NSArray *controllers = [self.navigationController viewControllers];
    LRReminderViewController *superView = (LRReminderViewController*)[controllers objectAtIndex:controllers.count - 2];
    NSString *inputText = nil;
    if(self.isInputTitle) {
        inputText = [self.inputTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    superView.reminderTitle = inputText;
    } else {
        inputText = [self.inputTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        superView.reminderNote = inputText;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
