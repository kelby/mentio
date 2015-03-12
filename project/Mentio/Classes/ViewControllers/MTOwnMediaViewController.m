//
//  MTOwnMediaViewController.m
//  Mentio
//
//  Created by Martin Hartl on 20/04/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import "MTOwnMediaViewController.h"
#import "SZTextView.h"
#import "MTStatusBarConstants.h"

@interface MTOwnMediaViewController ()
@property (weak, nonatomic) IBOutlet SZTextView *ibTitleLabel;
@property (weak, nonatomic) IBOutlet SZTextView *ibNoteTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ibAddBarButton;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *textBackgrounds;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibBottomConstraint;

@end

@implementation MTOwnMediaViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.detailModel.protTitle;
    self.ibTitleLabel.text = self.detailModel.protTitle;
    self.ibNoteTextView.text = self.detailModel.protNotes;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFonts:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    
    self.ibTitleLabel.placeholder = NSLocalizedString(@"mtownmediaviewcontroller.titlelabel.placeholder", @"title");
    self.ibNoteTextView.placeholder = NSLocalizedString(@"mtownmediaviewcontroller.notestextview.placeholder", @"add some notes");
    self.ibNoteTextView.dataDetectorTypes = UIDataDetectorTypeLink;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNavigationTitleWithTyping) name:UITextViewTextDidChangeNotification object:nil];
    
    [self updateFonts:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];   //show nav bar
    [self.navigationController.navigationBar setTranslucent:YES];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    self.view.backgroundColor = [MHFancyPants colorForKey:@"backgroundColor"];
    [self.textBackgrounds enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.backgroundColor = [MHFancyPants colorForKey:MTAlternateBackgroundColor];
    }];
    
    self.ibTitleLabel.textColor = [MHFancyPants colorForKey:@"headingTextColor"];
    self.ibNoteTextView.textColor = [MHFancyPants colorForKey:@"bodyTextColor"];
    self.ibNoteTextView.keyboardAppearance = [MHFancyPants integerForKey:@"keyboardAppearance"];
    self.ibTitleLabel.keyboardAppearance = [MHFancyPants integerForKey:@"keyboardAppearance"];
    self.ibNoteTextView.placeholderTextColor = [MHFancyPants colorForKey:@"bodyTextColor"];
    self.ibTitleLabel.placeholderTextColor = [MHFancyPants colorForKey:@"headingTextColor"];
    
    [self configureForDifferentSources];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MTHideStatusBarView object:nil];
}

- (void)configureForDifferentSources {
    if (self.fromSearchViewController) {
        self.ibBottomConstraint.constant = 20;
    } else {
        self.ibBottomConstraint.constant = 70;
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self.view layoutSubviews];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
    if (!self.fromArchiveViewController) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];    // hide nav bar
    }
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    if (!(self.fromSearchViewController)) {
        [self saveChanges];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.ibBottomConstraint.constant = kbSize.height + 10;
    [self.view layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.ibBottomConstraint.constant = 20;
    [self.view layoutIfNeeded];
}

#pragma mark - Actions

- (IBAction)ibaPushedAddBarButton:(id)sender {
    [self saveChanges];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Helper

- (void)saveChanges {
    if ([self.ibTitleLabel.text isEqual:@""]) {
        [self.detailModel setProtTitle:NSLocalizedString(@"mtownmediaviewcontroller.titlelabel.placeholder", @"title")];
    }
    
    [self.detailModel setProtNotes:self.ibNoteTextView.text];
    [self.detailModel setProtArtistName:self.ibNoteTextView.text];
    [self.detailModel setProtTitle:self.ibTitleLabel.text];
    [self.detailModel save];
}

- (void)updateNavigationTitleWithTyping {
    self.navigationItem.title = self.ibTitleLabel.text;
}

#pragma mark - Daynamic Type

- (void)updateFonts:(NSNotification *)aNotification {
    self.ibTitleLabel.font = [UIFont preferredABeeZeeFontForTextStyle:UIFontTextStyleHeadline];
    self.ibNoteTextView.font = [UIFont preferredAvenirFontForTextStyle:UIFontTextStyleBody];
}

#pragma mark - Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
