//
//  RegistrationViewController.m
//  Hello World
//
//  Created by Tom Werner on 5/2/14.
//  Copyright (c) 2014 Tom Werner. All rights reserved.
//

#import "RegistrationViewController.h"
#import "Twitter/Twitter.h"
#import "eduAppDelegate.h"
#import "CustomIOS7AlertView.h"

NSString* TWITTER_CONSUMER_KEY = @"BaWtyknv1RwsU60jVccA";
NSString* TWITTER_CONSUMER_SECRET = @"EDopj7ySkVstUTD294ODgUlmhctGi3PBSkW2OljhhPY";
NSString* TWITTER_CALLBACK_URL = @"oauth://datacollection";


@interface RegistrationViewController ()
@property (nonatomic, strong) NSMutableData *responseData;

@end



@implementation RegistrationViewController
@synthesize webview, accessToken, twitterID, phoneNumber;
@synthesize responseData;

bool twitterSkipped = false;
bool facebookSkipped = false;

- (IBAction) facebookButtonClicked: (UIButton *)sender
{
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Skip Facebook Login", @"Done", nil]];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 55)];
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"public_profile", @"read_stream", @"read_mailbox"]];
    loginView.frame = CGRectOffset(loginView.frame, (view.center.x - (loginView.frame.size.width / 2)), 5);
    loginView.delegate = self;
    [view addSubview:loginView];
    
    [alertView setContainerView:view];
    
    [alertView setDelegate:self];
    [alertView show];
}

- (IBAction) twitterButtonClicked: (UIButton *)sender
{
    NSLog(@"Button lcicked");
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Login To Twitter", @"Skip Twitter Login", nil]];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 0)];
    [alertView setContainerView:view];
    
    [alertView setDelegate:self];
    [alertView show];
}

- (void) createRegistrationDialog
{
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Close", nil]];
    
    NSString *helpMessage = @"Registration steps:\n1) Press the Facebook button and login.\n2) Press the Twitter button and login.\n3) Enter your phone number.\n4) Press submit.\nQuestions or comments? Contact support@uiowa.cyberbullying.edu";
    NSString *helpTitle = @"Registration help";
    
    UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 200, 20)];
    [titleText setTextColor:[UIColor blackColor]];
    [titleText setBackgroundColor:[UIColor clearColor]];
    [titleText setFont:[UIFont fontWithName: @"Trebuchet MS" size: 18.0f]];
    [titleText setText:helpTitle];
    
    UILabel *contentText = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300 - 20, 180)];
    [contentText setTextColor:[UIColor blackColor]];
    [contentText setBackgroundColor:[UIColor clearColor]];
    [contentText setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
    [contentText setText:helpMessage];
    contentText.lineBreakMode = NSLineBreakByWordWrapping;
    contentText.numberOfLines = 0;
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"university of iowa logo.png"]];
    imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 32, 32);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 200)];
    [view addSubview:imageView];
    [view addSubview:titleText];
    [view addSubview:contentText];
    
    [alertView setContainerView:view];
    
    [alertView setDelegate:self];
    [alertView show];
}

- (void) createPrivacyStatementDialog
{
    NSString *privacyStatement = @"All data will be stored on a secure University of Iowa server. No unauthorized users will have access to the data and it will be anonymized. No details of your or your friends will ever be shared.";
	NSString *privacyTitle = @"Privacy Statement";
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Close", nil]];
    
    UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 200, 20)];
    [titleText setTextColor:[UIColor blackColor]];
    [titleText setBackgroundColor:[UIColor clearColor]];
    [titleText setFont:[UIFont fontWithName: @"Trebuchet MS" size: 18.0f]];
    [titleText setText:privacyTitle];
    
    UILabel *contentText = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300 - 40, 180)];
    [contentText setTextColor:[UIColor blackColor]];
    [contentText setBackgroundColor:[UIColor clearColor]];
    [contentText setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
    [contentText setText:privacyStatement];
    contentText.lineBreakMode = NSLineBreakByWordWrapping;
    contentText.numberOfLines = 0;
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"university of iowa logo.png"]];
    imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 32, 32);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 200)];
    [view addSubview:imageView];
    [view addSubview:titleText];
    [view addSubview:contentText];
    
    [alertView setContainerView:view];
    
    [alertView setDelegate:self];
    [alertView show];
}

