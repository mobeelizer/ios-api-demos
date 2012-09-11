//
// MDSampleRelationConflictsItem.h
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

#import <Foundation/Foundation.h>
#import "MDMSyncEntity.h"
#import "MDMGraphsConflictsOrderEntity.h"
#import "MDMGraphsConflictsItemEntity.h"

typedef enum {
    MDSampleRelationsItemTypeOrder = 0,
    MDSampleRelationsItemTypeItem,
    MDSampleRelationsItemTypeAddItem,
} MDSampleRelationsItemType;

@interface MDSampleRelationsItem : NSObject
@property(nonatomic) MDSampleRelationsItemType type;
@property(nonatomic, strong) MDMSyncEntity* entity;
@property(nonatomic, strong) MDMSyncEntity* relatedEntity;
@property(nonatomic, copy) NSString* guid;

- (MDSampleRelationsItem*)initAsOrdertWithEntity:(MDMGraphsConflictsOrderEntity*)entity;
- (MDSampleRelationsItem*)initAsItemWithEntity:(MDMGraphsConflictsItemEntity*)entity;
- (MDSampleRelationsItem*)initAsAddItemWithOrderEntity:(MDMGraphsConflictsOrderEntity*)entity;

@end
