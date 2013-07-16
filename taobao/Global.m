

#import "Global.h"

#pragma mark - UIImage extension
@implementation UIImage(UIImage_Extension)

+ (UIImage*) imageNamed:(NSString*)pImgName suffix:(NSString*)pSuffix
{
    if(! pImgName) return nil;
    
    NSString *imgDirectory=[pImgName stringByDeletingLastPathComponent];
    NSString *imgNameWithoutExtension=[[pImgName lastPathComponent] stringByDeletingPathExtension]; //去掉文件扩展名
    
    NSString *iphoneNormalName=[NSString stringWithFormat:@"%@%@",imgNameWithoutExtension,pSuffix];
    NSString *iphoneRetinaName=[NSString stringWithFormat:@"%@@2x%@",imgNameWithoutExtension,pSuffix];
    NSString *ipadNormalName=[NSString stringWithFormat:@"%@_ipad%@",imgNameWithoutExtension,pSuffix];
    NSString *ipadRetinaName=[NSString stringWithFormat:@"%@_ipad@2x%@",imgNameWithoutExtension,pSuffix];
    
    NSMutableArray *optionalImgNames=[NSMutableArray array];
    if(Is_Ipad)
    {
        if(kScreenScale == 1)   //ipad低清设备
        {
            [optionalImgNames addObject:ipadNormalName];
            [optionalImgNames addObject:iphoneNormalName];
        }
        else    //ipad高清设备
        {
            [optionalImgNames addObject:ipadRetinaName];
            [optionalImgNames addObject:ipadNormalName];
            [optionalImgNames addObject:iphoneNormalName];
        }
    }
    else
    {
        if(kScreenScale == 1)   //iphone低清设备
        {
            [optionalImgNames addObject:iphoneNormalName];
        }
        else
        {
            [optionalImgNames addObject:iphoneRetinaName];
            [optionalImgNames addObject:iphoneNormalName];
        }
    }
    
    UIImage *curImg=nil;
    for(NSString *curImgName in optionalImgNames)
    {
        NSString *curImgPath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",imgDirectory,curImgName]];
        if(curImgPath) curImg=[UIImage imageWithContentsOfFile:curImgPath];
        if(curImg)  break;
    }
    
    if(!curImg)
    {
#ifdef DEBUG
        NSLog(@"can't read image:%@",iphoneNormalName);
#endif
    }
    return curImg;

}

+ (UIImage*) imageNamedPNG:(NSString*)pImgName
{
    return [UIImage imageNamed:pImgName suffix:@".png"];
}

+ (UIImage*) imageNamedJPG:(NSString*)pImgName
{
    return [UIImage imageNamed:pImgName suffix:@".jpg"];
}

+ (UIImage*) imageNamedAuto:(NSString*)pImgName
{
    UIImage *img=[UIImage imageNamedPNG:pImgName];
    if(!img) img=[UIImage imageNamedJPG:pImgName];
    return img;
}
@end

#pragma mark - UIbutton extension
@implementation UIButton(UIbutton_Extra)

+ (UIButton*) buttonWithNormalImgName:(NSString *)pNormalImgName selectedImgName:(NSString *)pSelectedImgName target:(id)pTarget selector:(SEL)pSelector
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch=YES;
    [btn addTarget:pTarget action:pSelector forControlEvents:UIControlEventTouchUpInside];
    UIImage *normalImg=[UIImage imageNamedAuto:pNormalImgName];
    UIImage *selectedImg=[UIImage imageNamedAuto:pSelectedImgName];
    if(normalImg)   [btn setImage:normalImg forState:UIControlStateNormal];
    if(selectedImg) [btn setImage:selectedImg forState:UIControlStateSelected];
    [btn sizeToFit];
    if(! Is_Ipad) btn.bounds=CGRectMake(0, 0, btn.bounds.size.width/2, btn.bounds.size.height/2);
    return btn;
}

+ (UIButton*) buttonWithNormalImgName:(NSString *)pNormalImgName HighlightImgName:(NSString *)pHighlighImgName target:(id)pTarget selector:(SEL)pSelector
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch=YES;
    [btn addTarget:pTarget action:pSelector forControlEvents:UIControlEventTouchUpInside];
    UIImage *normalImg=[UIImage imageNamedAuto:pNormalImgName];
    UIImage *hilighImg=[UIImage imageNamedAuto:pHighlighImgName];
    if(normalImg)   [btn setImage:normalImg forState:UIControlStateNormal];
    if(hilighImg) [btn setImage:hilighImg forState:UIControlStateHighlighted];
    [btn sizeToFit];
    if(! Is_Ipad) btn.bounds=CGRectMake(0, 0, btn.bounds.size.width/2, btn.bounds.size.height/2);
    return btn;
}

@end



@implementation UIImageView(gesture_extra)

+ (UIImageView*) imageViewWithImageName:(NSString*)pImgName target:(id)pTarget selector:(SEL)pSelector
{
    UIImageView *imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamedAuto:pImgName]];
    imgView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:pTarget action:pSelector];
    imgView.exclusiveTouch=YES;
    tapGesture.numberOfTouchesRequired=1;
    tapGesture.numberOfTapsRequired=1;
    [imgView addGestureRecognizer:tapGesture];
    
    if(! Is_Ipad) imgView.bounds=CGRectMake(0, 0, imgView.bounds.size.width/2, imgView.bounds.size.height/2);
    return imgView;
}
@end







