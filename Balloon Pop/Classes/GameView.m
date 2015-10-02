#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "GameView.h"
#import "AppDelegate.h"

#define USE_DEPTH_BUFFER 0


@implementation GameView

@synthesize context;


//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder {
    
    if ((self = [super initWithCoder:coder])) {
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            [self release];
            return nil;
        }
		
		//CGRect rect = [[UIScreen mainScreen] bounds];
		
			
		// Set up OpenGL projection matrix
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		glOrthof(0, 480, 0, 320, -1, 1);
		glViewport(0, 0, 480, 320);
		//glTranslatef(-100, -320/2, 0.0f );
		glMatrixMode(GL_MODELVIEW);
		//glTranslatef(-0, -240.0f, 0.0f );
		//glRotatef(180.0f, 0.0f, 0.0f, 1.0f);
		//glScalef(-1.0, 1.0, 1.0);
		
		
		// Initialize OpenGL states
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		//glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
		glDisable(GL_DEPTH_TEST);
		glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_BLEND_SRC);
		glEnableClientState(GL_VERTEX_ARRAY);
		glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
		
		
		//Set up text
		for (int i = 32; i < 127; i ++) {
			NSString* textString = [NSString stringWithFormat:@"%c",i];
			Texture2D* tex = [[Texture2D alloc] initWithString:textString dimensions:[textString sizeWithFont:[UIFont fontWithName:@"Georgia" size:30]] alignment:UITextAlignmentLeft fontName:@"Georgia" fontSize:30];
			textImages[i-32] = [[Image alloc] initWithTexture:tex];
		}
		
		screenDimensions = CGPointMake([self bounds].size.height, [self bounds].size.width);
		//[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
		
	}
    return self;
	
}

