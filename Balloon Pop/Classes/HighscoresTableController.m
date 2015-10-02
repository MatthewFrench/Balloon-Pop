#import "HighscoresTableController.h"
#import "AppDelegate.h"

#define USE_CUSTOM_DRAWING 1

@implementation HighscoresTableController

@synthesize tableView;

//
// viewDidLoad
//
// Configures the table after it is loaded.
//
- (id)init{
    self = [super init];
    if (self) {
		//
		// Change the properties of the imageView and tableView (these could be set
		// in interface builder instead).
		//
		tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		tableView.rowHeight = 100;
		tableView.backgroundColor = [UIColor clearColor];
		
		//
		// Create a header view. Wrap it in a container to allow us to position
		// it better.
		//
		UIView *containerView =
		[[[UIView alloc]
		  initWithFrame:CGRectMake(0, 0, 300, 60)]
		 autorelease];
		UILabel *headerLabel =
		[[[UILabel alloc]
		  initWithFrame:CGRectMake(10, 20, 300, 40)]
		 autorelease];
		headerLabel.text = NSLocalizedString(@"Header for the table", @"");
		headerLabel.textColor = [UIColor whiteColor];
		headerLabel.shadowColor = [UIColor blackColor];
		headerLabel.shadowOffset = CGSizeMake(0, 1);
		headerLabel.font = [UIFont boldSystemFontOfSize:22];
		headerLabel.backgroundColor = [UIColor clearColor];
		[containerView addSubview:headerLabel];
		self.tableView.tableHeaderView = containerView;
		tableView.backgroundColor = [UIColor clearColor];
		
		
		//Cocos Live Stuff
		globalScores[0] = [NSMutableArray new];
		globalScores[1] = [NSMutableArray new];
		globalScores[2] = [NSMutableArray new];
		category = kCategoryEasy;
		world = kAll;
		requestList = [NSMutableArray new];
    }
    return self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	self.tableView.backgroundColor = [UIColor clearColor];
	return [globalScores[[difficulty selectedSegmentIndex]] count]+1;
}
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	//NSLog(@"Updating Cell");
	
	
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell =
		[[[UITableViewCell alloc]
		  initWithFrame:CGRectZero
		  reuseIdentifier:CellIdentifier]
		 autorelease];
		[cell setOpaque:NO];
	}
	
	if ([indexPath row] == 0) {
		cell.textLabel.text = @"# | Player Name  Score  Area";
	} else {
		NSDictionary	*s = [globalScores[[difficulty selectedSegmentIndex]] objectAtIndex:[indexPath row]-1];
		cell.textLabel.text = [NSString stringWithFormat:@"%d | %@", [[s objectForKey:@"position"] intValue]+1
						   ,[s objectForKey:@"cc_playername"]];
		UILabel* scoreLbl = [[UILabel alloc] initWithFrame:CGRectMake(160, 13, 100, 20)];
		scoreLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
		scoreLbl.text = [NSString stringWithFormat:@"%d",[[s objectForKey:@"cc_score"] intValue]];
		[cell addSubview:scoreLbl];
		[scoreLbl autorelease];
		
		UILabel* areaLbl = [[UILabel alloc] initWithFrame:CGRectMake(220, 13, 80, 20)];
		areaLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
		areaLbl.text = [NSString stringWithFormat:@"%@",[s objectForKey:@"cc_country"]];
		[cell addSubview:areaLbl];
		[areaLbl autorelease];
	}
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	//[delegate selectedTrainingMode:indexPath.row];
	//[self.tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}
- (void)dealloc{
	[tableView release];
	[super dealloc];
}

