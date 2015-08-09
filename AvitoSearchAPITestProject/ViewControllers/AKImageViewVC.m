//
//  AKImageViewVC.m
//  AvitoSearchAPITestProject
//
//  Created by Aleksey on 09/08/15.
//  Copyright (c) 2015 AlKol. All rights reserved.
//

#import "AKImageViewVC.h"

@interface AKImageViewVC ()
{
    __weak UIImageView *_imageView;
    UITapGestureRecognizer *tapRecognizer;
}


@end

@implementation AKImageViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_imageView setImage:[self image]];
}

-(void)loadView
{
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectZero];
    [iv setBackgroundColor:[UIColor clearColor]];
    [iv setContentMode:UIViewContentModeScaleAspectFit];
    [iv setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:iv];
    
    _imageView = iv;
    
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:iv attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:iv attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:iv attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:iv attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    [self.view addConstraints:@[leftConstraint, rightConstraint,topConstraint,bottomConstraint]];
    
    _leftIVConstraint = leftConstraint;
    _rightIVConstraint = rightConstraint;
    _topIVConstraint = topConstraint;
    _bottomIVConstraint = bottomConstraint;
    
    
    tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRecognized:)];
    [self.view addGestureRecognizer:tapRecognizer];
}

-(void)tapRecognized:(UITapGestureRecognizer*)recognizer
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
