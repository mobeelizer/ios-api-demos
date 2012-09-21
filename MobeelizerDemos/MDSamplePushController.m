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
    MobeelizerOperationError *error = nil;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        error = [Mobeelizer sendRemoteNotification:[self createNotificationMessageWithContent:@"iOS device greets all users!"]];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        error = [Mobeelizer sendRemoteNotification:[self createNotificationMessageWithContent:@"iOS device greets user A!"] toUsers: @[@"A"]];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        error = [Mobeelizer sendRemoteNotification:[self createNotificationMessageWithContent:@"iOS device greets user B!"] toUsers: @[@"B"]];
    }
    
    if(error != nil) {
        NSLog(@"Send remote notification failure: %@ - %@", error.code, error.message);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSDictionary*) createNotificationMessageWithContent:(NSString*) content {
    NSMutableDictionary* message = [[NSMutableDictionary alloc] init];
    message[@"alert"] = content;
    
    message[@"X-NotificationClass"] = @"2"; // microsoft notification priority
    message[@"X-WindowsPhone-Target"] = @"toast"; // notification type
    message[@"Text1"] = @"Push received";
    message[@"Text2"] = content;
    message[@"Param"] = @"/View/MainPage.xaml"; // wp7 toast page
    
    return [NSDictionary dictionaryWithDictionary:message];
}

@end
