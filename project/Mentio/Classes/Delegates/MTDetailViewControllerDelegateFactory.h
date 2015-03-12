//
//  MTDetailViewControllerDelegateFactory.h
//  Mentio
//
//  Created by Martin Hartl on 28/03/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCModel.h"
#import "MTModelProtocol.h"
#import <MHSegmentedView/MHSegmentedView.h>
#import "MTDetailViewController.h"

@interface MTDetailViewControllerDelegateFactory : NSObject

+ (id<MHSegmentedViewDelegate, MTDetailViewControllerDelegate>)delegateWithModel:(FCModel<MTModelProtocol> *)model;

@end
