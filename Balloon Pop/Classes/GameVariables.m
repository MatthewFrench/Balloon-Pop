//
//  gameVariables.m
//  Balloon Pop
//
//  Created by Matthew French on 7/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameVariables.h"
#import "AppDelegate.h"
#import "GameView.h"
#define BonusNone 0
#define BonusBouncyBullets 1
#define BonusMachineGun 2
#define BonusMatrixMode 3
#define BonusMultiDir 4
#define BonusNuke 5
#define BonusPenetrationBullets 6

#define NumberOfBonuses 6

@implementation GameVariables
@synthesize balloonPopCount;

- (id)initWithGame:(int)gameNum{
    self = [super init];
    if (self) {
		//Initialize self
		chosenGameNum = gameNum;
		AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
		switch (chosenGameNum) {
			case 0: //Speed Shooter
			{
				//[tex release];
				timerMax = 60*30;
				timerCount = 0;
				balloons = [NSMutableArray new];
				fire = [NSMutableArray new];
				playerPosition = CGPointMake(480/2 - delegate.player.imageWidth/2, 320/2 - delegate.player.imageHeight/2);
				balloonPopCount = 0;
				playerSpeed = 5;
				bonusMax = 5 * 60;
				for (int i = 1; i <= NumberOfBonuses ;i++) {
					currentBonus[i] = FALSE;
					displayBonus[i] = FALSE;
					bonusCount[i] = 0;
				}
				joystickDefault = CGPointMake(60, 320-60);
				joystickPosition = joystickDefault;
				break;
			}
			case 1: //Obstacle Course
			{
				
				break;
			}
			default:
			{
				break;
			}
		}
    }
    return self;
}
- (void)runLogic {
	switch (chosenGameNum) {
		case 0: //Speed Shooter
		{
			[self speedShooter];
			break;
		}
		case 1: //Obstacle Course
		{
			
			break;
		}
		default:
		{
			break;
		}
	}
}
- (void)drawGame {
	switch (chosenGameNum) {
		case 0: //Speed Shooter
		{
			[self drawSpeedShooter];
			break;
		}
		case 1: //Obstacle Course
		{
			
			break;
		}
		default:
		{
			break;
		}
	}
}
- (void)speedShooter {
	AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	
	//Timer
	if (timerCount >= timerMax) {
		[delegate finishedGame];
	} else {
		//Run fps counter
		float delta = (CFAbsoluteTimeGetCurrent() - fpsCounter)*60;
		if (delta < 0.8 || delta > 1.2) {delta = 1.0;}
		float originalDelta = delta;
		
		timerCount += 1;
		
		//Touch Logic
		if (delegate.touch1Start) {
			delegate.touch1Start = FALSE;
			if (delegate.ssTiltJoystick.selectedSegmentIndex == 1 && touchControllingJoyStick == 0 && 
				delegate.touchedScreen1.x < joystickDefault.x + delegate.joystick.imageWidth/1.5 && 
				delegate.touchedScreen1.y > joystickDefault.y- delegate.joystick.imageHeight/1.5) {
				touchControllingJoyStick = 1;
				[self controlJoystick:delegate.touchedScreen1 touch:1];
			} else
			if (touchControllingShooting == 0) {
				touchControllingShooting = 1;
				[self shoot:delegate.touchedScreen1];
			}
		}
		if (delegate.touch1Move) {
			delegate.touch1Move = FALSE;
			if (touchControllingJoyStick == 1) {
				[self controlJoystick:delegate.touchedScreen1 touch:1];
			} else
			if (touchControllingShooting == 1) {
				delegate.player.rotation = atan2(delegate.touchedScreen1.y-playerPosition.y-delegate.player.imageHeight/2,
												 delegate.touchedScreen1.x-
												 playerPosition.x-delegate.player.imageWidth/2)*180/M_PI + 90;
			}
		}
		if (delegate.touch1End) {
			delegate.touch1End = FALSE;
			if (touchControllingJoyStick == 1) {
				[self controlJoystick:delegate.touchedScreen1 touch:1];
				touchControllingJoyStick = 0;
				joystickPosition = joystickDefault;
			} else
			if (touchControllingShooting == 1) {
				touchControllingShooting = 0;
				delegate.player.rotation = atan2(delegate.touchedScreen1.y-playerPosition.y-delegate.player.imageHeight/2,
												 delegate.touchedScreen1.x-
												 playerPosition.x-delegate.player.imageWidth/2)*180/M_PI + 90;
			}
		}
		if (delegate.touch2Start) {
			delegate.touch2Start = FALSE;
			if (delegate.ssTiltJoystick.selectedSegmentIndex == 1 && touchControllingJoyStick == 0 && 
				delegate.touchedScreen2.x < joystickDefault.x + delegate.joystick.imageWidth/1.5 && 
				delegate.touchedScreen2.y > joystickDefault.y- delegate.joystick.imageHeight/1.5) {
				touchControllingJoyStick = 2;
				[self controlJoystick:delegate.touchedScreen1 touch:2];
			} else
			if (touchControllingShooting == 0) {
				touchControllingShooting = 2;
				[self shoot:delegate.touchedScreen2];
			}
		}
		if (delegate.touch2Move) {
			delegate.touch2Move = FALSE;
			if (touchControllingJoyStick == 2) {
				[self controlJoystick:delegate.touchedScreen2 touch:2];
			} else
			if (touchControllingShooting == 2) {
				delegate.player.rotation = atan2(delegate.touchedScreen2.y-playerPosition.y-delegate.player.imageHeight/2,
												 delegate.touchedScreen2.x-
												 playerPosition.x-delegate.player.imageWidth/2)*180/M_PI + 90;
			}
		}
		if (delegate.touch2End) {
			delegate.touch2End = FALSE;
			if (touchControllingJoyStick == 2) {
				[self controlJoystick:delegate.touchedScreen2 touch:2];
				touchControllingJoyStick = 0;
				joystickPosition = joystickDefault;
			} else
			if (touchControllingShooting == 2) {
				touchControllingShooting = 0;
				delegate.player.rotation = atan2(delegate.touchedScreen2.y-playerPosition.y-delegate.player.imageHeight/2,
												 delegate.touchedScreen2.x-
												 playerPosition.x-delegate.player.imageWidth/2)*180/M_PI + 90;
			}
		}
		
		
		if (currentBonus[BonusMatrixMode]) {
			float speedIncrease = 10.0;
			timerCount -= 1- (1/speedIncrease);
			delta *= 1.0/speedIncrease;
		}
		fpsCounter = CFAbsoluteTimeGetCurrent();
		
		//Move the player
		if (delegate.ssTiltJoystick.selectedSegmentIndex == 1) {
			//Joystick
			if (touchControllingJoyStick != 0) {
				playerPosition.x += cos(joystickRotation)*playerSpeed;
				playerPosition.y += sin(joystickRotation)*playerSpeed;
				if (touchControllingJoyStick != 1 && delegate.touchedScreen1.x != -1) {
					delegate.player.rotation = atan2(delegate.touchedScreen1.y-playerPosition.y-delegate.player.imageHeight/2,delegate.touchedScreen1.x-
											playerPosition.x-delegate.player.imageWidth/2)*180/M_PI + 90;
				}
				if (touchControllingJoyStick != 2 && delegate.touchedScreen2.x != -1) {
					delegate.player.rotation = atan2(delegate.touchedScreen2.y-playerPosition.y-delegate.player.imageHeight/2,delegate.touchedScreen2.x-
											playerPosition.x-delegate.player.imageWidth/2)*180/M_PI + 90;
				}
				if (playerPosition.x < 0) {playerPosition.x = 0;}
				if (playerPosition.x > 480-delegate.player.imageWidth) {playerPosition.x = 480-delegate.player.imageWidth;}
				if (playerPosition.y < 0) {playerPosition.y = 0;}
				if (playerPosition.y > 320-delegate.player.imageHeight) {playerPosition.y = 320-delegate.player.imageHeight;}
			}
		} 
		else {
			//Tilt
			if (hypot(delegate.movementy,delegate.movementx)*15 > 0.5) {
				float rotation = atan2(delegate.movementy, delegate.movementx);
				playerPosition.x += cos(rotation)*playerSpeed;
				playerPosition.y += sin(rotation)*playerSpeed;
				//ballPosition.x += movementx*speed;
				//ballPosition.y += (movementy)*speed*1.5;
				if (playerPosition.x < 0) {playerPosition.x = 0;}
				if (playerPosition.x > 480-delegate.player.imageWidth) {playerPosition.x = 480-delegate.player.imageWidth;}
				if (playerPosition.y < 0) {playerPosition.y = 0;}
				if (playerPosition.y > 320-delegate.player.imageHeight) {playerPosition.y = 320-delegate.player.imageHeight;}
			}
		}
		//Rotate the player
		if (touchControllingShooting != 0) {
			if (touchControllingShooting == 1) {
				delegate.player.rotation = atan2(delegate.touchedScreen1.y-playerPosition.y-delegate.player.imageHeight/2,
												 delegate.touchedScreen1.x-
												 playerPosition.x-delegate.player.imageWidth/2)*180/M_PI + 90;
			} else {
				delegate.player.rotation = atan2(delegate.touchedScreen2.y-playerPosition.y-delegate.player.imageHeight/2,
												 delegate.touchedScreen2.x-
												 playerPosition.x-delegate.player.imageWidth/2)*180/M_PI + 90;
			}
			
		}
		//Shoot Machine Gun if have it
		if (currentBonus[BonusMachineGun] && touchControllingShooting != 0) {
			if (touchControllingShooting == 1) {
				[self shoot:delegate.touchedScreen1];
			}
			if (touchControllingShooting == 2) {
				[self shoot:delegate.touchedScreen2];
			}
		}
		//Logic bullets
		for (int i = 0; i < [fire count]; i ++) {
			Sprite* fireBullet = [fire objectAtIndex: i];
			fireBullet.position = CGPointMake(fireBullet.position.x + fireBullet.vel.x*originalDelta
											  , fireBullet.position.y + fireBullet.vel.y*originalDelta);
			if (fireBullet.position.x < 0 || fireBullet.position.y < 0 || fireBullet.position.x > 480 || fireBullet.position.y > 320) {
				if (currentBonus[BonusBouncyBullets] ==FALSE) {
					[fire removeObjectAtIndex:i];
					i -= 1;
				} else {
					if (fireBullet.position.x < 0) {
						fireBullet.position = CGPointMake(0, fireBullet.position.y);
						fireBullet.vel = CGPointMake(fireBullet.vel.x*-1, fireBullet.vel.y);
					}
					if (fireBullet.position.y < 0) {
						fireBullet.position = CGPointMake(fireBullet.position.x, 0);
						fireBullet.vel = CGPointMake(fireBullet.vel.x, fireBullet.vel.y*-1);
					}
					if (fireBullet.position.x > 480) {
						fireBullet.position = CGPointMake(480, fireBullet.position.y);
						fireBullet.vel = CGPointMake(fireBullet.vel.x*-1, fireBullet.vel.y);
					}
					if (fireBullet.position.y > 320) {
						fireBullet.position = CGPointMake(fireBullet.position.x, 320);
						fireBullet.vel = CGPointMake(fireBullet.vel.x, fireBullet.vel.y*-1);
					}
				}
			} else {
				
				for (int j = 0; j < [balloons count]; j++) {
					Sprite* collBalloon = [balloons objectAtIndex:j];
					if ([delegate.gameView collisionOfCircles:CGPointMake(collBalloon.position.x + 40*collBalloon.spriteScale/2.0, collBalloon.position.y  + 40*collBalloon.spriteScale/2.0) rad:40*collBalloon.spriteScale/2.0 c2:CGPointMake(fireBullet.position.x + 1.5, fireBullet.position.y + 1.5) rad:1.5]) {
						//If have penetration bullets make change of not making bullet disappear
						if (currentBonus[BonusPenetrationBullets]) {
							if (rand()%3 == 1) {
								[fire removeObjectAtIndex:i];
							}
						} else {
							[fire removeObjectAtIndex:i];
						}
						i -= 1;
						if (collBalloon.spriteType == 1) {
							balloonPopCount += 1;
						} else if (collBalloon.spriteType == 2) {
							balloonPopCount += 1;
							timerCount -= 120;
						}
						[balloons removeObjectAtIndex:j];
						j = [balloons count];
					}
				}
				
			}
		}
		//Logic Balloons
		for (int i = 0; i < [balloons count]; i ++) {
			Sprite* thisBalloon = [balloons objectAtIndex:i];
			thisBalloon.position = CGPointMake(thisBalloon.position.x + thisBalloon.vel.x*delta, thisBalloon.position.y + thisBalloon.vel.y*delta);
			
			if (thisBalloon.position.x < 0) {
				thisBalloon.position = CGPointMake(0, thisBalloon.position.y);
				thisBalloon.vel = CGPointMake(thisBalloon.vel.x * -1, thisBalloon.vel.y);
			}
			
			if (thisBalloon.position.x > 480-40) {
				thisBalloon.position = CGPointMake(480-40, thisBalloon.position.y);
				thisBalloon.vel = CGPointMake(thisBalloon.vel.x * -1, thisBalloon.vel.y);
			}
			
			
			if (thisBalloon.position.y < 0) {
				thisBalloon.position = CGPointMake(thisBalloon.position.x, 0);
				thisBalloon.vel = CGPointMake(thisBalloon.vel.x, thisBalloon.vel.y * -1);
			}
			
			if (thisBalloon.position.y > 320-40) {
				thisBalloon.position = CGPointMake(thisBalloon.position.x, 320-40);
				thisBalloon.vel = CGPointMake(thisBalloon.vel.x, thisBalloon.vel.y * -1);
			}
			if (thisBalloon.spriteType == 2) {thisBalloon.transparency -= 1.0/300.0;}
			if (thisBalloon.transparency <= 0.0) {[balloons removeObjectAtIndex: i]; i -= 1;}
		}
		//Add balloons
		while ([balloons count] < 10) {
			Sprite* newBalloon;
			newBalloon = [[Sprite alloc] init];
			
			newBalloon.position = CGPointMake(rand()%(480-40), rand()%(320-40));
			newBalloon.vel = CGPointMake((rand()%9)-5, (rand()%9)-5);
			
			newBalloon.spriteType = 1;
			if (rand()%400 == 1) {newBalloon.spriteType = 2;}
			
			if (delegate.chosenDifficulty == 1) {
				newBalloon.spriteScale = 1.0;
			} else if (delegate.chosenDifficulty == 2) {
				newBalloon.spriteScale = 0.75;
			} else if (delegate.chosenDifficulty == 3) {
				newBalloon.spriteScale = 0.5;
			}
			
			[balloons addObject:newBalloon];
			[newBalloon release];
		}
		//Balloon Collision
		for (int i = 0; i < [balloons count]; i ++) {
			Sprite* thisBalloon = [balloons objectAtIndex:i];
			for (int j = i+1; j < [balloons count]; j ++) {
				Sprite* collideBalloon = [balloons objectAtIndex:j];
				
				if ([delegate.gameView collisionOfCircles:CGPointMake(ceil(thisBalloon.position.x+40*thisBalloon.spriteScale/2.0), ceil(thisBalloon.position.y+40*thisBalloon.spriteScale/2.0)) rad:ceil(40*thisBalloon.spriteScale/2.0 )
													   c2:CGPointMake(ceil(collideBalloon.position.x+40*collideBalloon.spriteScale/2.0), ceil(collideBalloon.position.y+40*collideBalloon.spriteScale/2.0)) rad:ceil(40*collideBalloon.spriteScale/2.0)]) {
					double x, y, d2;
					
					// displacement from i to j
					y = (collideBalloon.position.y - thisBalloon.position.y);
					x = (collideBalloon.position.x - thisBalloon.position.x);
					
					// distance squared
					d2 = x * x + y * y;
					
					double kii, kji, kij, kjj;
					
					kji = (x * thisBalloon.vel.x + y * thisBalloon.vel.y) / d2; // k of j due to i
					kii = (x * thisBalloon.vel.y - y * thisBalloon.vel.x) / d2; // k of i due to i
					kij = (x * collideBalloon.vel.x + y * collideBalloon.vel.y) / d2; // k of i due to j
					kjj = (x * collideBalloon.vel.y - y * collideBalloon.vel.x) / d2; // k of j due to j
					
					// set velocity of i
					thisBalloon.vel = CGPointMake(kij * x - kii * y, kij * y + kii * x);
					
					// set velocity of j
					collideBalloon.vel = CGPointMake(kji * x - kjj * y, kji * y + kjj * x);
					
					// the ratio between what it should be and what it really is
					float k = ((40*thisBalloon.spriteScale+40*collideBalloon.spriteScale)/2+0.1) / sqrt(x * x + y * y);
					
					// difference between x and y component of the two vectors
					y *= (k - 1) / 2;
					x *= (k - 1) / 2;
					
					// set new coordinates of disks
					thisBalloon.position = CGPointMake(thisBalloon.position.x - x,thisBalloon.position.y - y);
					collideBalloon.position = CGPointMake(collideBalloon.position.x + x,collideBalloon.position.y + y);
					//j.y += y;
					//j.x += x;
					//i.y -= y;
					//i.x -= x;
					
				}
			}
		}
		//Run bonuses
		for (int i = 1; i <= NumberOfBonuses;i++) {
			if (!displayBonus[i] && !currentBonus[i]) {
				if (rand()%700 == 1) {
					displayBonus[i] = TRUE;
					bonusPosition[i] = CGPointMake(rand() % 440, rand() % 280);
				}
			} else if (displayBonus[i]) {
				if ([delegate.gameView collisionOfCircles:CGPointMake(bonusPosition[i].x+20, bonusPosition[i].y+20) rad:20 c2:CGPointMake(playerPosition.x + delegate.player.imageWidth/2, playerPosition.y + delegate.player.imageHeight/2) rad:delegate.player.imageWidth/2]) {
					currentBonus[i] = TRUE;;
					displayBonus[i] = FALSE;
				}
			} 
			else if (currentBonus[i]) {
				if (bonusCount[i] >= bonusMax) {
					currentBonus[i] = FALSE;
					bonusCount[i] = 0;
				}
				switch (i) {
					case BonusBouncyBullets:
					{
						//Done
						bonusCount[i] += 1*originalDelta;
						break;
					}
					case BonusMachineGun:
					{
						//Done
						bonusCount[i] += 1*originalDelta;
						break;
					}
					case BonusMatrixMode:
					{
						bonusCount[i] += 1*originalDelta;
						break;
					}
					case BonusMultiDir:
					{
						//Done
						bonusCount[i] += 1*originalDelta;
						break;
					}
					case BonusNuke:
					{
						//Done
						balloonPopCount += [balloons count]/2;
						[balloons removeAllObjects];
						bonusCount[i] += 10*originalDelta;
						[delegate.radioActive setAlpha:1.0-((float)bonusCount[i]/bonusMax)];
						break;
					}
					case BonusPenetrationBullets:
					{
						//Done
						bonusCount[i] += 1*originalDelta;
						break;
					}
					default:
					{
						break;
					}
				}
			}
		}
	}
}
- (void)drawSpeedShooter {
	AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	GameView* gameView = delegate.gameView;
	if (timerCount < timerMax) {
		//Draw Background
		if (delegate.chosenDifficulty == 1) {
			color2[0] = 0.0;
			color2[1] = 0.0;
			color2[2] = 0.0;
			color2[3] = 0.0;
		}
		if (delegate.chosenDifficulty == 2) {
			if (rand()%110 == 1) {
				color2[0] = (rand()%10)/10.0;
				color2[1] = (rand()%10)/10.0;
				color2[2] = (rand()%10)/10.0;
			}
			color2[3] = 0.6;
		}			
		if (delegate.chosenDifficulty == 3) {
			color2[0] = (rand()%10)/10.0;
			color2[1] = (rand()%10)/10.0;
			
			color2[2] = (rand()%10)/10.0;
			color2[3] = 0.6;
		}
		
		float color3[4] = {1.0,1.0,1.0,1.0};
		[gameView drawRect:CGRectMake(0, 0, 480, 320) color:color3];
		[gameView drawImage:delegate.gameScreen AtPoint:CGPointMake(0, 0)];
		[gameView drawRect:CGRectMake(0, 0, 480, 320) color:color2];
		
		//Draw player
		[gameView drawImage:delegate.player AtPoint:CGPointMake(playerPosition.x, playerPosition.y)];
		//Draw bullets
		for (int i = 0; i < [fire count]; i ++) {
			Sprite* fireBullet = [fire objectAtIndex:i];
			[gameView drawImage:delegate.bullet AtPoint:fireBullet.position];
		}
		
		//Draw Bonus
		for (int i = 1; i <= NumberOfBonuses; i ++) {
			if (displayBonus[i]) {
				[gameView drawImage:[delegate bonusImages:i] AtPoint:bonusPosition[i]];
			}
		}
		
		//Draw balloons
		for (int i = 0; i < [balloons count]; i ++) {
			Sprite* thisBalloon = [balloons objectAtIndex:i];
			if (thisBalloon.spriteType == 1) {
				delegate.redBalloon.scale = thisBalloon.spriteScale;
				[delegate.redBalloon setAlpha:thisBalloon.transparency];
				[gameView drawImage:delegate.redBalloon AtPoint:thisBalloon.position];
			} else if (thisBalloon.spriteType == 2) {
				delegate.blueBalloon.scale = thisBalloon.spriteScale;
				[delegate.blueBalloon setAlpha:thisBalloon.transparency];
				[gameView drawImage:delegate.blueBalloon AtPoint:thisBalloon.position];
			}
		}
		//Draw radioactive
		if (currentBonus[BonusNuke] == TRUE) {
			[gameView drawImage:delegate.radioActive AtPoint:CGPointMake(480/2.0 - delegate.radioActive.imageWidth/2.0, 320/2.0 - delegate.radioActive.imageHeight/2.0+10)];
		}
		
		//Draw timer
		NSString* timeString = [NSString stringWithFormat:@"Time Left: %f",(timerMax-timerCount)/60];
		timeString = [timeString substringToIndex:[timeString rangeOfString:@"."].location+2];
		[gameView drawText:timeString AtPoint:CGPointMake(0, 0)];
		
		//Draw joystick
		if (delegate.ssTiltJoystick.selectedSegmentIndex == 1) {
			[gameView drawImage:delegate.joystick AtPoint:CGPointMake(joystickPosition.x - delegate.joystick.imageWidth/2,joystickPosition.y - delegate.joystick.imageHeight/2)];
		}
	}
}
- (void)shoot:(CGPoint)touchPosition {
	AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	
	delegate.player.rotation = atan2(touchPosition.y-playerPosition.y-delegate.player.imageHeight/2,touchPosition.x-
									 playerPosition.x-delegate.player.imageWidth/2)*180/M_PI + 90;
	//Now shoot a bullet
	Sprite* newBullet = [[Sprite alloc] init];
	newBullet.position = CGPointMake(playerPosition.x + delegate.player.imageWidth/2
									 +cos((delegate.player.rotation-90+5)*M_PI/180)*12
									 , playerPosition.y + delegate.player.imageHeight/2+sin((delegate.player.rotation-90+5)*M_PI/180)*12);
	
	newBullet.vel = CGPointMake(cos((delegate.player.rotation-90)*M_PI/180)*10, sin((delegate.player.rotation-90)*M_PI/180)*10);
	[fire addObject:newBullet];
	[newBullet release];
	if (currentBonus[BonusMultiDir]) {
		for (int i = 1; i <= 3; i ++) {
			//Now shoot a bullet
			Sprite* newBullet = [[Sprite alloc] init];
			newBullet.position = CGPointMake(playerPosition.x + delegate.player.imageWidth/2
											 +cos((delegate.player.rotation-90+5+90*i)*M_PI/180)*12
											 , playerPosition.y + delegate.player.imageHeight/2+sin((delegate.player.rotation-90+5+90*i)*M_PI/180)*12);
			
			newBullet.vel = CGPointMake(cos((delegate.player.rotation-90+90*i)*M_PI/180)*10, sin((delegate.player.rotation-90+90*i)*M_PI/180)*10);
			[fire addObject:newBullet];
			[newBullet release];
		}
	}
}
- (void)controlJoystick:(CGPoint)touchPosition touch:(int)touch {
	touchControllingJoyStick = touch;
	joystickPosition = CGPointMake(touchPosition.x, touchPosition.y);
	joystickRotation = atan2(touchPosition.y-joystickDefault.y,touchPosition.x-
							 joystickDefault.x);
	if (pow(touchPosition.x - joystickDefault.x, 2)+pow(touchPosition.y - joystickDefault.y, 2) > 40*40) {
		joystickPosition = CGPointMake(joystickDefault.x + cos(joystickRotation)*40,joystickDefault.y + sin(joystickRotation)*40);
	}
	
}
- (void)dealloc {
	[balloons release];
	[fire release];
	[super dealloc];
}
@end
