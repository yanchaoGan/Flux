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
    [self _postNotify];
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

@end
