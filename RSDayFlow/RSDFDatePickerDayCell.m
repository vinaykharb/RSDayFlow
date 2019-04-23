//
// RSDFDatePickerDayCell.m
//
// Copyright (c) 2013 Evadne Wu, http://radi.ws/
// Copyright (c) 2013-2016 Ruslan Skorb, http://ruslanskorb.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#define BackgroundColor [UIColor colorWithRed: 233/255.0f green: 63/255.0f blue: 67/255.0f alpha: 1.0]
#define YellowColor [UIColor colorWithRed: 255/255.0f green: 222/255.0f blue: 1/255.0f alpha: 1.0]
#define YellowShadowColor [UIColor colorWithRed: 247/255.0f green: 187/255.0f blue: 50/255.0f alpha: 1.0]
#define BorderWidth 3.0f

#import "RSDFDatePickerDayCell.h"

CGFloat roundOnBase(CGFloat x, CGFloat base) {
	return round(x * base) / base;
}

@interface RSDFDatePickerDayCell ()

+ (NSCache *)imageCache;
+ (id)fetchObjectForKey:(id)key withCreator:(id(^)(void))block;

@property (nonatomic, readonly, strong) UIImageView *selectedDayImageView;
@property (nonatomic, readonly, strong) UIImageView *markImageView;
@property (nonatomic, readonly, strong) UIImageView *todayImageView;
@property (nonatomic, readonly, strong) UIView *backgroundSelectedViewLeftRadius;
@property (nonatomic, readonly, strong) UIView *backgroundSelectedViewRightRadius;
@property (nonatomic, readonly, strong) UIView *backgroundSelectedViewNoRadius;
@property (nonatomic, readonly, strong) UIView *backgroundSelectedViewCircular;
@property (nonatomic, readonly, strong) UIView *backgroundSelectedViewCircularFusedLeft;
@property (nonatomic, readonly, strong) UIView *backgroundSelectedViewCircularFusedRight;
@property (nonatomic, readonly, strong) UIView *backgroundSelectedViewLeftRadiusBordered;
@property (nonatomic, readonly, strong) UIView *backgroundSelectedViewRightRadiusBordered;
@property (nonatomic, readonly, strong) UIView *backgroundSelectedViewNoRadiusBordered;
@property (nonatomic, readonly, strong) UIView *backgroundSelectedViewCircularBordered;
@property (nonatomic, readonly, strong) UIView *backgroundSelectedViewCircularGlowing;

@end

@implementation RSDFDatePickerDayCell

@synthesize dateLabel = _dateLabel;
@synthesize selectedDayImageView = _selectedDayImageView;
@synthesize markImageView = _markImageView;
@synthesize todayImageView = _todayImageView;
@synthesize backgroundSelectedViewLeftRadius = _backgroundSelectedViewLeftRadius;
@synthesize backgroundSelectedViewRightRadius = _backgroundSelectedViewRightRadius;
@synthesize backgroundSelectedViewNoRadius = _backgroundSelectedViewNoRadius;
@synthesize backgroundSelectedViewCircular = _backgroundSelectedViewCircular;
@synthesize backgroundSelectedViewCircularFusedLeft = _backgroundSelectedViewCircularFusedLeft;
@synthesize backgroundSelectedViewCircularFusedRight = _backgroundSelectedViewCircularFusedRight;
@synthesize backgroundSelectedViewLeftRadiusBordered = _backgroundSelectedViewLeftRadiusBordered;
@synthesize backgroundSelectedViewRightRadiusBordered = _backgroundSelectedViewRightRadiusBordered;
@synthesize backgroundSelectedViewNoRadiusBordered = _backgroundSelectedViewNoRadiusBordered;
@synthesize backgroundSelectedViewCircularBordered = _backgroundSelectedViewCircularBordered;
@synthesize backgroundSelectedViewCircularGlowing = _backgroundSelectedViewCircularGlowing;

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self commonInitializer];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self commonInitializer];
	}
	return self;
}

