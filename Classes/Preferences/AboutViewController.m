// AboutViewController.m
// MobileTerminal

#import <QuartzCore/CALayer.h>
#import "AboutViewController.h"
#import "Settings.h"


@implementation AboutViewController

@synthesize versionLabel;
@synthesize textview;
@synthesize cell;
@synthesize followcell;
@synthesize about;

static const char* LicenseMessage =
"License:\n"
"Original(GNU GPL v2)\n"
"https://code.google.com/p/mobileterminal/\n\n\n"


"Used library:\n"
"Color-Picker-for-iOS\n"
"Copyright (c) 2011 Ryota Hayashi\n"
"https://github.com/hayashi311/Color-Picker-for-iOS\n\n"

"This is follow new freebsd license\n\n"
"Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\n 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\n 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\n\n THIS SOFTWARE IS PROVIDED BY THE AUTHOR(S) ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR(S) BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\n\n"

"--------------------------------------------------\n\n"
"WYPopoverController\n"
"Copyright © 2013 Nicolas CHENG\n"
"https://github.com/nicolaschengdev/WYPopoverController\n\n"

"SVWebViewController\n"
"Copyright (c) 2011 Sam Vermette\n"
"https://github.com/TransitApp/SVWebViewController\n\n"

"HPGrowingTextView\n"
"Copyright (c) 2011 Hans Pinckaers\n"
"https://github.com/HansPinckaers/GrowingTextView\n\n"

"Tesseract-OCR-iOS\n"
"Copyright (c) 2014 Daniele Galiotto\n"
"https://github.com/gali8/Tesseract-OCR-iOS\n\n"

"They are follow MIT license\n\n"

"Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (\"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\n\n"


"The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\n"

"THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n\n"

"--------------------------------------------------\n\n"

"Tesseract, maintained by Google (http://code.google.com/p/tesseract-ocr/), is distributed under the Apache 2.0 license (see http://www.apache.org/licenses/LICENSE-2.0).\n\n"

"Fonts:\n\n"

"AnonymousPro, CutiveMono-Regular, FiraMono, MesloLGM-Regular, SourceCodePro-Regular, VT323-Regular\n"
"They are based on the SIL Open Font License version 1.1.\n\n"

"UbuntuMono-Regular\n"
"This is based on the Ubuntu Font Licence version 1.0.\n\n"

"Cousine-Regular\n"
"This is based on the Apache License version 2.0.\n\n"

"ProFont\n"
"This is based on the MIT License.\n\n"

"Fixedsys\n"
"This is based on the GNU General Public License.\n\n"

"LuxiMono\n"
"This is based on the Bigelow & Holmes - Luxi License.\n\n"

"Luxi fonts copyright (c) 2001 by Bigelow & Holmes Inc. Luxi font instruction code copyright (c) 2001 by URW++ GmbH. All Rights Reserved. Luxi is a registered trademark of Bigelow & Holmes Inc. Permission is hereby granted, free of charge, to any person obtaining a copy of these Fonts and associated documentation files (the \"Font Software\"), to deal in the Font Software, including without limitation the rights to use, copy, merge, publish, distribute, sublicense, and/or sell copies of the Font Software, and to permit persons to whom the Font Software is furnished to do so, subject to the following conditions:\n\nThe above copyright and trademark notices and this permission notice shall be included in all copies of one or more of the Font Software.\n\nThe Font Software may not be modified, altered, or added to, and in particular the designs of glyphs or characters in the Fonts may not be modified nor may additional glyphs or characters be added to the Fonts. This License becomes null and void when the Fonts or Font Software have been modified.\n\nTHE FONT SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF COPYRIGHT, PATENT, TRADEMARK, OR OTHER RIGHT. IN NO EVENT SHALL BIGELOW & HOLMES INC. OR URW++ GMBH. BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, INCLUDING ANY GENERAL, SPECIAL, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF THE USE OR INABILITY TO USE THE FONT SOFTWARE OR FROM OTHER DEALINGS IN THE FONT SOFTWARE.\n\nExcept as contained in this notice, the names of Bigelow & Holmes Inc. and URW++ GmbH. shall not be used in advertising or otherwise to promote the sale, use or other dealings in this Font Software without prior written authorization from Bigelow & Holmes Inc. and URW++ GmbH.\n\nFor further information, contact:\n\ninfo@urwpp.de or design@bigelowandholmes.com";

