//
//  ViewController.m
//  Robolution
//
//  Created by Fabian Töpfer on 10.05.13.
//  Copyright (c) 2013 baniaf. All rights reserved.
//
#import "ViewController.h"
#import "Sprite.h"
#include "constants.h"


@implementation ViewController
@synthesize canvas, joypad, jumpButton, player, imageSource;
@synthesize animationSource, platforms, levelSource;
@synthesize platformGraphicSource, layer0, layer1, fogLayer;

#pragma mark Levelvorbereitung
- (bool)loadLevel: (int)currentLevel {
    
     NSString* pathOfLevelFile = [[NSBundle mainBundle]
                                 pathForResource:[NSString stringWithFormat:@"level%d", currentLevel]
                                 ofType:@"lvl"];
    
     if (![[NSFileManager defaultManager] fileExistsAtPath: pathOfLevelFile ]==YES)
        return NO;
    
    NSString *levelDesign=[[NSString alloc] initWithContentsOfFile:pathOfLevelFile
                                                          encoding:NSUTF8StringEncoding
                                                             error:NULL];
     NSArray *lines = [levelDesign componentsSeparatedByString:@"\n"];
    
    int row = -1;
    
    for (id levelRow in lines) {
        row++;
        for (int col=0;col<[levelRow length];col++) {
            NSString *part = [levelRow substringWithRange:NSMakeRange(col, 1)];
            // Wenn ASCII-Zeichen nicht leer ist
           
            
            
            
                if(![part isEqualToString:@"-"]) {
                // dann Symbol auslesen
                int spriteTyp = [part intValue];
                if ([part isEqualToString:@"^"]) spriteTyp=spring; // Sprungfeder
                if ([part isEqualToString:@"X"]) spriteTyp=flag; // Zielflagge
                if ([part isEqualToString:@"*"]) spriteTyp=extralife; // Extraleben
                if ([part isEqualToString:@"@"]) spriteTyp=bogeye; // Sumpfmonster
                if ([part isEqualToString:@"#"]) {
                    // Startposition player
                    zaehler=col*rasterX-screenWidth/2-rasterX/2;
                    [player setCenter:screenWidth/2 y:row*rasterY];
                } else {
                     UIImage *img = [platformGraphicSource objectAtIndex:spriteTyp];
                    double imgWidth = img.size.width;
                    double imgHeight = img.size.height;
                    double posX = col*rasterX + imgWidth/2;
                    double posY = row*rasterY + imgHeight/2;
                    // zu levelSource hinzufuegen
                    [levelSource addObject:[NSArray arrayWithObjects:
                                            [NSNumber numberWithInteger:spriteTyp],  
                                            [NSNumber numberWithDouble:posX],  
                                            [NSNumber numberWithDouble:posY],  
                                            [NSNumber numberWithBool:NO], // Sichtbarkeit
                                            nil]];
                }
            }
        }
    }
     return YES;
}

- (void)restartLevel {
    normalAction=NO;
    
    // alten Level loeschen
    for (int p=0;p<[platforms count];p++) {
        [[platforms objectAtIndex:p] removeFromSuperview];
    }
    [platforms removeAllObjects];
    [levelSource removeAllObjects];
    
    bool nextLevelLoaded = [self loadLevel:level+1];
    
    if (nextLevelLoaded) {
        playerHasContactToFloor=NO;
        playerSpeedX=0;
        playerSpeedY=0;
        normalAction=YES;
    }
    else {
        level=0;
        [self restartLevel];
    }
}