- (void)commonInitializer
{
	self.backgroundColor = [self selfBackgroundColor];

	[self addSubview:self.selectedDayImageView];
	[self addSubview:self.backgroundSelectedViewLeftRadius];
	[self addSubview:self.backgroundSelectedViewRightRadius];
	[self addSubview:self.backgroundSelectedViewNoRadius];
	[self addSubview:self.backgroundSelectedViewCircular];
	[self addSubview:self.backgroundSelectedViewCircularFusedLeft];
	[self addSubview:self.backgroundSelectedViewCircularFusedRight];
	[self addSubview:self.backgroundSelectedViewLeftRadiusBordered];
	[self addSubview:self.backgroundSelectedViewRightRadiusBordered];
	[self addSubview:self.backgroundSelectedViewNoRadiusBordered];
	[self addSubview:self.backgroundSelectedViewCircularBordered];
	[self addSubview:self.backgroundSelectedViewCircularGlowing];
	[self addSubview:self.todayImageView];
	[self addSubview:self.markImageView];
	[self addSubview:self.dateLabel];

	[self updateSubviews];
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	self.dateLabel.frame = [self selectedImageViewFrame];
	self.markImageView.frame = [self markImageViewFrame];
	self.selectedDayImageView.frame = [self selectedImageViewFrame];

	CGRect smallerHeightFrame = CGRectMake(CGRectGetMinX([self selectedImageViewFrame]), CGRectGetMinY([self selectedImageViewFrame]) + 0.0, CGRectGetWidth([self selectedImageViewFrame]), CGRectGetHeight([self selectedImageViewFrame]) - 0.0);
	self.backgroundSelectedViewLeftRadius.frame = smallerHeightFrame;
	self.backgroundSelectedViewRightRadius.frame = smallerHeightFrame;
	self.backgroundSelectedViewNoRadius.frame = smallerHeightFrame;
	CGFloat diff = CGRectGetWidth([self selectedImageViewFrame]) - CGRectGetHeight([self selectedImageViewFrame]);
	CGRect circularViewFrame = CGRectMake(CGRectGetMinX([self selectedImageViewFrame]) + diff/2, CGRectGetMinY([self selectedImageViewFrame]), CGRectGetHeight([self selectedImageViewFrame]), CGRectGetHeight([self selectedImageViewFrame]));
	self.backgroundSelectedViewCircular.frame = circularViewFrame;
	self.backgroundSelectedViewCircularFusedLeft.frame = [self selectedImageViewFrame];
	self.backgroundSelectedViewCircularFusedRight.frame = [self selectedImageViewFrame];
	self.backgroundSelectedViewLeftRadiusBordered.frame = smallerHeightFrame;
	self.backgroundSelectedViewRightRadiusBordered.frame = smallerHeightFrame;
	self.backgroundSelectedViewNoRadiusBordered.frame = smallerHeightFrame;
	self.backgroundSelectedViewCircularBordered.frame = circularViewFrame;

	CGRect glowingCircularViewFrame = CGRectMake(CGRectGetMinX([self selectedImageViewFrame]) + diff/2 + 3.0, CGRectGetMinY([self selectedImageViewFrame]) + 3.0, CGRectGetHeight([self selectedImageViewFrame]) - 6.0, CGRectGetHeight([self selectedImageViewFrame]) - 6.0);
	self.backgroundSelectedViewCircularGlowing.frame = glowingCircularViewFrame;
	self.todayImageView.frame = glowingCircularViewFrame;
}

- (void)drawRect:(CGRect)rect
{
	[self updateSubviews];
}

#pragma mark - Custom Accessors

