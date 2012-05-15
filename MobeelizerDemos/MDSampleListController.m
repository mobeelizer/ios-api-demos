//
// MDSampleListController.m
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

#import "MDSampleListController.h"
#import "MDSampleTableController.h"
#import "MDSessionCreateController.h"

@interface MDSampleListController() {
@private
    NSMutableSet* visitedViews;
}
@end

@implementation MDSampleListController
@synthesize sessionCodeLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = TRUE;
    [[self navigationController] setToolbarHidden:NO animated:NO];
    [sessionCodeLabel setText:[NSString stringWithFormat:@"Your session code is: %@", self.sessionNumber]];
    visitedViews = [[NSMutableSet alloc] init];
}

- (void)viewDidUnload {
    [self setSessionCodeLabel:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)menuButtonClicked:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Logout", nil];
    [actionSheet showFromToolbar:self.navigationController.toolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:@"Logout"]) {
        [self performLogout];
        MDSessionCreateController* rootController = (MDSessionCreateController*) [self.navigationController.viewControllers objectAtIndex:0];
        [rootController setSessionNumber:self.sessionNumber];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.destinationViewController isKindOfClass:MDSampleController.class]) {
        MDSampleTableController* controller = segue.destinationViewController;
        if (! [visitedViews containsObject:[controller name]]) {
            [controller showHelp];
            [visitedViews addObject:[controller name]];
        }
    }
}

@end
