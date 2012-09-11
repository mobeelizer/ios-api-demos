//
// MDSampleRelationsItem.m
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

#import "MDSampleRelationsItem.h"

@implementation MDSampleRelationsItem
@synthesize type = _type;
@synthesize entity = _entity;
@synthesize relatedEntity = _relatedEntity;
@synthesize guid = _guid;

- (MDSampleRelationsItem*)initAsOrdertWithEntity:(MDMGraphsConflictsOrderEntity*)entity {
    self.type = MDSampleRelationsItemTypeOrder;
    self.entity = entity;
    self.guid = entity.guid;
    return self;
}

- (MDSampleRelationsItem*)initAsItemWithEntity:(MDMGraphsConflictsItemEntity*)entity {
    self.type = MDSampleRelationsItemTypeItem;
    self.entity = entity;
    self.guid = entity.guid;
    return self;
}

- (MDSampleRelationsItem*)initAsAddItemWithOrderEntity:(MDMGraphsConflictsOrderEntity*)entity {
    self.type = MDSampleRelationsItemTypeAddItem;
    self.relatedEntity = entity;
    self.guid = [NSString stringWithFormat:@"add_to_%@", entity.guid];
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"MDRelationsItem - %d - %@", self.type, self.guid];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[MDSampleRelationsItem class]]) {
        MDSampleRelationsItem* item = object;
        if (item.type != self.type) {
            return NO;
        }
        if (self.type == MDSampleRelationsItemTypeAddItem) {
            return [item.relatedEntity isEqual:self.relatedEntity];
        } else {
            return [item.entity isEqual:self.entity];
        }
    }
    return NO;
}

@end
