/*
 
 This is a starting point for a controller to facilitate
 "Citizen Reporting". It implements the delegate methods
 for the UIImagePickerController and the MFMailCompose
 controllers. So that a user can grab a picture from
 their camera or from their photo library and then
 send that image as an email to a designated email address.
 
 If the device is not set up for mail correctly then
 the contoller will just launch any mail application
 that responds to the URL of mailto:. In this case the
 attachement can not be sent along.
 
 This code relies heavily on the examples provided by
 the Apple documentation and Maher Ali's book "iPHone
 SDK3 Programming".

 Created by Walter Tyree on January 20, 2010
 Copyright 2010 TyreeApps.com. Reuse with attribution.
 Updated by Walter Tyree in July 2010
 
 */

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface CitizenReporterViewController : UIViewController <MFMailComposeViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> 
{

	IBOutlet UIImageView *photo;
	NSString *sendTo;
	NSString *subject;
	NSString *body;
}


@property (nonatomic, retain) IBOutlet UIImageView *photo;

-(IBAction)showPicker:(id)sender;
-(IBAction)takePicture:(id)sender;

-(id)initWithTabInfo:(NSDictionary *)tabInfo topLevelTab:(NSDictionary *)topLevelTab;

-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;

@end

