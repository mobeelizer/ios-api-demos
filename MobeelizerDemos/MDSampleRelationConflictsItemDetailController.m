//
// MDSampleRelationConflictsItemDetailController.m
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

#import "MDSampleRelationConflictsItemDetailController.h"

@implementation MDSampleRelationConflictsItemDetailController
@synthesize delegate = _delegate;
@synthesize row = _row;
@synthesize entity = _entity;
@synthesize deleteButton = _deleteButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.entity.title;
    UIImage *buttonImageNormal = [UIImage imageNamed:@"button_red.png"];
    UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:5 topCapHeight:0]; 
    
    UIImage *buttonImageHighlight = [UIImage imageNamed:@"button_red_dark.png"];
    UIImage *stretchableButtonImageHighlight = [buttonImageHighlight stretchableImageWithLeftCapWidth:5 topCapHeight:0]; 
    
    [self.deleteButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [self.deleteButton setBackgroundImage:stretchableButtonImageHighlight forState:UIControlStateHighlighted];
}

- (void)viewDidUnload {
    self.entity = nil;
    self.delegate = nil;
    [self setDeleteButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)deleteClicked:(id)sender {
    [[Mobeelizer database] remove:self.entity];
    [self.delegate updateRow:self.row withItem:nil];
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
