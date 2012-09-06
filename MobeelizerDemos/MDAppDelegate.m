//
// MDAppDelegate.m
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

#import "MDAppDelegate.h"

@interface MDAppDelegate() {
    NSData* pushToken;
}
@end

@implementation MDAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Mobeelizer create];
    MobeelizerOperationError *error = [Mobeelizer unregisterForRemoteNotifications];
    
    if(error != nil) {
        NSLog(@"Unregister for remote notification failure: %@ - %@", error.code, error.message);
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [Mobeelizer destroy];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token {
    pushToken = token;
    MobeelizerOperationError *error = [Mobeelizer registerForRemoteNotificationsWithDeviceToken:token];
    
    if(error != nil) {
        NSLog(@"Register for remote notification failure: %@ - %@", error.code, error.message);
    }
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);

}

- (void)application:(UIApplication *)app didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"MESSAGE RECEIVED: %@", userInfo);
    NSString* messageContent = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Push received!"
                                                    message:messageContent
                                                    delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
    [message show];
}

- (void) registerForPush {
    if (pushToken != nil) {
        MobeelizerOperationError *error = [Mobeelizer registerForRemoteNotificationsWithDeviceToken:pushToken];
        
        if(error != nil) {
            NSLog(@"Register for remote notification failure: %@ - %@", error.code, error.message);
        }
    }
}

@end