- (void)loadView {
    
     [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    // Hintergrund vorbereiten
    canvas = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen]
                                                 applicationFrame]];
    [canvas setImage:[UIImage imageNamed:@"bg.png"]];
    canvas.userInteractionEnabled = YES;
    canvas.multipleTouchEnabled = YES;
    self.view = canvas;
    
    
    //   landscape! 
    screenWidth = self.view.bounds.size.height;
    screenHeight = self.view.bounds.size.width;
    
    // Parallax-Ebenen
    
    //   hinterste Ebene
    layer1 = [[Sprite alloc] initWithImage: [UIImage imageNamed:@"layer1.png"]
                                 spriteTyp:0
                                parentView:canvas];
    
    // vordere Ebene
    layer0 = [[Sprite alloc] initWithImage: [UIImage imageNamed:@"layer0.png"]
                                 spriteTyp:0
                                parentView:canvas];
    
    // Nebel-Ebene
    fogLayer = [[Sprite alloc] initWithImage: [UIImage imageNamed:@"fairyfog.png"]
                                   spriteTyp:0
                                  parentView:canvas];
    
    
    platforms = [[NSMutableArray alloc] init];
    levelSource = [[NSMutableArray alloc] init];
    platformGraphicSource = [[NSMutableArray alloc] init];
    
    [platformGraphicSource addObject:[UIImage imageNamed:@"plattform0.png"]];
    [platformGraphicSource addObject:[UIImage imageNamed:@"plattform1.png"]];
    [platformGraphicSource addObject:[UIImage imageNamed:@"plattform2.png"]];
    [platformGraphicSource addObject:[UIImage imageNamed:@"plattform3.png"]];
    [platformGraphicSource addObject:[UIImage imageNamed:@"plattform4.png"]];
    [platformGraphicSource addObject:[UIImage imageNamed:@"spring2.png"]];
    [platformGraphicSource addObject:[UIImage imageNamed:@"heart.png"]];
    [platformGraphicSource addObject:[UIImage imageNamed:@"flag.png"]];
    [platformGraphicSource addObject:[UIImage imageNamed:@"bogeye0.png"]];
    
    level=0;
    
     animationSource = [[NSMutableArray alloc] init];
    // stehen:
    [animationSource addObject:[NSArray arrayWithObjects:
                                [UIImage imageNamed:@"liana1.png"],
                                nil]];
    // laufen:
    [animationSource addObject:[NSArray arrayWithObjects:
                                [UIImage imageNamed:@"liana1.png"],
                                [UIImage imageNamed:@"liana2.png"],
                                [UIImage imageNamed:@"liana3.png"],
                                [UIImage imageNamed:@"liana4.png"],
                                [UIImage imageNamed:@"liana5.png"],
                                [UIImage imageNamed:@"liana6.png"],
                                [UIImage imageNamed:@"liana7.png"],
                                [UIImage imageNamed:@"liana8.png"],
                                [UIImage imageNamed:@"liana9.png"],
                                [UIImage imageNamed:@"liana10.png"],
                                [UIImage imageNamed:@"liana11.png"],
                                [UIImage imageNamed:@"liana12.png"],
                                [UIImage imageNamed:@"liana13.png"],
                                [UIImage imageNamed:@"liana14.png"],
                                [UIImage imageNamed:@"liana15.png"],
                                nil]];
    // springen:
    [animationSource addObject:[NSArray arrayWithObjects:
                                [UIImage imageNamed:@"liana4.png"],
                                nil]];
    // Sprungfeder:
    [animationSource addObject:[NSArray arrayWithObjects:
                                [UIImage imageNamed:@"spring2.png"],
                                [UIImage imageNamed:@"spring1.png"],
                                [UIImage imageNamed:@"spring0.png"],
                                [UIImage imageNamed:@"spring1.png"],
                                [UIImage imageNamed:@"spring2.png"],
                                nil]];
    // Sumpfmonster
    [animationSource addObject:[NSArray arrayWithObjects:
                                [UIImage imageNamed:@"bogeye0.png"],
                                [UIImage imageNamed:@"bogeye1.png"],
                                [UIImage imageNamed:@"bogeye2.png"],
                                [UIImage imageNamed:@"bogeye3.png"],
                                [UIImage imageNamed:@"bogeye4.png"],
                                [UIImage imageNamed:@"bogeye5.png"],
                                nil]];
    
    
    // Spielersprite  
    player = [[Sprite alloc] initWithImage: [UIImage imageNamed:@"liana1.png"]
                                 spriteTyp:0
                                parentView:canvas];
    
    // Joypad
    joypad = [[UIImageView alloc] initWithFrame:CGRectMake(0, screenHeight-82,
                                                           142, 82)];
    joypad.image = [UIImage imageNamed:@"joypad.png"];
    [canvas addSubview:joypad];
    jumpButton = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-47,
                                                               screenHeight-47,
                                                               47, 48)];
    jumpButton.image = [UIImage imageNamed:@"jump.png"];
    [canvas addSubview:jumpButton];
    
    // breiteste Plattform  
    maxPlatformWidth=0;
    for (int i=0;i<[platformGraphicSource count];i++) {
        UIImage* tmpPic = [platformGraphicSource objectAtIndex:i];
        if (maxPlatformWidth<tmpPic.size.width) maxPlatformWidth=tmpPic.size.width;
    }
    maxPlatformWidth/=2;
    
    [self restartLevel];
     
    CADisplayLink *gameEngine =
    [CADisplayLink displayLinkWithTarget:self
                                selector:@selector(gameEngine)];
    [gameEngine setFrameInterval:2];
    [gameEngine addToRunLoop:[NSRunLoop currentRunLoop]
                         forMode:NSDefaultRunLoopMode];
    
}


- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

