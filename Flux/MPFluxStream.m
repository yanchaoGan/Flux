//
// Created by Grand on 2018/9/3.
// Copyright (c) 2018 Grand. All rights reserved.
//

#import "MPFluxStream.h"

#pragma mark - DataSource
@interface MPFluxDataSource () {
    NSMutableDictionary *_Actions;
}
@end

@implementation MPFluxDataSource

+ (instancetype)shareInstance {
    static MPFluxDataSource *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        _instance->_Actions = @{}.mutableCopy;
    });
    return _instance;
}

- (void)clear {
    [_Actions removeAllObjects];
}

- (void)addAction:(MPFluxAction *)action forKey:(NSString *)key {
    _Actions[key] = action;
}

- (void)removeActionForKey:(NSString *)key {
    _Actions[key] = nil;
}

- (MPFluxAction *)actionForKey:(NSString *)key {
    return _Actions[key];
}

- (MPFluxAction *(^)(MPFluxAction *action, NSString *key))addAction {
    return ^ MPFluxAction *(MPFluxAction *action, NSString *key) {
        [self addAction:action forKey:key];
        return action;
    };
}

- (void(^)(NSString *key))removeAction {
    return ^(NSString *key) {
        [self removeActionForKey:key];
    };
}

- (MPFluxAction *(^)(NSString *key))action {
    return ^ MPFluxAction *(NSString *key) {
        return [self actionForKey:key];
    };
}


@end

#pragma mark - Action
@interface MPFluxAction () {
    NSMutableDictionary *_Options;
}
@end

@implementation MPFluxAction

- (instancetype)init {
    self = [super init];
    if (self) {
        _Options = @{}.mutableCopy;
    }
    return self;
}

- (void)addOption:(MPFluxActionOption *)option forKey:(NSString *)key {
    _Options[key] = option;
}

- (void)removeOptionForKey:(NSString *)key {
    _Options[key] = nil;
}

- (MPFluxActionOption *)optionForKey:(NSString *)key {
    return _Options[key];
}

- (MPFluxActionOption *(^)(MPFluxActionOption *option, NSString *key))addOption {
    return ^ MPFluxActionOption *(MPFluxActionOption *option, NSString *key){
        [self addOption:option forKey:key];
        return option;
    };
}
- (void(^)(NSString *key))removeOption {
    return ^(NSString *key) {
        [self removeOptionForKey:key];
    };
}
- (MPFluxActionOption *(^)(NSString *key))option {
    return ^ MPFluxActionOption *(NSString *key) {
        return [self optionForKey:key];
    };
}

@end

#pragma mark - Option
@interface MPFluxActionOption () {
    NSMutableDictionary *_Observers;
}
@end

@implementation MPFluxActionOption

- (instancetype)init
{
    self = [super init];
    if (self) {
        _Observers = @{}.mutableCopy;
    }
    return self;
}

- (void)addObserver:(MPObserver)observer forKey:(NSString *)key {
    _Observers[key] = observer;
    if (observer) {
        observer(self);
    }
}

- (void)removeObserverForKey:(NSString *)key {
    _Observers[key] = nil;
}

- (void)commit:(MPCommit)change {
    _data = change(self, _data);
    [self _postNotify];
}

- (void)_postNotify {
    [_Observers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, MPObserver  _Nonnull observer, BOOL * _Nonnull stop) {
        observer(self);
    }];
}


- (void(^)(MPObserver observer, NSString *key))addObserver {
    return ^(MPObserver observer, NSString *key) {
        [self addObserver:observer forKey:key];
    };
}

- (void(^)(NSString *key))removeObserver {
    return ^(NSString *key) {
        [self removeObserverForKey:key];
    };
}

- (void(^)(MPCommit change))commit {
    return ^(MPCommit change) {
        [self commit:change];
    };
}

@end
