//
// MDSampleFilesController.m
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

#import "MDSampleFilesController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "MDMFileSyncEntity.h"
#import "MDSampleFilesDetailController.h"

@interface MDSampleFilesController()
- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType;
- (void)addRecordWithRandomImage;
- (void) addFile:(MobeelizerFile*) file;
@end

@implementation MDSampleFilesController

- (NSString*) name {
    return @"FILES";
}

- (NSString*) helpPage {
    return @"MDSampleFilesHelp";
}

- (NSArray*)getItemsList {
    return [[Mobeelizer database] list:[MDMFileSyncEntity class]];
}

- (UITableViewCell*)createCellForItem:(MDMSyncEntity*)item atRow:(NSInteger)row {
    static NSString *CellIdentifier = @"FilesSyncCell";
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:CellIdentifier];
    MDMFileSyncEntity* fileItem = (MDMFileSyncEntity*) item;
    UIImageView* imageView = (UIImageView*)[cell viewWithTag:1];
    imageView.image = [UIImage imageWithData:fileItem.photo.data];
    return cell;
}

- (void)newClicked:(id)sender {
    UIActionSheet *actionSheet = nil;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"New photo", @"Existing photo", @"Random photo", nil];
    } else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Existing photo", @"Random photo", nil];
    }
    [actionSheet showInView:[self view]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
                break;
            case 1:
                [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
                break;
            case 2:
                [self addRecordWithRandomImage];
                break;
        }
    } else {
        switch (buttonIndex) {
            case 0:
                [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
                break;
            case 1:
                [self addRecordWithRandomImage];
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66.0;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.5);
    MobeelizerFile* file = [Mobeelizer createFile:@"file" withData:imageData];
    [self addFile:file];
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)addRecordWithRandomImage {
    int randomIndex = (arc4random() % 10) + 1;
    NSString* fileName = [NSString stringWithFormat:@"landscape_%02d", randomIndex];
    NSString* fullFileName = [NSString stringWithFormat:@"%@.jpg", fileName];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"jpg"];  
    MobeelizerCriteriaBuilder* crit = [[Mobeelizer database] find:[MDMFileSyncEntity class]];
    crit = [crit add:[MobeelizerCriterion field:@"photo_name" eq:fullFileName]];
    crit = [crit maxResults:1];
    MDMFileSyncEntity* oldEntity = [crit uniqueResult];
    MobeelizerFile* file = nil;
    if (oldEntity == nil) {
        NSData* data = [NSData dataWithContentsOfFile:filePath];
        file = [Mobeelizer createFile:fullFileName withData:data];
    } else {
        file = [Mobeelizer createFile:fullFileName withGuid:oldEntity.photo.guid];   
    }
    [self addFile:file];
}

- (void) addFile:(MobeelizerFile*) file {
    MDMFileSyncEntity* entity = [[MDMFileSyncEntity alloc] initWithFile:file];
    [[Mobeelizer database] save:entity];
    [self insertNewCurrentItems];
}

- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType {
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediaTypes count] > 0) {
        NSArray *mediaTypes = @[(NSString *) kUTTypeImage];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        [self presentModalViewController:picker animated:YES];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error accessing media" message:@"Device doesn’t support that media source." delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"goToFileDetail"]) {
        MDSampleFilesDetailController *vc = [segue destinationViewController];
        NSUInteger row = [self.tableView indexPathForSelectedRow].row;
        vc.entity = [self itemAtRow:row];
    }
    [super prepareForSegue:segue sender:sender];
}

@end
