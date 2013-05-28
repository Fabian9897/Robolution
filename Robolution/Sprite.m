#import "Sprite.h"
#import "constants.h"

@implementation Sprite
@synthesize mask;

- (id) initWithImageResource:(id)resource spriteTyp:(double)sTyp parentView:(UIView *)parentView

{
  if (self = [super init]) {
      if ([[resource class] isSubclassOfClass:[UIImage class ]]) {
          _pic = [[UIImageView alloc] initWithImage:resource];

          
      }
      else if ( [[resource class] isSubclassOfClass:[NSArray class]]){
          _pic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) )];
          _pic.animationImages = resource;
      }
    _pic.hidden = YES;
    [self addSubview:_pic];
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
  _pic.frame = CGRectMake(_pic.frame.origin.x,
                         _pic.frame.origin.y,
                         img.size.width,
                         img.size.height);
  _pic.image = img;
  spriteTyp = sTyp;
}

- (void) setSprites: (NSArray *) images
{
    
    _pic.animationImages = images;
 
}

- (void) setAnimationTyp: (NSArray *) img
                     spriteTyp: (int) sTyp
                duration: (double) duration
                  repeat: (int) repeat {
    _pic.animationImages = img;
    _pic.animationDuration = duration;
    _pic.animationRepeatCount = repeat;
    [_pic startAnimating];
    spriteTyp = sTyp;
}

- (void) moveBy: (double) x
      y: (double) y {
  _pic.center = CGPointMake(_pic.center.x+x, _pic.center.y+y);
}

- (void) setCenter: (double) x
         y: (double) y {
  _pic.center = CGPointMake(x, y);
  _pic.hidden = NO;
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
        CGRect sMask = CGRectMake(_pic.frame.origin.x + rect.origin.x,
                                  _pic.frame.origin.y + rect.origin.y,
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
  _pic.transform = CGAffineTransformMakeScale(direction,1);
}

- (CGRect) frame
{
    return _pic.frame;
}
- (void)setFrame:(CGRect)frame{
    _pic.frame = frame;
}
- (CGPoint) center {return _pic.center;}
- (int) spriteTyp { return spriteTyp; }
- (int) movingDirection { return movingDirection; }
- (void) setMovingDirection: (int) a {movingDirection = a;}
- (void) setAlpha: (float) a {_pic.alpha = a;};


- (void) setId: (int) a {sId=a;}
- (int) sId {return sId;}
- (void) setShieldPower: (int) a  {shieldPower=a;}
- (int) shieldPower {return shieldPower;}

@end
