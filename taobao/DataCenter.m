//
//  DataCenter.m
//  taobao
//
//  Created by zw on 13-5-25.
//  Copyright (c) 2013年 zw. All rights reserved.
//

#import "DataCenter.h"
#import "Search.h"
#import "Product.h"

static DataCenter *dataCenter = nil;

@implementation DataCenter


+ (DataCenter*)sharedDataCenter
{
    if (dataCenter == nil) {
        dataCenter = DataCenter.new;
    }
    return dataCenter;
}

- (NSArray*)searchArray:(NSDictionary*)dic
{
    NSDictionary *searchDic = [dic objectForKey:@"search_list"];
    DLog(@"searchDic count: %i ",searchDic.count);
    NSMutableArray *array = NSMutableArray.new;
    for (NSDictionary *sdic in searchDic) {
        
        Search *search = Search.new;
        search.searchid = [[sdic objectForKey:@"searchid"] integerValue];
        search.name = [sdic objectForKey:@"name"];
        search.str_url = [sdic objectForKey:@"url"];
        
        [array addObject:search];
    }
    return array;
}

/*
 @property(assign)int cid;
 @property(assign)int num;
 @property(assign)int num_iid;
 
 @property(nonatomic,strong)NSString *price ;
 @property(nonatomic,strong)NSString *pic_url ;
 @property(nonatomic,strong)NSString *title ;
 @property(nonatomic,strong)NSString *nick ;
 
 */

- (NSMutableArray*)productArray:(NSDictionary *)dic
{
    NSDictionary *pdic = [dic objectForKey:@"product_list"];
    DLog(@" %i ",pdic.count);
    NSMutableArray *array = NSMutableArray.new;
    for (NSDictionary *dic1 in pdic) {
        
        Product *p = Product.new;
        p.productid = [[dic1 objectForKey:@"productid"] integerValue];
        p.cid = [[dic1 objectForKey:@"cid"] integerValue];
        p.num = [[dic1 objectForKey:@"num"] integerValue];
        p.num_iid = [dic1 objectForKey:@"num_iid"];
        
        p.price = [dic1 objectForKey:@"price"];
        p.url = [dic1 objectForKey:@"url"];
        p.pic_url = [dic1 objectForKey:@"picurl"];
        p.title = [dic1 objectForKey:@"name"];
        p.nick = [dic1 objectForKey:@"nick"];
        
        [array addObject:p];
    }
    return array;
    
}


@end
