//
//  UserPreference.m
//  bclient
//
//  Created by ayibang on 16/4/12.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import "UserPreference.h"
#import <objc/runtime.h>

@implementation UserPreference
{
    NSCache *_cache;
}

@dynamic currentVersion;

+ (instancetype)sharedPreference
{
    static UserPreference *preference = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        preference = [[UserPreference alloc] init];
    });
    return preference;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _cache = [[NSCache alloc] init];
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{}];
    }
    return self;
}

- (NSString *)propertyNameWithSelector:(SEL)aSelector isSet:(BOOL *)isSet
{
    @try {
        NSString *selectorString = NSStringFromSelector(aSelector);
        if ([selectorString rangeOfString:@":"].length <= 0)
        {
            *isSet = NO;
            return selectorString;
        }
        else
        {
            if ([selectorString hasPrefix:@"set"] && [selectorString hasSuffix:@":"])
            {
                NSMutableString *result = [NSMutableString stringWithString:selectorString];
                [result deleteCharactersInRange:NSMakeRange(0, 3)];
                [result deleteCharactersInRange:NSMakeRange(result.length - 1, 1)];
                if ([result rangeOfString:@":"].length > 0 || selectorString.length <= 0)
                {
                    return nil;
                }
                [result replaceCharactersInRange:NSMakeRange(0, 1) withString:[[result substringWithRange:NSMakeRange(0, 1)] lowercaseString]];
                *isSet = YES;
                return [result copy];
            }
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }

    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    BOOL isSet = NO;
    NSString *propertyName = [self propertyNameWithSelector:aSelector isSet:&isSet];
    if (!propertyName)
    {
        return [super methodSignatureForSelector:aSelector];
    }
    
    objc_property_t property = class_getProperty([self class],propertyName.UTF8String);
    if (!property)
    {
        return [super methodSignatureForSelector:aSelector];
    }
    
    NSString *propertyAttributes = [NSString stringWithUTF8String:property_getAttributes(property)];
    NSString *propertyTypeAttribute = [propertyAttributes componentsSeparatedByString:@","][0];
    if (![propertyAttributes hasPrefix:@"T"])
    {
        return [super methodSignatureForSelector:aSelector];
    }

    if (isSet)
    {


        return [NSMethodSignature signatureWithObjCTypes:[NSString stringWithFormat:@"v@:%@",[propertyTypeAttribute substringFromIndex:1]].UTF8String];
    }
    else
    {
        return [NSMethodSignature signatureWithObjCTypes:[NSString stringWithFormat:@"%@@:",[propertyTypeAttribute substringFromIndex:1]].UTF8String];
    }
    
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL selector = [anInvocation selector];
    
    BOOL isSet = NO;
    NSString *propertyName = [self propertyNameWithSelector:selector isSet:&isSet];
    if (!propertyName)
    {
        [super forwardInvocation:anInvocation];
        return;
    }
    
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:selector];
    if (!methodSignature)
    {
        [super forwardInvocation:anInvocation];
        return;
    }
    
    if (isSet && methodSignature.numberOfArguments > 2)
    {
        const char *argumentType = [methodSignature getArgumentTypeAtIndex:2];
        if (strlen(argumentType) < 1)
        {
            [super forwardInvocation:anInvocation];
            return;
        }
        
        if (argumentType[0] == 'i' || argumentType[0] == 'l' || argumentType[0] == 'q')
        {
            NSInteger arg = 0;
            [anInvocation getArgument:&arg atIndex:2];
            [[NSUserDefaults standardUserDefaults] setInteger:arg forKey:propertyName];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [_cache setObject:@(arg) forKey:propertyName];
            return;
        }
        else if (argumentType[0] == 'f')
        {
            float arg = 0;
            [anInvocation getArgument:&arg atIndex:2];
            [[NSUserDefaults standardUserDefaults] setFloat:arg forKey:propertyName];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [_cache setObject:@(arg) forKey:propertyName];
            return;
        }
        else if (argumentType[0] == 'd')
        {
            double arg = 0;
            [anInvocation getArgument:&arg atIndex:2];
            [[NSUserDefaults standardUserDefaults] setDouble:arg forKey:propertyName];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [_cache setObject:@(arg) forKey:propertyName];
            return;
        }
        else if (argumentType[0] == 'B')
        {
            BOOL arg = 0;
            [anInvocation getArgument:&arg atIndex:2];
            [[NSUserDefaults standardUserDefaults] setBool:arg forKey:propertyName];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [_cache setObject:@(arg) forKey:propertyName];
            return;
        }
        else if (argumentType[0] == '@')
        {
            __autoreleasing id arg = nil;
            [anInvocation getArgument:&arg atIndex:2];
            [[NSUserDefaults standardUserDefaults] setObject:arg forKey:propertyName];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (arg)
            {
                if ([arg isKindOfClass:[NSString class]] ||
                    [arg isKindOfClass:[NSArray class]] ||
                    [arg isKindOfClass:[NSDictionary class]])
                {
                    [_cache setObject:[arg copy] forKey:propertyName];
                }
                else
                {
                    [_cache setObject:arg forKey:propertyName];
                }
            }
            else
            {
                [_cache removeObjectForKey:propertyName];
            }
            return;
        }
    }
    else
    {
        const char *returnType = methodSignature.methodReturnType;
        
        if (returnType[0] == 'i' || returnType[0] == 'l' || returnType[0] == 'q')
        {
            id valueObject = [_cache objectForKey:propertyName];
            NSInteger value = 0;
            if (valueObject)
            {
                value = [valueObject integerValue];
            }
            else
            {
                value = [[NSUserDefaults standardUserDefaults] integerForKey:propertyName];
                [_cache setObject:@(value) forKey:propertyName];
            }
            [anInvocation setReturnValue:&value];
            return;
        }
        else if (returnType[0] == 'f')
        {
            id valueObject = [_cache objectForKey:propertyName];
            float value = 0;
            if (valueObject)
            {
                value = [valueObject floatValue];
            }
            else
            {
                value = [[NSUserDefaults standardUserDefaults] floatForKey:propertyName];
                [_cache setObject:@(value) forKey:propertyName];
            }
            [anInvocation setReturnValue:&value];
            return;
        }
        else if (returnType[0] == 'd')
        {
            id valueObject = [_cache objectForKey:propertyName];
            double value = 0;
            if (valueObject)
            {
                value = [valueObject doubleValue];
            }
            else
            {
                value = [[NSUserDefaults standardUserDefaults] doubleForKey:propertyName];
                [_cache setObject:@(value) forKey:propertyName];
            }
            [anInvocation setReturnValue:&value];
            return;
        }
        else if (returnType[0] == 'B')
        {
            id valueObject = [_cache objectForKey:propertyName];
            BOOL value = 0;
            if (valueObject)
            {
                value = [valueObject boolValue];
            }
            else
            {
                value = [[NSUserDefaults standardUserDefaults] boolForKey:propertyName];
                [_cache setObject:@(value) forKey:propertyName];
            }
            [anInvocation setReturnValue:&value];
            return;
        }
        else if (returnType[0] == '@')
        {
            id value = [_cache objectForKey:propertyName];
            if (!value)
            {
                value = [[NSUserDefaults standardUserDefaults] objectForKey:propertyName];
                if (value)
                {
                    [_cache setObject:value forKey:propertyName];
                }
                else
                {
                    [_cache removeObjectForKey:propertyName];
                }
            }
            if (value)
            {
                CFAutorelease(CFBridgingRetain(value));
            }
            [anInvocation setReturnValue:&value];
            return;
        }
    }
    
    [super forwardInvocation:anInvocation];
}

@end
