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

#import "RSDFDatePickerDayCell.h"

CGFloat roundOnBase(CGFloat x, CGFloat base) {
    return round(x * base) / base;
}

@interface RSDFDatePickerDayCell ()

+ (NSCache *)imageCache;
+ (id)fetchObjectForKey:(id)key withCreator:(id(^)(void))block;

@property (nonatomic, readonly, strong) UIImageView *selectedDayImageView;
@property (nonatomic, readonly, strong) UIImageView *overlayImageView;
@property (nonatomic, readonly, strong) UIImageView *markImageView;
@property (nonatomic, readonly, strong) UIImageView *dividerImageView;
@property (nonatomic, readonly, strong) UIImageView *todayImageView;
@property (nonatomic, readonly, strong) UIView *backgroundSelectedViewLeftRadius;
@property (nonatomic, readonly, strong) UIView *backgroundSelectedViewRightRadius;
@property (nonatomic, readonly, strong) UIView *backgroundSelectedViewNoRadius;
@property (nonatomic, readonly, strong) UIView *backgroundSelectedViewCircular;
@property (nonatomic, readonly, strong) UIView *backgroundSelectedViewCircularFusedLeft;
@property (nonatomic, readonly, strong) UIView *backgroundSelectedViewCircularFusedRight;

@end

@implementation RSDFDatePickerDayCell

@synthesize dateLabel = _dateLabel;
@synthesize selectedDayImageView = _selectedDayImageView;
@synthesize overlayImageView = _overlayImageView;
@synthesize markImage = _markImage;
@synthesize markImageColor = _markImageColor;
@synthesize markImageView = _markImageView;
@synthesize dividerImageView = _dividerImageView;
@synthesize todayImageView = _todayImageView;
@synthesize backgroundSelectedViewLeftRadius = _backgroundSelectedViewLeftRadius;
@synthesize backgroundSelectedViewRightRadius = _backgroundSelectedViewRightRadius;
@synthesize backgroundSelectedViewNoRadius = _backgroundSelectedViewNoRadius;
@synthesize backgroundSelectedViewCircular = _backgroundSelectedViewCircular;
@synthesize backgroundSelectedViewCircularFusedLeft = _backgroundSelectedViewCircularFusedLeft;
@synthesize backgroundSelectedViewCircularFusedRight = _backgroundSelectedViewCircularFusedRight;

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
    [self addSubview:self.overlayImageView];
    [self addSubview:self.markImageView];
    [self addSubview:self.dividerImageView];
	[self addSubview:self.todayImageView];
	[self addSubview:self.backgroundSelectedViewLeftRadius];
	[self addSubview:self.backgroundSelectedViewRightRadius];
	[self addSubview:self.backgroundSelectedViewNoRadius];
	[self addSubview:self.backgroundSelectedViewCircular];
	[self addSubview:self.backgroundSelectedViewCircularFusedLeft];
	[self addSubview:self.backgroundSelectedViewCircularFusedRight];
    [self addSubview:self.dateLabel];

    [self updateSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.dateLabel.frame = [self selectedImageViewFrame];
    self.selectedDayImageView.frame = [self selectedImageViewFrame];
    self.overlayImageView.frame = [self selectedImageViewFrame];
	self.todayImageView.frame = [self selectedImageViewFrame];
    self.markImageView.frame = [self markImageViewFrame];
    self.dividerImageView.frame = [self dividerImageViewFrame];
    self.dividerImageView.image = [self dividerImage];

	CGRect smallerHeightFrame = CGRectMake(CGRectGetMinX([self selectedImageViewFrame]), CGRectGetMinY([self selectedImageViewFrame]) + 5.0, CGRectGetWidth([self selectedImageViewFrame]), CGRectGetHeight([self selectedImageViewFrame]) - 10.0);
	self.backgroundSelectedViewLeftRadius.frame = smallerHeightFrame;
	self.backgroundSelectedViewRightRadius.frame = smallerHeightFrame;
	self.backgroundSelectedViewNoRadius.frame = smallerHeightFrame;
	self.backgroundSelectedViewCircular.frame = [self selectedImageViewFrame];
	self.backgroundSelectedViewCircularFusedLeft.frame = [self selectedImageViewFrame];
	self.backgroundSelectedViewCircularFusedRight.frame = [self selectedImageViewFrame];
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
		CGRect frame = CGRectMake(CGRectGetMinX([self selectedImageViewFrame]), CGRectGetMinY([self selectedImageViewFrame]) + 5.0, CGRectGetWidth([self selectedImageViewFrame]), CGRectGetHeight([self selectedImageViewFrame]) - 10.0);
		_backgroundSelectedViewLeftRadius = [[UIView alloc] initWithFrame:frame];
		_backgroundSelectedViewLeftRadius.backgroundColor = [UIColor colorWithRed:212/255.0f green:53/255.0f blue:75/255.0f alpha:1.0];
		CGFloat radius = _backgroundSelectedViewLeftRadius.frame.size.height/2;
		[self roundCornersOnView:_backgroundSelectedViewLeftRadius onTopLeft:true topRight:false bottomLeft:true bottomRight:false radius:radius];
	}
	return _backgroundSelectedViewLeftRadius;
}

