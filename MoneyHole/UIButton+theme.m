//
//  UIButton+theme.m
//  MoneyHole
//
//  Created by Joel Parsons on 29/04/2013.
//  Copyright (c) 2013 Small Bet. All rights reserved.
//

#import "UIButton+theme.h"

@implementation UIButton (theme)
-(void)jdpThemeButtonWithMoneyholeTheme{
    UIImage * buttonImage = [UIImage imageNamed:@"button"];
    
    CGFloat leftInset = floorf(buttonImage.size.width / 2.0f) - 1;
    CGFloat rightInset = buttonImage.size.width - leftInset;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, leftInset, 0, rightInset);
    
    buttonImage = [buttonImage resizableImageWithCapInsets:insets];
    UIImage * disabledButtonImage = [[UIImage imageNamed:@"buttonDisabled"] resizableImageWithCapInsets:insets];
    UIImage * selectedButtonImage = [[UIImage imageNamed:@"buttonHighlighted"] resizableImageWithCapInsets:insets];
    
    [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self setBackgroundImage:selectedButtonImage forState:UIControlStateHighlighted];
    [self setBackgroundImage:selectedButtonImage forState:UIControlStateSelected];
    [self setBackgroundImage:disabledButtonImage forState:UIControlStateDisabled];
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    [self setAdjustsImageWhenHighlighted:NO];
    [self setAdjustsImageWhenDisabled:NO];
}
@end
