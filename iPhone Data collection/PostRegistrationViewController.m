//
//  PostRegistrationViewController.m
//  iphone-sms
//
//  Created by Tom Werner on 5/18/14.
//  Copyright (c) 2014 Tom Werner. All rights reserved.
//

#import "PostRegistrationViewController.h"
#import "eduAppDelegate.h"
#import "CustomIOS7AlertView.h"

@interface PostRegistrationViewController ()

@end

@implementation PostRegistrationViewController



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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reRegisterClicked:(id)sender
{
    eduAppDelegate *appDelegate = (eduAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate changeToRegistration];
}

- (IBAction)launchSurveyClicked:(id)sender
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
    
    NSURL *url = [NSURL URLWithString:SURVEY_URL];
    
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

- (IBAction)resourcesClicked:(id)sender
{
    NSString *urlString = GET_HELP_URL;
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (![[UIApplication sharedApplication] openURL:url])
    {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}

- (IBAction)reportClicked:(id)sender
{
    NSString *urlString = REPORT_BULLYING_URL;
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (![[UIApplication sharedApplication] openURL:url])
    {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
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
        NSLog(@"Here");
        if (buttonIndex == 0) // The email button
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
    }
}



- (IBAction)helpClicked:(id)sender
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
@end
