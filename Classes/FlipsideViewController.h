//
//  FlipsideViewController.h
//  YPassword
//
//  Created by Yann Esposito on 14/07/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlipsideViewControllerDelegate;


@interface FlipsideViewController : UIViewController {
    IBOutlet UITextField *masterPasswordTextField;
	IBOutlet id doneButton;
	IBOutlet UILabel *defaultMaxPasswordLengthLabel;
	IBOutlet UISlider *slider;
	id <FlipsideViewControllerDelegate> delegate;
	int oldslidervalue;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
- (IBAction)done:(id)sender;
- (IBAction)masterPasswordTextFieldChanged:(id)sender;
- (IBAction)clickedToWebSite:(id)sender;
- (IBAction)sliderChanged:(id)sender;
- (void)saveMasterPassword:(NSString *)masterPassword;
@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
- (NSString *)masterPassword;
- (void)setMasterPassword:(NSString *)masterPassword;
@end

