//
// MDSampleConflictsDetailController.m
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

#import "MDSampleConflictsDetailController.h"

@interface MDSampleConflictsDetailController() {
@private
    UIImage *starImage;
}
@end

@implementation MDSampleConflictsDetailController
@synthesize delegate = _delegate;
@synthesize row = _row;
@synthesize entity = _entity;

- (void)viewDidLoad {
    [super viewDidLoad];
    starImage = [UIImage imageNamed:@"star.png"];
    self.navigationItem.title = self.entity.title;
}

- (void)viewDidUnload {
    self.entity = nil;
    starImage = nil;
    self.delegate = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    CGFloat width = starImage.size.width * (indexPath.row + 1);
    CGRect rect = CGRectMake((cell.bounds.size.width-width)/2, (cell.bounds.size.height-starImage.size.height)/2, width, starImage.size.height);
    UIView* starsView = [[UIView alloc] initWithFrame:rect];
    for (NSInteger i=0; i<indexPath.row+1; i++) {
        UIImageView *starView = [[UIImageView alloc] initWithImage:starImage];
        starView.frame = CGRectMake(starImage.size.width*i, 0, starImage.size.width, starImage.size.height);
        [starsView addSubview:starView];
    }
    [cell addSubview:starsView];
    
    if (indexPath.row == self.entity.score-1) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* oldCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.entity.score-1 inSection:0]];
    oldCell.accessoryType = UITableViewCellAccessoryNone;
    
    self.entity.score = indexPath.row + 1;
    [[Mobeelizer database] save:self.entity];
    [self.delegate updateRow:self.row withItem:self.entity];
    
    UITableViewCell* newCell = [self.tableView cellForRowAtIndexPath:indexPath];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
