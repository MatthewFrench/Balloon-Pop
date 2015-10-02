#import <Foundation/Foundation.h>
#import "Image.h"
@class Sprite;


@interface Sprite : NSObject {
	//*****Sprite Vars***
	int spriteType;
	float transparency, spriteScale, timer, timerMax;
	CGPoint position,vel;
	Image *spriteImage;
};
- (id)initWithImage:(Image*)initImage position:(CGPoint)initPosition;
-(void) dealloc;

@property(nonatomic) float transparency,spriteScale, timer, timerMax;
@property(nonatomic) int spriteType;
@property(nonatomic) CGPoint position, vel;
@property(nonatomic, retain) Image *spriteImage;

@end
