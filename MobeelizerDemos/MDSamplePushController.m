//
//  MDSamplePushController.m
//  MobeelizerDemos
//
//  Created by Ja on 07.05.2012.
//  Copyright (c) 2012 Joselewicza. All rights reserved.
//

#import "MDSamplePushController.h"

#import "MDSampleConflictsController.h"
#import "MDSampleConflictsDetailController.h"
#import "MDMovies.h"

@interface MDSamplePushController()
-(NSDictionary*) createNotificationMessageWithContent:(NSString*) content;
@end

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
        [Mobeelizer sendRemoteNotification:[self createNotificationMessageWithContent:@"iOS device greets all users!"]];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        [Mobeelizer sendRemoteNotification:[self createNotificationMessageWithContent:@"iOS device greets user A!"] toUsers: [NSArray arrayWithObject:@"A"]];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        [Mobeelizer sendRemoteNotification:[self createNotificationMessageWithContent:@"iOS device greets user B!"] toUsers: [NSArray arrayWithObject:@"B"]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSDictionary*) createNotificationMessageWithContent:(NSString*) content {
    NSMutableDictionary* message = [[NSMutableDictionary alloc] init];
    [message setObject:content forKey:@"alert"];
    
    [message setObject:@"2" forKey:@"X-NotificationClass"]; // microsoft notification priority
    [message setObject:@"toast" forKey:@"X-WindowsPhone-Target"]; // notification type
    [message setObject:@"Push received" forKey:@"Text1"];
    [message setObject:content forKey:@"Text2"];
    [message setObject:@"/View/MainPage.xaml" forKey:@"Param"]; // wp7 toast page
    
    return [NSDictionary dictionaryWithDictionary:message];
}

@end