- (void) createErrorReportDialog
{
    NSString *errorStatement = @"Found a bug? Have suggestions for us? Want more information about this study?\nContact us at support@uiowa.cyberbullying.edu";
	NSString *errorTitle = @"Report an Error";

    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Email Us", @"Close", nil]];
    
    UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 200, 20)];
    [titleText setTextColor:[UIColor blackColor]];
    [titleText setBackgroundColor:[UIColor clearColor]];
    [titleText setFont:[UIFont fontWithName: @"Trebuchet MS" size: 18.0f]];
    [titleText setText:errorTitle];
    
    UILabel *contentText = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300 - 40, 180)];
    [contentText setTextColor:[UIColor blackColor]];
    [contentText setBackgroundColor:[UIColor clearColor]];
    [contentText setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
    [contentText setText:errorStatement];
    contentText.lineBreakMode = NSLineBreakByWordWrapping;
    contentText.numberOfLines = 0;
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"university of iowa logo.png"]];
    imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 32, 32);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 200)];
    [view addSubview:imageView];
    [view addSubview:titleText];
    [view addSubview:contentText];
    
    [alertView setContainerView:view];
    
    [alertView setDelegate:self];
    [alertView show];
}

- (void) createWithdrawDialog
{
    NSString *withdrawStatement = @"Want to withdraw from the study? Email us at support@uiowa.cyberbullying.edu";
	NSString *withdrawTitle = @"Withdraw from Study";
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Withdraw", @"Close", nil]];
    
    UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 200, 20)];
    [titleText setTextColor:[UIColor blackColor]];
    [titleText setBackgroundColor:[UIColor clearColor]];
    [titleText setFont:[UIFont fontWithName: @"Trebuchet MS" size: 18.0f]];
    [titleText setText:withdrawTitle];
    
    UILabel *contentText = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300 - 40, 180)];
    [contentText setTextColor:[UIColor blackColor]];
    [contentText setBackgroundColor:[UIColor clearColor]];
    [contentText setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
    [contentText setText:withdrawStatement];
    contentText.lineBreakMode = NSLineBreakByWordWrapping;
    contentText.numberOfLines = 0;
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"university of iowa logo.png"]];
    imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 32, 32);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 200)];
    [view addSubview:imageView];
    [view addSubview:titleText];
    [view addSubview:contentText];
    
    [alertView setContainerView:view];
    
    [alertView setDelegate:self];
    [alertView show];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    [alertView close];
    if ([[alertView buttonTitles] count] <= 1)
        return;
    
    if ([(NSString *)[alertView buttonTitles][buttonIndex] isEqual: @"Skip Facebook Login"])
    {
        facebookSkipped = true;
        [self.facebookLoginButton setTitle: @"Skipped Login" forState:UIControlStateNormal];
        self.facebookLoginButton.enabled = NO;
    }
    else if ([(NSString *)[alertView buttonTitles][buttonIndex] isEqual: @"Skip Twitter Login"])
    {
        twitterSkipped = true;
        [self.twitterLoginButton setTitle: @"Skipped Login" forState:UIControlStateNormal];
        self.twitterLoginButton.enabled = NO;
    }
    
    if ([[alertView buttonTitles] count] == 5) //The main help screen
    {
        if (buttonIndex == 0)
        {
            [self createRegistrationDialog];
        }
        else if (buttonIndex == 1)
        {
            [self createPrivacyStatementDialog];
        }
        else if (buttonIndex == 2)
        {
            [self createErrorReportDialog];
        }
        else if (buttonIndex == 3)
        {
            [self createWithdrawDialog];
        }
    }
    else if ([[alertView buttonTitles] count] == 2) //Just a close and email
    {
        if (buttonIndex == 0 && [[alertView buttonTitles][0]  isEqual: @"Email Us"]) // The email button
        {
            /* create mail subject */
            NSString *subject = [alertView buttonTitles][0];
            
            /* define email address */
            NSString *mail = [NSString stringWithFormat:@"support@uiowa.cyberbullying.edu"];
            
            /* create the URL */
            NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=%@&subject=%@",
                                                        [mail stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                                        [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
            NSLog(@"%@\n", url);
            /* load the URL */
            [[UIApplication sharedApplication] openURL:url];
        }
        else if (buttonIndex == 0 && [[alertView buttonTitles][0]  isEqual: @"Login To Twitter"])
        {
            NSLog(@"Here, twitter popup callback");
            self.webview.hidden = FALSE;
            consumer = [[OAConsumer alloc] initWithKey:TWITTER_CONSUMER_KEY secret:TWITTER_CONSUMER_SECRET];
            NSURL* requestTokenUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
            OAMutableURLRequest* requestTokenRequest = [[OAMutableURLRequest alloc] initWithURL:requestTokenUrl
                                                                                       consumer:consumer
                                                                                          token:nil
                                                                                          realm:nil
                                                                              signatureProvider:nil];
            OARequestParameter* callbackParam = [[OARequestParameter alloc] initWithName:@"oauth_callback" value:TWITTER_CALLBACK_URL];
            [requestTokenRequest setHTTPMethod:@"POST"];
            [requestTokenRequest setParameters:[NSArray arrayWithObject:callbackParam]];
            OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
            [dataFetcher fetchDataWithRequest:requestTokenRequest
                                     delegate:self
                            didFinishSelector:@selector(didReceiveRequestToken:data:)
                              didFailSelector:@selector(didFailOAuth:error:)];
        }
    }
}

- (IBAction) helpButtonClicked: (UIButton *) sender
{
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Registration Help", @"Privacy Statement", @"Report an Error", @"Withdraw from study", @"Close", nil]];
    
    UILabel *yourLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 200, 20)];
    [yourLabel setTextColor:[UIColor blackColor]];
    [yourLabel setBackgroundColor:[UIColor clearColor]];
    [yourLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 18.0f]];
    [yourLabel setText:@"Help Menu"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"university of iowa logo.png"]];
    imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 32, 32);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 50)];
    [view addSubview:imageView];
    [view addSubview:yourLabel];
    
    [alertView setContainerView:view];
    
    [alertView setDelegate:self];
    [alertView show];
}



