//
// MDSampleRelationsController.m
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

#import "MDSampleRelationsController.h"
#import "MDMGraphsConflictsOrderEntity.h"
#import "MDMGraphsConflictsItemEntity.h"
#import "MDSampleRelationsItem.h"
#import "MDMovies.h"

@interface MDSampleRelationsController() {
@private
    NSArray* statusImages;
}
@end

@implementation MDSampleRelationsController

- (NSString*) name {
    return @"RELATIONS";
}

- (NSString*) helpPage {
    return @"MDSampleRelationsHelp";
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
        [result addObject:[[MDSampleRelationsItem alloc] initAsOrdertWithEntity:order]];
        MobeelizerCriteriaBuilder *itemsCriteria = [[Mobeelizer database] find:[MDMGraphsConflictsItemEntity class]];
        itemsCriteria = [itemsCriteria add:[MobeelizerCriterion field:@"orderGuid" eq:order.guid]];
        itemsCriteria = [itemsCriteria addOrder:[MobeelizerOrder asc:@"title"]];
        for (MDMGraphsConflictsItemEntity* item in [itemsCriteria list]) {
            [result addObject:[[MDSampleRelationsItem alloc] initAsItemWithEntity:item]];
        }
        [result addObject:[[MDSampleRelationsItem alloc] initAsAddItemWithOrderEntity:order]];
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
    
    static NSString *OrderIdentifier = @"RelationsOrderSyncCell";
    static NSString *ItemIdentifier = @"RelationsItemSyncCell";
    static NSString *AddItemIdentifier = @"RelationsAddItemSyncCell";
    
    UITableViewCell *cell = nil;
    MDMGraphsConflictsOrderEntity* orderBean = nil;
    MDMGraphsConflictsItemEntity* itemBean = nil;
    
    UILabel* nameLabel = nil;
    UIImageView* imageView = nil;
    
    MDSampleRelationsItem* conflictItem = (MDSampleRelationsItem*) item;
    switch (conflictItem.type) {            
        case MDSampleRelationsItemTypeOrder:
            cell = [self dequeueReusableCellWithIdentifier:OrderIdentifier];
            orderBean = (MDMGraphsConflictsOrderEntity*) conflictItem.entity;
            
            nameLabel = (UILabel*)[cell viewWithTag:1];
            nameLabel.text = [NSString stringWithFormat:@"Order %@", orderBean.name];
            
            imageView = (UIImageView*)[cell viewWithTag:2];
            imageView.image = statusImages[(orderBean.status - 1)];
            
            break;
        case MDSampleRelationsItemTypeItem:
            cell = [self dequeueReusableCellWithIdentifier:ItemIdentifier];
            itemBean = (MDMGraphsConflictsItemEntity*) conflictItem.entity;
            
            nameLabel = (UILabel*)[cell viewWithTag:1];
            nameLabel.text = itemBean.title;
            
            break;
        case MDSampleRelationsItemTypeAddItem:
            cell = [self dequeueReusableCellWithIdentifier:AddItemIdentifier];
            break;
    }

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([[segue destinationViewController] conformsToProtocol:@protocol(MDSampleRelationsDetailController)]) {
        id<MDSampleRelationsDetailController> vc = [segue destinationViewController];
        NSUInteger row = [self.tableView indexPathForSelectedRow].row;
        [vc setDelegate:self];
        [vc setRow:row];
        MDSampleRelationsItem* selectedItem = [self itemAtRow:row];
        [vc setEntity:(MDMSyncEntity*) selectedItem.entity];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MDSampleRelationsItem* item = [self itemAtRow:indexPath.row];
    if (item.type == MDSampleRelationsItemTypeAddItem) {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:NO animated:YES];
        MDMovie* movie = [[MDMovies instance] getRandomMovie];
        MDMGraphsConflictsItemEntity* newItem = [[MDMGraphsConflictsItemEntity alloc] initWithTitle:movie.title andOrder:item.relatedEntity.guid];
        [[Mobeelizer database] save:newItem];
        [self insertNewCurrentItems];
    } else if (item.type == MDSampleRelationsItemTypeOrder) {
        [self performSegueWithIdentifier:@"goToRelationsOrderDetail" sender:self];
    } else if (item.type == MDSampleRelationsItemTypeItem) {
        [self performSegueWithIdentifier:@"goToRelationsItemDetail" sender:self];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    MDSampleRelationsItem* item = [self itemAtRow:indexPath.row];
    if (item.type == MDSampleRelationsItemTypeItem) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MDSampleRelationsItem* item = [self itemAtRow:indexPath.row];
        [[Mobeelizer database] remove:item.entity];
        [self updateRow:indexPath.row withItem:nil];
    }
}


@end
