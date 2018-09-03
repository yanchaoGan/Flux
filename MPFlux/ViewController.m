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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak ViewController *weakSelf = self;
    //init
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
}


@end
