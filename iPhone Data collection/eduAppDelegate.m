//
//  eduAppDelegate.m
//  Hello World
//
//  Created by Tom Werner on 5/2/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "eduAppDelegate.h"
#import "RegistrationViewController.h"
#import "PostRegistrationViewController.h"


//Just do find replace to change the url, objective c doesn't allow for string
//concatenation in variables like these
NSString* BASE_URL =             @"http://192.168.1.13:7000/DataCollection";
NSString* ANDROID_UPLOAD_URL =   @"http://192.168.1.13:7000/DataCollection/postandroid/";
NSString* POST_TOKEN_URL =       @"http://192.168.1.13:7000/DataCollection/newtoken/";
NSString* SURVEY_URL =           @"http://192.168.1.13:7000/DataCollection/survey/";
NSString* CREATE_USER_URL =      @"http://192.168.1.13:7000/DataCollection/makeuser/";
NSString* GET_HELP_URL =         @"http://192.168.1.13:7000/DataCollection/gethelp/";
NSString* REPORT_BULLYING_URL =  @"http://192.168.1.13:7000/DataCollection/reportbullying/";
NSString* WITHDRAW_REQUEST_URL = @"http://192.168.1.13:7000/DataCollection/withdraw/";



@implementation eduAppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBProfilePictureView class];
    [FBLoginView class];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"phone_number"])
    {
        PostRegistrationViewController *viewController = [[PostRegistrationViewController alloc] initWithNibName:@"PostRegistrationViewController" bundle:nil];
        self.navigation = [[UINavigationController alloc]initWithRootViewController:viewController];
        self.window.rootViewController = self.navigation;
    }
    else
    {
        RegistrationViewController *viewController = [[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController" bundle:nil];
        self.navigation = [[UINavigationController alloc]initWithRootViewController:viewController];
        self.window.rootViewController = self.navigation;
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    [self.window makeKeyAndVisible];
    
    if (launchOptions != nil)
	{
		NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil)
		{
			NSLog(@"Launched from push notification: %@", dictionary);
			[self launchSurveyFromRemoteNotification:dictionary updateUI:NO];
		}
	}
    
    return YES;
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
	NSLog(@"Received notification: %@", userInfo);
	[self launchSurveyFromRemoteNotification:userInfo updateUI:YES];
}

- (void)launchSurvey
{
    NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone_number"];
    
    NSDictionary *postDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             phoneNumber, @"user",
                             nil];
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDic options:0 error:&error];
    if (error)
    {
        
        NSLog(@"ERROR: \n%@\n", error);
    }
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.13:7000/DataCollection/survey/"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    //[req setValue:[NSString stringWithFormat:@"%d", postData.length] forHTTPHeaderField:@"Content-Length"];
    //[req setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:postData];
    
    NSError *err = nil;
    NSHTTPURLResponse *res = nil;
    NSData *retData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
    if (err)
    {
        NSLog(@"ERROR: \n%@\n", err);
    }
    else
    {
        NSString *strData = [[NSString alloc]initWithData:retData encoding:NSUTF8StringEncoding];
        //handle response and returning data
        
        //Valid survey
        if (![strData isEqualToString:@"null"])
        {
            NSURL *url = [NSURL URLWithString:strData];
            
            if (![[UIApplication sharedApplication] openURL:url])
            {
                NSLog(@"%@%@",@"Failed to open url:",[url description]);
            }
        }
        
        NSLog(@"URL returned: %@\n\n", strData);
        
    }
    
}

- (void)launchSurveyFromRemoteNotification:(NSDictionary*)userInfo updateUI:(BOOL)updateUI
{
    //This will contain information from the notification
    NSString *alertValue = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    
	if (updateUI)
    {
        [self launchSurvey];
    }
}



- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void) changeToRegistration
{
    [self.navigation pushViewController:[[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController" bundle:nil] animated:true];
}

- (void) changeToPostRegistration
{
    [self.navigation pushViewController:[[PostRegistrationViewController alloc] initWithNibName:@"PostRegistrationViewController" bundle:nil] animated:true];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    
    
    return wasHandled;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
