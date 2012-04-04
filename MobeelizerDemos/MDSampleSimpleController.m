//
// MDSampleSimpleController.m
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

#import "MDSampleSimpleController.h"
#import "MDMSimpleSyncEntity.h"
#import "MDMovies.h"

@implementation MDSampleSimpleController

- (NSString*) name {
    return @"SIMPLE";
}

- (NSString*) helpPage {
    return @"MDSampleSimpleHelp";
}

- (NSArray*)getItemsList {
    MobeelizerCriteriaBuilder *criteria = [[Mobeelizer database] find:[MDMSimpleSyncEntity class]];
    criteria = [criteria addOrder:[MobeelizerOrder asc:@"title"]];
    return [criteria list];
}

- (MDMSyncEntity*) createNewItem {
    MDMovie* movie = [[MDMovies instance] getRandomMovie];
    return  [[MDMSimpleSyncEntity alloc] initWithTitle:movie.title];
}

- (UITableViewCell*)createCellForItem:(MDMSyncEntity*)item atRow:(NSInteger)row {
    static NSString *CellIdentifier = @"SimpleSyncCell";
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:CellIdentifier];
    
    MDMSimpleSyncEntity* simpleItem = (MDMSimpleSyncEntity*) item;
    
    UILabel* titleLabel = (UILabel*)[cell viewWithTag:1];
    titleLabel.text = simpleItem.title;
    
    return cell;
}

@end
