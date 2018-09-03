//
//  UserViewController.m
//  MPFlux
//
//  Created by Grand on 2018/9/3.
//  Copyright © 2018年 Grand. All rights reserved.
//

#import "UserViewController.h"
#import "MPFluxStream.h"

@interface UserViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@end

@implementation UserViewController

- (void)dealloc
{
    NSLog(@"%s",__func__);
    MPFluxActionOption *option = [[MPFluxDataSource.shareInstance actionForKey:@"global_action_key"] optionForKey:@"option_key"];
    [option removeObserverForKey:@"obv2_key"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //useage
    __weak UserViewController *weakSelf = self;
    MPFluxActionOption *option = [[MPFluxDataSource.shareInstance actionForKey:@"global_action_key"] optionForKey:@"option_key"];
    [option addObserver:^(MPFluxActionOption *option) {
        __strong UserViewController *self = weakSelf;
        self.tipLabel.text = option.data;
    } forKey:@"obv2_key"];
}

- (IBAction)onChange:(id)sender {
    static int time;
    time ++;
    MPFluxActionOption *option = [[MPFluxDataSource.shareInstance actionForKey:@"global_action_key"] optionForKey:@"option_key"];
    [option commit:^id(MPFluxActionOption *option, id dataOld) {
        return [@"i change the title " stringByAppendingFormat:@"%zi",time];
    }];
}

@end
