//
// ZDStickerView.h
//
// Created by Seonghyun Kim on 5/29/13.
// Copyright (c) 2013 scipi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ZDSTICKERVIEW_LONGPRESS 1

typedef NS_ENUM(NSUInteger, ZDStickerViewButton) {
    ZDStickerViewButtonNull,
    ZDStickerViewButtonDel,
    ZDStickerViewButtonResize,
    ZDStickerViewButtonCustom,
    ZDStickerViewButtonMax
};

@protocol ZDStickerViewDelegate;


@interface ZDStickerView : UIView

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic) BOOL preventsPositionOutsideSuperview;    // default = YES
@property (nonatomic) BOOL preventsResizing;                    // default = NO
@property (nonatomic) BOOL preventsDeleting;                    // default = NO
@property (nonatomic) BOOL preventsCustomButton;                // default = YES
@property (nonatomic) BOOL translucencySticker;                 // default = YES
/// Allows user to zoom the sticker by pinching on the sticker view. Defaults to true.
@property (nonatomic) BOOL allowPinchToZoom;
/// Allows the user to rotate the sticker by using 2 finger rotation on the view. Defaults to true.
@property (nonatomic) BOOL allowRotationGesture;
/// Allows the user drag the sticker view around.
@property (nonatomic) BOOL allowDragging;
/// Defines the color of the border drawn around the content view. Defaults to gray.
@property (nonatomic) UIColor *borderColor;
/// Defines the width of the border drawn around the sticker view.
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat minHeight;

@property (weak, nonatomic) id <ZDStickerViewDelegate> stickerViewDelegate;

@end


@protocol ZDStickerViewDelegate <NSObject>
@required
@optional
- (void)stickerViewDidBeginEditing:(ZDStickerView *)sticker;
- (void)stickerViewDidEndEditing:(ZDStickerView *)sticker;
- (void)stickerViewDidCancelEditing:(ZDStickerView *)sticker;
- (void)stickerViewDidClose:(ZDStickerView *)sticker;
#ifdef ZDSTICKERVIEW_LONGPRESS
- (void)stickerViewDidLongPressed:(ZDStickerView *)sticker;
#endif
- (void)stickerViewDidCustomButtonTap:(ZDStickerView *)sticker;
- (void)stickerViewDidMoved:(ZDStickerView *)sticker;
@end
