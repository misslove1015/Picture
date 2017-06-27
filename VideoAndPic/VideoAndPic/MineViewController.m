//
//  MineViewController.m
//  VideoAndPic
//
//  Created by miss on 2017/6/23.
//  Copyright © 2017年 mukr. All rights reserved.
//

#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]

#import "MineViewController.h"

@interface MineViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *touchIDSwitch;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([USER_DEFAULTS boolForKey:@"touchIDIsOpen"]) {
        self.touchIDSwitch.on = YES;
    }
}

- (IBAction)touchIDSwitchValueChanged:(UISwitch *)sender {
    if (sender.isOn) {
        [USER_DEFAULTS setBool:YES forKey:@"touchIDIsOpen"];
        [USER_DEFAULTS synchronize];
    }else {
        [USER_DEFAULTS setBool:NO forKey:@"touchIDIsOpen"];
        [USER_DEFAULTS synchronize];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
