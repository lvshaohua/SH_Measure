//
// ZDStickerView.m
//
// Created by Seonghyun Kim on 5/29/13.
// Copyright (c) 2013 scipi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ZDStickerView.h"


#define kSPUserResizableViewGlobalInset 0
#define kSPUserResizableViewDefaultMinWidth 48.0
#define kSPUserResizableViewInteractiveBorderSize 10.0
#define kZDStickerViewControlSize 36.0



@interface ZDStickerView ()

@property (nonatomic, assign) CGPoint orignalCenter;

@property (strong, nonatomic) UIImageView *resizingControl;
@property (strong, nonatomic) UIImageView *deleteControl;
@property (strong, nonatomic) UIImageView *customControl;

@property (strong, nonatomic) UIPinchGestureRecognizer *pinchRecognizer;
@property (strong, nonatomic) UIRotationGestureRecognizer *rotationRecognizer;

@property (nonatomic) BOOL preventsLayoutWhileResizing;

@property (nonatomic) CGFloat deltaAngle;
@property (nonatomic) CGPoint prevPoint;
@property (nonatomic) CGAffineTransform startTransform;

@property (nonatomic) CGPoint touchStart;

@end



@implementation ZDStickerView


#ifdef ZDSTICKERVIEW_LONGPRESS
- (void)longPress:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidLongPressed:)])
        {
            [self.stickerViewDelegate stickerViewDidLongPressed:self];
        }
    }
}
#endif


- (void)singleTap:(UIPanGestureRecognizer *)recognizer
{
    if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidClose:)])
    {
        [self.stickerViewDelegate stickerViewDidClose:self];
    }

    if (NO == self.preventsDeleting)
    {
        UIView *close = (UIView *)[recognizer view];
        [close.superview removeFromSuperview];
    }
}



- (void)customTap:(UIPanGestureRecognizer *)recognizer
{
    if (NO == self.preventsCustomButton)
    {
        if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidCustomButtonTap:)])
        {
            [self.stickerViewDelegate stickerViewDidCustomButtonTap:self];
        }
    }
}


- (void)pinchTranslate:(UIPinchGestureRecognizer *)recognizer {
    static CGRect boundsBeforeScaling;
    static CGAffineTransform transformBeforeScaling;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        boundsBeforeScaling = recognizer.view.bounds;
        transformBeforeScaling = recognizer.view.transform;
    }
    
    CGPoint center = recognizer.view.center;
    CGAffineTransform scale = CGAffineTransformScale(CGAffineTransformIdentity,
                                                     recognizer.scale,
                                                     recognizer.scale);
    CGRect frame = CGRectApplyAffineTransform(boundsBeforeScaling, scale);
    
    frame.origin = CGPointMake(center.x - frame.size.width / 2,
                               center.y - frame.size.height / 2);

    recognizer.view.transform = CGAffineTransformIdentity;
    recognizer.view.frame = frame;
    recognizer.view.transform = transformBeforeScaling;
}

- (void)rotateTranslate:(UIRotationGestureRecognizer *)recognizer {
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
}

- (void)resizeTranslate:(UIPanGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        [self enableTransluceny:YES];
        self.prevPoint = [recognizer locationInView:self];
//        [self setNeedsDisplay];
        
        // Inform delegate.
        if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidBeginEditing:)]) {
            [self.stickerViewDelegate stickerViewDidBeginEditing:self];
        }
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        
        
        [self enableTransluceny:YES];
        
        // preventing from the picture being shrinked too far by resizing
        if (self.bounds.size.width < self.minWidth || self.bounds.size.height < self.minHeight)
        {
            self.bounds = CGRectMake(self.bounds.origin.x,
                                     self.bounds.origin.y,
                                     self.minWidth+1,
                                     self.minHeight+1);
            self.resizingControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                                   self.bounds.size.height-kZDStickerViewControlSize,
                                                   kZDStickerViewControlSize,
                                                   kZDStickerViewControlSize);
            self.deleteControl.frame = CGRectMake(0, 0,
                                                  kZDStickerViewControlSize, kZDStickerViewControlSize);
            self.customControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                                 0,
                                                 kZDStickerViewControlSize,
                                                 kZDStickerViewControlSize);
            self.prevPoint = [recognizer locationInView:self];
            
        }
        // Resizing
        else
        {
            CGPoint point = [recognizer locationInView:self];
            float wChange = 0.0, hChange = 0.0;

            wChange = (point.x - self.prevPoint.x);
            hChange = point.y - self.prevPoint.y;
            if (self.isSwitchOn) {
                self.frame = CGRectMake(self.frame.origin.x - wChange,
                                        self.frame.origin.y - hChange,
                                        self.frame.size.width + (wChange * 2),
                                        self.frame.size.height + (hChange * 2));
                
            } else {
                
                self.frame = CGRectMake(self.frame.origin.x,
                                        self.frame.origin.y,
                                        self.frame.size.width + (wChange ),
                                        self.frame.size.height + (hChange));
                
            }
            
            self.resizingControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                                   self.bounds.size.height-kZDStickerViewControlSize,
                                                   kZDStickerViewControlSize, kZDStickerViewControlSize);
            self.customControl.frame =CGRectMake(self.bounds.size.width-kZDStickerViewControlSize,
                                                 0,
                                                 kZDStickerViewControlSize,
                                                 kZDStickerViewControlSize);
            
            self.prevPoint = [recognizer locationOfTouch:0 inView:self];
        }

        [self setNeedsDisplay];
        
        if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidMoved:)]) {
            [self.stickerViewDelegate stickerViewDidMoved:self];
        }
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        [self enableTransluceny:NO];
        self.prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
        
        // Inform delegate.
        if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidEndEditing:)]) {
            [self.stickerViewDelegate stickerViewDidEndEditing:self];
        }
    }
    else if ([recognizer state] == UIGestureRecognizerStateCancelled)
    {
        // Inform delegate.
        if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidCancelEditing:)]) {
            [self.stickerViewDelegate stickerViewDidCancelEditing:self];
        }
    }
}



