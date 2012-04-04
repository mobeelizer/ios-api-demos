//
// MDSessionCreatedController.m
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

#import "MDSessionCreatedController.h"
#import "MDSampleListController.h"
#import "MDUserContextController.h"

@implementation MDSessionCreatedController
@synthesize sessionNumberLabel;
@synthesize exploreButton;
@synthesize sessionNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    [sessionNumberLabel setText:sessionNumber];
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"doneButton.png"];
    UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:5 topCapHeight:0]; 
    
    UIImage *buttonImageHighlight = [UIImage imageNamed:@"doneButton_dark.png"];
    UIImage *stretchableButtonImageHighlight = [buttonImageHighlight stretchableImageWithLeftCapWidth:5 topCapHeight:0]; 

    [exploreButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [exploreButton setBackgroundImage:stretchableButtonImageHighlight forState:UIControlStateHighlighted];
}

- (void)viewDidUnload{
    [self setSessionNumberLabel:nil];
    [self setExploreButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"exploreSession"]) {
        MDSampleListController *vc = [segue destinationViewController];
        [vc setSessionNumber:sessionNumber];
        [vc setUser:USER_A];
    }
}

@end
