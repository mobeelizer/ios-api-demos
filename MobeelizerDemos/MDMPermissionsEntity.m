//
// MDMPermissionsEntity.m
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

#import "MDMPermissionsEntity.h"

@implementation MDMPermissionsEntity

@synthesize title = _title;
@synthesize director = _director;

- (MDMPermissionsEntity*) initWithTitle:(NSString*)title andDirector:(NSString*)director {
    self.title = title;
    self.director = director;
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"MDMPermissionsEntity - %@ - %@ - %@", self.owner, self.title, self.director];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[MDMPermissionsEntity class]]) {
        MDMPermissionsEntity* entity = object;
        if ([entity.guid isEqualToString:self.guid] && [entity.title isEqualToString:self.title]) {
            return YES;
        }
    }
    return NO;
}

@end