#import "Sprite.h"

@implementation Sprite
@synthesize spriteImage, position, vel, spriteScale, transparency, spriteType, timer, timerMax;
- (id)init 
{
	//if (self = [super init])
	spriteImage = nil;
	position = CGPointMake(0,0);
	transparency = 1.0;
	spriteScale = 1.0;
	spriteType = 0;
	timer = 0.0;
	timerMax = 0.0;
	return self;
}
- (id)initWithImage:(Image*)initImage position:(CGPoint)initPosition
{
	//if (self = [super init])
	spriteImage = initImage;
	position = initPosition;
	transparency = 1.0;
	spriteScale = 1.0;
	spriteType = 0;
	timer = 0.0;
	timerMax = 0.0;
	return self;
}
//encode the data
- (void) encodeWithCoder: (NSCoder *)coder
{   

} 
//init from coder
- (id) initWithCoder: (NSCoder *) coder
{
    [self init];
    return self;
}
-(void)dealloc {
	[super dealloc];
}
@end
