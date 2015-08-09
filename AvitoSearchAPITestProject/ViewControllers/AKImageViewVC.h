//
//  AKImageViewVC.h
//  AvitoSearchAPITestProject
//
//  Created by Aleksey on 09/08/15.
//  Copyright (c) 2015 AlKol. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AKImageViewVC : UIViewController


@property (nonatomic,strong) UIImage *image;


@property (nonatomic,weak) NSLayoutConstraint *topIVConstraint;
@property (nonatomic,weak) NSLayoutConstraint *bottomIVConstraint;
@property (nonatomic,weak) NSLayoutConstraint *leftIVConstraint;
@property (nonatomic,weak) NSLayoutConstraint *rightIVConstraint;

@end
