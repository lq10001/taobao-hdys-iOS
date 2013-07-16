//
//  DataCenter.h
//  taobao
//
//  Created by zw on 13-5-25.
//  Copyright (c) 2013年 zw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCenter : NSObject

+ (DataCenter*)sharedDataCenter;

- (NSArray*)searchArray:(NSDictionary*)dic;

- (NSMutableArray*)productArray:(NSDictionary*)dic;

@end
