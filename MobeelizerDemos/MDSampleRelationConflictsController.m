//
// MDSampleRelationConflictsController.m
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

#import "MDSampleRelationConflictsController.h"
#import "MDMGraphsConflictsOrderEntity.h"
#import "MDMGraphsConflictsItemEntity.h"
#import "MDSampleRelationConflictsItem.h"
#import "MDMovies.h"

@interface MDSampleRelationConflictsController() {
@private
    NSArray* statusImages;
}
@end

@implementation MDSampleRelationConflictsController

- (NSString*) name {
    return @"RELATION_CONFLICTS";
}

- (NSString*) helpPage {
    return @"MDSampleRelationConflictsHelp";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray* images = [[NSMutableArray alloc] init];
    for (int i=0; i<5; i++) {
        NSString* imageName = [NSString stringWithFormat:@"status_%d.png", (i+1)];
        [images addObject:[UIImage imageNamed:imageName]];
    }
    statusImages = [[NSArray alloc] initWithArray:images];
}

- (void)viewDidUnload {
    statusImages = nil;
    [super viewDidUnload];
}

- (NSArray*)getItemsList {
    NSMutableArray* result = [[NSMutableArray alloc] init];
    MobeelizerCriteriaBuilder *ordersCriteria = [[Mobeelizer database] find:[MDMGraphsConflictsOrderEntity class]];
    ordersCriteria = [ordersCriteria addOrder:[MobeelizerOrder asc:@"name"]];
    for (MDMGraphsConflictsOrderEntity* order in [ordersCriteria list]) {
        [result addObject:[[MDSampleRelationConflictsItem alloc] initAsOrdertWithEntity:order]];
        MobeelizerCriteriaBuilder *itemsCriteria = [[Mobeelizer database] find:[MDMGraphsConflictsItemEntity class]];
        itemsCriteria = [itemsCriteria add:[MobeelizerCriterion field:@"orderGuid" eq:order.guid]];
        itemsCriteria = [itemsCriteria addOrder:[MobeelizerOrder asc:@"title"]];
        for (MDMGraphsConflictsItemEntity* item in [itemsCriteria list]) {
            [result addObject:[[MDSampleRelationConflictsItem alloc] initAsItemWithEntity:item]];
        }
        [result addObject:[[MDSampleRelationConflictsItem alloc] initAsAddItemWithOrderEntity:order]];
    }
    return result;
}

- (void)newClicked:(id)sender {
    MobeelizerCriteriaBuilder *ordersCriteria = [[Mobeelizer database] find:[MDMGraphsConflictsOrderEntity class]];
    ordersCriteria = [ordersCriteria add:[MobeelizerCriterion ownerEq:self.user]];
    NSString* orderName = [NSString stringWithFormat:@"%@/%03d", self.user, ([ordersCriteria count] + 1)];
    MDMGraphsConflictsOrderEntity* order = [[MDMGraphsConflictsOrderEntity alloc] initWithName:orderName andStatus:1];
    [[Mobeelizer database] save:order];
    [self insertNewCurrentItems];
}

- (UITableViewCell*)createCellForItem:(id)item atRow:(NSInteger)row {
    
    static NSString *OrderIdentifier = @"RelationConflictsOrderSyncCell";
    static NSString *ItemIdentifier = @"RelationConflictsItemSyncCell";
    static NSString *AddItemIdentifier = @"RelationConflictsAddItemSyncCell";
    
    UITableViewCell *cell = nil;
    MDMGraphsConflictsOrderEntity* orderBean = nil;
    MDMGraphsConflictsItemEntity* itemBean = nil;
    
    UILabel* nameLabel = nil;
    UIImageView* imageView = nil;
    
    MDSampleRelationConflictsItem* conflictItem = (MDSampleRelationConflictsItem*) item;
    switch (conflictItem.type) {            
        case MDSampleRelationConflictsItemTypeOrder:
            cell = [self dequeueReusableCellWithIdentifier:OrderIdentifier];
            orderBean = (MDMGraphsConflictsOrderEntity*) conflictItem.entity;
            
            nameLabel = (UILabel*)[cell viewWithTag:1];
            nameLabel.text = [NSString stringWithFormat:@"Order %@", orderBean.name];
            
            imageView = (UIImageView*)[cell viewWithTag:2];
            imageView.image = [statusImages objectAtIndex:(orderBean.status - 1)];
            
            break;
        case MDSampleRelationConflictsItemTypeItem:
            cell = [self dequeueReusableCellWithIdentifier:ItemIdentifier];
            itemBean = (MDMGraphsConflictsItemEntity*) conflictItem.entity;
            
            nameLabel = (UILabel*)[cell viewWithTag:1];
            nameLabel.text = itemBean.title;
            
            break;
        case MDSampleRelationConflictsItemTypeAddItem:
            cell = [self dequeueReusableCellWithIdentifier:AddItemIdentifier];
            break;
    }

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([[segue destinationViewController] conformsToProtocol:@protocol(MDSampleRelationConflictsDetailController)]) {
        id<MDSampleRelationConflictsDetailController> vc = [segue destinationViewController];
        NSUInteger row = [self.tableView indexPathForSelectedRow].row;
        [vc setDelegate:self];
        [vc setRow:row];
        MDSampleRelationConflictsItem* selectedItem = [self itemAtRow:row];
        [vc setEntity:(MDMSyncEntity*) selectedItem.entity];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MDSampleRelationConflictsItem* item = [self itemAtRow:indexPath.row];
    if (item.type == MDSampleRelationConflictsItemTypeAddItem) {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:NO animated:YES];
        MDMovie* movie = [[MDMovies instance] getRandomMovie];
        MDMGraphsConflictsItemEntity* newItem = [[MDMGraphsConflictsItemEntity alloc] initWithTitle:movie.title andOrder:item.relatedEntity.guid];
        [[Mobeelizer database] save:newItem];
        [self insertNewCurrentItems];
    } else if (item.type == MDSampleRelationConflictsItemTypeOrder) {
        [self performSegueWithIdentifier:@"goToRelationConflictOrderDetail" sender:self];
    } else if (item.type == MDSampleRelationConflictsItemTypeItem) {
        [self performSegueWithIdentifier:@"goToRelationConflictItemDetail" sender:self];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    MDSampleRelationConflictsItem* item = [self itemAtRow:indexPath.row];
    if (item.type == MDSampleRelationConflictsItemTypeItem) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MDSampleRelationConflictsItem* item = [self itemAtRow:indexPath.row];
        [[Mobeelizer database] remove:item.entity];
        [self updateRow:indexPath.row withItem:nil];
    }
}


@end
