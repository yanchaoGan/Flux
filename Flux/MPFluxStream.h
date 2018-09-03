//
// Created by Grand on 2018/9/3.
// Copyright (c) 2018 Grand. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MPFluxAction;
@class MPFluxActionOption;

typedef void (^MPObserver)(MPFluxActionOption *option);
typedef id (^MPCommit)(MPFluxActionOption *option, id dataOld);

//store
@interface MPFluxDataSource : NSObject

+ (instancetype)shareInstance;

- (void)addAction:(MPFluxAction *)action forKey:(NSString *)key;
- (void)removeActionForKey:(NSString *)key;
- (MPFluxAction *)actionForKey:(NSString *)key;

- (void)clear;

//fp support
- (MPFluxAction *(^)(MPFluxAction *action, NSString *key))addAction;
- (void(^)(NSString *key))removeAction;
- (MPFluxAction *(^)(NSString *key))action;


@end

//action . for special vc or view
@interface MPFluxAction : NSObject

- (void)addOption:(MPFluxActionOption *)option forKey:(NSString *)key;
- (void)removeOptionForKey:(NSString *)key;
- (MPFluxActionOption *)optionForKey:(NSString *)key;

//fp support
- (MPFluxActionOption *(^)(MPFluxActionOption *option, NSString *key))addOption;
- (void(^)(NSString *key))removeOption;
- (MPFluxActionOption *(^)(NSString *key))option;

@end

/**< 被替代品*/
//dispatcher -> mainqueue
//observer binding view -> block

/**< weak strong 属性观察物 替代物; eg: BFDataModel */
@interface MPFluxActionOption : NSObject
@property (nonatomic, strong, readonly) id data; //or eg: BFDataModel

- (void)addObserver:(MPObserver)observer forKey:(NSString *)key;
- (void)removeObserverForKey:(NSString *)key;

- (void)commit:(MPCommit)change;

//fp support
- (void(^)(MPObserver observer, NSString *key))addObserver;
- (void(^)(NSString *key))removeObserver;
- (void(^)(MPCommit change))commit;

@end

