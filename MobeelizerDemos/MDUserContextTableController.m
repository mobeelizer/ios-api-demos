//
// MDUserContextController.m
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

#import "MDUserContextTableController.h"
#import "MDAppDelegate.h"

@interface MDUserContextTableController() {
@private
    UIBarButtonItem *userButton;
}
- (void)refreshUserButton;
- (void)setUserToView:(UIViewController*) view;
@end

@implementation MDUserContextTableController
@synthesize user;
@synthesize sessionNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    userButton = [[UIBarButtonItem alloc] initWithTitle:@"User" style:UIBarButtonItemStyleBordered target:self action:@selector(userButtonClicked:)];
    self.navigationItem.rightBarButtonItem = userButton;
}

- (void)viewDidUnload {
    userButton = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshUserButton];
}

- (IBAction)userButtonClicked:(id)sender {
    UIAlertView *alert = [MDUtils showLoadingWithText:@"Changing user"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([user isEqualToString:USER_A]) {
            user = USER_B;
        } else {
            user = USER_A;        
        }
        
        [self performLogout];
        [MDUtils performLoginAsUser:user onSession:sessionNumber];
        
        MDAppDelegate *appDelegate = (MDAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate registerForPush];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            
            [self refreshUserButton];
                
            [UIView beginAnimations:@"View Flip" context:nil];
            [UIView setAnimationDuration:0.75];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
            [self onUserChange];
            [UIView commitAnimations];
        });
    });
}

- (void)refreshUserButton {
    if ([user isEqualToString:USER_B]) {
        [userButton setTitle:@"B"];
        [userButton setTintColor:USER_B_COLOR];
    } else {
        [userButton setTitle:@"A"];        
        [userButton setTintColor:USER_A_COLOR];
    }
}

- (void)onUserChange {
}

- (void) performLogout {
    [Mobeelizer unregisterForRemoteNotifications];
    [Mobeelizer logout];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [self setUserToView:self.navigationController.viewControllers.lastObject];
    }
    [super viewWillDisappear:animated];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self setUserToView:segue.destinationViewController];
    if ([segue.destinationViewController respondsToSelector:@selector(setSessionNumber:)]) {
        [segue.destinationViewController setValue:sessionNumber forKey:@"sessionNumber"];
    }
    [super prepareForSegue:segue sender:sender];
}

- (void)setUserToView:(UIViewController*) view {
    if ([view isKindOfClass:MDUserContextTableController.class]) {
        MDUserContextTableController* userContextVC = (MDUserContextTableController*) view;
        [userContextVC setUser:user];
    }
}

@end
