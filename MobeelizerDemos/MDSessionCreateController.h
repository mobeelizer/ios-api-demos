//
// MDSessionCreateController.h
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

#import <UIKit/UIKit.h>
#import <MobeelizerSDK/MobeelizerSDK.h>

@interface MDSessionCreateController : UIViewController<UITextFieldDelegate>
- (IBAction)onCreate:(id)sender;
- (IBAction)onJoin:(id)sender;
- (IBAction)onJoinCodeChanged:(id)sender;
- (IBAction)backgroundTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *mobeelizerLogo;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UITextField *joinCodeInput;

@property (weak, nonatomic) IBOutlet UIView *mainView;

- (void)setSessionNumber:(NSString*)sessionNumber;

@end
