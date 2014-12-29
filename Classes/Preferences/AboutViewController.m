// AboutViewController.m
// MobileTerminal

#import "AboutViewController.h"
#import "Settings.h"

@implementation AboutViewController

@synthesize versionLabel;

-(IBAction)followButton:(id)sender{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        
        if (granted) {
            
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            // For the sake of brevity, we'll assume there is only one Twitter account present.
            // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
            if ([accountsArray count] > 0) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = accountsArray[0];
                
                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                [tempDict setValue:@"CodeHex" forKey:@"screen_name"];
                [tempDict setValue:@"true" forKey:@"follow"];
                
                SLRequest *followRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"https://api.twitter.com/1/friendships/create.json"] parameters:tempDict];
                
                [followRequest setAccount:twitterAccount];
                [followRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
                    NSLog(@"%@", output);
                    if (error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"tap");
                            //alert
                            UIAlertView *alert = [[UIAlertView alloc]
                                                  initWithTitle:@"Failed!"
                                                  message:@"I'm sorry. Please try search for the account of @CodeHex in twitter."
                                                  delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alert show];
                            //Update UI to show follow request failed
                        });
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"tap");
                            //alert
                            UIAlertView *alert = [[UIAlertView alloc]
                                                  initWithTitle:@"Accomplished!"
                                                  message:@"Thanks follow me 😊"
                                                  delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alert show];
                            //Update UI to show success
                        });
                    }
                }];
            }
        }
    }];
}


-(IBAction)tweetbutton:(id)sender
{
    SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweet setInitialText:@"White mobile Terminal is simple & awesome!! Don`t you wanna try it?\nRepo http://simplecake.tk/apt"];
    [self presentViewController:tweet animated:YES completion:nil];
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (void)awakeFromNib
{
  [super awakeFromNib];
    /* svnVersion is float type */
  Settings* settings = [Settings sharedInstance];
  versionLabel.text = [NSString stringWithFormat:@"w%0.1f", settings.svnVersion];
}

@end
