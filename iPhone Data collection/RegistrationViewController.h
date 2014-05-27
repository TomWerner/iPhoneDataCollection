//
//  RegistrationViewController.h
//  Hello World
//
//  Created by Tom Werner on 5/2/14.
//  Copyright (c) 2014 Tom Werner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "OAuthConsumer.h"

@interface RegistrationViewController : UIViewController <FBLoginViewDelegate, UIWebViewDelegate>
{
    IBOutlet UIWebView *webview;
    OAConsumer* consumer;
    OAToken* requestToken;
    OAToken* accessToken;
}

// In your view header file:
@property (strong, nonatomic) IBOutlet UIButton *facebookLoginButton;
@property (strong, nonatomic) IBOutlet UIButton *twitterLoginButton;
@property (retain, nonatomic) IBOutlet UIWebView* webview;

@property (strong, nonatomic) OAToken* accessToken;
@property (strong, nonatomic) NSString* twitterID;
@property (strong, nonatomic) NSString* phoneNumber;

- (IBAction) twitterButtonClicked: (UIButton *)sender;
- (IBAction) helpButtonClicked: (UIButton *)sender;
- (IBAction) submitButtonClicked: (UIButton *)sender;
- (IBAction) facebookButtonClicked: (UIButton *)sender;

- (void) uploadRegistrationData: (FBSession*) currentSession;
- (void)textFieldDidBeginEditing:(UITextField *) textField;
- (void)textFieldDidEndEditing:(UITextField *) textField;
- (void) animateTextField: (UITextField*) textField up: (BOOL) up;

@end

