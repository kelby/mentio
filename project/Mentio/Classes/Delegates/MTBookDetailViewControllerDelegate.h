//
//  MTBookDetailViewController.h
//  Mentio
//
//  Created by Martin Hartl on 08/02/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import "MTDetailViewController.h"
#import "Book.h"

@interface MTBookDetailViewControllerDelegate : NSObject <MHSegmentedViewDelegate, MTDetailViewControllerDelegate>

- (instancetype)initWIthBookModel:(Book *)bookModel;


@end