- (UIView *)backgroundSelectedViewRightRadius
{
	if (!_backgroundSelectedViewRightRadius) {
		CGRect frame = CGRectMake(CGRectGetMinX([self selectedImageViewFrame]), CGRectGetMinY([self selectedImageViewFrame]) + 5.0, CGRectGetWidth([self selectedImageViewFrame]), CGRectGetHeight([self selectedImageViewFrame]) - 10.0);
		_backgroundSelectedViewRightRadius = [[UIView alloc] initWithFrame:frame];
		_backgroundSelectedViewRightRadius.backgroundColor = [UIColor colorWithRed:212/255.0f green:53/255.0f blue:75/255.0f alpha:1.0];
		CGFloat radius = _backgroundSelectedViewRightRadius.frame.size.height/2;
		[self roundCornersOnView:_backgroundSelectedViewRightRadius onTopLeft:false topRight:true bottomLeft:false bottomRight:true radius:radius];
	}
	return _backgroundSelectedViewRightRadius;
}

- (UIView *)backgroundSelectedViewNoRadius
{
	if (!_backgroundSelectedViewNoRadius) {
		CGRect frame = CGRectMake(CGRectGetMinX([self selectedImageViewFrame]), CGRectGetMinY([self selectedImageViewFrame]) + 5.0, CGRectGetWidth([self selectedImageViewFrame]), CGRectGetHeight([self selectedImageViewFrame]) - 10.0);
		_backgroundSelectedViewNoRadius = [[UIView alloc] initWithFrame:frame];
		_backgroundSelectedViewNoRadius.backgroundColor = [UIColor colorWithRed:212/255.0f green:53/255.0f blue:75/255.0f alpha:1.0];
	}
	return _backgroundSelectedViewNoRadius;
}

- (UIView *)backgroundSelectedViewCircular
{
	if (!_backgroundSelectedViewCircular) {
		_backgroundSelectedViewCircular = [[UIView alloc] initWithFrame:[self selectedImageViewFrame]];
		_backgroundSelectedViewCircular.backgroundColor = [UIColor colorWithRed:212/255.0f green:53/255.0f blue:75/255.0f alpha:1.0];
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
		circularView.backgroundColor = [UIColor colorWithRed:212/255.0f green:53/255.0f blue:75/255.0f alpha:1.0];
		CGFloat radius = circularView.frame.size.height/2;
		circularView.layer.cornerRadius = radius;

		CGRect fusedViewFrame = CGRectMake(CGRectGetMinX([self selectedImageViewFrame]), CGRectGetMinY([self selectedImageViewFrame]) + 5.0, CGRectGetWidth([self selectedImageViewFrame])/2, CGRectGetHeight([self selectedImageViewFrame]) - 10.0);
		UIView* fusedView = [[UIView alloc] initWithFrame:fusedViewFrame];
		fusedView.backgroundColor = [UIColor colorWithRed:212/255.0f green:53/255.0f blue:75/255.0f alpha:1.0];

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
		circularView.backgroundColor = [UIColor colorWithRed:212/255.0f green:53/255.0f blue:75/255.0f alpha:1.0];
		CGFloat radius = circularView.frame.size.height/2;
		circularView.layer.cornerRadius = radius;

		CGRect fusedViewFrame = CGRectMake(CGRectGetMaxX([self selectedImageViewFrame]), CGRectGetMinY([self selectedImageViewFrame]) + 5.0, -CGRectGetWidth([self selectedImageViewFrame])/2, CGRectGetHeight([self selectedImageViewFrame]) - 10.0);
		UIView* fusedView = [[UIView alloc] initWithFrame:fusedViewFrame];
		fusedView.backgroundColor = [UIColor colorWithRed:212/255.0f green:53/255.0f blue:75/255.0f alpha:1.0];

		[_backgroundSelectedViewCircularFusedRight addSubview:fusedView];
		[_backgroundSelectedViewCircularFusedRight addSubview:circularView];

	}
	return _backgroundSelectedViewCircularFusedRight;
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

- (UIImageView *)dividerImageView
{
    if (!_dividerImageView) {
        _dividerImageView = [[UIImageView alloc] initWithFrame:[self dividerImageViewFrame]];
        _dividerImageView.contentMode = UIViewContentModeCenter;
        _dividerImageView.image = [self dividerImage];
    }
    return _dividerImageView;
}

- (CGRect)dividerImageViewFrame
{
    return CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame) + 3.0f, roundOnBase(0.5f, [UIScreen mainScreen].scale));
}

- (CGRect)markImageViewFrame
{
    return CGRectMake(roundOnBase(CGRectGetWidth(self.frame) / 2 - 4.5f, [UIScreen mainScreen].scale), roundOnBase(45.5f, [UIScreen mainScreen].scale), 9.0f, 9.0f);
}

- (UIImage *)markImage
{
    if (!_markImage) {
        NSString *markImageKey = [NSString stringWithFormat:@"img_mark_%@", [self.markImageColor description]];
        _markImage = [self ellipseImageWithKey:markImageKey frame:self.markImageView.frame color:self.markImageColor];
    }
    return _markImage;
}

