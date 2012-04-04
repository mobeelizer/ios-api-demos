//
// MDUtils.m
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

#import "MDUtils.h"

@implementation MDUtils

+ (UIAlertView*)showLoadingWithText:(NSString*)text {
    NSString* alertTitle = [[NSString alloc] initWithFormat:@"%@\nPlease Wait...", text];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:alertTitle message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [alert show];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = CGPointMake(alert.bounds.size.width / 2, alert.bounds.size.height - 50);
    [indicator startAnimating];
    [alert addSubview:indicator];
    return alert;
}

+ (UIAlertView*)showAlertErrorWithText:(NSString*)text {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Connection error" message:text delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    return alert;
}

+ (BOOL) performLoginAsUser:(NSString *)user onSession:(NSString*) session {
    NSString* login = nil;
    NSString* password = nil;
    if ([user isEqualToString:USER_A]) {
        login = @"A";
        password = @"+Su(w4KV4L";
    } else {
        login = @"B";
        password = @"B9$zGOl6!n";
    }
    MobeelizerLoginStatus loginStatus = [Mobeelizer loginToInstance:session withUser:login andPassword:password];
    return loginStatus == MobeelizerLoginStatusOk;
}

@end