#pragma mark - Lebenszyklus ( View)

- (void)playerEngine {
    
    bool playerIsInTheAir = YES;
    
    playerHasContactToFloor=NO;
    
    // Kontakt mit Plattform?
    for (int p=0; p<[platforms count]; p++) {
        
        // Boden-Tile holen
        Sprite *tmpBottom = [platforms objectAtIndex:p];
        
        // Player mit Boden-Teil auf Kollisions pruefen
        if ([player detectCollisionWith: tmpBottom]) {
            
            bool specialItem = NO;
            // auf besondere Plattformen checken
            int sTyp = [[[levelSource objectAtIndex:[tmpBottom sId]] objectAtIndex:0]
                        intValue];
            // Sprungfeder
            if ((sTyp==spring)&&(playerSpeedY>0)) {
                specialItem=YES;
                playerSpeedY=up*18;
                playerLooksLike=jump;
                [tmpBottom setAnimationTyp:[animationSource objectAtIndex:springjump]
                                 spriteTyp:0
                                  duration:0.25
                                    repeat:1];
            };
            // Zielflagge
            if ((sTyp==flag)&&(player.center.y<tmpBottom.center.y)) {
                specialItem=YES;
                level++;
                [self restartLevel];
            }
            // +1 Leben
            if (sTyp==extralife) {
                specialItem=YES;
                [tmpBottom removeFromSuperview];
                [platforms removeObject:tmpBottom];
                p--;
            }
            if (!specialItem)
                
                /*HIER KOLLISIONSABFRAGE EINFUEGEN*/
                if (player.center.y<tmpBottom.frame.origin.y) {
                    
                    // Bei Bodenkontakt: bouncen
                    if (playerSpeedY > 1) {
                        playerSpeedY = -playerSpeedY * 0.3;
                        playerHasContactToFloor = YES;
                    }
                    
                    // oder wenn Schwung zu gering:
                    // auf Boden absetzen
                    else if (playerSpeedY >= 0) {
                        playerSpeedY = 0;
                        playerIsInTheAir = NO;
                        playerHasContactToFloor = YES;}
                    
                    // aber auf jeden Fall:
                    // an Plattform ausrichten!
                    [player setCenter: player.center.x y:tmpBottom.frame.origin.y -
                     player.frame.size.height/2+4];
                }
        }
    }
    
    // Animation an Verhalten anpassen
    // springen und fallen
    if (playerSpeedY!=0) [player setSpriteTyp:
                          [[animationSource objectAtIndex:walk] objectAtIndex:3] typ:0];
    
    // rechts
    else if (playerSpeedX>0) [player setSpriteTyp:
                              [[animationSource objectAtIndex:walk]
                               objectAtIndex:(zaehler/5+100000)%15] typ:0];
    
    // links
    else if (playerSpeedX<0) [player setSpriteTyp:
                              [[animationSource objectAtIndex:walk]
                               objectAtIndex:14-(zaehler/5+100000)%15] typ:0];
    
    // stehen
    else if (playerSpeedX==0) [player setSpriteTyp:
                               [[animationSource objectAtIndex:walk] objectAtIndex:0] typ:0];
    
    // Gravitation einwirken lassen
    if (playerIsInTheAir) playerSpeedY+=down*0.75;
    
    // Sprungkraft nur bis zu bestimmter Hoehe verstaerken
    if (playerAddJumpEnergy) {
        if (playerSpeedY>up*7) playerSpeedY+=up*1.2; else playerAddJumpEnergy=NO;
    }
    
    // Faellt in Loch
    if (player.center.y>screenHeight) [self restartLevel];
    
}