- (void)renderScene {
	// Make sure we are renderin to the frame buffer
	[EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	
	// Clear the color buffer with the glClearColor which has been set
	glClear(GL_COLOR_BUFFER_BIT);
	
	AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	
	
	
	[delegate drawGame];
	
	
	// Switch the render buffer and framebuffer so our scene is displayed on the screen
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
	
}

- (void)setOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
		rotationNeg = CGPointMake(-1, 1);
		rotationOffset = CGPointMake(480, 0);
		//Reset Rotation/Translation
		glTranslatef(0-viewTranslationX, 0-viewTranslationY, 0.0f );
		glRotatef(0-viewRotation, 0.0f, 0.0f, 1.0f);
		
		glRotatef(90.0, 0.0f, 0.0f, 1.0f);
		viewRotation = 90.0;
		glTranslatef(0, -320.0, 0.0f );
		viewTranslationY = -320.0;
		viewTranslationX = 0.0;
		//[self setTransform:CGAffineTransformMakeRotation(-M_PI/2)];
		[self setFrame:CGRectMake(0, 0, 320, 480)];
		//[gameView setCenter:CGPointMake(320/4, 320/2)];
		// Set up OpenGL projection matrix
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		glOrthof(0, 320, 0, 480, -1, 1);
		glViewport(0, 0, 320, 480);
		//glTranslatef(-100, -320/2, 0.0f );
		glMatrixMode(GL_MODELVIEW);
		//glTranslatef(-0, -240.0f, 0.0f );
		//glRotatef(180.0f, 0.0f, 0.0f, 1.0f);
		//glScalef(-1.0, 1.0, 1.0);
		
		
		// Initialize OpenGL states
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		//glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
		glDisable(GL_DEPTH_TEST);
		glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_BLEND_SRC);
		glEnableClientState(GL_VERTEX_ARRAY);
		glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
		//[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
	}
	if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		rotationNeg = CGPointMake(1, -1);
		rotationOffset = CGPointMake(0, 320);
		//Reset rotation/translation
		glTranslatef(0-viewTranslationX, 0-viewTranslationY, 0.0f );
		glRotatef(0-viewRotation, 0.0f, 0.0f, 1.0f);
		
		glRotatef(-90.0, 0.0f, 0.0f, 1.0f);
		viewRotation = -90.0;
		glTranslatef(-480.0, 0.0, 0.0f );
		viewTranslationX = -480.0;
		viewTranslationY = 0.0;
		//[self setTransform:CGAffineTransformMakeRotation(M_PI/2)];
		[self setFrame:CGRectMake(0, 0, 320, 480)];
		//[gameView setCenter:CGPointMake(320/4, 320/2)];
		// Set up OpenGL projection matrix
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		glOrthof(0, 320, 0, 480, -1, 1);
		glViewport(0, 0, 320, 480);
		//glTranslatef(-100, -320/2, 0.0f );
		glMatrixMode(GL_MODELVIEW);
		//glTranslatef(-0, -240.0f, 0.0f );
		//glRotatef(180.0f, 0.0f, 0.0f, 1.0f);
		//glScalef(-1.0, 1.0, 1.0);
		
		
		// Initialize OpenGL states
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		//glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
		glDisable(GL_DEPTH_TEST);
		glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_BLEND_SRC);
		glEnableClientState(GL_VERTEX_ARRAY);
		glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
		//[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
	}
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSArray* allTouches = [touches allObjects];
	
	for (int i = 0; i < [allTouches count]; i +=1) {
		if (delegate.touch1 == nil) {
			delegate.touch1 = [allTouches objectAtIndex:i];
			CGPoint touch = CGPointMake([[allTouches objectAtIndex:i] locationInView:self].y*rotationNeg.x+rotationOffset.x, [[allTouches objectAtIndex:i] locationInView:self].x*rotationNeg.y+rotationOffset.y);
			delegate.touchedScreen1 = touch;
			delegate.touch1Start = TRUE;
		} else if (delegate.touch2 == nil) {
			delegate.touch2 = [allTouches objectAtIndex:i];
			CGPoint touch = CGPointMake([[allTouches objectAtIndex:i] locationInView:self].y*rotationNeg.x+rotationOffset.x, [[allTouches objectAtIndex:i] locationInView:self].x*rotationNeg.y+rotationOffset.y);
			delegate.touchedScreen2 = touch;
			delegate.touch2Start = TRUE;
		}
	}
}
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event{
	AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSArray* allTouches = [touches allObjects];
	
	for (int i = 0; i < [allTouches count]; i +=1) {
		if ([allTouches objectAtIndex:i] == delegate.touch1) {
			CGPoint touch = CGPointMake([[allTouches objectAtIndex:i] locationInView:self].y*rotationNeg.x+rotationOffset.x, [[allTouches objectAtIndex:i] locationInView:self].x*rotationNeg.y+rotationOffset.y);
			delegate.touchedScreen1 = touch;
			delegate.touch1Move = TRUE;
		} else if ([allTouches objectAtIndex:i] == delegate.touch2) {
			CGPoint touch = CGPointMake([[allTouches objectAtIndex:i] locationInView:self].y*rotationNeg.x+rotationOffset.x, [[allTouches objectAtIndex:i] locationInView:self].x*rotationNeg.y+rotationOffset.y);
			delegate.touchedScreen2 = touch;
			delegate.touch2Move = TRUE;
		}
	}
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSArray* allTouches = [touches allObjects];
	
	for (int i = 0; i < [allTouches count]; i +=1) {
		if ([allTouches objectAtIndex:i] == delegate.touch1) {
			CGPoint touch = CGPointMake([[allTouches objectAtIndex:i] locationInView:self].y*rotationNeg.x+rotationOffset.x, [[allTouches objectAtIndex:i] locationInView:self].x*rotationNeg.y+rotationOffset.y);
			delegate.touchedScreen1 = touch;
			delegate.touch1 = nil;
			delegate.touch1End = TRUE;
		} else if ([allTouches objectAtIndex:i] == delegate.touch2) {
			CGPoint touch = CGPointMake([[allTouches objectAtIndex:i] locationInView:self].y*rotationNeg.x+rotationOffset.x, [[allTouches objectAtIndex:i] locationInView:self].x*rotationNeg.y+rotationOffset.y);
			delegate.touchedScreen2 = touch;
			delegate.touch2 = nil;
			delegate.touch2End = TRUE;
		}
		
	}
}

- (void)drawImage:(Image*)image AtPoint:(CGPoint)point {
	
	[image renderAtPoint:CGPointMake(point.x, 320-point.y - image.imageHeight) centerOfImage:NO];
}
- (void)drawText:(NSString*)text AtPoint:(CGPoint)point {
	float lastxpoint = 0.0;
	for (int i = 0; i < [text length]; i ++) {
		int charNum = [text characterAtIndex:i]-32;
		CGPoint drawPoint = CGPointMake(point.x + lastxpoint, point.y-3);
		[self drawImage:textImages[charNum] AtPoint:drawPoint];
		lastxpoint += textImages[charNum].imageWidth;
	}
}

