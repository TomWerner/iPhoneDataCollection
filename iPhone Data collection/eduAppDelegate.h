//
//  eduAppDelegate.h
//  Hello World
//
//  Created by Tom Werner on 5/2/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* BASE_URL;
extern NSString* ANDROID_UPLOAD_URL;
extern NSString* POST_TOKEN_URL;
extern NSString* SURVEY_URL;
extern NSString* CREATE_USER_URL;
extern NSString* GET_HELP_URL;
extern NSString* REPORT_BULLYING_URL;
extern NSString* WITHDRAW_REQUEST_URL;


@interface eduAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigation;



- (void) changeToPostRegistration;
- (void) changeToRegistration;

@end