- (void)platformEngine {
     
    for (int currentPlatformInLoop = 0;
         currentPlatformInLoop < [levelSource count];
         currentPlatformInLoop++) {
        
         int sTyp = [[[levelSource objectAtIndex:currentPlatformInLoop]
                     objectAtIndex:0] intValue];
        int posX = [[[levelSource objectAtIndex:currentPlatformInLoop]
                     objectAtIndex:1] intValue];
        int posY = [[[levelSource objectAtIndex:currentPlatformInLoop]
                     objectAtIndex:2] intValue];
        bool platformIsVisible = [[[levelSource objectAtIndex:currentPlatformInLoop]
                                   objectAtIndex:3] boolValue];
        
        // Sprite sichtbar schalten, falls in Viewport
        if ((posX>zaehler-maxPlatformWidth) &&
            (posX<zaehler+screenWidth+maxPlatformWidth)) {
            
            if (platformIsVisible==NO) {
                
                // Plattform als Sprite in Array platforms einfuegen
                Sprite *showPlatform =
                [[Sprite alloc] initWithImage:[platformGraphicSource objectAtIndex:sTyp]
                                    spriteTyp: 0
                                   parentView: canvas];
                if (sTyp==bogeye)
                    [showPlatform setAnimationTyp:[animationSource objectAtIndex:bogeyewalk]
                                        spriteTyp:bogeye
                                         duration:0.5
                                           repeat:0];
                // Auf Display 
                [showPlatform setCenter:posX-zaehler y:posY];
                [showPlatform setId:currentPlatformInLoop];
                
                [platforms addObject:showPlatform];
                [levelSource replaceObjectAtIndex:currentPlatformInLoop
                                       withObject:[NSArray arrayWithObjects:
                                                   [NSNumber numberWithInteger:sTyp],  
                                                   [NSNumber numberWithDouble:posX],  
                                                   [NSNumber numberWithDouble:posY],  
                                                   [NSNumber numberWithBool:YES], // Sichtbarkeit
                                                   nil]];
                
                // z-Index sortieren  
                for (int zIndex = 0; zIndex < screenHeight; zIndex +=rasterY) {
                    
                    for (int sortCurrentVisiblePlatform = 0;
                         sortCurrentVisiblePlatform < [platforms count];
                         sortCurrentVisiblePlatform++) {
                        
                        Sprite *existingPlatform =
                        [platforms objectAtIndex:sortCurrentVisiblePlatform];
                        int platformTyp= [[[levelSource objectAtIndex:currentPlatformInLoop]
                                           objectAtIndex:0] intValue];
                        
                        if ((platformTyp==bogeye) ||
                            ((existingPlatform.frame.origin.y <= zIndex) &&
                             (existingPlatform.frame.origin.y > zIndex-rasterY))) {
                                [self.view bringSubviewToFront:existingPlatform];
                            }
                    }
                }
                 
            }
        }
    }
    
    
     for (int currentVisiblePlatformInLoop=0;
         currentVisiblePlatformInLoop < [platforms count];
         currentVisiblePlatformInLoop++) {
        
        Sprite *showPlatform=[platforms objectAtIndex:currentVisiblePlatformInLoop];
        int spriteId = [showPlatform sId];
        
        // Daten holen
        int sTyp = [[[levelSource objectAtIndex:spriteId] objectAtIndex:0]
                    intValue];
        double posX = [[[levelSource objectAtIndex:spriteId] objectAtIndex:1]
                       doubleValue];
        double posY = [[[levelSource objectAtIndex:spriteId] objectAtIndex:2]
                       doubleValue];
        
        // Sprite sichtbar schalten, falls in Viewport
        if ((posX > zaehler - maxPlatformWidth) &&
            (posX < zaehler + screenWidth + maxPlatformWidth)) {
            if (sTyp!=bogeye) [showPlatform setCenter:posX-zaehler y:posY];
        } else {
            
            // Plattform wieder loeschen
            [levelSource replaceObjectAtIndex:spriteId withObject:
             [NSArray arrayWithObjects: [NSNumber numberWithInteger:sTyp], 
              [NSNumber numberWithDouble:posX],  
              [NSNumber numberWithDouble:posY],  
              [NSNumber numberWithBool:NO], // Sichtbarkeit
              nil]];
            [showPlatform removeFromSuperview];
            [platforms removeObject:showPlatform];
            currentVisiblePlatformInLoop--;
        }
    }
    
}

- (void)parallaxScrolling {
    fogMove+=0.5;
    [layer0 setCenter:-((960 + zaehler)/2) % 960 + layer0.frame.size.width/2
                    y:screenHeight/2];
    [layer1 setCenter:-((960 + zaehler)/3) % 960 + layer1.frame.size.width/2
                    y:screenHeight/2];
    [fogLayer setCenter:-fmod((480 + zaehler + fogMove)/2,480) +
     fogLayer.frame.size.width/2
                      y:screenHeight/2];
}



