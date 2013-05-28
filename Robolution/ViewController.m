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
#import "RetryViewController.h"
 //#import "LevelViewController.m"

 @implementation ViewController



 
@synthesize canvas, rechtsButton, jumpButton, player, imageSource,linksButton,powerAnzeige;
@synthesize animationSource, platforms, levelSource;
@synthesize platformGraphicSource, layer0, layer1, fogLayer,Level;

#pragma mark - publics

-(void)jumpToLevel:(int)levelNumber
{
    level = levelNumber;
}

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
              //  if ([part isEqualToString:@"^"]) spriteTyp=spring; // Sprungfeder
                if ([part isEqualToString:@"X"]) spriteTyp=flag; // Zielflagge
                if ([part isEqualToString:@"*"]) spriteTyp=oel; // Extraleben
                if ([part isEqualToString:@"@"]) spriteTyp=bratwurst; // Bratwurst
                 if ([part isEqualToString:@">"]) spriteTyp=kran; // Kran
                if ([part isEqualToString:@"K"]) spriteTyp=kranBewegung; // Kran
                if ([part isEqualToString:@"W"]) spriteTyp=wasser; // Kran
                if ([part isEqualToString:@"S"]) spriteTyp=stage; // Kran


                if ([part isEqualToString:@"#"]) {
                    // Startposition player
                    zaehler=col*rasterX-screenWidth/2-rasterX/2;
                    [player setCenter:screenWidth/2 y:row*rasterY];
                } else {
                    
                    if ( [[[platformGraphicSource objectAtIndex:spriteTyp ] class]isSubclassOfClass:[NSArray class]]) {
                        
                        UIImage *img = [[platformGraphicSource objectAtIndex:spriteTyp] objectAtIndex:0];
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
                    else if ([[[platformGraphicSource objectAtIndex:spriteTyp ] class]isSubclassOfClass:[UIImage class]])
                    {
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
    }
    return YES;
}

- (void)restartLevel {
    normalAction=NO;
   // AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
  // externLevel = level;
    [player setAlpha:1.0];

     steps = 0;
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
    
    powerAnzeige.image = [UIImage imageNamed:@"Power"];

    if (level == 0)    {   maxSteps = 10000;
          
    }
    
    
    else if (level == 1)
                             {maxSteps = 8000;
     }
    
    else if (level == 2) {       maxSteps = 7000;
    
    }
    
    
    else if (level == 3) {       maxSteps = 3000;
    }
    else if (level == 4) {       maxSteps = 8000;
    }
    else if (level == 5) {       maxSteps = 4000;
    }
    else if (level == 6) {       maxSteps = 5000;         }
    else if (level == 7) {       maxSteps = 5000;
    }
    else if (level == 8) {       maxSteps = 5500;
    }

    currentSteps =0;
    
   Level.text = [NSString stringWithFormat:@"%2d", level+1];
    
    
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
    
    
     
  powerAnzeige = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 108,56)];

    
    [canvas addSubview:powerAnzeige];

    // Parallax-Ebenen
    
    //   hinterste Ebene
   layer1 = [[Sprite alloc] initWithImageResource: [UIImage imageNamed:@"neu_layer_1.png"]
                              spriteTyp:0
                              parentView:canvas];
    
    // vordere Ebene
    layer0 = [[Sprite alloc] initWithImageResource: [UIImage imageNamed:@"neu_layer_2.png"]
                               spriteTyp:0
                                parentView:canvas];
    
    // Nebel-Ebene
     fogLayer = [[Sprite alloc] initWithImageResource: [UIImage imageNamed:@"fairyfog.png"]
                                  spriteTyp:0
                               parentView:canvas];
    
    
    platforms = [[NSMutableArray alloc] init];
    //Platform_Bewegung
    
    animationSource = [[NSMutableArray alloc] init];
    // stehen:
    [animationSource addObject:[NSArray arrayWithObjects:
                                [UIImage imageNamed:@"Roboter2.png"],
                                nil]];
    // laufen:
    [animationSource addObject:[NSArray arrayWithObjects:
                                [UIImage imageNamed:@"Roboter2.png"],
                                [UIImage imageNamed:@"Roboter3.png"],
                                [UIImage imageNamed:@"Roboter4.png"],
                                [UIImage imageNamed:@"Roboter5.png"],
                                
                                
                                nil]];
    
    // springen:
    [animationSource addObject:[NSArray arrayWithObjects:
                                [UIImage imageNamed:@"Sprung.png"],
                                [UIImage imageNamed:@"Sprung2.png"],
                                [UIImage imageNamed:@"Sprung3.png"],
                                [UIImage imageNamed:@"Sprung4.png"],
                                [UIImage imageNamed:@"Sprung5.png"],
                                nil]];
    
    
    // Bratwurst
    [animationSource addObject:[NSArray arrayWithObjects:
                                [UIImage imageNamed:@"Feind.png"],
                                [UIImage imageNamed:@"Feind2.png"],
                                [UIImage imageNamed:@"Feind3.png"],
                                [UIImage imageNamed:@"Feind4.png"],
                                [UIImage imageNamed:@"Feind5.png"],
                                
                                nil]];
  
    [animationSource addObject:[NSArray arrayWithObjects:
                                [UIImage imageNamed:@"Platform"],
                                [UIImage imageNamed:@"Platform2.png"],
                                [UIImage imageNamed:@"Platform3.png"],
                                [UIImage imageNamed:@"Platform4.png"],
                                [UIImage imageNamed:@"Platform5.png"],
                                [UIImage imageNamed:@"Platform6.png"],
                                [UIImage imageNamed:@"Platform7.png"],
                                [UIImage imageNamed:@"Platform8.png"],
                                [UIImage imageNamed:@"Platform9.png"],
                                [UIImage imageNamed:@"Platform10.png"],
                                [UIImage imageNamed:@"Platform11.png"],
                                [UIImage imageNamed:@"Platform12.png"],
                                [UIImage imageNamed:@"Platform13.png"] ,
                                [UIImage imageNamed:@"Platform12.png"],
                                [UIImage imageNamed:@"Platform11.png"],
                                [UIImage imageNamed:@"Platform10.png"],
                                [UIImage imageNamed:@"Platform9.png"],
                                [UIImage imageNamed:@"Platform8.png"],
                                [UIImage imageNamed:@"Platform7.png"],
                                [UIImage imageNamed:@"Platform6.png"],
                                [UIImage imageNamed:@"Platform5.png"],
                                [UIImage imageNamed:@"Platform4.png"],
                                [UIImage imageNamed:@"Platform3.png"],
                                [UIImage imageNamed:@"Platform2.png"],
                                [UIImage imageNamed:@"Platform"],

                                
                                
                                
                                nil]];
    
    // Wasser
    [animationSource addObject:[NSArray arrayWithObjects:
                                [UIImage imageNamed:@"wasser.png"],
                                [UIImage imageNamed:@"wasser2.png"],
                                [UIImage imageNamed:@"wasser3.png"],
                                [UIImage imageNamed:@"wasser2.png"],
                                [UIImage imageNamed:@"wasser3.png"],
                                 [UIImage imageNamed:@"wasser2.png"],
                       
                                
                                nil]];
    
    
    levelSource = [[NSMutableArray alloc] init];
    platformGraphicSource = [[NSMutableArray alloc] init];
    
    [platformGraphicSource addObject:[UIImage imageNamed:@"small_Container.png"]];
    [platformGraphicSource addObject:[UIImage imageNamed:@"Container_green.png"]];
    [platformGraphicSource addObject:[UIImage imageNamed:@"Kran.png"]];
    [platformGraphicSource addObject:[UIImage imageNamed:@"Stahltraeger.png"]];
    [platformGraphicSource addObject:[UIImage imageNamed:@"Holzkiste.png"]];
    [platformGraphicSource addObject:[UIImage imageNamed:@"Platform.png"]];
    [platformGraphicSource addObject:[UIImage imageNamed:@"Oel_tropfen.png"]];
    [platformGraphicSource addObject:[UIImage imageNamed:@"flag.png"]];
    [platformGraphicSource addObject:[UIImage imageNamed:@"Feind.png"]];
    //[platformGraphicSource addObject:[animationSource objectAtIndex:4]];
    [platformGraphicSource addObject:[UIImage imageNamed:@"Kran.png"]];
    [platformGraphicSource addObject:[UIImage imageNamed:@"Platform.png"]];
    [platformGraphicSource addObject:[UIImage imageNamed:@"Kran.png"]]; 
    [platformGraphicSource addObject:[UIImage imageNamed:@"wasser.png"]];
    
    Level = [[UITextField alloc ] initWithFrame:CGRectMake(43, 0, 27, 27)];
    Level.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0];
     CGFloat yourSelectedFontSize = 24.0 ;
    UIFont *yourNewSameStyleFont = [Level.font fontWithSize:yourSelectedFontSize];
    Level.font = yourNewSameStyleFont ;
    [canvas addSubview:Level];

    // Spielersprite
    player = [[Sprite alloc] initWithImageResource: [UIImage imageNamed:@"Roboter.png"]
                                 spriteTyp:0
                                parentView:canvas];
    
    // Joypad
    rechtsButton = [[UIImageView alloc] initWithFrame:CGRectMake(75, screenHeight-56,
                                                                 105, 63)];
    rechtsButton.image = [UIImage imageNamed:@"rechts.png"];
    [canvas addSubview:rechtsButton];
    
    
    linksButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, screenHeight-48,
                                                                75, 48)];
    linksButton.image = [UIImage imageNamed:@"links.png"];
    [canvas addSubview:linksButton];
    
    
    
    jumpButton = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-75,
                                                               screenHeight-48,
                                                               75, 48)];
    jumpButton.image = [UIImage imageNamed:@"jump.png"];
    [canvas addSubview:jumpButton];
    
    
    
    
    
    pause = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth- 78, 0, 60, 33)];
    [pause setBackgroundImage:[UIImage imageNamed: @"exit_button"] forState:UIControlStateNormal];
    [pause setTitle:[NSString stringWithFormat:@"esc"] forState:UIControlStateNormal];
    [pause addTarget:self action:@selector(pause:) forControlEvents:UIControlEventTouchUpInside];
    [canvas addSubview:pause];
    
    
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
    [gameEngine setFrameInterval:1];
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
            
                      // Zielflagge
            if ((sTyp==flag)&&(player.center.y<tmpBottom.center.y)) {
                specialItem=YES;
                level++;
                [self restartLevel];
            }
            // +1 Leben
            if (sTyp==oel) {
                specialItem=YES;
                [tmpBottom removeFromSuperview];
                [platforms removeObject:tmpBottom];
                
                
                
                if (level ==0) {
                    currentSteps -= 500;
                }
                
                else if (level ==1) {
                    currentSteps -= 500;
                }
                else if (level ==2) {
                    currentSteps -= 500;
                }
                else if (level ==3) {
                    currentSteps -= 405;
                }
                else if (level ==4) {
                    currentSteps -= 305;
                }
                else if (level ==5) {
                    currentSteps -= 405;
                }
                else if (level ==6) {
                    currentSteps -= 305;
                }
                else if (level ==7) {
                    currentSteps -= 300;
                }
                else if (level ==8) {
                    currentSteps -= 250;
                }
                [self powerEngine];

             }
           //Kran
            if (sTyp==kran) {
                specialItem=YES;
                if (player.center.y<tmpBottom.center.y + 50 ) {
                    
                    // Bei Bodenkontakt: bouncen
                    if (playerSpeedY > 1) {
                        playerSpeedY = -playerSpeedY * 0.2;
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
                    [player setCenter: player.center.x y:tmpBottom.center.y   +55-
                     player.frame.size.height/2-5];
                }

            }
           // KRan Bewegung
            if (sTyp==kranBewegung)
            
            {
                
 
                specialItem=YES;
                if (player.center.y<tmpBottom.center.y + 50 ) {
                    
                    // Bei Bodenkontakt: bouncen
                    if (playerSpeedY > 1) {
                        playerSpeedY = -playerSpeedY * 0.2;
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
                    [player setCenter: player.center.x y:tmpBottom.center.y   +55-
                     player.frame.size.height/2-5];
                }
            
                
            }
            
                
            if (sTyp == wasser)
            {
                
                /*HIER KOLLISIONSABFRAGE EINFUEGEN*/
                if (player.center.y<tmpBottom.frame.origin.y) {
                    
                    // Bei Bodenkontakt: bouncen
                    if (playerSpeedY > 1) {
                        playerSpeedY = -playerSpeedY * 0.2;
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
                    [player setCenter: player.center.x y:tmpBottom.frame.origin.y+
                     player.frame.size.height/2-4];
                }
             
      
                
                specialItem = YES;
                
                
                
                
                /*
                
                [UIView transitionWithView:self.view
                                  duration:0.5
                                   options:UIViewAnimationOptionCurveEaseIn
                                animations:^{
                                    [player moveBy:0 y:0];
                                    [player setAlpha:0.0];
                                 } completion:^(BOOL finished) {
                                   // [player removeFromSuperview];
                                     
                                     [self restartLevel];
                                    
                                }];

                
                
          */
                [self restartLevel];
                
                
                
                
            }
                 if (!specialItem)
            /*HIER KOLLISIONSABFRAGE EINFUEGEN*/
                if (player.center.y<tmpBottom.frame.origin.y) {
                    
                    // Bei Bodenkontakt: bouncen
                    if (playerSpeedY > 1) {
                        playerSpeedY = -playerSpeedY * 0.2;
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
    //springen
    if (playerSpeedY<-3)
        
    {
 
        [player setSpriteTyp:
         [[animationSource objectAtIndex:jump] objectAtIndex:1%5] typ:0];
     
        
        
        //SCHRITTE ABZIEHEN
      }
    else  if (playerSpeedY >-3 && playerSpeedY<0)
    {
        
        [player setSpriteTyp:
         [[animationSource objectAtIndex:walk] objectAtIndex:3] typ:0];
    }
    
    //fallen
    else  if (playerSpeedY<-1)
        
        
        [player setSpriteTyp:
         [[animationSource objectAtIndex:walk] objectAtIndex:3] typ:0];
    
    
    
    // rechts
    else if (playerSpeedX>0)
    {
        [player setSpriteTyp:
                              [[animationSource objectAtIndex:walk]
     
                               objectAtIndex: (zaehler/5+10000)%4] typ:0];
        //SCHRITTE ABZIEHEN
 
     }
    // links
    else if (playerSpeedX<0)
    {[player setSpriteTyp:
                              [[animationSource objectAtIndex:walk]
                               objectAtIndex:3-(zaehler/5+10000)%4] typ:0];
        //SCHRITTE ABZIEHEN
 
    }
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
                [[Sprite alloc] initWithImageResource:[platformGraphicSource objectAtIndex:sTyp]
                                    spriteTyp: 0
                                   parentView: canvas];
                showPlatform.isVisible = TRUE;
                
                
                if (sTyp==bratwurst)
                    [showPlatform setAnimationTyp:[animationSource objectAtIndex:bratwurstWalk]
                                        spriteTyp:bratwurst
                                         duration:0.5
                                           repeat:0];
                
                if (sTyp == wasser) {
                     
                        [showPlatform setAnimationTyp:[animationSource objectAtIndex:wasserAnimation]
                                         spriteTyp:wasser
                                          duration:0.5
                                            repeat:0];
                }
                 if (sTyp == stage) {
                    
                    [showPlatform setAnimationTyp:[animationSource objectAtIndex:stageAnimation]
                                     spriteTyp:stage
                                      duration:2.5
                                        repeat:0];
                     
                     
                     
                     showPlatform.pic.contentMode = UIViewContentModeBottom;
                     
                     
//                   [UIView animateWithDuration:1.25 delay:0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveLinear animations:^{
//
//                         CGRect frame = showPlatform.frame;
//                         frame.size.height += 60;
//                         showPlatform.frame = frame;
//                     }completion:^(BOOL finished){
//                         
//                     }];
                  
                }

                            

                
                /*
                if (sTyp == platformUp)
                {
                    
                    [showPlatform setAnimationTyp:[animationSource objectAtIndex:platformUpAnimation]spriteTyp:platformUp
                                         duration:0.5
                                           repeat:0];
                    [showPlatform.pic setAnimationDuration:.6];
               [showPlatform.pic startAnimating];
                    

                      showPlatform.pic.contentMode = UIViewContentModeTop;
                }
                 */
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
                        
                        if ((platformTyp==bratwurst) ||
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
       // NSLog(@"center x: %f, center y: %f",posX,posY);;
        
        // Sprite sichtbar schalten, falls in Viewport
        if ((posX > zaehler - maxPlatformWidth) &&
            (posX < zaehler + screenWidth + maxPlatformWidth)) {
            if (sTyp!=bratwurst) {
                
                [showPlatform setCenter:posX-zaehler y:posY];
                
                if (sTyp == stage) {
                    float minHeight = 38;
                    float maxHeight = 98;
                    BOOL reversed = showPlatform.animationFlag;
                    
                    CGRect frame = showPlatform.frame;
                    // platform moves down
                    if (reversed == false) {
                        if (frame.size.height>=minHeight) {
                            frame.size.height -= .815;
                        } else {
                            frame.size.height = 38;
                            reversed = TRUE;
                        }
                    } else {
                        // platform moves up
                        if (frame.size.height<=maxHeight) {
                            frame.size.height += .815;
                        } else {
                            frame.size.height = 98;
                            reversed = FALSE;
                        }
                    }
                    showPlatform.animationFlag = reversed;
                    showPlatform.frame = frame;
                    [showPlatform setCenter:posX-zaehler y:posY];

                  //  NSLog(@"Frame: %@",NSStringFromCGRect(showPlatform.frame));
                }
            }
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

- (void)platformUpEngine {
   /*
    for (int currentEnemy=0;currentEnemy<[platforms count];currentEnemy++) {
        
        Sprite *enemySprite = [platforms objectAtIndex:currentEnemy];
        int spriteId = [enemySprite sId];
        int sTyp= [[[levelSource objectAtIndex:spriteId] objectAtIndex:0] intValue];
        
         if (sTyp==platformUp) {
            
            [self.view bringSubviewToFront:enemySprite];
                        // Sprite bewegen
             
            [enemySprite moveBy: 0 y:-50];
            
         }}
*/
}

- (void)enemyEngine {
    
    for (int currentEnemy=0;currentEnemy<[platforms count];currentEnemy++) {
        
        Sprite *enemySprite = [platforms objectAtIndex:currentEnemy];
        int spriteId = [enemySprite sId];
        int sTyp= [[[levelSource objectAtIndex:spriteId] objectAtIndex:0] intValue];
        
        // Monster bewegen
        if (sTyp==bratwurst) {
            
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
            [enemySprite moveBy:-bratwurstSpeed*[enemySprite movingDirection] -
             playerSpeedX y:0];
            
        }
    }
    
    
    // Kollision mit Sally START
    for (int currentEnemy=0;currentEnemy<[platforms count];currentEnemy++) {
        
        Sprite *enemySprite = [platforms objectAtIndex:currentEnemy];
        int spriteId = [enemySprite sId];
        int sTyp= [[[levelSource objectAtIndex:spriteId] objectAtIndex:0] intValue];
        
        // Monster?
        if (sTyp==bratwurst) {
            
            if ([enemySprite detectCollisionWith:player]) {
                                
                
                // Player kollidiert mit Sumpfmonster?
                if ([player detectCollisionWith:enemySprite]) {
                 
                   
                    
                    
                    // wenn in Fallbewegung: Sumpfmonster entfernen
                    if (playerSpeedY>0) {
                      /*
                        UIImageView *cloud = [[UIImageView alloc]initWithFrame:CGRectMake(player.center.x, player.center.y, 150, 150)];
                        
                        cloud.image = [UIImage imageNamed:@"Wolke.png"];
                        [canvas addSubview:cloud];
                        [self.view bringSubviewToFront:cloud];
                      */  

                        
                        
                        // kleiner Sprung
                        playerSpeedY=-6;

                         [platforms removeObject:enemySprite];
                        //  [cloud removeFromSuperview];
 
                        [UIView transitionWithView:self.view
                                          duration:0.5
                                           options:UIViewAnimationOptionCurveEaseIn
                                        animations:^{
                                            [enemySprite moveBy:0 y:100];
                                            [enemySprite setAlpha:0.0];
                                        } completion:^(BOOL finished) {
                                            [enemySprite removeFromSuperview];

                                        }];                   
                    } else{
                     /*   UIImageView *cloud = [[UIImageView alloc]initWithFrame:CGRectMake(player.frame.origin.x, player.frame.origin.y, 100, 100)];
                        
                        cloud.image = [UIImage imageNamed:@"Wolke.png"];
                        [canvas addSubview:cloud];
                        [self.view bringSubviewToFront:cloud];
                        
                      */  /* [UIView transitionWithView:self.view
                                             duration:0.5
                                              options:UIViewAnimationOptionCurveEaseIn
                                           animations:^{
                                               [player moveBy:0 y:100];
                                               [player setAlpha:0.0];
                                           } completion:^(BOOL finished) {
                                               [player removeFromSuperview];
                                               
                                           }];                   
*/
                        
                     [self restartLevel];
 
                    }

                 }
                
            }
        }
        
        
    }
    
    
}



-(void)powerEngine
{
    //Schritte abziehen und aktualisieren 
    //currentSteps --;
   
    
    
    
   // if (playerSpeedX < 0) {
        //steps += playerSpeedX * -1;
   // }
  //  else
   // {
    //NSLog(@"currentSteps: %d ",currentSteps);
    
    
    steps = 0;
    
  
    if (currentSteps <= 0.02 * maxSteps    ) {
        powerAnzeige.image = [UIImage imageNamed:@"Power.png"];
        [canvas addSubview:powerAnzeige];

    }
    
        // Bilder aktualisieren 
     else if (currentSteps <= 0.1 *maxSteps  ) {
         powerAnzeige.image = [UIImage imageNamed:@"Power2.png"];
         [canvas addSubview:powerAnzeige];
 

     }
    
     else if (currentSteps <= 0.2 *maxSteps  ) {
         powerAnzeige.image = [UIImage imageNamed:@"Power3.png"];
         [canvas addSubview:powerAnzeige];


    }
    
     else if (currentSteps <= 0.3 *maxSteps    ) {
         powerAnzeige.image = [UIImage imageNamed:@"Power4.png"];
         [canvas addSubview:powerAnzeige];


     }
    
     else if (currentSteps <= 0.4 *maxSteps  ) {
         powerAnzeige.image = [UIImage imageNamed:@"Power5.png"];

         [canvas addSubview:powerAnzeige];

    }
    
     else if (currentSteps <= 0.5 *maxSteps   ) {
         powerAnzeige.image = [UIImage imageNamed:@"Power6.png"];
         [canvas addSubview:powerAnzeige];

      
    }
    
     else if (currentSteps <= 0.6 *maxSteps  ) {
         powerAnzeige.image = [UIImage imageNamed:@"Power7.png"];
         [canvas addSubview:powerAnzeige];

      
    }
    
     else if (currentSteps <= 0.7 *maxSteps  ) {
         powerAnzeige.image = [UIImage imageNamed:@"Power8.png"];
         [canvas addSubview:powerAnzeige];

        
    }
    
    
    else if (currentSteps <= 0.8 *maxSteps   ) {
        powerAnzeige.image = [UIImage imageNamed:@"Power9.png"];
        [canvas addSubview:powerAnzeige];

      
    }
    else if (currentSteps <= 0.9 *maxSteps   ) {
        powerAnzeige.image = [UIImage imageNamed:@"Power10_neu.png"];
        [canvas addSubview:powerAnzeige];

        
    }
    //wenn 0 dann Verloren !
   else if (currentSteps <= maxSteps ) {
       
                [self restartLevel];
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
        [self.view bringSubviewToFront:linksButton];
        [self.view bringSubviewToFront:rechtsButton];
        [self.view bringSubviewToFront:powerAnzeige];

        [self.view bringSubviewToFront:jumpButton];
        [self.view bringSubviewToFront:Level];
         [self.view bringSubviewToFront:pause];

    
        
        if (playerSpeedX < 0) {
            steps += -1*playerSpeedX;
        }
        else
        {
            steps += playerSpeedX;
        }
        
        
        currentSteps +=steps;
        
        
        [self powerEngine];
    }
    
    
    
    
    
    
    
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *allTouches = [touches allObjects];
    CGPoint coord = [[allTouches objectAtIndex:[touches count]-1]
                     locationInView:self.view];
   
    

    // Springen
    if (!((coord.x<=200) && (coord.y>screenHeight/2)) &&
        (playerHasContactToFloor)) {
        playerAddJumpEnergy = YES;
        playerSpeedY = up*5;
        playerHasContactToFloor=NO;
        currentSteps+= 110;
        [self powerEngine];
 
    }
    
    // oder Laufen
    else {
        [self touchesMoved:touches withEvent:event];
     //   currentSteps -= 3;
       // [self powerEngine];

    }
       {
        
    }
   

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *allTouches = [touches allObjects];
    CGPoint coord = [[allTouches objectAtIndex:[touches count]-1]
                     locationInView:self.view];
    if ((coord.x<=220) && (coord.y>screenHeight/2))
   
    {
        playerSpeedX = (coord.x-85)/5;
      //  currentSteps -= 0.005;
       // [self powerEngine];
        
        
        if (playerSpeedX < -5) playerSpeedX=-5;
        {        }

        if (playerSpeedX > 5)  playerSpeedX=5;    
        { 
        }
        
        if (playerSpeedX < 0) { [player mirrorSprite:left]; }
        else { [player mirrorSprite:right];  }
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

#pragma  mark - Actions
-(void)pause:(id)sender
{
    RetryViewController *view = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"navController"];
    [self presentViewController:view animated:YES completion:nil];
    
    normalAction =NO;

}

    @end
