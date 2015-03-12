//
//  MTAffiliateTokenTableViewController.m
//  Mentio
//
//  Created by Martin Hartl on 25/05/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import "MTAffiliateTokenTableViewController.h"

@interface MTAffiliateTokenTableViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *ibTextfield;
@property (weak, nonatomic) IBOutlet UILabel *moreInformationLabel;

@end

@implementation MTAffiliateTokenTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [MHFancyPants colorForKey:MTBackgroundColor];
    
    self.ibTextfield.text = [self affiliateToken];
    self.ibTextfield.delegate = self;
    UIColor *placeHolderColor = [MHFancyPants colorForKey:MTBodyTextColor];
    placeHolderColor = [placeHolderColor colorWithAlphaComponent:0.7f];
    
    UIFont *prefFont = [UIFont preferredAvenirFontForTextStyle:UIFontTextStyleBody];
    
    self.moreInformationLabel.textColor = [MHFancyPants colorForKey:MTHeadingTextColor];
    self.moreInformationLabel.font = prefFont;
    self.moreInformationLabel.text = NSLocalizedString(@"mtaffiliatetokenviewcontroller.tableview.moreInformation", @"more information");
    
    self.ibTextfield.font = prefFont;
    self.ibTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"11lqGj" attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    self.ibTextfield.textColor = [MHFancyPants colorForKey:MTHeadingTextColor];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self setAffiliateToken:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
            return NSLocalizedString(@"mtaffiliatetokenviewcontroller.tableview.footer", "affiliate description");
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        NSURL *webURL = [NSURL URLWithString:NSLocalizedString(@"mtaffiliatetokenviewcontroller.tableview.moreInformation.link", @"link")];
        
        [[UIApplication sharedApplication] openURL: webURL];
    }
    
    return;
    
}

#pragma mark - Custom Setter and Getter

- (NSString *)affiliateToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:MTAffiliateTokenKeyConstant];
}

- (void)setAffiliateToken:(NSString *)affiliateToken {
    [[NSUserDefaults standardUserDefaults] setObject:affiliateToken forKey:MTAffiliateTokenKeyConstant];
}


@end
