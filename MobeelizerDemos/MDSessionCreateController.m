//
// MDSessionCreateController.m
// 
// Copyright (C) 2012 Mobeelizer Ltd. All Rights Reserved.
// 
// Licensed under the Apache License, Version 2.0 (the "License"); you may not
// use this file except in compliance with the License. You may obtain a copy 
// of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software 
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the 
// License for the specific language governing permissions and limitations under
// the License.
// 

#import "MDSessionCreateController.h"
#import "MDSampleListController.h"
#import "MDSessionCreatedController.h"
#import "MDUserContextController.h"
#import "MDUtils.h"

@interface MDSessionCreateController() {
@private
    UIAlertView *alert;
    NSString* sessionNumber;
    NSString* user;
}
@end

@implementation MDSessionCreateController
@synthesize mobeelizerLogo;
@synthesize joinButton;
@synthesize createButton;
@synthesize joinCodeInput;
@synthesize mainView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"doneButton.png"];
    UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:5 topCapHeight:0]; 
    
    UIImage *buttonImageHighlight = [UIImage imageNamed:@"doneButton_dark.png"];
    UIImage *stretchableButtonImageHighlight = [buttonImageHighlight stretchableImageWithLeftCapWidth:5 topCapHeight:0]; 
    
    UIImage *buttonImageDisabled = [UIImage imageNamed:@"doneButton_grey.png"];
    UIImage *stretchableButtonImageDisabled = [buttonImageDisabled stretchableImageWithLeftCapWidth:5 topCapHeight:0]; 
    
    [createButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [createButton setBackgroundImage:stretchableButtonImageHighlight forState:UIControlStateHighlighted];
    [createButton setBackgroundImage:stretchableButtonImageDisabled forState:UIControlStateDisabled];
    
    [joinButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [joinButton setBackgroundImage:stretchableButtonImageHighlight forState:UIControlStateHighlighted];
    [joinButton setBackgroundImage:stretchableButtonImageDisabled forState:UIControlStateDisabled];
    
    joinCodeInput.frame = CGRectMake(joinCodeInput.frame.origin.x, joinCodeInput.frame.origin.y, joinCodeInput.frame.size.width, 39);
}

- (void)viewDidUnload {
    [self setJoinButton:nil];
    [self setJoinCodeInput:nil];
    [self setMobeelizerLogo:nil];
    [self setMainView:nil];
    [self setCreateButton:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [[self navigationController] setToolbarHidden:YES animated:NO];
    [mainView setAlpha:0];
    [self onJoinCodeChanged:joinCodeInput];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
        
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    //mobeelizerLogo.transform = CGAffineTransformMakeTranslation(0.0, -170.0);
    [mainView setAlpha:1];

    [UIView commitAnimations];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"createSession"]) {
        MDSessionCreatedController *vc = [segue destinationViewController];
        [vc setSessionNumber:sessionNumber];
    } else if ([[segue identifier] isEqualToString:@"joinSession"]) {
        MDSampleListController *vc = [segue destinationViewController];
        [vc setSessionNumber:sessionNumber];
        [vc setUser:USER_B];
    }
}

- (IBAction)onCreate:(id)sender {
    alert = [MDUtils showLoadingWithText:@"Creating session"];
    user = USER_A;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL* url = [[NSURL alloc] initWithString:@"http://mobeelizer.elasticbeanstalk.com/app/demos/create"];
        NSError* e = nil;
        BOOL isOk = true;
        
        sessionNumber = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&e];
        
        if (sessionNumber != nil) {
            isOk = [MDUtils performLoginAsUser:user onSession:sessionNumber];
        } else {
            NSLog(@"Session number not generated");
            isOk = false;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            if (isOk) {
                [self performSegueWithIdentifier:@"createSession" sender:sender];
            } else {
                alert = [MDUtils showAlertErrorWithText:@"Session couldn't be created.\nPlease try again later"];
            }
        });
    });
}

- (IBAction)onJoin:(id)sender {
    alert = [MDUtils showLoadingWithText:@"Joining session"];
    sessionNumber = joinCodeInput.text;
    user = USER_B;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        BOOL isOk = [MDUtils performLoginAsUser:user onSession:sessionNumber];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            if (isOk) {
                [self performSegueWithIdentifier:@"joinSession" sender:sender];
            } else {
                alert = [MDUtils showAlertErrorWithText:@"Cannot join session."];
            }
                
        });
    });
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSUInteger newLength = [textField.text length] + [string length] - range.length;
 //   return (newLength > 0) ? YES : NO;
//}

- (IBAction)onJoinCodeChanged:(id)sender {
    if ([joinCodeInput.text length] > 0) {
        [joinButton setEnabled:YES];
    } else {    
        [joinButton setEnabled:NO];  
    }
}

- (void)setSessionNumber:(NSString*)newSessionNumber {
    self.joinCodeInput.text = newSessionNumber;
    [self.joinCodeInput resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [joinCodeInput resignFirstResponder];
}

@end
