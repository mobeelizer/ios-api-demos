//
// MDSampleConflictsController.m
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

#import "MDSampleConflictsController.h"
#import "MDSampleConflictsDetailController.h"
#import "MDMovies.h"

@interface MDSampleConflictsController() {
@private
    UIImage *starImage;
}
@end

@implementation MDSampleConflictsController

- (NSString*) name {
    return @"CONFLICTS";
}

- (NSString*) helpPage {
    return @"MDSampleConflictsHelp";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    starImage = [UIImage imageNamed:@"star_small.png"];
}

- (void)viewDidUnload {
    starImage = nil;
    [super viewDidUnload];
}

- (NSArray*)getItemsList {
    MobeelizerCriteriaBuilder *criteria = [[Mobeelizer database] find:[MDMConflictsEntity class]];
    criteria = [criteria addOrder:[MobeelizerOrder asc:@"title"]];
    return [criteria list];
}

- (MDMSyncEntity*) createNewItem {
    MDMovie* movie = [[MDMovies instance] getRandomMovie];
    NSUInteger score = (arc4random() % 5) + 1;
    return [[MDMConflictsEntity alloc] initWithTitle:movie.title andScore:score];
}

- (UITableViewCell*)createCellForItem:(MDMSyncEntity*)item atRow:(NSInteger)row {
    static NSString *CellIdentifier = @"ConflictsSyncCell";
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:CellIdentifier];
    
    MDMConflictsEntity* conflictsItem = (MDMConflictsEntity*) item;
    
    UILabel* titleLabel = (UILabel*)[cell viewWithTag:1];
    titleLabel.text = conflictsItem.title;
    
    UIView* scoreView = (UIView*)[cell viewWithTag:2];
    for (UIView *scoreSubview in scoreView.subviews) {
        [scoreSubview removeFromSuperview];
    }

    CGFloat offset = (5-conflictsItem.score) * 5;
    for (NSInteger i=0; i<conflictsItem.score; i++) {
        UIImageView *starView = [[UIImageView alloc] initWithImage:starImage];
        starView.frame = CGRectMake(offset + (starImage.size.width*i), 0, starImage.size.width, starImage.size.height);
        [scoreView addSubview:starView];
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"goToConflictDetail"]) {
        MDSampleConflictsDetailController *vc = [segue destinationViewController];
        NSUInteger row = [self.tableView indexPathForSelectedRow].row;
        vc.delegate = self;
        vc.row =  row;
        vc.entity = [self itemAtRow:row];
    }
    [super prepareForSegue:segue sender:sender];
}

@end
