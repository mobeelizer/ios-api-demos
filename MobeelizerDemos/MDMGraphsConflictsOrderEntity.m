//
// MDMGraphsConflictsOrderEntity.m
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

#import "MDMGraphsConflictsOrderEntity.h"

@implementation MDMGraphsConflictsOrderEntity

@synthesize name = _name;
@synthesize status = _status;

- (MDMGraphsConflictsOrderEntity*) initWithName:(NSString*)name andStatus:(NSUInteger)status {
    self.name = name;
    self.status = status;
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"MDMGraphsConflictsOrderEntity - %@ - %@ - %d", self.owner, self.name, self.status];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[MDMGraphsConflictsOrderEntity class]]) {
        MDMGraphsConflictsOrderEntity* entity = object;
        if ([entity.guid isEqualToString:self.guid] && [entity.name isEqualToString:self.name] && entity.status == self.status) {
            return YES;
        }
    }
    return NO;
}

@end
