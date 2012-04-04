//
// MDSampleHelpController.m
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

#import "MDSampleHelpController.h"
#import "MDUtils.h"

@implementation MDSampleHelpController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIToolbar* toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleDefault;
    [toolbar sizeToFit];
    CGFloat toolbarHeight = toolbar.frame.size.height;
    CGFloat windowHeight = self.view.frame.size.height;
    
    CGRect rectArea = CGRectMake(0, windowHeight-toolbarHeight, self.view.frame.size.width, toolbarHeight);
    [toolbar setFrame:rectArea];
    [self.view addSubview:toolbar];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(backButtonClicked:)];
    backButton.style = UIBarButtonItemStyleBordered;
    [toolbar setItems:[NSArray arrayWithObjects:space,backButton, nil]];
    
//    if ([self.view isKindOfClass:[UIControl class]]) {
//        UIControl* viewControl = (UIControl *) self.view;
//        [viewControl addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchDown];
//    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backButtonClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)connectAnotherDeviceClicked:(id)sender {
    MDSampleHelpController* view = [[MDSampleHelpController alloc] initWithNibName:@"MDSimpleSyncHelp" bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentModalViewController:view animated:YES];
}

@end
