

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject<NSCoding>
{
}

//@property (nonatomic, strong) NSMutableDictionary *toolUnlockInfoDic;
@property (nonatomic, strong) NSMutableDictionary *shopDic;
@property (nonatomic, strong) NSMutableDictionary *productDic;



+ (UserInfo*) defaultUserInfo;

@end
