//
//  JDPCreditsViewController.m
//  MoneyHole
//
//  Created by Joel Parsons on 30/05/2013.
//  Copyright (c) 2013 Small Bet. All rights reserved.
//

#import "JDPCreditsViewController.h"
#import "JDPMainViewController.h"
#import "JDPMenuViewController.h"


@interface JDPCreditsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *creditsTextView;

@end

@implementation JDPCreditsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.backgroundColor = [UIColor clearColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGFloat creditsHeight = CGRectGetHeight(self.creditsTextView.frame);
    CGFloat creditsLength = self.creditsTextView.contentSize.height;
    if (creditsLength > creditsHeight) {
        [self.creditsTextView flashScrollIndicators];
    }
}

#pragma mark - target action

- (IBAction)infoButtonTapped:(id)sender {
    JDPMenuViewController * menuViewController = [[JDPMenuViewController alloc] init];
    [(id)self.parentViewController crossfadeToViewController:menuViewController];
}

@end
