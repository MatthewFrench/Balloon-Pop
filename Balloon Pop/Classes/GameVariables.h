
//
//  gameVariables.h
//  Balloon Pop
//
//  Created by Matthew French on 7/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"
#import "Texture2D.h"

@interface GameVariables : NSObject {
	int chosenGameNum;
	
	CFTimeInterval fpsCounter;
	
	NSMutableArray* balloons;
	CGPoint playerPosition, joystickPosition, joystickDefault;
	float joystickRotation;
	int touchControllingJoyStick;
	int touchControllingShooting;
	int playerSpeed;
	
	NSMutableArray* fire;
	int balloonPopCount;
	float balloonPopCountUp;

	BOOL currentBonus[7];
	BOOL displayBonus[7];
	CGPoint bonusPosition[7];
	int bonusMax;
	int bonusCount[7];
	
	float timerMax;
	float timerCount;
	
	float color2[4];
}
@property(nonatomic,assign) int balloonPopCount;
- (id)initWithGame:(int)gameNum;
- (void)runLogic;
- (void)speedShooter;
- (void)drawSpeedShooter;
- (void)shoot:(CGPoint)touchPosition;
- (void)controlJoystick:(CGPoint)touchPosition touch:(int)touch;
- (void)drawGame;
- (void)dealloc;
@end