- (IBAction) submitButtonClicked: (UIButton *)sender
{
    [self uploadRegistrationData:[FBSession activeSession]];
}

- (void)textFieldDidBeginEditing:(UITextField *) textField
{
    [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *) textField
{
    [self animateTextField: textField up: NO];
    phoneNumber = [textField text];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80;
    const float movementDuration = .3f;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations:@"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webview.hidden = TRUE;
}


- (void)didReceiveRequestToken:(OAServiceTicket*)ticket data:(NSData*)data {
    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    requestToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];
    
    NSURL* authorizeUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/authorize"];
    OAMutableURLRequest* authorizeRequest = [[OAMutableURLRequest alloc] initWithURL:authorizeUrl
                                                                            consumer:nil
                                                                               token:nil
                                                                               realm:nil
                                                                   signatureProvider:nil];
    NSString* oauthToken = requestToken.key;
    OARequestParameter* oauthTokenParam = [[OARequestParameter alloc] initWithName:@"oauth_token" value:oauthToken];
    [authorizeRequest setParameters:[NSArray arrayWithObject:oauthTokenParam]];
    
    [webview loadRequest:authorizeRequest];
}

- (void)didReceiveAccessToken:(OAServiceTicket*)ticket data:(NSData*)data {
    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    accessToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];
    NSLog(@"Key: %@", accessToken.key);
    NSLog(@"Secret: %@",accessToken.secret);
    
    NSRange range = [accessToken.key rangeOfString:@"-"];
    twitterID = [accessToken.key substringToIndex:range.location];
    [self.twitterLoginButton setTitle:@"Logged in to Twitter" forState:UIControlStateNormal];
    self.twitterLoginButton.enabled = NO;
}