- (IBAction)postHighscores:(id)sender {
	UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Insert Your Name:" message:@"this gets covered" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	textfield = [[UITextField alloc] init];
	textfield.delegate = self;
	textfield.opaque = YES;
	textfield.borderStyle = UITextBorderStyleRoundedRect;
	if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0) {
		textfield.frame = CGRectMake(30, 45, 220, 25.0); 
		myAlertView.transform = CGAffineTransformTranslate( myAlertView.transform, 0, 80 );
	} else {
		textfield.frame = CGRectMake(30, 33, 220, 25.0); 
		myAlertView.transform = CGAffineTransformTranslate( myAlertView.transform, 0, 0 );
	}
	textfield.textAlignment = UITextAlignmentCenter;
	textfield.keyboardType = UIKeyboardTypeDefault;
	textfield.returnKeyType = UIReturnKeyDone;
	textfield.autocapitalizationType = UITextAutocorrectionTypeNo;
	[textfield setEnablesReturnKeyAutomatically:FALSE];
	[textfield becomeFirstResponder];
	[myAlertView addSubview:textfield];
	[textfield release];
	[myAlertView show];
	[myAlertView release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	if (buttonIndex == 1) {
		if ([[textfield text] length] > 0) {
			[textfield resignFirstResponder];
			//scoreScreenFinishedTouching = FALSE;
			NSString* username = [textfield text];
			//[playerUsername retain];
			//currentView = PersonalHighscores;
			
			//[personalScores[viewScores] release];
			//personalScores[viewScores] = nil;
			//Now get the scores
			//NSMutableArray* test; //Make test cause if you put the array of nsarrays though this it'll blow up.
			//if (trainingMode == 1) {
			//	test = [self openFileInDocs:@"scores1.txt"];
			//}
			//if (trainingMode == 2) {
			//	test = [self openFileInDocs:@"scores2.txt"];
			//}
			//if (trainingMode == 3) {
			//	test = [self openFileInDocs:@"scores3.txt"];
			//}
			//f (test == nil) {
			//	test = [NSMutableArray new];
			//}
			//personalScores[viewScores] = test;
			
			//Now insert score
			//NSMutableDictionary *thisScore = [[NSMutableDictionary alloc]init];
			//[thisScore setObject:playerUsername forKey:@"cc_playername"];
			//[thisScore setObject:[NSNumber numberWithInt:delegate.gameVariables.balloonPopCount] forKey:@"cc_score"];
			//if ([personalScores[viewScores] count] > 0) {
			//	int insertPosition = [personalScores[viewScores] count];
			//	for (int i = 0; i < [personalScores[viewScores] count]; i++) {
			//		NSDictionary* getScore = [personalScores[viewScores] objectAtIndex:i];
			//		if ([[getScore objectForKey:@"cc_score"] intValue] < (int)balloonPopCount) {
			//			insertPosition = i;
			//			i = [personalScores[viewScores] count];
			//		}
			//	}
			//	[personalScores[viewScores] insertObject:(NSDictionary*)thisScore atIndex:insertPosition];
			//} else {
			//	[personalScores[viewScores] addObject:(NSDictionary*)thisScore];[thisScore release];
			//}
			//Now save the scores
			//if (trainingMode == 1) {
			//	[self saveFileInDocs:@"scores1.txt" object:personalScores[viewScores]];
			//}
			//if (trainingMode == 2) {
			//	[self saveFileInDocs:@"scores2.txt" object:personalScores[viewScores]];
			//}
			//if (trainingMode == 3) {
			//	[self saveFileInDocs:@"scores3.txt" object:personalScores[viewScores]];
			//}
			
			//Now start loading global scores ahead of schedule
			[self postScore:username];
			[delegate toHighscores:nil];
			//globalHighscoresLoading = TRUE;
		}
	}
	//updateScreen = TRUE;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	if (textField.text.length >= 12 && range.length == 0)
	{
		return NO; // return NO to not change text
	}else{
		return YES;
	}
}

- (IBAction) scoreHit:(UISegmentedControl*)sender {
	[self requestScore];
}

//Cocos Live stuff
-(void) requestScore{
	
	[tableView reloadData];
	
	NSString *cat = @"Classic";
	if ([difficulty selectedSegmentIndex] == 0 && !requestingEasy) {cat = @"BeginnerShoot"; requestingEasy = TRUE;}
	if ([difficulty selectedSegmentIndex] == 1 && !requestingMedium) {cat = @"DistractedShoot"; requestingMedium = TRUE;}
	if ([difficulty selectedSegmentIndex] == 2 && !requestingHard) {cat = @"SeizurificShoot"; requestingHard = TRUE;}
	
	if (![cat isEqualToString:@"Classic"]) {
	
	CLScoreServerRequest *request = [[CLScoreServerRequest alloc] initWithGameName:@"Balloon Pop" delegate:self];
	
	[requestList addObject:[NSNumber numberWithInt:[difficulty selectedSegmentIndex]]];
	
	// The only supported flags as of v0.2 is kQueryFlagByCountry and kQueryFlagByDevice
	tQueryFlags flags = kQueryFlagIgnore;
	if( world == kCountry )
		flags = kQueryFlagByCountry;
	else if(world == kDevice )
		flags = kQueryFlagByDevice;
	
	// request All time Scores: the only supported version as of v0.2
	// request best 15 scores (limit:15, offset:0)
	[request requestScores:kQueryAllTime limit:20 offset:0 flags:flags category:cat];
	
	
	
	// Release. It won't be freed from memory until the connection fails or suceeds
	[request release];
	}
}