- (UIColor *)markImageColor
{
    if (!_markImageColor) {
        _markImageColor = [UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    }
    return _markImageColor;
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

- (UIImageView *)overlayImageView
{
    if (!_overlayImageView) {
        _overlayImageView = [[UIImageView alloc] initWithFrame:[self selectedImageViewFrame]];
        _overlayImageView.backgroundColor = [UIColor clearColor];
        _overlayImageView.opaque = NO;
        _overlayImageView.alpha = 0.5f;
        _overlayImageView.contentMode = UIViewContentModeScaleAspectFit;
        _overlayImageView.image = [self overlayImage];
    }
    return _overlayImageView;
}

- (UIImageView *)selectedDayImageView
{
    if (!_selectedDayImageView) {
        _selectedDayImageView = [[UIImageView alloc] initWithFrame:[self selectedImageViewFrame]];
        _selectedDayImageView.backgroundColor = [UIColor clearColor];
        _selectedDayImageView.contentMode = UIViewContentModeScaleAspectFill;
        _selectedDayImageView.image = [self selectedDayImage];
		_selectedDayImageView.clipsToBounds = YES;
    }
    return _selectedDayImageView;
}

- (CGRect)selectedImageViewFrame
{
    return CGRectMake(roundOnBase(CGRectGetWidth(self.frame) / 2 - 17.5f, [UIScreen mainScreen].scale), roundOnBase(5.5, [UIScreen mainScreen].scale), 35.0f, 35.0f);
}

- (UIImageView *)todayImageView
{
	if (!_todayImageView) {
		_todayImageView = [[UIImageView alloc] initWithFrame:[self selectedImageViewFrame]];
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

- (void)setMarkImageColor:(UIColor *)markImageColor
{
    if (![_markImageColor isEqual:markImageColor]) {
        _markImageColor = markImageColor;
        _markImage = nil;
        
        [self setNeedsDisplay];
    }
}

#pragma mark - Private

- (void)updateSubviews
{
    self.selectedDayImageView.hidden = !self.isSelected || self.isNotThisMonth || self.isOutOfRange || self.isBackgroundSelectionViewVisible;
    self.overlayImageView.hidden = !self.isHighlighted || self.isNotThisMonth || self.isOutOfRange;
    self.markImageView.hidden = !self.isMarked || self.isNotThisMonth || self.isOutOfRange;
    self.dividerImageView.hidden = self.isNotThisMonth;
	self.todayImageView.hidden = !self.isToday;

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
	self.todayImageView.image = [self customTodayImage];

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
					self.selectedDayImageView.image = [self selectedDayImage];
				} else {
					self.dateLabel.font = [self selectedTodayLabelFont];
					self.dateLabel.textColor = [self selectedTodayLabelTextColor];
					self.selectedDayImageView.image = [self selectedTodayImage];
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

- (UIImage *)selectedTodayImage
{
    UIImage *selectedTodayImage = [self customSelectedTodayImage];
    if (!selectedTodayImage) {
        UIColor *selectedTodayImageColor = [self selectedTodayImageColor];
        NSString *selectedTodayImageKey = [NSString stringWithFormat:@"img_selected_today_%@", [selectedTodayImageColor description]];
        selectedTodayImage = [self ellipseImageWithKey:selectedTodayImageKey frame:self.selectedDayImageView.frame color:selectedTodayImageColor];
    }
    return selectedTodayImage;
}

- (UIFont *)selectedDayLabelFont
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:19.0f];
}

- (UIColor *)selectedDayLabelTextColor
{
    return [UIColor whiteColor];
}

- (UIColor *)selectedDayImageColor
{
    return [UIColor colorWithRed:255/255.0f green:59/255.0f blue:48/255.0f alpha:1.0f];
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

- (UIColor *)overlayImageColor
{
    return [UIColor colorWithRed:184/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f];
}

- (UIImage *)customOverlayImage
{
    return nil;
}

- (UIImage *)overlayImage
{
    UIImage *overlayImage = [self customOverlayImage];
    if (!overlayImage) {
        UIColor *overlayImageColor = [self overlayImageColor];
        NSString *overlayImageKey = [NSString stringWithFormat:@"img_overlay_%@", [overlayImageColor description]];
        overlayImage = [self ellipseImageWithKey:overlayImageKey frame:self.overlayImageView.frame color:overlayImageColor];
    }
    return overlayImage;
}

- (UIColor *)dividerImageColor
{
    return [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0f];
}

- (UIImage *)customDividerImage
{
    return nil;
}

- (UIImage *)dividerImage
{
    UIImage *dividerImage = [self customDividerImage];
    if (!dividerImage) {
        UIColor *dividerImageColor = [self dividerImageColor];
        NSString *dividerImageKey = [NSString stringWithFormat:@"img_divider_%@_%g", [dividerImageColor description], CGRectGetWidth(self.dividerImageView.frame)];
        dividerImage = [self rectImageWithKey:dividerImageKey frame:self.dividerImageView.frame color:dividerImageColor];
    }
    return dividerImage;
}

- (UIImage *)customTodayImage
{
	return nil;
}

@end
