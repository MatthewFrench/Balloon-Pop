#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Menu.h"
#import "GameView.h"
#import "Texture2D.h"
#import "Image.h"
#import "Sprite.h"
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>
#import "GameVariables.h"
#import "HighscoresTableController.h"
#import "EasyCustomTableController.h"

@interface AppDelegate : NSObject <UIApplicationDelegate,AVAudioPlayerDelegate, UIAlertViewDelegate,UIAccelerometerDelegate> {
    UIWindow *window;
    Menu *menuController;
	CADisplayLink* theTimer;
	CFTimeInterval fpsCounter;
	
	 CGPoint touchedScreen1;
	 UITouch* touch1;
	 CGPoint touchedScreen2;
	 UITouch* touch2;
	BOOL touch1Start,touch1Move,touch1End,touch2Start,touch2Move,touch2End;
	
	NSTimer* menuTimer;
	
	IBOutlet GameView *gameView;
	IBOutlet UIView *mainMenuView,*instructionsView,*creditsView,*trainingModesView,*speedShooting,*scoreView,*highscoresView;
	IBOutlet UIImageView *blueMenuBall,*redMenuBall,*purpleMenuBall,*greenMenuBall;
	IBOutlet UIButton *ssBeginnerBtn, *ssDistractedBtn, *ssSeizurificBtn;
	CGPoint blueMenuBallVel,redMenuBallVel,greenMenuBallVel,purpleMenuBallVel;
	
	int chosenGame, chosenDifficulty;
	GameVariables* gameVariables;
	BOOL invertedAccelerometer;
	float movementx,movementy,direction;
	float calibrationx,calibrationy,calibrationz;
	BOOL calibrated;
	
	Image *bonusImages[7],*player, *redBalloon, *blueBalloon, *bullet, *radioActive,*gameScreen,*joystick;
	
	IBOutlet UILabel *scoreLbl,*goalLbl;
	IBOutlet UIImageView *goalImage;
	
	IBOutlet HighscoresTableController* highscoresTableData;
	
	AVAudioPlayer *modeMusic[3];
	
	//Save Data for shooting
	int achievedStarsShooting;
	BOOL shootingEasyGoal,shootingMediumGoal,shootingHardGoal;
	
	IBOutlet UIImageView* beginnerStar,* mediumStar,* hardStar;
	
	IBOutlet UITableView* levelTable;
}
- (IBAction)clearGameData:(id)sender;
- (IBAction)toInstructions:(id)sender;
- (IBAction)toMenu:(id)sender;
- (IBAction)toCredits:(id)sender;
- (IBAction)toGameScreen:(id)sender;
- (IBAction)toTrainingModes:(id)sender;
- (IBAction)exitTrainingMode:(id)sender;
- (IBAction)toHighscores:(id)sender;
- (IBAction)exitHighscores:(id)sender;
- (void)pauseGame;
- (void)initializeTimer;
- (void)gameLogic;
- (void)drawGame;
- (void)switchView:(UIView*)oldView to:(UIView*)newView with:(UIViewAnimationTransition)trans time:(float)sec;
- (void)animationFinished;
- (void)selectedTrainingMode:(int)mode;
- (void)switchView:(UIView*)oldView to:(UIView*)newView with:(CATransition*)trans;
- (void)menuTimer;
- (void)initializeGame;
- (void)configureAccelerometer;
- (Image*)bonusImages:(int)bonusNum;
- (void)finishedGame;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Menu *menuController;

@property (nonatomic, assign) CGPoint touchedScreen1,touchedScreen2;
@property (nonatomic, assign) UITouch *touch1, *touch2;
@property (nonatomic) BOOL touch1Start,touch1Move,touch1End,touch2Start,touch2Move,touch2End;

@property (nonatomic, assign) Image *player, *redBalloon, *blueBalloon, *bullet, *radioActive, *gameScreen,*joystick;

@property (nonatomic) float movementx,movementy;

@property (nonatomic, assign) GameView* gameView;
@property (nonatomic, assign) IBOutlet UISegmentedControl* ssTiltJoystick;

@property (nonatomic) int chosenGame, chosenDifficulty, achievedStarsShooting;
@property (nonatomic,assign) GameVariables* gameVariables;

@end

