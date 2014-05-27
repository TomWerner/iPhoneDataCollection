//
//  PostRegistrationViewController.h
//  iphone-sms
//
//  Created by Tom Werner on 5/18/14.
//  Copyright (c) 2014 Tom Werner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostRegistrationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *reRegisterButton;
@property (weak, nonatomic) IBOutlet UIButton *launchSurveyButton;
@property (weak, nonatomic) IBOutlet UIButton *resourcesButton;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
- (IBAction)reRegisterClicked:(id)sender;
- (IBAction)launchSurveyClicked:(id)sender;
- (IBAction)resourcesClicked:(id)sender;
- (IBAction)reportClicked:(id)sender;
- (IBAction)helpClicked:(id)sender;

@end