- (void)drawRect:(CGRect)rect color:(float[])color {
	/**
	 GLfloat vertx[4*2];
	 
	 vertx[2] = rect.origin.x;
	 vertx[3] = 320-rect.origin.y;
	 vertx[0] = rect.size.width;
	 vertx[1] = 320-rect.origin.y;
	 vertx[4] = rect.size.width;
	 vertx[5] = 320-rect.size.height;
	 vertx[6] = rect.origin.x;
	 vertx[7] = 320-rect.size.height;
	 
	 GLfloat colors[4 * 4];
	 
	 for(int i = 0; i < 4 * 4; i++) {
	 colors[i] = color[0];
	 colors[++i] = color[1];
	 colors[++i] = color[2];
	 colors[++i] = color[3];
	 }
	 glEnable(GL_BLEND);
	 //glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
	 glDisable(GL_DEPTH_TEST);
	 
	 glVertexPointer(2, GL_FLOAT, 0, vertx);
	 glEnableClientState(GL_VERTEX_ARRAY);
	 glColorPointer(4, GL_FLOAT, 0, colors);
	 glEnableClientState(GL_COLOR_ARRAY);
	 glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	 glDisableClientState(GL_COLOR_ARRAY);
	 
	 //glEnable(GL_DEPTH_TEST);
	 glDisable(GL_BLEND);
	 **/
	// Replace the implementation of this method to do your own custom drawing
	
	GLfloat squareVertices[] = {
        rect.origin.x,  320-rect.origin.y,
		rect.size.width, 320-rect.origin.y,
        rect.origin.x,  320-rect.size.height,
		rect.size.width,  320-rect.size.height,
    };
	
	GLubyte squareColors[] = {
        255*color[0], 255*color[1],   255*color[2], 255*color[3],
        255*color[0], 255*color[1],   255*color[2], 255*color[3],
        255*color[0], 255*color[1],   255*color[2], 255*color[3],
        255*color[0], 255*color[1],   255*color[2], 255*color[3],
    };
	glEnable(GL_BLEND);
	
    glVertexPointer(2, GL_FLOAT, 0, squareVertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
    glEnableClientState(GL_COLOR_ARRAY);
	
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	glDisableClientState(GL_COLOR_ARRAY);
	
	glDisable(GL_BLEND);
	
}

- (BOOL) collisionOfCircles:(CGPoint)c1 rad:(float)c1r c2:(CGPoint)c2 rad:(float)c2r  {
	float a, dx, dy, d, h, rx, ry;
	float x2, y2;
	
	/* dx and dy are the vertical and horizontal distances between
	 * the circle centers.
	 */
	dx = c2.x - c1.x;
	dy = c2.y - c1.y;
	
	/* Determine the straight-line distance between the centers. */
	//d = sqrt((dy*dy) + (dx*dx));
	d = hypot(dx,dy); // Suggested by Keith Briggs
	
	/* Check for solvability. */
	if (d > (c1r + c2r))
	{
		/* no solution. circles do not intersect. */
		return FALSE;
	}
	if (d < abs(c1r - c2r))
	{
		/* no solution. one circle is contained in the other */
		return TRUE;
	}
	
	/* 'point 2' is the point where the line through the circle
	 * intersection points crosses the line between the circle
	 * centers.  
	 */
	
	/* Determine the distance from point 0 to point 2. */
	a = ((c1r*c1r) - (c2r*c2r) + (d*d)) / (2.0 * d) ;
	
	/* Determine the coordinates of point 2. */
	x2 = c1.x + (dx * a/d);
	y2 = c1.y + (dy * a/d);
	
	/* Determine the distance from point 2 to either of the
	 * intersection points.
	 */
	h = sqrt((c1r*c1r) - (a*a));
	
	/* Now determine the offsets of the intersection points from
	 * point 2.
	 */
	rx = -dy * (h/d);
	ry = dx * (h/d);
	
	/* Determine the absolute intersection points. */
	
	return TRUE;
}

- (void)layoutSubviews {
    [EAGLContext setCurrentContext:context];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self renderScene];
}
- (BOOL)createFramebuffer {
    
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (USE_DEPTH_BUFFER) {
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}
- (void)destroyFramebuffer {
    
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}
+ (Class)layerClass {
    return [CAEAGLLayer class];
}


- (void)dealloc {
	for (int i = 0; i < 95; i ++) {
		[textImages[i] release];
	}
	if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [context release];  
    [super dealloc];
}

@end
