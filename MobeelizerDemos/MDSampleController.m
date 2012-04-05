//
// MDSampleController.m
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

#import <QuartzCore/QuartzCore.h>
#import "MDSampleController.h"
#import "MDSampleHelpController.h"
#import "MDUtils.h"
#import "MDMSyncEntity.h"

@interface MDSampleController() {
@private
    NSMutableArray* currentItems;
    BOOL showHelp;
    UIImage* userAImage;
    UIImage* userBImage;
}
@end

@implementation MDSampleController

- (NSString*) name {
    return nil;
}

- (NSString*) helpPage {
    return nil;
}

- (void) showHelp {
    showHelp = YES;
}

- (NSArray*)getItemsList {
    return nil;
}

- (MDMSyncEntity*) createNewItem {
    return nil;
}

- (UITableViewCell*)createCellForItem:(id)item atRow:(NSInteger)row {
    return nil;
}

- (id)itemAtRow:(NSInteger)row {
    return [currentItems objectAtIndex:row];
}

- (void)updateRow:(NSInteger)row withItem:(id)item {
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    if (item == nil) {
        [currentItems removeObjectAtIndex:row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [currentItems replaceObjectAtIndex:row withObject:item];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    currentItems = [[NSMutableArray alloc] initWithArray:[self getItemsList]];
    userAImage = [UIImage imageNamed:@"userA.png"];
    userBImage = [UIImage imageNamed:@"userB.png"];
}

- (void)viewDidUnload {
    currentItems = nil;
    userAImage = nil;
    userBImage = nil;
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.navigationController.toolbar.items.count == 0) {
        NSMutableArray* toolbarItems = [[NSMutableArray alloc] initWithArray:self.navigationController.toolbar.items];
        
        UIBarButtonItem* newButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newClicked:)];
        [newButton setStyle:UIBarButtonItemStyleBordered];
        [toolbarItems addObject:newButton];
        
        UIBarButtonItem *space1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [space1 setWidth:10];
        [toolbarItems addObject:space1];
        
        UIBarButtonItem* syncButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(syncClicked:)];
        [syncButton setStyle:UIBarButtonItemStyleBordered];
        [toolbarItems addObject:syncButton];
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolbarItems addObject:space];
        
        if ([self helpPage] != nil) {
            UIBarButtonItem *helpButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(helpClicked:)];
            [toolbarItems addObject:helpButton];
        }
        
        [self.navigationController.toolbar setItems:toolbarItems animated:NO];
    }
    
    if (showHelp && [self helpPage] != nil) {
        showHelp = NO;
        [self performSelector:@selector(helpClicked:) withObject:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [currentItems count];
}

- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString*)cellIdentifier {
    return [[self tableView] dequeueReusableCellWithIdentifier:cellIdentifier];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    id item = [currentItems objectAtIndex:[indexPath row]];
    UITableViewCell* cell = [self createCellForItem:item atRow:indexPath.row];
    
    MDMSyncEntity* entity = item;
    if ([item respondsToSelector:@selector(entity)]) {
        entity = [item valueForKey:@"entity"];
    }
    
    if ([entity respondsToSelector:@selector(owner)]) {
        UIImageView* userLabel = (UIImageView*)[cell.contentView viewWithTag:1001];
        CGFloat userLabelY = (cell.contentView.frame.size.height - 30) /2; // 7
        CGFloat userLabelX = (cell.contentView.frame.size.width - 37); // 283
        if (userLabel == nil) {
            CGRect userLabelRect = CGRectMake(userLabelX, userLabelY, 30, 30);
            userLabel = [[UIImageView alloc] initWithFrame:userLabelRect];
            [userLabel setTag:1001];
            [cell.contentView addSubview:userLabel];   
        }
        if ([entity.owner isEqual:@"A"]) {
            userLabel.image = userAImage;
        } else {
            userLabel.image = userBImage;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [currentItems objectAtIndex:[indexPath row]];
    MDMSyncEntity* entity = item;
    if ([item respondsToSelector:@selector(entity)]) {
        entity = [item valueForKey:@"entity"];
    }
    
    if ([entity respondsToSelector:@selector(modified)] && [entity respondsToSelector:@selector(conflicted)]) {
        if (entity.conflicted) {
            //cell.backgroundColor = [UIColor redColor];
            cell.backgroundColor = RGB(255,135,135);
        } else if (entity.modified) {
            //cell.backgroundColor = [UIColor greenColor];
            //cell.backgroundColor = RGB(112,255,98);
            //cell.backgroundColor = RGB(164,255,157);
            cell.backgroundColor = RGB(153,255,155);
        } else {
            cell.backgroundColor = [UIColor whiteColor];
        }
    }
}


- (void)onUserChange {
    currentItems = [[NSMutableArray alloc] initWithArray:[self getItemsList]];
    [self.tableView reloadData];
}

- (void)helpClicked:(id) sender {
    MDSampleHelpController* view = [[MDSampleHelpController alloc] initWithNibName:[self helpPage] bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentModalViewController:view animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)newClicked:(id)sender {
    MDMSyncEntity* newItem  = [self createNewItem];
    
    [[Mobeelizer database] save:newItem];
    
    currentItems = [[NSMutableArray alloc] initWithArray:[self getItemsList]];
    NSInteger row = -1;
    for (NSInteger i=0; i<currentItems.count; i++) {
        if ([newItem.guid isEqualToString:((MDMSyncEntity*)[currentItems objectAtIndex:i]).guid]) {
            row = i;
            break;
        }
    }
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void) insertNewCurrentItems {
    NSMutableDictionary* objects = [[NSMutableDictionary alloc] init];
    for (id item in currentItems) {
        [objects setObject:item forKey:[item valueForKey:@"guid"]];
    }
    currentItems = [[NSMutableArray alloc] initWithArray:[self getItemsList]];
    NSMutableArray* indexesToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<currentItems.count; i++) {
        id newItem = [currentItems objectAtIndex:i];
        id oldItem = [objects objectForKey:[newItem valueForKey:@"guid"]];
        if (oldItem == nil) {
            [indexesToInsert addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }
    [self.tableView insertRowsAtIndexPaths:indexesToInsert withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView scrollToRowAtIndexPath:[indexesToInsert lastObject] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // TODO maybe show 'insert row' animation here?
}


- (void)syncClicked:(id) sender {
    UIAlertView *alert = [MDUtils showLoadingWithText:@"Synchronization in progress"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        NSArray* oldItems = currentItems;
        NSMutableDictionary* oldObjects = [[NSMutableDictionary alloc] init];
        for (id item in currentItems) {
            [oldObjects setObject:item forKey:[item valueForKey:@"guid"]];
        }
        
        [Mobeelizer sync];
        
        NSArray *newItems = [self getItemsList];
        NSMutableDictionary* newObjects = [[NSMutableDictionary alloc] init];
        for (id item in newItems) {
            [newObjects setObject:item forKey:[item valueForKey:@"guid"]];
        }
        
        NSMutableArray* indexesToInsert = [[NSMutableArray alloc] init];
        NSMutableArray* indexesToDelete = [[NSMutableArray alloc] init];
        NSMutableArray* indexesToUpdate = [[NSMutableArray alloc] init];
        NSMutableArray* indexesToClear = [[NSMutableArray alloc] init];
        
        for (NSInteger i=0; i<oldItems.count; i++) {
            id oldItem = [oldItems objectAtIndex:i];
            id newItem = [newObjects objectForKey:[oldItem valueForKey:@"guid"]];
            if (newItem == nil) {
                [indexesToDelete addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
        }

        for (NSInteger i=0; i<newItems.count; i++) {
            id newItem = [newItems objectAtIndex:i];
            id oldItem = [oldObjects objectForKey:[newItem valueForKey:@"guid"]];
            if (oldItem == nil) {
                [indexesToInsert addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            } else if (![oldItem isEqual:newItem]) {
                [indexesToUpdate addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            } else {
                MDMSyncEntity* oldEntity = [oldItem respondsToSelector:@selector(entity)] ? [oldItem valueForKey:@"entity"] : oldItem;
                MDMSyncEntity* newEntity = [newItem respondsToSelector:@selector(entity)] ? [newItem valueForKey:@"entity"] : newItem;
                if (newEntity.conflicted && !oldEntity.conflicted) {
                    [indexesToUpdate addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                } else if (oldEntity.modified) {
                    [indexesToClear addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            currentItems = [[NSMutableArray alloc] initWithArray:newItems];
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexesToDelete withRowAnimation:UITableViewRowAnimationRight];
            [self.tableView insertRowsAtIndexPaths:indexesToInsert withRowAnimation:UITableViewRowAnimationRight];
            [self.tableView endUpdates];
            
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:indexesToUpdate withRowAnimation:UITableViewRowAnimationLeft];
            [self.tableView reloadRowsAtIndexPaths:indexesToClear withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        });
    });
}

@end


