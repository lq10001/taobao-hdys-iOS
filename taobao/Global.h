

#import <Foundation/Foundation.h>
#import "UIViewAdditions.h"
#import <QuartzCore/QuartzCore.h>

#ifndef Is_Ipad 
#define Is_Ipad         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#endif

#ifndef IS_IPHONE_5 
#define IS_IPHONE_5     ([UIScreen mainScreen].bounds.size.height == 568)
#endif


#ifndef KScreenSize
#define kScreenSize    (Is_Ipad ? CGSizeMake(1024, 768) :   (IS_IPHONE_5 ? CGSizeMake(568, 320) : CGSizeMake(480, 320)))
#endif


#ifndef kScreenScale
#define kScreenScale ((int)[[UIScreen mainScreen] scale])
#endif

#define Rect2(x,y,w,h)   (Is_Ipad ? CGRectMake(x,y,w,h) :   CGRectMake(x / 2,y/ 2,w/2,h/2))

#define Num2(x)   (Is_Ipad ? x * 2 : x)


#define kMUSIC          @"kMUSIC"
#define kSOUND          @"kSOUND"
#define kNOTIFY         @"kNOTIFY"

#define kUSER_DATA      @"kUSER_DATA"
#define kSHOPARRAY_DATA      @"kSHOPARRAY_DATA"
#define kPRODUCTARRAY_DATA      @"kPRODUCTARRAY_DATA"

#define kTAOBAO_CLICK_URL   @"http://s.click.taobao.com/t_9?p=mm_1698546_0_0&l="



#define kUMENG_KEY      @"51860ce956240b65f202f72e"

#define kTAOBAO_KEY     @"21501533"
#define kTAOBAO_SECRET  @"b96e9f4ca2f7fffe81f9239991d5d190"

//121.199.47.31

#define kSERVER_URL         @"http://121.199.47.31:8080/taobao/"
#define kSHOP_URL           @"http://121.199.47.31:8080/taobao/web/shop_list"
#define kSEARCH_TAG_URL     @"http://121.199.47.31:8080/taobao/web/search_list"
#define kPRODUCT_NEW_URL        @"http://121.199.47.31:8080/taobao/web/product_list?numPerPage=20&pageNum="
#define kPRODUCT_SALE_URL        @"http://121.199.47.31:8080/taobao/web/productSale_list?numPerPage=20&pageNum="
#define kPRODUCTIMG_URL     @"http://121.199.47.31:8080/taobao/web/productimg_list?productid="


//#define kSERVER_URL         @"http://192.168.1.105:8080/taobao/"
//#define kSHOP_URL           @"http://192.168.1.105:8080/taobao/web/shop_list"
//#define kSEARCH_TAG_URL     @"http://192.168.1.105:8080/taobao/web/search_list"
//#define kPRODUCT_NEW_URL        @"http://192.168.1.105:8080/taobao/web/product_list?numPerPage=20&pageNum="
//#define kPRODUCT_SALE_URL        @"http://192.168.1.105:8080/taobao/web/productSale_list?numPerPage=20&pageNum="
//#define kPRODUCTIMG_URL     @"http://192.168.1.105:8080/taobao/web/productimg_list?productid="


#define kNEW_PRODUCT_URL    @"http://handuyishe.m.tmall.com/shop/shop_auction_search.htm?conditions=&sid=9ee8445d31cc7a85&sort=oldstarts&suid=263817957&q=&end_price=&pds=newrank%23h%23shop&ascid=&scid=&start_price="

#define kSALE_PRODUCT_URL    @"http://handuyishe.m.tmall.com/shop/shop_auction_search.htm?conditions=&sid=03a247e303178cdc&sort=hotsell&suid=263817957&q=&p=2&end_price=&ascid=&scid=&start_price="

#define kSEARCH_URL @"http://s.m.taobao.com/search.htm?topSearch=1&abtest=5&sst=1&q="

#define kLOGIN_URL @"http://login.m.taobao.com/login.htm?sid=e38100d1885b03da&pds=login%23h%23&tpl_redirect_url=http%3A%2F%2Fa.m.tmall.com%2Fi23348500695.htm%3Fsid%3De38100d1885b03da%26show_id%3D5131925%26pds%3Dfromtop%2523h%2523shop"






// DLog is almost a drop-in replacement for NSLog
// DLog();
// DLog(@"here");
// DLog(@"value: %d", x);
// Unfortunately this doesn't work DLog(aStringVariable); you have to do this instead DLog(@"%@", aStringVariable);
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif
// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

@interface Global

+ (NSDictionary*)requestServer:(NSString*)str_url;

+ (BOOL)checkNet;

@end


@interface UIImage(UIImage_Extension)

+ (UIImage*) imageNamed:(NSString*)pImgName suffix:(NSString*)pSuffix;
+ (UIImage*) imageNamedPNG:(NSString*)pImgName;
+ (UIImage*) imageNamedJPG:(NSString*)pImgName;

/*
 根据一个给定的图片名字(可以包含文件目录，比如Images/play.png)来得到最合适的图片路径，然后读取图片
 如果此时是ipad3,那么优先读取play_ipad@2x.png,如果读取不到则读取play_ipad.png,然后是play.png
 如果此时是ipad2,那么优先读取play_ipad.png,然后是play.png
 
 如果此时是iphone4，那么优先读取play@2x.png,然后是play.png
 如果此时是iphone3GS,那么优先读取play.png
 */
+ (UIImage*) imageNamedAuto:(NSString*)pImgName;


typedef enum
{
    TypeNone,
    NewType,
    SaleType,
    ShopType,
    ProductType
}PersonType;

@end


@interface UIButton(UIbutton_Extra)

+ (UIButton*) buttonWithNormalImgName:(NSString*)pNormalImgName selectedImgName:(NSString*)pSelectedImgName target:(id)pTarget selector:(SEL)pSelector;
+ (UIButton*) buttonWithNormalImgName:(NSString*)pNormalImgName HighlightImgName:(NSString*)pHighlighImgName target:(id)pTarget selector:(SEL)pSelector;
@end



@interface UIImageView(gesture_extra)

+ (UIImageView*) imageViewWithImageName:(NSString*)pImgName target:(id)pTarget selector:(SEL)pSelector;
@end




