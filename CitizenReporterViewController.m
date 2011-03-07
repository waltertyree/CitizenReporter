/*
 
Implementation of CitizenReporterViewController
Iv'e added string contstants at the beginning so
 that you don't have to sift through the code.
 
 
Created by Walter Tyree, Jan 20 2010
 Copyright 2010 TyreeApps.com Reuse with attribution.
 Updated by Walter Tyree, July 2010
 
 */

#import "CitizenReporterViewController.h"

@implementation CitizenReporterViewController
@synthesize photo;

#pragma mark -
#pragma mark Initialize for TapLynx
-(id)initWithTabInfo:(NSDictionary *)tabInfo topLevelTab:(NSDictionary *)topLevelTab {
	//Grab values from the NGConfig file
	sendTo = [tabInfo objectForKey:@"EmailSendTo"];
	subject = [tabInfo objectForKey:@"EmailSubject"];
	body = [tabInfo objectForKey:@"EmailBody"];
	return [self initWithNibName:nil bundle:nil];
}

#pragma mark -
#pragma mark Mail Picker Display
-(IBAction)showPicker:(id)sender
{

	// We display an email composition interface if MFMailComposeViewController exists and the device can send emails.
	// We launch the Mail application on the device, otherwise.
	
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// This is a check to see if the current device can send emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
}



#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:subject];
	

	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:sendTo]; 
	
	[picker setToRecipients:toRecipients];

	
	// Attach an image to the email
	
    NSData *myData = UIImageJPEGRepresentation(photo.image, 0.9);
	[picker addAttachmentData:myData mimeType:@"image/jpg" fileName:@"scoop"];
	
	// Fill out the email body text
	NSString *emailBody = body;
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
    [picker release];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
	NSString *alertMessage = nil;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			alertMessage = NSLocalizedString(@"Your message has been sent.", nil);
			break;
		case MFMailComposeResultFailed:
			alertMessage = NSLocalizedString(@"Your message could not be sent.", nil);
			break;
		default:
			alertMessage = NSLocalizedString(@"Your message could not be sent.", nil);
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
	if (alertMessage != nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sending Email", nil) 
														message:alertMessage 
													   delegate:nil 
											  cancelButtonTitle:NSLocalizedString(@"OK", nil)
											  otherButtonTitles:nil,nil];
		[alert show];
		[alert release];
	}
	
}
#pragma mark Workaround for Mail.app Problems

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = [NSString stringWithFormat:@"mailto:%@?subject=%@",sendTo,subject];

	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}
#pragma mark -
#pragma mark Image Picker
-(IBAction)takePicture:(id)sender{
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && ([[sender currentTitle] isEqualToString:@"Take Photo"])){
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}else{
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	picker.allowsImageEditing = YES;
	picker.delegate = self;
	[self presentModalViewController:picker animated:YES];
	[picker release];

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
	photo.image = image;
	[self dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[self dismissModalViewControllerAnimated:YES];
}



#pragma mark -
#pragma mark Unload views

- (void)viewDidUnload 
{
	self.photo = nil;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc 
{
    	[super dealloc];
}

@end
