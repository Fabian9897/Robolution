#import <UIKit/UIKit.h>

@interface Sprite : UIView {
     NSMutableArray *mask;
  int spriteTyp;
  int movingDirection;
    int sId;
  int shieldPower;
}

@property (nonatomic, strong) UIImageView *pic;
@property (nonatomic, strong) NSMutableArray *mask;
@property (nonatomic) BOOL isVisible;
@property (nonatomic) BOOL animationFlag;

- (id) initWithImageResource: (id) resource
     spriteTyp: (double) sTyp
    parentView: (UIView*) parentView;

- (void) addMask: (double) x 
               y:(double) y 
           width:(double)width 
          height:(double)height;

- (void) setSpriteTyp: (UIImage *) img
                  typ: (int) sTyp;

- (void) setAnimationTyp: (NSArray *) img
               spriteTyp: (int) sTyp
                duration: (double) duration
                  repeat: (int) repeat;

- (void) moveBy: (double) x
      y: (double) y;

- (void) setCenter: (double) x
      y: (double) y;

- (bool) detectCollisionWith: (Sprite *) sprite;
- (bool) detectCollisionWithMask: (Sprite *) sprite;

- (CGPoint) center;
- (int) spriteTyp;
- (int) movingDirection;
- (void) setMovingDirection: (int) a;
- (void) setAlpha: (float) a;
- (void) mirrorSprite: (int) a;
- (void) setId: (int) a;
- (int) sId;
- (void) setShieldPower: (int) a;
- (int) shieldPower;
//- (void) deleteSprite;

@end