- (UILabel *)dateLabel
{
	if (!_dateLabel) {
		_dateLabel = [[UILabel alloc] initWithFrame:[self selectedImageViewFrame]];
		_dateLabel.backgroundColor = [UIColor clearColor];
		_dateLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _dateLabel;
}

- (UIView *)backgroundSelectedViewLeftRadius
{
	if (!_backgroundSelectedViewLeftRadius) {
		CGRect frame = CGRectMake(CGRectGetMinX([self selectedImageViewFrame]), CGRectGetMinY([self selectedImageViewFrame]) + 0.0, CGRectGetWidth([self selectedImageViewFrame]), CGRectGetHeight([self selectedImageViewFrame]) - 0.0);
		_backgroundSelectedViewLeftRadius = [[UIView alloc] initWithFrame:frame];
		_backgroundSelectedViewLeftRadius.backgroundColor = BackgroundColor;
		CGFloat radius = _backgroundSelectedViewLeftRadius.frame.size.height/2;
		[self roundCornersOnView:_backgroundSelectedViewLeftRadius onTopLeft:true topRight:false bottomLeft:true bottomRight:false radius:radius];
	}
	return _backgroundSelectedViewLeftRadius;
}

- (UIView *)backgroundSelectedViewRightRadius
{
	if (!_backgroundSelectedViewRightRadius) {
		CGRect frame = CGRectMake(CGRectGetMinX([self selectedImageViewFrame]), CGRectGetMinY([self selectedImageViewFrame]) + 0.0, CGRectGetWidth([self selectedImageViewFrame]), CGRectGetHeight([self selectedImageViewFrame]) - 0.0);
		_backgroundSelectedViewRightRadius = [[UIView alloc] initWithFrame:frame];
		_backgroundSelectedViewRightRadius.backgroundColor = BackgroundColor;
		CGFloat radius = _backgroundSelectedViewRightRadius.frame.size.height/2;
		[self roundCornersOnView:_backgroundSelectedViewRightRadius onTopLeft:false topRight:true bottomLeft:false bottomRight:true radius:radius];
	}
	return _backgroundSelectedViewRightRadius;
}

- (UIView *)backgroundSelectedViewNoRadius
{
	if (!_backgroundSelectedViewNoRadius) {
		CGRect frame = CGRectMake(CGRectGetMinX([self selectedImageViewFrame]), CGRectGetMinY([self selectedImageViewFrame]) + 0.0, CGRectGetWidth([self selectedImageViewFrame]), CGRectGetHeight([self selectedImageViewFrame]) - 0.0);
		_backgroundSelectedViewNoRadius = [[UIView alloc] initWithFrame:frame];
		_backgroundSelectedViewNoRadius.backgroundColor = BackgroundColor;
	}
	return _backgroundSelectedViewNoRadius;
}

- (UIView *)backgroundSelectedViewCircular
{
	if (!_backgroundSelectedViewCircular) {
		CGFloat diff = CGRectGetWidth([self selectedImageViewFrame]) - CGRectGetHeight([self selectedImageViewFrame]);
		CGRect frame = CGRectMake(CGRectGetMinX([self selectedImageViewFrame]) + diff/2, CGRectGetMinY([self selectedImageViewFrame]), CGRectGetHeight([self selectedImageViewFrame]), CGRectGetHeight([self selectedImageViewFrame]));
		_backgroundSelectedViewCircular = [[UIView alloc] initWithFrame:frame];
		_backgroundSelectedViewCircular.backgroundColor = BackgroundColor;
		CGFloat radius = _backgroundSelectedViewCircular.frame.size.height/2;
		_backgroundSelectedViewCircular.layer.cornerRadius = radius;
	}
	return _backgroundSelectedViewCircular;
}

- (UIView *)backgroundSelectedViewCircularFusedLeft
{
	if (!_backgroundSelectedViewCircularFusedLeft) {
		_backgroundSelectedViewCircularFusedLeft = [[UIView alloc] initWithFrame:[self selectedImageViewFrame]];
		_backgroundSelectedViewCircularFusedLeft.backgroundColor = [UIColor clearColor];

		UIView* circularView = [[UIView alloc] initWithFrame:[self selectedImageViewFrame]];
		circularView.backgroundColor = BackgroundColor;
		CGFloat radius = circularView.frame.size.height/2;
		circularView.layer.cornerRadius = radius;

		CGRect fusedViewFrame = CGRectMake(CGRectGetMinX([self selectedImageViewFrame]), CGRectGetMinY([self selectedImageViewFrame]) + 0.0, CGRectGetWidth([self selectedImageViewFrame])/2, CGRectGetHeight([self selectedImageViewFrame]) - 0.0);
		UIView* fusedView = [[UIView alloc] initWithFrame:fusedViewFrame];
		fusedView.backgroundColor = BackgroundColor;

		[_backgroundSelectedViewCircularFusedLeft addSubview:fusedView];
		[_backgroundSelectedViewCircularFusedLeft addSubview:circularView];

	}
	return _backgroundSelectedViewCircularFusedLeft;
}

- (UIView *)backgroundSelectedViewCircularFusedRight
{
	if (!_backgroundSelectedViewCircularFusedRight) {
		_backgroundSelectedViewCircularFusedRight = [[UIView alloc] initWithFrame:[self selectedImageViewFrame]];
		_backgroundSelectedViewCircularFusedRight.backgroundColor = [UIColor clearColor];

		UIView* circularView = [[UIView alloc] initWithFrame:[self selectedImageViewFrame]];
		circularView.backgroundColor = BackgroundColor;
		CGFloat radius = circularView.frame.size.height/2;
		circularView.layer.cornerRadius = radius;

		CGRect fusedViewFrame = CGRectMake(CGRectGetMaxX([self selectedImageViewFrame]), CGRectGetMinY([self selectedImageViewFrame]) + 0.0, -CGRectGetWidth([self selectedImageViewFrame])/2, CGRectGetHeight([self selectedImageViewFrame]) - 0.0);
		UIView* fusedView = [[UIView alloc] initWithFrame:fusedViewFrame];
		fusedView.backgroundColor = BackgroundColor;

		[_backgroundSelectedViewCircularFusedRight addSubview:fusedView];
		[_backgroundSelectedViewCircularFusedRight addSubview:circularView];

	}
	return _backgroundSelectedViewCircularFusedRight;
}

- (UIView *)backgroundSelectedViewLeftRadiusBordered
{
	if (!_backgroundSelectedViewLeftRadiusBordered) {
		CGRect frame = CGRectMake(CGRectGetMinX([self selectedImageViewFrame]), CGRectGetMinY([self selectedImageViewFrame]) + 0.0, CGRectGetWidth([self selectedImageViewFrame]), CGRectGetHeight([self selectedImageViewFrame]) - 0.0);
		_backgroundSelectedViewLeftRadiusBordered = [[UIView alloc] initWithFrame:frame];
		_backgroundSelectedViewLeftRadiusBordered.backgroundColor = [UIColor clearColor];
		CGFloat radius = _backgroundSelectedViewLeftRadiusBordered.frame.size.height/2;
		[self bordersOnRoundCornersOnView:_backgroundSelectedViewLeftRadiusBordered onTopLeft:true topRight:false bottomLeft:true bottomRight:false radius:radius];
	}
	return _backgroundSelectedViewLeftRadiusBordered;
}

- (UIView *)backgroundSelectedViewRightRadiusBordered
{
	if (!_backgroundSelectedViewRightRadiusBordered) {
		CGRect frame = CGRectMake(CGRectGetMinX([self selectedImageViewFrame]), CGRectGetMinY([self selectedImageViewFrame]) + 0.0, CGRectGetWidth([self selectedImageViewFrame]), CGRectGetHeight([self selectedImageViewFrame]) - 0.0);
		_backgroundSelectedViewRightRadiusBordered = [[UIView alloc] initWithFrame:frame];
		_backgroundSelectedViewRightRadiusBordered.backgroundColor = [UIColor clearColor];
		CGFloat radius = _backgroundSelectedViewRightRadiusBordered.frame.size.height/2;
		[self bordersOnRoundCornersOnView:_backgroundSelectedViewRightRadiusBordered onTopLeft:false topRight:true bottomLeft:false bottomRight:true radius:radius];
	}
	return _backgroundSelectedViewRightRadiusBordered;
}

- (UIView *)backgroundSelectedViewNoRadiusBordered
{
	if (!_backgroundSelectedViewNoRadiusBordered) {
		CGRect frame = CGRectMake(CGRectGetMinX([self selectedImageViewFrame]), CGRectGetMinY([self selectedImageViewFrame]) + 0.0, CGRectGetWidth([self selectedImageViewFrame]), CGRectGetHeight([self selectedImageViewFrame]) - 0.0);
		_backgroundSelectedViewNoRadiusBordered = [[UIView alloc] initWithFrame:frame];
		_backgroundSelectedViewNoRadiusBordered.backgroundColor = [UIColor clearColor];
		[self addTopBorderOnView:_backgroundSelectedViewNoRadiusBordered];
		[self addBottomBorderOnView:_backgroundSelectedViewNoRadiusBordered];
	}
	return _backgroundSelectedViewNoRadiusBordered;
}

- (UIView *)backgroundSelectedViewCircularBordered
{
	if (!_backgroundSelectedViewCircularBordered) {
		CGFloat diff = CGRectGetWidth([self selectedImageViewFrame]) - CGRectGetHeight([self selectedImageViewFrame]);
		CGRect frame = CGRectMake(CGRectGetMinX([self selectedImageViewFrame]) + diff/2, CGRectGetMinY([self selectedImageViewFrame]), CGRectGetHeight([self selectedImageViewFrame]), CGRectGetHeight([self selectedImageViewFrame]));
		_backgroundSelectedViewCircularBordered = [[UIView alloc] initWithFrame:frame];
		_backgroundSelectedViewCircularBordered.backgroundColor = [UIColor clearColor];
		CGFloat radius = _backgroundSelectedViewCircularBordered.frame.size.height/2;
		_backgroundSelectedViewCircularBordered.layer.cornerRadius = radius;
		_backgroundSelectedViewCircularBordered.layer.borderColor = BackgroundColor.CGColor;
		_backgroundSelectedViewCircularBordered.layer.borderWidth = BorderWidth/2;
	}
	return _backgroundSelectedViewCircularBordered;
}

- (UIView *)backgroundSelectedViewCircularGlowing
{
	if (!_backgroundSelectedViewCircularGlowing) {
		CGFloat diff = CGRectGetWidth([self selectedImageViewFrame]) - CGRectGetHeight([self selectedImageViewFrame]);
		CGRect frame = CGRectMake(CGRectGetMinX([self selectedImageViewFrame]) + diff/2 + 3.0, CGRectGetMinY([self selectedImageViewFrame]) + 3.0, CGRectGetHeight([self selectedImageViewFrame]) - 6.0, CGRectGetHeight([self selectedImageViewFrame]) - 6.0);
		_backgroundSelectedViewCircularGlowing = [[UIView alloc] initWithFrame: frame];
		_backgroundSelectedViewCircularGlowing.backgroundColor = YellowColor;
		_backgroundSelectedViewCircularGlowing.layer.shadowColor = [YellowColor CGColor];
		_backgroundSelectedViewCircularGlowing.layer.shadowRadius = 6.0;
		_backgroundSelectedViewCircularGlowing.layer.shadowOffset = CGSizeMake(0, 0);
		_backgroundSelectedViewCircularGlowing.layer.shadowOpacity = 1.0;
		_backgroundSelectedViewCircularGlowing.layer.masksToBounds = NO;
		CGFloat radius = _backgroundSelectedViewCircularGlowing.frame.size.height/2;
		_backgroundSelectedViewCircularGlowing.layer.cornerRadius = radius;
	}
	return _backgroundSelectedViewCircularGlowing;
}

- (void)roundCornersOnView:(UIView *)view onTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius {

	if (tl || tr || bl || br) {
		UIRectCorner corner = 0;
		if (tl) {corner = corner | UIRectCornerTopLeft;}
		if (tr) {corner = corner | UIRectCornerTopRight;}
		if (bl) {corner = corner | UIRectCornerBottomLeft;}
		if (br) {corner = corner | UIRectCornerBottomRight;}

		UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
		CAShapeLayer *maskLayer = [CAShapeLayer layer];
		maskLayer.frame = view.bounds;
		maskLayer.path = maskPath.CGPath;
		view.layer.mask = maskLayer;
	}
}

- (void)bordersOnRoundCornersOnView:(UIView *)view onTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius {

	if (tl || tr || bl || br) {
		UIRectCorner corner = 0;
		if (tl) {corner = corner | UIRectCornerTopLeft;}
		if (tr) {corner = corner | UIRectCornerTopRight;}
		if (bl) {corner = corner | UIRectCornerBottomLeft;}
		if (br) {corner = corner | UIRectCornerBottomRight;}

		UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
		CAShapeLayer *maskLayer = [CAShapeLayer layer];
		maskLayer.frame = view.bounds;
		maskLayer.path = maskPath.CGPath;
		view.layer.mask = maskLayer;

		CGRect bounds;
		if (tl) {
			bounds = CGRectMake(view.bounds.origin.x, view.bounds.origin.y, view.bounds.origin.x + 100.0f, view.bounds.size.height);
		} else {
			bounds = CGRectMake(- 100.0f + view.bounds.origin.x, view.bounds.origin.y, view.bounds.size.width + 100.0f, view.bounds.size.height);
		}

		CAShapeLayer *borderLayer = [CAShapeLayer layer];
		UIBezierPath *borderMaskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
		borderLayer.path = borderMaskPath.CGPath;
		borderLayer.strokeColor = BackgroundColor.CGColor;
		borderLayer.fillColor = [UIColor clearColor].CGColor;
		borderLayer.lineWidth = BorderWidth;
		[view.layer addSublayer: borderLayer];
	}
}

- (void)addTopBorderOnView:(UIView*) view
{
	UIView *border = [UIView new];
	border.backgroundColor = BackgroundColor;
	[border setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
	border.frame = CGRectMake(0, 0, view.frame.size.width, BorderWidth/2);
	[view addSubview:border];
}

- (void)addBottomBorderOnView:(UIView*) view
{
	UIView *border = [UIView new];
	border.backgroundColor = BackgroundColor;
	[border setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
	border.frame = CGRectMake(0, view.frame.size.height - BorderWidth/2, view.frame.size.width, BorderWidth/2);
	[view addSubview:border];
}

- (void)addLeftBorderOnView:(UIView*) view
{
	UIView *border = [UIView new];
	border.backgroundColor = BackgroundColor;
	border.frame = CGRectMake(0, 0, BorderWidth, view.frame.size.height);
	[border setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
	[view addSubview:border];
}

- (void)addRightBorderOnView:(UIView*) view
{
	UIView *border = [UIView new];
	border.backgroundColor = BackgroundColor;
	[border setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
	border.frame = CGRectMake(view.frame.size.width - BorderWidth, 0, BorderWidth, view.frame.size.height);
	[view addSubview:border];
}

- (CGRect)markImageViewFrame
{
	return CGRectMake(roundOnBase(CGRectGetWidth(self.frame) / 2 - 3.0f, [UIScreen mainScreen].scale), roundOnBase(25, [UIScreen mainScreen].scale), 6.0f, 6.0f);
}

- (UIImageView *)markImageView
{
	if (!_markImageView) {
		_markImageView = [[UIImageView alloc] initWithFrame:[self markImageViewFrame]];
		_markImageView.backgroundColor = [UIColor clearColor];
		_markImageView.contentMode = UIViewContentModeScaleAspectFit;
		_markImageView.image = self.markImage;
	}
	return _markImageView;
}

- (UIImageView *)selectedDayImageView
{
	if (!_selectedDayImageView) {
		_selectedDayImageView = [[UIImageView alloc] initWithFrame:[self selectedImageViewFrame]];
		_selectedDayImageView.backgroundColor = [UIColor clearColor];
		_selectedDayImageView.contentMode = UIViewContentModeScaleAspectFit;
		_selectedDayImageView.image = [self selectedDayImage];
		_selectedDayImageView.clipsToBounds = YES;
	}
	return _selectedDayImageView;
}

- (UIImageView *)todayImageView
{
	if (!_todayImageView) {
		CGRect frame = CGRectMake(CGRectGetMinX([self selectedImageViewFrame]) + 3.0, CGRectGetMinY([self selectedImageViewFrame]) + 3.0, CGRectGetHeight([self selectedImageViewFrame]) - 6.0, CGRectGetHeight([self selectedImageViewFrame]) - 6.0);
		_todayImageView = [[UIImageView alloc] initWithFrame: frame];
		_todayImageView.backgroundColor = [UIColor clearColor];
		_todayImageView.contentMode = UIViewContentModeScaleAspectFit;
		_todayImageView.image = [self customTodayImage];
	}
	return _todayImageView;
}

- (void)setMarkImage:(UIImage *)markImage
{
	if (![_markImage isEqual:markImage]) {
		_markImage = markImage;

		[self setNeedsDisplay];
	}
}

#pragma mark - Private

- (void)updateSubviews
{
	self.selectedDayImageView.hidden = !self.isTemporarilySelected || self.isNotThisMonth || self.isOutOfRange;
	self.markImageView.hidden = !self.isMarked || self.isNotThisMonth || self.isOutOfRange;
	self.todayImageView.hidden = !self.isToday;

	if (self.isSelectedInFuture) {
		self.selected = true;
	}

	BOOL hideBackgroundSelectedView = !self.isSelected || self.isNotThisMonth || self.isOutOfRange || !self.isBackgroundSelectionViewVisible;

	self.backgroundSelectedViewLeftRadius.hidden = self.selectionStyle != RSDFDaySelectionStyleLeftRadius || hideBackgroundSelectedView;
	self.backgroundSelectedViewRightRadius.hidden = self.selectionStyle != RSDFDaySelectionStyleRightRadius || hideBackgroundSelectedView;
	self.backgroundSelectedViewNoRadius.hidden = self.selectionStyle != RSDFDaySelectionStyleNoRadius || hideBackgroundSelectedView;
	self.backgroundSelectedViewCircular.hidden = self.selectionStyle != RSDFDaySelectionStyleCircular || hideBackgroundSelectedView;
	self.backgroundSelectedViewCircularFusedLeft.hidden = self.selectionStyle != RSDFDaySelectionStyleCircularFusedLeft || hideBackgroundSelectedView;
	self.backgroundSelectedViewCircularFusedRight.hidden = self.selectionStyle != RSDFDaySelectionStyleCircularFusedRight || hideBackgroundSelectedView;
	if (self.selectionStyle == RSDFDaySelectionStyleCircularFused && !hideBackgroundSelectedView) {
		self.backgroundSelectedViewCircularFusedLeft.hidden = false;
		self.backgroundSelectedViewCircularFusedRight.hidden = false;
	}
	self.backgroundSelectedViewLeftRadiusBordered.hidden = self.selectionStyle != RSDFDaySelectionStyleLeftRadius || hideBackgroundSelectedView;
	self.backgroundSelectedViewRightRadiusBordered.hidden = self.selectionStyle != RSDFDaySelectionStyleRightRadius || hideBackgroundSelectedView;
	self.backgroundSelectedViewNoRadiusBordered.hidden = self.selectionStyle != RSDFDaySelectionStyleNoRadius || hideBackgroundSelectedView;
	self.backgroundSelectedViewCircularBordered.hidden = self.selectionStyle != RSDFDaySelectionStyleCircular || hideBackgroundSelectedView;

	CGFloat alphaForBorderedViews = !self.isSelectedInFuture ? 0.0 : 0.53;
	CGFloat alphaForFilledViews = !self.isSelectedInFuture ? 1.0 : 0.0;
	self.backgroundSelectedViewLeftRadius.alpha = alphaForFilledViews;
	self.backgroundSelectedViewRightRadius.alpha = alphaForFilledViews;
	self.backgroundSelectedViewNoRadius.alpha = alphaForFilledViews;
	self.backgroundSelectedViewCircular.alpha = alphaForFilledViews;
	self.backgroundSelectedViewCircularFusedLeft.alpha = alphaForFilledViews;
	self.backgroundSelectedViewCircularFusedRight.alpha = alphaForFilledViews;
	self.backgroundSelectedViewLeftRadiusBordered.alpha = alphaForBorderedViews;
	self.backgroundSelectedViewRightRadiusBordered.alpha = alphaForBorderedViews;
	self.backgroundSelectedViewNoRadiusBordered.alpha = alphaForBorderedViews;
	self.backgroundSelectedViewCircularBordered.alpha = alphaForBorderedViews;

	self.backgroundSelectedViewCircularGlowing.hidden = !self.isGlowing;

	switch (self.dayState) {
			case RSDFDayStateNotThisMonthDay:
			self.dateLabel.textColor = [self notThisMonthLabelTextColor];
			self.dateLabel.font = [self dayLabelFont];
			break;
			case RSDFDayStateWeekDayLabel:
			self.dateLabel.textColor = [self weekDayLabelTextColor];
			self.dateLabel.font = [self weekDayLabelTextFont];
			break;
			case RSDFDayStateOutOfRange:
			self.dateLabel.textColor = [self outOfRangeDayLabelTextColor];
			self.dateLabel.font = [self outOfRangeDayLabelFont];
			break;
			case RSDFDayStateMonthDay:
			if (!self.isSelected) {
				if (!self.isToday) {
					self.dateLabel.font = [self dayLabelFont];
					if (!self.dayOff) {
						if (self.isPastDate) {
							self.dateLabel.textColor = [self pastDayLabelTextColor];
						} else {
							self.dateLabel.textColor = [self dayLabelTextColor];
						}
					} else {
						if (self.isPastDate) {
							self.dateLabel.textColor = [self pastDayOffLabelTextColor];
						} else {
							self.dateLabel.textColor = [self dayOffLabelTextColor];
						}
					}
				} else {
					self.dateLabel.font = [self todayLabelFont];
					self.dateLabel.textColor = [self todayLabelTextColor];
				}
			} else {
				if (!self.isToday) {
					self.dateLabel.font = [self selectedDayLabelFont];
					self.dateLabel.textColor = [self selectedDayLabelTextColor];
				} else {
					self.dateLabel.font = [self selectedTodayLabelFont];
					self.dateLabel.textColor = [self selectedTodayLabelTextColor];
				}
			}

			if (self.marked) {
				self.markImageView.image = self.markImage;
			} else {
				self.markImageView.image = nil;
			}
			break;
		default:
			break;
	}
	if (self.isGlowing || self.isToday) {
		self.dateLabel.textColor = [UIColor blackColor];
	}
	self.selectedDayImageView.image = [self customSelectedDayImage];
	self.todayImageView.image = self.isToday ? [self customTodayImage] : nil;
}

+ (NSCache *)imageCache
{
	static NSCache *cache;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		cache = [NSCache new];
	});
	return cache;
}

+ (id)fetchObjectForKey:(id)key withCreator:(id(^)(void))block
{
	id answer = [[self imageCache] objectForKey:key];
	if (!answer) {
		answer = block();
		[[self imageCache] setObject:answer forKey:key];
	}
	return answer;
}

- (UIImage *)ellipseImageWithKey:(NSString *)key frame:(CGRect)frame color:(UIColor *)color
{
	UIImage *ellipseImage = [[self class] fetchObjectForKey:key withCreator:^id{
		UIGraphicsBeginImageContextWithOptions(frame.size, NO, self.window.screen.scale);
		CGContextRef context = UIGraphicsGetCurrentContext();

		CGRect rect = frame;
		rect.origin = CGPointZero;

		CGContextSetFillColorWithColor(context, color.CGColor);
		CGContextFillEllipseInRect(context, rect);

		UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();

		return image;
	}];
	return ellipseImage;
}

- (UIImage *)rectImageWithKey:(NSString *)key frame:(CGRect)frame color:(UIColor *)color
{
	UIImage *rectImage = [[self class] fetchObjectForKey:key withCreator:^id{
		UIGraphicsBeginImageContextWithOptions(frame.size, NO, self.window.screen.scale);
		CGContextRef context = UIGraphicsGetCurrentContext();

		CGContextSetFillColorWithColor(context, color.CGColor);
		CGContextFillRect(context, frame);

		UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();

		return image;
	}];
	return rectImage;
}

#pragma mark - Atrributes of the View

- (UIColor *)selfBackgroundColor
{
	return [UIColor clearColor];
}

#pragma mark - Attributes of Subviews

- (UIFont *)dayLabelFont
{
	return [UIFont fontWithName:@"HelveticaNeue" size:18.0f];
}

- (UIColor *)dayLabelTextColor
{
	return [UIColor blackColor];
}

- (UIColor *)dayOffLabelTextColor
{
	return [UIColor colorWithRed:184/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f];
}

- (UIColor *)outOfRangeDayLabelTextColor
{
	return [UIColor colorWithRed:184/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f];
}

- (UIFont *)outOfRangeDayLabelFont
{
	return [UIFont fontWithName:@"HelveticaNeue" size:18.0f];
}

- (UIColor *)weekDayLabelTextColor
{
	return [UIColor colorWithRed:184/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f];
}

- (UIFont *)weekDayLabelTextFont
{
	return [UIFont fontWithName:@"HelveticaNeue" size:18.0f];
}

- (UIColor *)notThisMonthLabelTextColor
{
	return [UIColor clearColor];
}

- (UIColor *)pastDayLabelTextColor
{
	return [self dayLabelTextColor];
}

- (UIColor *)pastDayOffLabelTextColor
{
	return [self dayOffLabelTextColor];
}

- (UIFont *)todayLabelFont
{
	return [UIFont fontWithName:@"HelveticaNeue" size:18.0f];
}

- (UIColor *)todayLabelTextColor
{
	return [UIColor colorWithRed:0/255.0f green:121/255.0f blue:255/255.0f alpha:1.0f];
}

- (UIFont *)selectedTodayLabelFont
{
	return [UIFont fontWithName:@"HelveticaNeue-Bold" size:19.0f];
}

- (UIColor *)selectedTodayLabelTextColor
{
	return [UIColor whiteColor];
}

- (UIColor *)selectedTodayImageColor
{
	return [UIColor colorWithRed:0/255.0f green:121/255.0f blue:255/255.0f alpha:1.0f];
}

- (UIImage *)customSelectedTodayImage
{
	return nil;
}

- (UIFont *)selectedDayLabelFont
{
	return [UIFont fontWithName:@"HelveticaNeue-Bold" size:19.0f];
}

- (UIImage *)customSelectedDayImage
{
	return nil;
}

- (UIImage *)selectedDayImage
{
	UIImage *selectedDayImage = [self customSelectedDayImage];
	if (!selectedDayImage) {
		UIColor *selectedDayImageColor = [self selectedDayImageColor];
		NSString *selectedDayImageKey = [NSString stringWithFormat:@"img_selected_day_%@", [selectedDayImageColor description]];
		selectedDayImage = [self ellipseImageWithKey:selectedDayImageKey frame:self.selectedDayImageView.frame color:selectedDayImageColor];
	}
	return selectedDayImage;
}

- (UIColor *)selectedDayLabelTextColor
{
	return [UIColor whiteColor];
}

- (UIColor *)selectedDayImageColor
{
	return [UIColor colorWithRed:255/255.0f green:59/255.0f blue:48/255.0f alpha:1.0f];
}

- (UIImage *)customTodayImage
{
	return nil;
}

@end
