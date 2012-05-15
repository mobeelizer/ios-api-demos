//
//  MDSampleController.m
//  MobeelizerDemos
//
//  Created by Ja on 08.05.2012.
//  Copyright (c) 2012 Joselewicza. All rights reserved.
//

#import "MDSampleController.h"
#import "MDSampleHelpController.h"

@interface MDSampleController() {
@private
    BOOL showHelp;
}
@end

@implementation MDSampleController

- (NSString*) name {
    return nil;
}

- (NSString*) helpPage {
    return nil;
}

- (void) showHelp {
    showHelp = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    BOOL hasHelpButton = NO;
    for (UIView* view in self.navigationController.toolbar.items) {
        if (view.tag == 1232) {
            hasHelpButton = YES;
            break;
        }
    }
    
    if (!hasHelpButton) {
        NSMutableArray* toolbarItems = [[NSMutableArray alloc] initWithArray:self.navigationController.toolbar.items];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        space.tag = 1231;
        [toolbarItems addObject:space];
    
        if ([self helpPage] != nil) {
            UIBarButtonItem *helpButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(helpClicked:)];
            helpButton.tag = 1232;
            [toolbarItems addObject:helpButton];
        }
        [self.navigationController.toolbar setItems:toolbarItems animated:NO];
    }
    
    if (showHelp && [self helpPage] != nil) {
        showHelp = NO;
        [self performSelector:@selector(helpClicked:) withObject:nil];
    }
}

- (void)helpClicked:(id) sender {
    MDSampleHelpController* view = [[MDSampleHelpController alloc] initWithNibName:[self helpPage] bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:view animated:YES];
}


@end
