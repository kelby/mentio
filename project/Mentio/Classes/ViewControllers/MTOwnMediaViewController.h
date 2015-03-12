//
//  MTOwnMediaViewController.h
//  Mentio
//
//  Created by Martin Hartl on 20/04/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCModel.h"
#import "MTModelProtocol.h"

@interface MTOwnMediaViewController : UIViewController

@property (nonatomic, strong) FCModel<MTModelProtocol> *detailModel;

@property (nonatomic, assign) BOOL fromSearchViewController;
@property (nonatomic, assign) BOOL fromArchiveViewController;

@end