- (void)viewDidLoad
{
    [super viewDidLoad];
    textview.editable = NO;
    textview.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:14];
    textview.text = [NSString stringWithUTF8String:LicenseMessage];
    
    Settings* settings = [Settings sharedInstance];
    versionLabel.text = [NSString stringWithFormat:@"Version: %0.1f", settings.svnVersion];
    CALayer *lay = about.layer;
    [lay setCornerRadius:14];
    lay.borderColor = [UIColor lightGrayColor].CGColor;
    lay.borderWidth = 1;
    UIImage *img = [UIImage imageNamed:@"uLt_AVJN.jpeg"];
    UIImage *profile = [img makeimgofsize:CGSizeMake(60, 60)];
    CALayer *cellImageLayer = cell.imageView.layer;
    [cellImageLayer setCornerRadius:30];
    [cellImageLayer setMasksToBounds:YES];
    cellImageLayer.bounds = CGRectMake(0, 0, 10, 10);
    CALayer *topBorder = [CALayer layer];
    topBorder.borderColor = [UIColor lightGrayColor].CGColor;
    topBorder.borderWidth = 0.7;
    topBorder.frame = CGRectMake(0, 0, CGRectGetWidth(cell.frame), 0.7);
    
    [cell.layer addSublayer:topBorder];
    cell.imageView.image = profile;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    cell.textLabel.text = @"K (CodeHex)";
    cell.detailTextLabel.text = @"I'm WhiteTerminal Developer";
    cell.tintColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor whiteColor];
    
    followcell.layer.borderWidth = 0.7;
    followcell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    followcell.textLabel.text = @"Follow me on Twitter";
    followcell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    unichar c = 0xf081;
    NSString *twi = [[[NSString alloc] initWithCharacters:&c length:1] autorelease];
    followcell.imageView.image = [profile imageWithText:twi fontName:@"FontAwesome" fontSize:45 rectSize:CGSizeMake(60, 60)];

    UIButton *btn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(0, 0, followcell.frame.size.width, followcell.frame.size.height);
    [btn addTarget:self action:@selector(followButton:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[profile imageWithColor:[UIColor darkGrayColor]] forState:UIControlStateHighlighted];
    [followcell addSubview:btn];
    
}

-(void)followButton:(id)sender{
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
                
                NSMutableDictionary *tempDict = [[[NSMutableDictionary alloc] init] autorelease];
                [tempDict setValue:@"CodeHex" forKey:@"screen_name"];
                [tempDict setValue:@"true" forKey:@"follow"];
                
                SLRequest *followRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"https://api.twitter.com/1/friendships/create.json"] parameters:tempDict];
                
                [followRequest setAccount:twitterAccount];
                [followRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
 
                    if (error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            Class class = NSClassFromString(@"UIAlertController");
                            if(class){
                                UIAlertController *alert = nil;
                                alert = [UIAlertController alertControllerWithTitle:@"Accomplished"
                                                                            message:@"I'm sorry. Please try search for the account of @CodeHex in twitter."
                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                          style:UIAlertActionStyleDefault
                                                                        handler:nil]];
                                [self presentViewController:alert animated:YES completion:nil];
                            } else {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Accomplished"
                                                                                message:@"I'm sorry. Please try search for the account of @CodeHex in twitter."
                                                                               delegate:self
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                                [alert show];
                            }
                            //Update UI to show follow request failed
                        });
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"tap");
                            Class class = NSClassFromString(@"UIAlertController");
                            if(class){
                                UIAlertController *alert = nil;
                                alert = [UIAlertController alertControllerWithTitle:@"Accomplished"
                                                                            message:@"Thanks follow me 😊"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                          style:UIAlertActionStyleDefault
                                                                        handler:nil]];
                                [self presentViewController:alert animated:YES completion:nil];
                            } else {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Accomplished"
                                                                                message:@"Thanks follow me 😊"
                                                                               delegate:self
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                                [alert show];
                            }
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
    [tweet setInitialText:@"\"#WhiteTerminal is simple & powerful & awesome!! Don't you wanna try it?\nhttp://cydia.saurik.com/package/com.codehex.whiteterminal/\""];
    [self presentViewController:tweet animated:YES completion:nil];
}

- (void)dealloc {
    [textview release];
    [cell release];
    [followcell release];
    [about release];
    [super dealloc];
}
@end
