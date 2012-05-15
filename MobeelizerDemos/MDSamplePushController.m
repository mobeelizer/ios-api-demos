//
//  MDSamplePushController.m
//  MobeelizerDemos
//
//  Created by Ja on 07.05.2012.
//  Copyright (c) 2012 Joselewicza. All rights reserved.
//

#import "MDSamplePushController.h"

@implementation MDSamplePushController

- (NSString*) name {
    return @"Push";
}

- (NSString*) helpPage {
    return @"MDSamplePushHelp";
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        [Mobeelizer sendRemoteNotification:[NSDictionary dictionaryWithObject:@"iOS device greets all users!" forKey:@"alert"]];        
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        [Mobeelizer sendRemoteNotification:[NSDictionary dictionaryWithObject:@"iOS device greets user A!" forKey:@"alert"] toUsers: [NSArray arrayWithObject:@"A"]];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        [Mobeelizer sendRemoteNotification:[NSDictionary dictionaryWithObject:@"iOS device greets user B!" forKey:@"alert"] toUsers: [NSArray arrayWithObject:@"B"]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
