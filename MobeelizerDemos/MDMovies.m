//
// MDMovies.m
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

#import "MDMovies.h"

@interface MDMovies() {
@private
    NSArray* movies;
}
@end

@implementation MDMovies

static MDMovies* sharedInstance = nil;

+ (MDMovies*)instance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:nil] init];
    }
    return sharedInstance;
}

- (id)init {
    if (movies == nil) {
        self = [super init];
        if (self) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Movies" ofType:@"plist"];
            movies = [[NSArray alloc] initWithContentsOfFile:path];
        }
    }
    return self;
}

+(id)allocWithZone:(NSZone *)zone {
    return sharedInstance;
}

- (MDMovie*)getRandomMovie {
    int randomIndex = arc4random() % [movies count];
    return [[MDMovie alloc] initWithDictionary:movies[randomIndex]];
}

@end