-(void) postScore:(NSString*)username{
	AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	
	
	//NSLog(@"Posting Score");
	
	// Create que "post" object for the game "DemoGame 3"
	// The gameKey is the secret key that is generated when you create you game in cocos live.
	// This secret key is used to prevent spoofing the high scores
	CLScoreServerPost *server = [[CLScoreServerPost alloc] initWithGameName:@"Balloon Pop" gameKey:@"eb223c6e495fa9d712cc96265e495840" delegate:self];
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
	
	// cc_ files are predefined cocoslive fields.
	// set score
	[dict setObject: [NSNumber numberWithInt: delegate.gameVariables.balloonPopCount ] forKey:@"cc_score"];
	
	// set playername
	[dict setObject:username forKey:@"cc_playername"];
	
	
	// cc_ are fields that cannot be modified. cocos fields
	// set category... it can be "easy", "medium", whatever you want.
	NSString *cat = @"Classic";
	if (delegate.chosenDifficulty == 1) {cat = @"BeginnerShoot";}
	if (delegate.chosenDifficulty == 2) {cat = @"DistractedShoot";}
	if (delegate.chosenDifficulty == 3) {cat = @"SeizurificShoot";}
	
	[dict setObject:cat forKey:@"cc_category"];
	
	//NSLog(@"Sending data: %@", dict);
	
	// You can add a new score to the database
	//	[server sendScore:dict];
	
	// Or you can "update" your score instead of adding a new one.
	// The score will be udpated only if it is better than the previous one
	// 
	// "update score" is the recommend way since it can be treated like a profile
	// and it has some benefits like: "tell me if my score was beaten", etc.
	// It also supports "world ranking". eg: "What's my ranking ?"
	[server updateScore:dict];
	
	// Release. It won't be freed from memory until the connection fails or suceeds
	[server release];
}

#pragma mark -
#pragma mark ScorePost Delegate

-(void) scorePostOk: (id) sender{
	//NSLog(@"score post OK");
	[self requestScore];
	/**
	 if( [sender ranking] != kServerPostInvalidRanking && [sender scoreDidUpdate]) {
	 NSString *message = [NSString stringWithFormat:@"World ranking: %d", [sender ranking]];
	 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Post Ok." message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];	
	 alert.tag = 2;
	 [alert show];
	 [alert release];		
	 
	 }
	 **/
}

-(void) scorePostFail: (id) sender{
	//if (currentView == GlobalHighscores) {
		NSString *message = nil;
		tPostStatus status = [sender postStatus];
		if( status == kPostStatusPostFailed )
			message = @"Could not post the score to the server.";
		else if( status == kPostStatusConnectionFailed )
			message = @"Internet connection not available. Enable wi-fi / 3g to post your scores to the server";
		
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Score Post Failed" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];	
		alert.tag = 0;
		[alert show];
		[alert release];
		//currentView = MainScreen;
	//}
}

#pragma mark -
#pragma mark ScoreRequest Delegate

-(void) scoreRequestOk: (id) sender{
	//NSLog(@"score request OK");
	NSArray *scores = [sender parseScores];	
	NSMutableArray *mutable = [NSMutableArray arrayWithArray:scores];
	// use the property (retain is needed)
	
	[globalScores[[[requestList objectAtIndex:0] intValue]] release];
	if (mutable) {
		globalScores[[[requestList objectAtIndex:0] intValue]] = mutable;
		[globalScores[[[requestList objectAtIndex:0] intValue]] retain];
	} else {
		globalScores[[[requestList objectAtIndex:0] intValue]] = [[NSMutableArray alloc] init];
	}
	
	if ([[requestList objectAtIndex:0] intValue] == 0) {requestingEasy = FALSE;}
	if ([[requestList objectAtIndex:0] intValue] == 1) {requestingMedium = FALSE;}
	if ([[requestList objectAtIndex:0] intValue] == 2) {requestingHard = FALSE;}

	[requestList removeObjectAtIndex:0];
	
	[tableView reloadData];
}

-(void) scoreRequestFail: (id) sender{
	//NSLog(@"score request fail");
	//if (currentView == GlobalHighscores) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Score Request Failed" message:@"Internet connection not available, cannot view world scores" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];	
		alert.tag = 0;
		[alert show];
		[alert release];
	//}
	if ([[requestList objectAtIndex:0] intValue] == 0) {requestingEasy = FALSE;}
	if ([[requestList objectAtIndex:0] intValue] == 1) {requestingMedium = FALSE;}
	if ([[requestList objectAtIndex:0] intValue] == 2) {requestingHard = FALSE;}
	[requestList removeObjectAtIndex:0];
}


@end


