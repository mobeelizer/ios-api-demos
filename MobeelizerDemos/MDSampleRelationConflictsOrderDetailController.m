//
// MDSampleRelationConflictsOrderDetailController.m
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

#import "MDSampleRelationConflictsOrderDetailController.h"
#import "MDSampleRelationConflictsItem.h"

@implementation MDSampleRelationConflictsOrderDetailController
@synthesize delegate = _delegate;
@synthesize row = _row;
@synthesize entity = _entity;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.entity.name;
}

- (void)viewDidUnload {
    self.entity = nil;
    self.delegate = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];    
    if (indexPath.row == self.entity.status-1) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* oldCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.entity.status-1 inSection:0]];
    oldCell.accessoryType = UITableViewCellAccessoryNone;
    
    self.entity.status = indexPath.row + 1;
    [[Mobeelizer database] save:self.entity];
    MDSampleRelationConflictsItem* newOrderItem = [[MDSampleRelationConflictsItem alloc] initAsOrdertWithEntity:self.entity];
    [self.delegate updateRow:self.row withItem:newOrderItem];
    
    UITableViewCell* newCell = [self.tableView cellForRowAtIndexPath:indexPath];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [[self navigationController] popViewControllerAnimated:YES];
}


@end