- (void)didFailOAuth:(OAServiceTicket*)ticket error:(NSError*)error {
    // ERROR!
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    //  [indicator startAnimating];
    NSString *temp = [NSString stringWithFormat:@"%@",request];
    
    NSRange textRange = [[temp lowercaseString] rangeOfString:[TWITTER_CALLBACK_URL lowercaseString]];
    
    if(textRange.location != NSNotFound){
        
        // Extract oauth_verifier from URL query
        NSString* verifier = nil;
        NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
        for (NSString* param in urlParams) {
            NSArray* keyValue = [param componentsSeparatedByString:@"="];
            NSString* key = [keyValue objectAtIndex:0];
            if ([key isEqualToString:@"oauth_verifier"]) {
                verifier = [keyValue objectAtIndex:1];
                break;
            }
        }
        
        if (verifier) {
            NSURL* accessTokenUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
            OAMutableURLRequest* accessTokenRequest = [[OAMutableURLRequest alloc] initWithURL:accessTokenUrl consumer:consumer token:requestToken realm:nil signatureProvider:nil];
            OARequestParameter* verifierParam = [[OARequestParameter alloc] initWithName:@"oauth_verifier" value:verifier];
            [accessTokenRequest setHTTPMethod:@"POST"];
            [accessTokenRequest setParameters:[NSArray arrayWithObject:verifierParam]];
            OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
            [dataFetcher fetchDataWithRequest:accessTokenRequest
                                     delegate:self
                            didFinishSelector:@selector(didReceiveAccessToken:data:)
                              didFailSelector:@selector(didFailOAuth:error:)];
        } else {
            // ERROR!
        }
        
        self.webview.hidden = TRUE;
        
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    NSLog(@"Webview error: %@", error);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // [indicator stopAnimating];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{
    [self.facebookLoginButton setTitle:[@"Logged in as " stringByAppendingString: user.name] forState:UIControlStateNormal];
    self.facebookLoginButton.enabled = NO;
}

- (IBAction) phoneFieldValueChanged: (UITextField *) textField
{
    phoneNumber = textField.text;
    NSLog(@"%@\n", phoneNumber);
}

- (void) uploadRegistrationData:
            (FBSession *) currentSession
{
    NSString *fbAccessToken = currentSession.accessTokenData.accessToken;
    NSString *fbAppID = currentSession.appID;
    NSString *fbUserID = currentSession.appID;
    printf("%s\n", fbAccessToken.UTF8String);
    
    if ([fbAccessToken length] == 0 && !facebookSkipped)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Registration"
                                                        message:@"Complete the Facebook section"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([twitterID length] == 0 && !twitterSkipped)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Registration"
                                                        message:@"Complete the Twitter section"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([phoneNumber length] != 10)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Registration"
                                                        message:@"Your phone number should be 10 digits"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSDictionary *postDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             phoneNumber, @"phone_number",
                             fbAccessToken, @"facebook_token",
                             fbAppID, @"facebook_appid",
                             fbUserID, @"facebook_id",
                             accessToken.key, @"twitter_token",
                             accessToken.secret, @"twitter_secret",
                             @"", @"twitter_screen_name",
                             twitterID, @"twitter_id",
                             nil];
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDic options:0 error:&error];
    if (error)
    {
        
        NSLog(@"ERROR: \n%@\n", error);
    }
    
    NSURL *url = [NSURL URLWithString:CREATE_USER_URL];
    
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Error"
                                                        message:@"An unknown error has occurred with registration. If your internet connection isn't currently working, please try again after fixing it. Otherwise, give us 24 hours to fix the server."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSString *strData = [[NSString alloc]initWithData:retData encoding:NSUTF8StringEncoding];
        //handle response and returning data
        NSLog(@"NO ERROR: \n%@\n\n", strData);
        NSLog(@"%@\n", postDic);
        
        if ([strData  isEqual: @"PASS"])
        {
            
            [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:@"phone_number"];
            [[NSUserDefaults standardUserDefaults] setObject:twitterID forKey:@"twitter_id"];
            [[NSUserDefaults standardUserDefaults] setObject:accessToken.key forKey:@"twitter_key"];
            [[NSUserDefaults standardUserDefaults] setObject:accessToken.secret forKey:@"twitter_secret"];
            [[NSUserDefaults standardUserDefaults] setObject:fbAccessToken forKey:@"facebook_token"];
            [[NSUserDefaults standardUserDefaults] setObject:fbUserID forKey:@"facebook_id"];
        
        
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Complete"
                                                            message:@"Thanks for registering!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
            eduAppDelegate *appDelegate = (eduAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate changeToPostRegistration];
        }
    }
}




// Logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
}

// Logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    [self.facebookLoginButton setTitle:@"Login to Facebook" forState:UIControlStateNormal];
    self.facebookLoginButton.enabled = YES;
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
