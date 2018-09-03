//
//  ViewController.m
//  MPFlux
//
//  Created by Grand on 2018/9/3.
//  Copyright © 2018年 Grand. All rights reserved.
//

#import "ViewController.h"
#import "MPFluxStream.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation ViewController

- (void)dealloc
{
    MPFluxDataSource.shareInstance.removeAction(@"global_action_key");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak ViewController *weakSelf = self;
    /*
    //way1
    MPFluxActionOption *option = MPFluxActionOption.alloc.init;
    [option addObserver:^(MPFluxActionOption *option) {
        __strong ViewController *self = weakSelf;
        self.tipLabel.text = option.data;

    } forKey:@"obv1_key"];

    MPFluxAction *action = MPFluxAction.alloc.init;
    [action addOption:option forKey:@"option_key"];

    MPFluxDataSource *flux = MPFluxDataSource.shareInstance;
    [flux addAction:action forKey:@"global_action_key"];

    [option commit:^id(MPFluxActionOption *option, id dataOld) {
        return @"this is flux demo";
    }];
     */
    
//    way2
    MPFluxDataSource.shareInstance
    .addAction(MPFluxAction.new,@"global_action_key")
    .addOption(MPFluxActionOption.new,@"option_key")
    .addObserver(^(MPFluxActionOption *option){
        __strong ViewController *self = weakSelf;
        self.tipLabel.text = option.data;
    },@"obv1_key");
    
    MPFluxDataSource.shareInstance
    .action(@"global_action_key")
    .option(@"option_key")
    .commit(^(MPFluxActionOption *option, id dataOld){
        return @"this is flux demo";
    });

    
}

- (IBAction)onchange:(id)sender {
    MPFluxActionOption *option = [[MPFluxDataSource.shareInstance actionForKey:@"global_action_key"] optionForKey:@"option_key"];
    [option commit:^id(MPFluxActionOption *option, id dataOld) {
        return @"home had chage title";
    }];
}

@end
