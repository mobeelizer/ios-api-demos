//
// MDMConflictsEntity.m
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

#import "MDMConflictsEntity.h"

@implementation MDMConflictsEntity

@synthesize title = _title;
@synthesize score = _score;

- (MDMConflictsEntity*) initWithTitle:(NSString*)title andScore:(NSUInteger)score {
    self.title = title;
    self.score = score;
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"MDMSimpleSyncEntity - %@ - %@ - %@ - %d", self.owner, self.guid, self.title, self.score];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[MDMConflictsEntity class]]) {
        MDMConflictsEntity* entity = object;
        if ([entity.guid isEqualToString:self.guid] && [entity.title isEqualToString:self.title] && entity.score == self.score) {
            return YES;
        }
    }
    return NO;
}

@end
