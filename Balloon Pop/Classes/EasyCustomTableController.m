//
//  EasyCustomTableController.m
//  EasyCustomTable
//
//  Created by Matt Gallagher on 27/04/09.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "EasyCustomTableController.h"
#import "AppDelegate.h"

#define USE_CUSTOM_DRAWING 1

@implementation EasyCustomTableController

@synthesize tableView;

//
// viewDidLoad
//
// Configures the table after it is loaded.
//
- (id)init
{
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
    }
    return self;
}
//
// numberOfSectionsInTableView:
//
// Return the number of sections for the table.
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

//
// tableView:numberOfRowsInSection:
//
// Returns the number of rows in a given section.
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

//
// tableView:cellForRowAtIndexPath:
//
// Returns the cell for a given indexPath.
//
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	const NSInteger TOP_LABEL_TAG = 1001;
	const NSInteger BOTTOM_LABEL_TAG = 1002;
	UILabel *topLabel;
	UILabel *bottomLabel;

	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		//
		// Create the cell.
		//
		cell =
			[[[UITableViewCell alloc]
				initWithFrame:CGRectZero
				reuseIdentifier:CellIdentifier]
			autorelease];

		UIImage *indicatorImage = [UIImage imageNamed:@"indicator.png"];
		cell.accessoryView =
			[[[UIImageView alloc]
				initWithImage:indicatorImage]
			autorelease];
		
		const CGFloat LABEL_HEIGHT = 20;
		UIImage *image;
		AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
		if (delegate.achievedStarsShooting == 0) {
			image = [UIImage imageNamed:@"imageA.png"];
		} else if (delegate.achievedStarsShooting == 1) {
			image = [UIImage imageNamed:@"imageB.png"];
		} else if (delegate.achievedStarsShooting == 2) {
			image = [UIImage imageNamed:@"imageC.png"];
		} else if (delegate.achievedStarsShooting == 3) {
			image = [UIImage imageNamed:@"imageD.png"];
		}

		//
		// Create the label for the top row of text
		//
		topLabel =
			[[[UILabel alloc]
				initWithFrame:
					CGRectMake(
						image.size.width + 2.0 * cell.indentationWidth,
						0.5 * (aTableView.rowHeight - 2 * LABEL_HEIGHT),
						aTableView.bounds.size.width -
							image.size.width - 4.0 * cell.indentationWidth
								- indicatorImage.size.width,
						LABEL_HEIGHT)]
			autorelease];
		[cell.contentView addSubview:topLabel];

		//
		// Configure the properties for the text that are the same on every row
		//
		topLabel.tag = TOP_LABEL_TAG;
		topLabel.backgroundColor = [UIColor clearColor];
		topLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
		topLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		topLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];

		//
		// Create the label for the top row of text
		//
		bottomLabel =
			[[[UILabel alloc]
				initWithFrame:
					CGRectMake(
						image.size.width + 2.0 * cell.indentationWidth,
						0.5 * (aTableView.rowHeight - 2 * LABEL_HEIGHT) + LABEL_HEIGHT,
						aTableView.bounds.size.width -
							image.size.width - 4.0 * cell.indentationWidth
								- indicatorImage.size.width,
						LABEL_HEIGHT)]
			autorelease];
		[cell.contentView addSubview:bottomLabel];

		//
		// Configure the properties for the text that are the same on every row
		//
		bottomLabel.tag = BOTTOM_LABEL_TAG;
		bottomLabel.backgroundColor = [UIColor clearColor];
		bottomLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
		bottomLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		bottomLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 2];

		//
		// Create a background image view.
		//
		cell.backgroundView =
			[[[UIImageView alloc] init] autorelease];
		cell.selectedBackgroundView =
			[[[UIImageView alloc] init] autorelease];
	}

	else
	{
		topLabel = (UILabel *)[cell viewWithTag:TOP_LABEL_TAG];
		bottomLabel = (UILabel *)[cell viewWithTag:BOTTOM_LABEL_TAG];
	}
	
	if (indexPath.row == 0) {
		topLabel.text = [NSString stringWithFormat:@"Speed Shooting", [indexPath row]];
		bottomLabel.text = [NSString stringWithFormat:@"Train your firing speed.", [indexPath row]];
	} else if (indexPath.row == 1) {
		topLabel.text = [NSString stringWithFormat:@"Obstacle Course", [indexPath row]];
		bottomLabel.text = [NSString stringWithFormat:@"Get through as fast as you can...", [indexPath row]];
	}
	
	//
	// Set the background and selected background images for the text.
	// Since we will round the corners at the top and bottom of sections, we
	// need to conditionally choose the images based on the row index and the
	// number of rows in the section.
	//
	UIImage *rowBackground;
	UIImage *selectionBackground;
	NSInteger sectionRows = [aTableView numberOfRowsInSection:[indexPath section]];
	NSInteger row = [indexPath row];
	if (row == 0 && row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
	}
	else if (row == 0)
	{
		rowBackground = [UIImage imageNamed:@"topRow.png"];
		selectionBackground = [UIImage imageNamed:@"topRowSelected.png"];
	}
	else if (row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"bottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"bottomRowSelected.png"];
	}
	else
	{
		rowBackground = [UIImage imageNamed:@"middleRow.png"];
		selectionBackground = [UIImage imageNamed:@"middleRowSelected.png"];
	}
	((UIImageView *)cell.backgroundView).image = rowBackground;
	((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
	
	//
	// Here I set an image based on the row. This is just to have something
	// colorful to show on each row.
	//
		//cell.image
	AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	if (delegate.achievedStarsShooting == 0) {
		cell.imageView.image = [UIImage imageNamed:@"imageA.png"];
	} else if (delegate.achievedStarsShooting == 1) {
		cell.imageView.image = [UIImage imageNamed:@"imageB.png"];
	} else if (delegate.achievedStarsShooting == 2) {
		cell.imageView.image = [UIImage imageNamed:@"imageC.png"];
	} else if (delegate.achievedStarsShooting == 3) {
		cell.imageView.image = [UIImage imageNamed:@"imageD.png"];
	}

	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	[delegate selectedTrainingMode:indexPath.row];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}

//
// dealloc
//
// Releases instance memory.
//
- (void)dealloc
{
	[tableView release];
	[super dealloc];
}


@end


