#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window,menuController,touchedScreen1,touchedScreen2,touch1, touch2,player, redBalloon, 
blueBalloon, bullet, radioActive,movementx,movementy,gameView, gameScreen,touch1Start,touch1Move,
touch1End,touch2Start,touch2Move,touch2End,ssTiltJoystick,joystick,chosenGame,chosenDifficulty,achievedStarsShooting,
gameVariables;

//@synthesize viewController;
#pragma mark -
#pragma mark Menu
- (IBAction)toInstructions:(id)sender {
	if (menuTimer) {
		[menuTimer invalidate];
		menuTimer = nil;
	}
	[self switchView:mainMenuView to:instructionsView with:UIViewAnimationTransitionFlipFromLeft time:0.5];
}
- (IBAction)toMenu:(id)sender {
	[self switchView:menuController.view to:mainMenuView with:UIViewAnimationTransitionFlipFromRight time:0.5];
}
- (IBAction)toCredits:(id)sender {
	if (menuTimer) {
		[menuTimer invalidate];
		menuTimer = nil;
	}
	[self switchView:mainMenuView to:creditsView with:UIViewAnimationTransitionFlipFromLeft time:0.5];
}
- (IBAction)toGameScreen:(id)sender {
	if (sender == ssBeginnerBtn) {
		chosenGame = 0;
		chosenDifficulty = 1;
	}
	if (sender == ssDistractedBtn) {
		chosenGame = 0;
		chosenDifficulty = 2;
	}
	if (sender == ssSeizurificBtn) {
		chosenGame = 0;
		chosenDifficulty = 3;
	}
	[self switchView:menuController.view to:gameView with:UIViewAnimationTransitionFlipFromLeft time:0.5];
}
- (IBAction)toTrainingModes:(id)sender {
	if (menuTimer) {
		[menuTimer invalidate];
		menuTimer = nil;
	}
	[self switchView:menuController.view to:trainingModesView with:UIViewAnimationTransitionFlipFromLeft time:0.5];
}
- (IBAction)exitTrainingMode:(id)sender {
	// set up an animation for the transition between the views
	CATransition *animation = [CATransition animation];
	[animation setDuration:0.5];
	[animation setType:kCATransitionPush];
	if ([menuController currentOrientation] == UIInterfaceOrientationLandscapeRight) {
		[animation setSubtype:kCATransitionFromBottom];
	} else {
		[animation setSubtype:kCATransitionFromTop];
	}
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[self switchView:menuController.view to:trainingModesView with:animation];
}
- (IBAction)toHighscores:(id)sender {
	[highscoresTableData requestScore];
	[self switchView:menuController.view to:highscoresView with:UIViewAnimationTransitionFlipFromLeft time:0.5];
}
- (IBAction)exitHighscores:(id)sender {
	if (chosenGame == 0) {
		[self switchView:menuController.view to:speedShooting with:UIViewAnimationTransitionFlipFromRight time:0.5];
	}
}
- (void)switchView:(UIView*)oldView to:(UIView*)newView with:(UIViewAnimationTransition)trans time:(float)sec {
	[oldView removeFromSuperview];
	if (newView == gameView) {
		[gameView setOrientation:[menuController currentOrientation]];
	} else {
		[menuController setView:newView];
		//Manually re-orient the view if in OS less than 4.0
		if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0) {
			if ([menuController currentOrientation] == UIInterfaceOrientationLandscapeRight) {
				if (newView.transform.a == 0.0 && newView.transform.b == -1.0 && newView.transform.c == 1.0 &&
					newView.transform.d == 0.0 && newView.transform.tx == 0.0 && newView.transform.ty == 0.0) {
					[newView setTransform:CGAffineTransformMake(0.0, 1.0, -1.0, 0.0, 0.0, 0.0)];
				} else if (!(newView.transform.a == 0.0 && newView.transform.b == 1.0 && newView.transform.c == -1.0 &&
							 newView.transform.d == 0.0 && newView.transform.tx == 0.0 && newView.transform.ty == 0.0)) {
					[newView setTransform:CGAffineTransformMake(0.0, 1.0, -1.0, 0.0, -80.0, 80.0)];
				}
			}
			if ([menuController currentOrientation] == UIInterfaceOrientationLandscapeLeft) {
				if (newView.transform.a == 0.0 && newView.transform.b == 1.0 && newView.transform.c == -1.0 &&
					newView.transform.d == 0.0 && newView.transform.tx == 0.0 && newView.transform.ty == 0.0) {
					[newView setTransform:CGAffineTransformMake(0.0, -1.0, 1.0, 0.0, 0.0, 0.0)];
				} else if (!(newView.transform.a == 0.0 && newView.transform.b == -1.0 && newView.transform.c == 1.0 &&
							 newView.transform.d == 0.0 && newView.transform.tx == 0.0 && newView.transform.ty == 0.0)) {
					[newView setTransform:CGAffineTransformMake(0.0, -1.0, 1.0, 0.0, -80.0, 80.0)];
				}
			}
		}
	}
	[self.window addSubview:newView];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:sec];
	[UIView setAnimationTransition:trans
						   forView:window
							 cache:YES];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationFinished)];
	[UIView commitAnimations];
	
	//Can use CATransitions for custom transitions
}
- (void)switchView:(UIView*)oldView to:(UIView*)newView with:(CATransition*)trans {
	// get the the underlying UIWindow, or the view containing the current view view
	UIView *theWindow = [oldView superview];
	
	// remove the current view and replace with myView1
	[oldView removeFromSuperview];
	if (newView == gameView) {
		[gameView setOrientation:[menuController currentOrientation]];
	} else {
		[menuController setView:newView];
		//Manually re-orient the view if in OS less than 4.0
		if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0) {
			if ([menuController currentOrientation] == UIInterfaceOrientationLandscapeRight) {
				if (newView.transform.a == 0.0 && newView.transform.b == -1.0 && newView.transform.c == 1.0 &&
					newView.transform.d == 0.0 && newView.transform.tx == 0.0 && newView.transform.ty == 0.0) {
					[newView setTransform:CGAffineTransformMake(0.0, 1.0, -1.0, 0.0, 0.0, 0.0)];
				} else if (!(newView.transform.a == 0.0 && newView.transform.b == 1.0 && newView.transform.c == -1.0 &&
							 newView.transform.d == 0.0 && newView.transform.tx == 0.0 && newView.transform.ty == 0.0)) {
					[newView setTransform:CGAffineTransformMake(0.0, 1.0, -1.0, 0.0, -80.0, 80.0)];
				}
			}
			if ([menuController currentOrientation] == UIInterfaceOrientationLandscapeLeft) {
				if (newView.transform.a == 0.0 && newView.transform.b == 1.0 && newView.transform.c == -1.0 &&
					newView.transform.d == 0.0 && newView.transform.tx == 0.0 && newView.transform.ty == 0.0) {
					[newView setTransform:CGAffineTransformMake(0.0, -1.0, 1.0, 0.0, 0.0, 0.0)];
				} else if (!(newView.transform.a == 0.0 && newView.transform.b == -1.0 && newView.transform.c == 1.0 &&
							 newView.transform.d == 0.0 && newView.transform.tx == 0.0 && newView.transform.ty == 0.0)) {
					[newView setTransform:CGAffineTransformMake(0.0, -1.0, 1.0, 0.0, -80.0, 80.0)];
				}
			}
		}
	}
	[menuController setView:newView];
	[theWindow addSubview:newView];
	[[theWindow layer] addAnimation:trans forKey:@"SwitchToView1"];
	
	[self animationFinished];
}
- (void)animationFinished {
	//This tells us when our flipping animation finishes so we can start the game.
	if ([[window subviews] containsObject:gameView]) {
		[self initializeGame];
	}
	if ([[window subviews] containsObject:mainMenuView]) {
		menuTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60 target:self selector:@selector(menuTimer) userInfo:nil repeats:YES];
	}
	if ([[window subviews] containsObject:speedShooting]) {
		if (shootingEasyGoal) {beginnerStar.image = [UIImage imageNamed:@"Gold Star.png"];} else 
		{beginnerStar.image = [UIImage imageNamed:@"Faded Star.png"];}
		if (shootingMediumGoal) {mediumStar.image = [UIImage imageNamed:@"Gold Star.png"];} else 
		{mediumStar.image = [UIImage imageNamed:@"Faded Star.png"];}
		if (shootingHardGoal) {hardStar.image = [UIImage imageNamed:@"Gold Star.png"];} else 
		{hardStar.image = [UIImage imageNamed:@"Faded Star.png"];}
	}
	if ([[window subviews] containsObject:trainingModesView]) {
		NSLog(@"Reloading table: %d",achievedStarsShooting);
		[levelTable reloadData];
	}
}
- (void)selectedTrainingMode:(int)mode {
	// set up an animation for the transition between the views
	CATransition *animation = [CATransition animation];
	[animation setDuration:0.5];
	[animation setType:kCATransitionPush];
	if ([menuController currentOrientation] == UIInterfaceOrientationLandscapeRight) {
		[animation setSubtype:kCATransitionFromTop];
	} else {
		[animation setSubtype:kCATransitionFromBottom];
	}
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	
	if (mode == 0) {
		[self switchView:menuController.view to:speedShooting with:animation];
	}

}
- (void)menuTimer {
	//Logic Balloons
	for (int i = 0; i < 4; i ++) {
		UIImageView* ball;
		CGPoint vel;
		if (i == 0) {ball = blueMenuBall; vel = blueMenuBallVel;}
		if (i == 1) {ball = redMenuBall; vel = redMenuBallVel;}
		if (i == 2) {ball = greenMenuBall; vel = greenMenuBallVel;}
		if (i == 3) {ball = purpleMenuBall; vel = purpleMenuBallVel;}
		ball.center = CGPointMake(ball.center.x + vel.x, ball.center.y + vel.y);
		if (ball.center.x < 20) {
			ball.center = CGPointMake(20, ball.center.y);
			vel = CGPointMake(vel.x * -1, vel.y);
		}
		if (ball.center.x > 480-20) {
			ball.center = CGPointMake(480-20, ball.center.y);
			vel = CGPointMake(vel.x * -1, vel.y);
		}
		if (ball.center.y < 20) {
			ball.center = CGPointMake(ball.center.x, 20);
			vel = CGPointMake(vel.x, vel.y * -1);
		}
		if (ball.center.y > 320-20) {
			ball.center = CGPointMake(ball.center.x, 320-20);
			vel = CGPointMake(vel.x, vel.y * -1);
		}
		if (i == 0) {blueMenuBallVel = vel;}
		if (i == 1) {redMenuBallVel = vel;}
		if (i == 2) {greenMenuBallVel = vel;}
		if (i == 3) {purpleMenuBallVel = vel;}
	}
	
	//Balloon-Balloon Collision
	for (int i = 0; i < 4; i ++) {
		UIImageView* ball;
		CGPoint vel;
		if (i == 0) {ball = blueMenuBall; vel = blueMenuBallVel;}
		if (i == 1) {ball = redMenuBall; vel = redMenuBallVel;}
		if (i == 2) {ball = greenMenuBall; vel = greenMenuBallVel;}
		if (i == 3) {ball = purpleMenuBall; vel = purpleMenuBallVel;}
		for (int j = i+1; j < 4; j ++) {
			UIImageView* ball2;
			CGPoint vel2;
			if (j == 0) {ball2 = blueMenuBall; vel2 = blueMenuBallVel;}
			if (j == 1) {ball2 = redMenuBall; vel2 = redMenuBallVel;}
			if (j == 2) {ball2 = greenMenuBall; vel2 = greenMenuBallVel;}
			if (j == 3) {ball2 = purpleMenuBall; vel2 = purpleMenuBallVel;}

			if ([gameView collisionOfCircles:CGPointMake(ceil(ball.center.x), ceil(ball.center.y)) rad:20
										  c2:CGPointMake(ceil(ball2.center.x), ceil(ball2.center.y)) rad:20]) {
				float x, y, d2;
				// displacement from i to j
				y = (ball2.center.y - ball.center.y);
				x = (ball2.center.x - ball.center.x);
				
				// distance squared
				d2 = x * x + y * y;
				
				float kii, kji, kij, kjj;
				
				kji = (x * vel.x + y * vel.y) / d2; // k of j due to i
				kii = (x * vel.y - y * vel.x) / d2; // k of i due to i
				kij = (x * vel2.x + y * vel2.y) / d2; // k of i due to j
				kjj = (x * vel2.y - y * vel2.x) / d2; // k of j due to j
				
				// set velocity of i
				vel = CGPointMake(kij * x - kii * y, kij * y + kii * x);
				
				// set velocity of j
				vel2 = CGPointMake(kji * x - kjj * y, kji * y + kjj * x);
				
				// the ratio between what it should be and what it really is
				float k = ((40*1.0+40*1.0)/2.0+0.1) / sqrt(x * x + y * y);
				
				// difference between x and y component of the two vectors
				y *= (k - 1) / 2;
				x *= (k - 1) / 2;
				
				// set new coordinates of disks
				ball.center = CGPointMake(ball.center.x - x,ball.center.y - y);
				ball2.center = CGPointMake(ball2.center.x + x,ball2.center.y + y);
				//j.y += y;
				//j.x += x;
				//i.y -= y;
				//i.x -= x;
				if (i == 0) {blueMenuBallVel = vel;}
				if (i == 1) {redMenuBallVel = vel;}
				if (i == 2) {greenMenuBallVel = vel;}
				if (i == 3) {purpleMenuBallVel = vel;}
				
				if (j == 0) {blueMenuBallVel = vel2;}
				if (j == 1) {redMenuBallVel = vel2;}
				if (j == 2) {greenMenuBallVel = vel2;}
				if (j == 3) {purpleMenuBallVel = vel2;}
			}
		}
	}
	
}
- (void)finishedGame {
	if (chosenGame == 0) {
		[modeMusic[chosenDifficulty-1] pause];
		[modeMusic[chosenDifficulty-1] setCurrentTime:0];
		[self pauseGame];
		scoreLbl.text = [NSString stringWithFormat:@"%d",gameVariables.balloonPopCount];
		goalImage.image = [UIImage imageNamed:@"Faded Star.png"];
		if (chosenDifficulty == 1) {
			goalLbl.text = [NSString stringWithFormat:@"6000"];
			if (gameVariables.balloonPopCount >= 6000 || shootingEasyGoal) {
				goalImage.image = [UIImage imageNamed:@"Gold Star.png"];
				if (!shootingEasyGoal) {
					shootingEasyGoal = TRUE;
					achievedStarsShooting += 1;
				}
			}
		}
		if (chosenDifficulty == 2) {
			goalLbl.text = [NSString stringWithFormat:@"4000"];
			if (gameVariables.balloonPopCount >= 4000 || shootingMediumGoal) {
				goalImage.image = [UIImage imageNamed:@"Gold Star.png"];
				if (!shootingMediumGoal) {
					shootingMediumGoal = TRUE;
					achievedStarsShooting += 1;
				}
			}
		}
		if (chosenDifficulty == 3) {
			goalLbl.text = [NSString stringWithFormat:@"3000"];
			if (gameVariables.balloonPopCount >= 3000 || shootingHardGoal) {
				goalImage.image = [UIImage imageNamed:@"Gold Star.png"];
				if (!shootingHardGoal) {
					shootingHardGoal = TRUE;
					achievedStarsShooting += 1;
				}
			}
		}
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *filePath = [documentsDirectory stringByAppendingString:@"/PlayerData.sav"];
		NSMutableArray* save = [[NSMutableArray alloc] init];
		[save addObject:[NSNumber numberWithInt:achievedStarsShooting]];
		[save addObject:[NSNumber numberWithBool:shootingEasyGoal]];
		[save addObject:[NSNumber numberWithBool:shootingMediumGoal]];
		[save addObject:[NSNumber numberWithBool:shootingHardGoal]];
		[save writeToFile:filePath atomically:YES];
		[save release];
		
		[self switchView:gameView to:scoreView with:UIViewAnimationTransitionFlipFromRight time:0.5];
	}
}
- (IBAction)clearGameData:(id)sender {
	UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Clear Game Data" message:@"Are you sure you want to erase all data?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[myAlertView show];
	[myAlertView release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		achievedStarsShooting = 0;
		shootingEasyGoal = FALSE;
		shootingMediumGoal = FALSE;
		shootingHardGoal = FALSE;
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *filePath = [documentsDirectory stringByAppendingString:@"/PlayerData.sav"];
		NSMutableArray* save = [[NSMutableArray alloc] init];
		[save addObject:[NSNumber numberWithInt:achievedStarsShooting]];
		[save addObject:[NSNumber numberWithBool:shootingEasyGoal]];
		[save addObject:[NSNumber numberWithBool:shootingMediumGoal]];
		[save addObject:[NSNumber numberWithBool:shootingHardGoal]];
		[save writeToFile:filePath atomically:YES];
		[save release];
	}
}
#pragma mark -
#pragma mark In Game
- (void)initializeGame {
	modeMusic[chosenDifficulty-1].numberOfLoops = -1;
	[modeMusic[chosenDifficulty-1] play];
	touch1 = nil;
	touch2 = nil;
	if ([menuController currentOrientation] == UIInterfaceOrientationLandscapeLeft) {
		invertedAccelerometer = TRUE;
		direction = -1;
	}
	if ([menuController currentOrientation] == UIInterfaceOrientationLandscapeRight) {
		invertedAccelerometer = FALSE;
		direction = -1;
	}
	calibrated = FALSE;
	if (gameVariables) {[gameVariables release]; gameVariables = nil;}
	gameVariables = [[GameVariables alloc] initWithGame:chosenGame];
	[self initializeTimer];
}
- (void)pauseGame {
	if (theTimer != nil) {
		[theTimer invalidate];
		theTimer = nil;
	}
}
- (void)initializeTimer {
	if (theTimer == nil) {
		theTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(gameLogic)];
		theTimer.frameInterval = 1;//1 = 60fps, 2 = 30fps
		[theTimer addToRunLoop: [NSRunLoop currentRunLoop]
					   forMode: NSDefaultRunLoopMode];
		fpsCounter = CFAbsoluteTimeGetCurrent();
	}
}
- (void)gameLogic {
	/**
	//Delta is still experimental!!! If bad results disable.
	//Made to keep things smooth even when they skip frames.
	/**
	float delta = (CFAbsoluteTimeGetCurrent() - fpsCounter)*60;
	fpsCounter = CFAbsoluteTimeGetCurrent();
	//delta = 1.0;
	//Logic time
	if (touch2 && [balloonData count] < 100) {
		Sprite* newBalloon;
		newBalloon = [[Sprite alloc] init];
		newBalloon.position = CGPointMake(touchedScreen2.x, touchedScreen2.y);
		newBalloon.vel = CGPointMake((rand()%9)-5, (rand()%9)-5);
		[balloonData addObject:newBalloon];
		[newBalloon release];
	}
	if (touch1) {
		if (manPos.x+man.imageWidth/2 != touchedScreen1.x) {
			manPos.x -= (int)((cos(atan2(manPos.y+man.imageHeight/2-touchedScreen1.y, manPos.x+man.imageWidth/2-touchedScreen1.x))*4)*delta);
			if (abs(manPos.x+man.imageWidth/2-touchedScreen1.x) < 4) {
				manPos.x = touchedScreen1.x - man.imageWidth/2;
			}
		}
		if (manPos.y+man.imageHeight/2 != touchedScreen1.y) {
			manPos.y -= (int)((sin(atan2(manPos.y+man.imageHeight/2-touchedScreen1.y, manPos.x+man.imageWidth/2-touchedScreen1.x))*4)*delta);
			if (abs(manPos.y+man.imageHeight/2-touchedScreen1.y) < 4) {
				manPos.y = touchedScreen1.y - man.imageHeight/2;
			}
		}
	}
	//Logic Balloons
	for (int i = 0; i < [balloonData count]; i ++) {
		Sprite* thisBalloon = [balloonData objectAtIndex:i];
		
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
	}
	//Balloon-Balloon Collision
	for (int i = 0; i < [balloonData count]; i ++) {
		Sprite* thisBalloon = [balloonData objectAtIndex:i];
		
		for (int j = i+1; j < [balloonData count]; j ++) {
			Sprite* collideBalloon = [balloonData objectAtIndex:j];
			//Program is yourself you lazy bum.
			//Find the combined vel of x and y. Use hypot.
			//Find the tangent.
			//Make it bounce off of the tangent with the same combined vel.
			if ([gameView collisionOfCircles:CGPointMake(ceil(thisBalloon.position.x+40*1.0/2.0), ceil(thisBalloon.position.y+40*1.0/2.0)) rad:ceil(40*1.0/2.0 )
									  c2:CGPointMake(ceil(collideBalloon.position.x+40*1.0/2.0), ceil(collideBalloon.position.y+40*1.0/2.0)) rad:ceil(40*1.0/2.0)]) {
				float x, y, d2;
				
				// displacement from i to j
				y = (collideBalloon.position.y - thisBalloon.position.y);
				x = (collideBalloon.position.x - thisBalloon.position.x);
				
				// distance squared
				d2 = x * x + y * y;
				
				float kii, kji, kij, kjj;
				
				kji = (x * thisBalloon.vel.x + y * thisBalloon.vel.y) / d2; // k of j due to i
				kii = (x * thisBalloon.vel.y - y * thisBalloon.vel.x) / d2; // k of i due to i
				kij = (x * collideBalloon.vel.x + y * collideBalloon.vel.y) / d2; // k of i due to j
				kjj = (x * collideBalloon.vel.y - y * collideBalloon.vel.x) / d2; // k of j due to j
				
			
				// set velocity of i
				thisBalloon.vel = CGPointMake(kij * x - kii * y, kij * y + kii * x);
				
				// set velocity of j
				collideBalloon.vel = CGPointMake(kji * x - kjj * y, kji * y + kjj * x);
				
				// the ratio between what it should be and what it really is
				float k = ((40*1.0+40*1.0)/2.0+0.1) / sqrt(x * x + y * y);
				
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
	 **/
	[gameVariables runLogic];
	
	//Now draw everything
	[gameView renderScene];
}
- (void)drawGame {
	/**
	for (int i = 0; i < [balloonData count];i++) {
		Sprite* balloonSprite = [balloonData objectAtIndex:i];
		[gameView drawImage:balloon AtPoint:CGPointMake(balloonSprite.position.x, balloonSprite.position.y)];
	}
	[gameView drawImage:man AtPoint:manPos];
	 **/
	[gameVariables drawGame];
}
- (void)configureAccelerometer{
	UIAccelerometer*  theAccelerometer = [UIAccelerometer sharedAccelerometer];
	if(theAccelerometer)
	{
		theAccelerometer.updateInterval = 1.0 / 60;
		theAccelerometer.delegate = self;
	}
}
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
	if (calibrated == FALSE) { //Calibrate so you can figure which way to move the player later
		calibrationx = acceleration.x;
		calibrationy = acceleration.y;
		calibrationz = acceleration.z;
		calibrated = TRUE;
	}
	int invert = 1;
	if (invertedAccelerometer) { //Depending on phone orientation, invert.
		invert = -1;
	}
	if (calibrationz > 0.1) {invert *= -1;} //If phone is upside down then invert.
	movementx = (invert)*(calibrationy - acceleration.y);
	movementy = (invert)*(calibrationx - acceleration.x) - (calibrationz-acceleration.z);
}
- (Image*)bonusImages:(int)bonusNum {
	return bonusImages[bonusNum];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	NSString *beginnerLoopPath = [[NSBundle mainBundle] pathForResource:@"beginner" ofType:@"mp3"];
	modeMusic[0] = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:beginnerLoopPath] error:nil];
	modeMusic[0].delegate = self;
	
	NSString *distractedLoopPath = [[NSBundle mainBundle] pathForResource:@"distracted" ofType:@"mp3"];
	modeMusic[1] = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:distractedLoopPath] error:nil];
	modeMusic[1].delegate = self;
	
	NSString *seizurificLoopPath = [[NSBundle mainBundle] pathForResource:@"seizurific" ofType:@"mp3"];
	modeMusic[2] = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:seizurificLoopPath] error:nil];
	modeMusic[2].delegate = self;
	
    player = [[Image alloc] initWithImage:[UIImage imageNamed:@"Shootingman.png"] filter:GL_NEAREST];
	redBalloon = [[Image alloc] initWithImage:[UIImage imageNamed:@"RedBalloon.png"] filter:GL_NEAREST];
	blueBalloon = [[Image alloc] initWithImage:[UIImage imageNamed:@"BlueBalloon.png"] filter:GL_NEAREST];
	bullet = [[Image alloc] initWithImage:[UIImage imageNamed:@"Bullet.png"] filter:GL_NEAREST];
	
	bonusImages[1] = [[Image alloc] initWithImage:[UIImage imageNamed:@"BouncyBullets.png"] filter:GL_NEAREST];
	bonusImages[2] = [[Image alloc] initWithImage:[UIImage imageNamed:@"MachineGun.png"] filter:GL_NEAREST];
	bonusImages[3] = [[Image alloc] initWithImage:[UIImage imageNamed:@"MatrixMode.png"] filter:GL_NEAREST];
	bonusImages[4] = [[Image alloc] initWithImage:[UIImage imageNamed:@"MultiDirShot.png"] filter:GL_NEAREST];
	bonusImages[5] = [[Image alloc] initWithImage:[UIImage imageNamed:@"Nuke.png"] filter:GL_NEAREST];
	bonusImages[6] = [[Image alloc] initWithImage:[UIImage imageNamed:@"PenetrationBullets.png"] filter:GL_NEAREST];
	radioActive = [[Image alloc] initWithImage:[UIImage imageNamed:@"radioactive.png"] filter:GL_NEAREST];
	gameScreen = [[Image alloc] initWithImage:[UIImage imageNamed:@"Game Screen.png"] filter:GL_NEAREST];
	joystick = [[Image alloc] initWithImage:[UIImage imageNamed:@"Joystick.png"] filter:GL_NEAREST];
	
	blueMenuBallVel = CGPointMake((rand()%9)-5, (rand()%9)-5);
	redMenuBallVel = CGPointMake((rand()%9)-5, (rand()%9)-5);
	greenMenuBallVel = CGPointMake((rand()%9)-5, (rand()%9)-5);
	purpleMenuBallVel = CGPointMake((rand()%9)-5, (rand()%9)-5);
	menuTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60 target:self selector:@selector(menuTimer) userInfo:nil repeats:YES];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingString:@"/PlayerData.sav"];
	NSMutableArray *load = [NSMutableArray arrayWithContentsOfFile:filePath];
	if (load) {
		achievedStarsShooting = [[load objectAtIndex:0] intValue];
		NSLog(@"%d",achievedStarsShooting);
		shootingEasyGoal = [[load objectAtIndex:1] boolValue];
		shootingMediumGoal = [[load objectAtIndex:2] boolValue];
		shootingHardGoal = [[load objectAtIndex:3] boolValue];
	}
	
	// configure for accelerometer
	direction = -1;
	[self configureAccelerometer];
    [window addSubview:menuController.view];
    [window makeKeyAndVisible];

    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	[self pauseGame];
	if (menuTimer) {
		[menuTimer invalidate];
		menuTimer = nil;
	}
	menuTimer = nil;
	touch1 = nil;
	touch2 = nil;
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	if ([[window subviews] containsObject:gameView]) {
		[self initializeTimer];
	}
	if ([[window subviews] containsObject:mainMenuView]) {
		menuTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60 target:self selector:@selector(menuTimer) userInfo:nil repeats:YES];
	}
}
- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}
- (void)dealloc {
	if (menuTimer) {
		[menuTimer invalidate];
		menuTimer = nil;
	}
	[self pauseGame];
	if (gameVariables) {
		[gameVariables release];
	}
	for (int i = 0; i < 7; i ++) {
		if (bonusImages[7]) {
			[bonusImages[i] release];
		}
	}
	[player release];
	[redBalloon release];
	[blueBalloon release];
	[bullet release];
	[radioActive release];
	[gameScreen release];
	[joystick release];
	[modeMusic[0] release];
	
	[modeMusic[1] release];
	
	[modeMusic[2] release];
    [menuController release];
    [window release];
    [super dealloc];
}


@end
