#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "Texture2D.h"
#import "Image.h"

@interface GameView : UIView {
	CGPoint screenDimensions;
	CGPoint rotationOffset;
	CGPoint rotationNeg;
	float viewRotation,viewTranslationX,viewTranslationY;
	Image* textImages[95];
@private
    /* The pixel dimensions of the backbuffer */
    GLint backingWidth;
    GLint backingHeight;
    
    EAGLContext *context;
    
    /* OpenGL names for the renderbuffer and framebuffers used to render to this view */
    GLuint viewRenderbuffer, viewFramebuffer;
    
    /* OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist) */
    GLuint depthRenderbuffer;
}
@property (nonatomic, retain) EAGLContext *context;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;
- (void) renderScene;
- (void) drawImage:(Image*)image AtPoint:(CGPoint)point;
- (void)drawText:(NSString*)text AtPoint:(CGPoint)point;
- (void) drawRect:(CGRect)rect color:(float[])color;
- (void)setOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (BOOL) collisionOfCircles:(CGPoint)c1 rad:(float)c1r c2:(CGPoint)c2 rad:(float)c2r;
@end
