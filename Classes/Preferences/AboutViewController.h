// AboutViewController.h
// MobileTerminal

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>


@interface AboutViewController : UIViewController {
@private
  UILabel* versionLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* versionLabel;

-(IBAction)tweetbutton:(id)sender;
-(IBAction)followButton:(id)sender;


@end
