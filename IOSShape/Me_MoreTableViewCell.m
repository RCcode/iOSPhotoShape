//
//  Me_MoreTableViewCell.m
//  IOSMirror
//
//  Created by gaoluyangrc on 14-6-20.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.

#import "Me_MoreTableViewCell.h"
#import "CMethods.h"

@implementation Me_MoreTableViewCell

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.logoImageView.layer.cornerRadius = 12.f;
    self.logoImageView.layer.masksToBounds = YES;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont fontWithName:FONTNAMESTRING size:14];
    self.titleLabel.numberOfLines = 0;
    [self.titleLabel sizeToFit];
    self.typeLabel.textColor = colorWithHexString(@"#777777");
    self.commentLabel.textColor = colorWithHexString(@"#777777");
    self.installBtn.layer.borderColor = colorWithHexString(@"#3D7DBF").CGColor;
    self.installBtn.layer.borderWidth = 1.f;
    self.installBtn.layer.cornerRadius = 4.f;
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 94.5, 320, .5f)];
    backView.backgroundColor = colorWithHexString(@"#dddddd");
    [self.contentView addSubview:backView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

- (IBAction)installBtnClick:(id)sender
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.appInfo.openUrl]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appInfo.openUrl]];
    }
    else
    {
        [self.delegate jumpAppStore:self.appInfo.downUrl];
    }
}

@end
