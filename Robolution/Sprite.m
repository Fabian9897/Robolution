#import "Sprite.h"
#import "constants.h"

@implementation Sprite
@synthesize pic, mask;

- (id) initWithImage: (UIImage *) img
     spriteTyp: (double) sTyp
    parentView: (UIView *) parentView {
  if (self == [super init]) {
    pic = [[UIImageView alloc] initWithImage:img];
    pic.hidden = YES;
    [self addSubview:pic];
    [parentView addSubview:self];
    spriteTyp = sTyp;
    movingDirection = right;
        mask = [[NSMutableArray alloc] init];
        [mask addObject:[NSValue valueWithCGRect:CGRectMake(0, 0, 1,1)]];
  }
  return self;
}

- (void) addMask: (double) x 
               y:(double) y 
           width:(double)width 
          height:(double)height {
    [mask addObject:[NSValue valueWithCGRect:CGRectMake(x, y, width, height)]];
}


- (void) setSpriteTyp: (UIImage *) img
                  typ: (int) sTyp {
  pic.frame = CGRectMake(pic.frame.origin.x,
                         pic.frame.origin.y,
                         img.size.width,
                         img.size.height);
  pic.image = img;
  spriteTyp = sTyp;
}

- (void) setAnimationTyp: (NSArray *) img
                     spriteTyp: (int) sTyp
                duration: (double) duration
                  repeat: (int) repeat {
    pic.animationImages = img;
    pic.animationDuration = duration;
    pic.animationRepeatCount = repeat;
    [pic startAnimating];
    spriteTyp = sTyp;
}

- (void) moveBy: (double) x
      y: (double) y {
  pic.center = CGPointMake(pic.center.x+x, pic.center.y+y);
}

- (void) setCenter: (double) x
         y: (double) y {
  pic.center = CGPointMake(x, y);
  pic.hidden = NO;
}

- (bool) detectCollisionWith: (Sprite *) sprite {
  if (CGRectIntersectsRect(self.frame, sprite.frame)) {
    return YES;
  }
  return NO;
}

- (bool) detectCollisionWithMask: (Sprite *) sprite {
    bool collision = NO;
    // Alle Masken des Sprites durchtesten
    for (int p=0;p<[mask count]; p++) {
        //CGRect aus Array holen
        CGRect rect = [[mask objectAtIndex:p] CGRectValue];
        // Koordinatenaddition
        CGRect sMask = CGRectMake(pic.frame.origin.x + rect.origin.x,
                                  pic.frame.origin.y + rect.origin.y,
                                  rect.size.width,
                                  rect.size.height);
        // eigentliche Kollisionsabfrage
        if (CGRectIntersectsRect(sprite.frame, sMask)){
            collision = YES;
        }
    }
  return collision;
}

- (void) mirrorSprite:(int) direction {
  pic.transform = CGAffineTransformMakeScale(direction,1);
}

- (CGRect) frame {return pic.frame;}
- (CGPoint) center {return pic.center;}
- (int) spriteTyp { return spriteTyp; }
- (int) movingDirection { return movingDirection; }
- (void) setMovingDirection: (int) a {movingDirection = a;}
- (void) setAlpha: (float) a {pic.alpha = a;};


- (void) setId: (int) a {sId=a;}
- (int) sId {return sId;}
- (void) setShieldPower: (int) a  {shieldPower=a;}
- (int) shieldPower {return shieldPower;}

@end
