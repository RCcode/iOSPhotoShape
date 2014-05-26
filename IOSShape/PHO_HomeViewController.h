//
//  PHO_HomeViewController.h
//  photoprocessing
//
//  Created by wsq-wlq on 14-5-21.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GADBannerViewDelegate.h"

@class GADBannerView;
@class GADRequest;

@interface PHO_HomeViewController : UIViewController<UIImagePickerControllerDelegate, GADBannerViewDelegate, MFMailComposeViewControllerDelegate>
{
    UIImagePickerController *imagePicker;
    UIImage *chooseImage;
    UIView *moreView;
}

@property(strong, nonatomic) GADBannerView *adBanner;

- (GADRequest *)request;


@end