- (void)setupDefaultAttributes
{
    
    self.minWidth = 0;
    self.minHeight = 0;

    self.preventsPositionOutsideSuperview = YES;
    self.preventsLayoutWhileResizing = YES;
    self.preventsResizing = NO;
    self.preventsDeleting = NO;
    self.preventsCustomButton = YES;
    self.translucencySticker = YES;
    self.allowDragging = YES;

#ifdef ZDSTICKERVIEW_LONGPRESS
    UILongPressGestureRecognizer*longpress = [[UILongPressGestureRecognizer alloc]
                                              initWithTarget:self
                                                      action:@selector(longPress:)];
    [self addGestureRecognizer:longpress];
#endif
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:panGesture];
    
    //拖动手势触发方法
    

    self.resizingControl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-kZDStickerViewControlSize,
                                                                        self.frame.size.height-kZDStickerViewControlSize,
                                                                        kZDStickerViewControlSize, kZDStickerViewControlSize)];
    self.resizingControl.backgroundColor = [UIColor clearColor];
    self.resizingControl.userInteractionEnabled = YES;
    self.resizingControl.image = [UIImage imageNamed:@"ZDStickerView.bundle/ZDBtn2.png.png"];
    UIPanGestureRecognizer*panResizeGesture = [[UIPanGestureRecognizer alloc]
                                               initWithTarget:self
                                                       action:@selector(resizeTranslate:)];
    [self.resizingControl addGestureRecognizer:panResizeGesture];
    [self addSubview:self.resizingControl];

    self.customControl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-kZDStickerViewControlSize,
                                                                      0,
                                                                      kZDStickerViewControlSize, kZDStickerViewControlSize)];
    self.customControl.backgroundColor = [UIColor clearColor];
    self.customControl.userInteractionEnabled = YES;
    self.customControl.image = nil;
    
    // Add pinch gesture recognizer.
    self.pinchRecognizer = [[UIPinchGestureRecognizer alloc]
                            initWithTarget:self
                            action:@selector(pinchTranslate:)];
    [self addGestureRecognizer:self.pinchRecognizer];
    
    // Add rotation recognizer.
    self.rotationRecognizer = [[UIRotationGestureRecognizer alloc]
                               initWithTarget:self
                               action:@selector(rotateTranslate:)];
    [self addGestureRecognizer:self.rotationRecognizer];
    
    // Add custom control recognizer.
    UITapGestureRecognizer *customTapGesture = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(customTap:)];
    [self.customControl addGestureRecognizer:customTapGesture];
    [self addSubview:self.customControl];

    self.deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,
                            self.frame.origin.x+self.frame.size.width - self.center.x);
}

-(void)panGesture:(UIPanGestureRecognizer *)sender
{
    UIPanGestureRecognizer *panGesture = sender;
    
    
    if ([sender state] == UIGestureRecognizerStateBegan)
    {
        self.orignalCenter = self.center;
    }
    else if ([sender state] == UIGestureRecognizerStateChanged)
    {
        CGPoint movePoint = [panGesture translationInView:self.superview];
        NSLog(@"mvoePoint = %@", NSStringFromCGPoint(movePoint));
        
        [self translateUsingTouchLocation:movePoint];
    }
    else if ([sender state] == UIGestureRecognizerStateEnded)
    {

    }
    else if ([sender state] == UIGestureRecognizerStateCancelled)
    {

    }
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setupDefaultAttributes];
    }

    return self;
}



- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setupDefaultAttributes];
    }

    return self;
}



- (void)setContentView:(UIView *)newContentView
{
    [self.contentView removeFromSuperview];
    _contentView = newContentView;

    self.contentView.frame = CGRectInset(self.bounds,
                                         kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2,
                                         kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2);

    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self addSubview:self.contentView];

    for (UIView *subview in [self.contentView subviews])
    {
        [subview setFrame:CGRectMake(0, 0,
                                     self.contentView.frame.size.width,
                                     self.contentView.frame.size.height)];

        subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }

    [self bringSubviewToFront:self.resizingControl];
    [self bringSubviewToFront:self.deleteControl];
    [self bringSubviewToFront:self.customControl];
}

- (void)translateUsingTouchLocation:(CGPoint)touchPoint
{
    CGPoint newCenter = CGPointMake(self.orignalCenter.x + touchPoint.x ,
                                    self.orignalCenter.y + touchPoint.y );

    if (self.preventsPositionOutsideSuperview)
    {
        // Ensure the translation won't cause the view to move offscreen.
        CGFloat midPointX = CGRectGetMidX(self.bounds);
        if (newCenter.x > self.superview.bounds.size.width - midPointX)
        {
            newCenter.x = self.superview.bounds.size.width - midPointX;
        }

        if (newCenter.x < midPointX)
        {
            newCenter.x = midPointX;
        }

        CGFloat midPointY = CGRectGetMidY(self.bounds);
        if (newCenter.y > self.superview.bounds.size.height - midPointY)
        {
            newCenter.y = self.superview.bounds.size.height - midPointY;
        }

        if (newCenter.y < midPointY)
        {
            newCenter.y = midPointY;
        }
    }

    self.center = newCenter;
    
    if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidMoved:)]) {
        [self.stickerViewDelegate stickerViewDidMoved:self];
    }
}

#pragma mark - Property setter and getter

- (void)hideDelHandle
{
    self.deleteControl.hidden = YES;
}



- (void)showDelHandle
{
    self.deleteControl.hidden = NO;
}



- (void)hideEditingHandles
{
    self.resizingControl.hidden = YES;
    self.deleteControl.hidden = YES;
    self.customControl.hidden = YES;
}



- (void)showEditingHandles
{
    if (NO == self.preventsCustomButton)
    {
        self.customControl.hidden = NO;
    }
    else
    {
        self.customControl.hidden = YES;
    }

    if (NO == self.preventsDeleting)
    {
        self.deleteControl.hidden = NO;
    }
    else
    {
        self.deleteControl.hidden = YES;
    }

    if (NO == self.preventsResizing)
    {
        self.resizingControl.hidden = NO;
    }
    else
    {
        self.resizingControl.hidden = YES;
    }
}



- (void)showCustomHandle
{
    self.customControl.hidden = NO;
}



- (void)hideCustomHandle
{
    self.customControl.hidden = YES;
}



- (void)setButton:(ZDStickerViewButton)type image:(UIImage*)image
{
    switch (type)
    {
        case ZDStickerViewButtonResize:
            self.resizingControl.image = image;
            break;
        case ZDStickerViewButtonDel:
            self.deleteControl.image = image;
            break;
        case ZDStickerViewButtonCustom:
            self.customControl.image = image;
            break;

        default:
            break;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.stickerViewDelegate respondsToSelector:@selector(stickerViewDidMoved:)]) {
        [self.stickerViewDelegate stickerViewDidMoved:self];
    }
}

- (void)enableTransluceny:(BOOL)state
{
    if (self.translucencySticker == YES)
    {
        if (state == YES)
        {
            self.alpha = 0.65;
        }
        else
        {
            self.alpha = 1.0;
        }
    }
}

- (BOOL)allowPinchToZoom {
    return self.pinchRecognizer.isEnabled;
}

- (void)setAllowPinchToZoom:(BOOL)allowPinchToZoom {
    self.pinchRecognizer.enabled = allowPinchToZoom;
}

- (BOOL)allowRotationGesture {
    return self.rotationRecognizer.isEnabled;
}

-(void)setAllowRotationGesture:(BOOL)allowRotationGesture {
    self.rotationRecognizer.enabled = allowRotationGesture;
}


- (IBAction)switchButton:(id)sender {
}
@end