- (void)enemyEngine {
    
     for (int currentEnemy=0;currentEnemy<[platforms count];currentEnemy++) {
        
        Sprite *enemySprite = [platforms objectAtIndex:currentEnemy];
        int spriteId = [enemySprite sId];
        int sTyp= [[[levelSource objectAtIndex:spriteId] objectAtIndex:0] intValue];
        
        // Monster bewegen
        if (sTyp==bogeye) {
            
             [self.view bringSubviewToFront:enemySprite];
            
            // auf Kollision mit allen anderen Plattformen pruefen
            for (int otherVisiblePlatforms=0;
                 otherVisiblePlatforms<[platforms count];
                 otherVisiblePlatforms++) {
                
                if (otherVisiblePlatforms!=currentEnemy) {
                    Sprite *otherPlatform=[platforms objectAtIndex:otherVisiblePlatforms];
                    
                    // Beruehrung mit Plattform?
                    if ([enemySprite detectCollisionWith:otherPlatform]) {
                        
                        // Monster AUF Plattform?
                        if (enemySprite.center.y < otherPlatform.frame.origin.y) {
                            
                            if (enemySprite.center.x < otherPlatform.frame.origin.x) {
                                if ([enemySprite movingDirection]==right) {
                                    [enemySprite setMovingDirection:
                                     -[enemySprite movingDirection]];
                                    [enemySprite mirrorSprite:left];
                                }
                            } else if (enemySprite.center.x > otherPlatform.frame.origin.x +
                                       otherPlatform.frame.size.width) {
                                if ([enemySprite movingDirection] == left)  {
                                    [enemySprite setMovingDirection:
                                     -[enemySprite movingDirection]];
                                    [enemySprite mirrorSprite:right];
                                }
                            } else {
                                [enemySprite setCenter:enemySprite.center.x
                                                     y:otherPlatform.frame.origin.y -
                                 enemySprite.frame.size.height/3];
                            }
                        }
                    }
                 }
            }
            // Sprite bewegen
            [enemySprite moveBy:-bogeyeSpeed*[enemySprite movingDirection] -
             playerSpeedX y:0];
            
        }
    }
     
    
    // Kollision mit Sally START
    for (int currentEnemy=0;currentEnemy<[platforms count];currentEnemy++) {
        
        Sprite *enemySprite = [platforms objectAtIndex:currentEnemy];
        int spriteId = [enemySprite sId];
        int sTyp= [[[levelSource objectAtIndex:spriteId] objectAtIndex:0] intValue];
        
        // Monster?
        if (sTyp==bogeye) {
            
            if ([enemySprite detectCollisionWith:player]) {
                
                // Player kollidiert mit Sumpfmonster?
                if ([player detectCollisionWith:enemySprite]) {
                    
                    // wenn in Fallbewegung: Sumpfmonster entfernen
                    if (playerSpeedY>0) {
                        
                        // kleiner Sprung
                        playerSpeedY=-6;
                        [platforms removeObject:enemySprite];
                        
                        [UIView transitionWithView:self.view
                                          duration:0.5
                                           options:UIViewAnimationOptionCurveEaseIn
                                        animations:^{
                                            [enemySprite moveBy:0 y:100];
                                            [enemySprite setAlpha:0.0];
                                        } completion:^(BOOL finished) {
                                            [enemySprite removeFromSuperview];
                                        }];
                    } else [self restartLevel];
                }
                
            }
        }
        
        
    }
     
    
}


// -------------------
// --- Game Loop -----
// -------------------

- (void)gameEngine {
    
    if (normalAction) {
        
         zaehler+=playerSpeedX;
        
        [self enemyEngine];
        [self platformEngine];
        [self parallaxScrolling];
        [self playerEngine];
        [player moveBy:0 y: playerSpeedY];
        
         [self.view bringSubviewToFront:player];
        [self.view bringSubviewToFront:joypad];
        [self.view bringSubviewToFront:jumpButton];
        
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *allTouches = [touches allObjects];
    CGPoint coord = [[allTouches objectAtIndex:[touches count]-1]
                     locationInView:self.view];
    
    // Springen
    if (!((coord.x<=100) && (coord.y>screenHeight/2)) &&
        (playerHasContactToFloor)) {
        playerAddJumpEnergy = YES;
        playerSpeedY = up*5;
        playerHasContactToFloor=NO;
    }
    
    // oder Laufen
    else {
        [self touchesMoved:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *allTouches = [touches allObjects];
    CGPoint coord = [[allTouches objectAtIndex:[touches count]-1]
                     locationInView:self.view];
    if ((coord.x<=100) && (coord.y>screenHeight/2)) {
        playerSpeedX = (coord.x-50)/5;
        if (playerSpeedX < -5) playerSpeedX=-5;
        if (playerSpeedX > 5)  playerSpeedX=5;
        if (playerSpeedX < 0)  [player mirrorSprite:left];
        else  [player mirrorSprite:right];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *allTouches = [touches allObjects];
    
    CGPoint coord = [[allTouches objectAtIndex:[allTouches count]-1]
                     locationInView:self.view];
    if ((coord.x<=200) && (coord.y>screenHeight/2)) {
        playerSpeedX = 0;
    } else playerAddJumpEnergy = NO;
}


- (void)viewDidUnload {[super viewDidUnload];}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)
interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}


@end
