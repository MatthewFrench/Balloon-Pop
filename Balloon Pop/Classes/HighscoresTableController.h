#import <UIKit/UIKit.h>

//Cocos Live stuff
#import "cocoslive.h"
enum {
	kCategoryEasy = 0,
	kCategoryMedium = 1,
	kCategoryHard = 2,
};

enum {
	kAll = 0,
	kCountry = 1,
	kDevice = 2,
};

@interface HighscoresTableController : NSObject<UITextFieldDelegate>
{
	UITableView *tableView;
	
	//Cocos live stuff:
	// scores category
	int			category;
	// scores world
	int			world;
	
	NSMutableArray *globalScores[3];
	NSMutableArray* requestList;
	
	
	IBOutlet UISegmentedControl* difficulty;
	UITextField* textfield;
	
	BOOL requestingEasy,requestingMedium,requestingHard;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
- (IBAction) scoreHit:(UISegmentedControl*)sender;
- (IBAction)postHighscores:(id)sender;
-(void) postScore:(NSString*)username;
-(void) requestScore;

@end

