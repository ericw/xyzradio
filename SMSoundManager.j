//
//  SMSoundManager.j
//  SoundManager
//
//  Created by Ross Boucher on 10/3/08.
//  Copyright 280 North 2008. All rights reserved.
//

import <Foundation/CPObject.j>
import <AppKit/AppKit.j>

@implementation SMSoundManager : CPObject
{
    BOOL    isLoaded;
    Object  soundManager;
	Object song; 
}

- (id)init
{
    self = [super init];
    console.log("Inicializando el SM");
    window.setTimeout(setupSoundManager, 1000, self);
    
    return self;
}

- (void)soundManagerDidLoad:(Object)aManager
{
    isLoaded = YES;
    soundManager = aManager;
    
    //[self playSound];
}

- (void)playSound:(CPString)aFile
{
    var song = soundManager.createSound({ 
		id : 'aSong', 
		url : aFile,
		onfinish: function(){
			[self soundDidFinish]
		;},
		whileplaying: function(){
			[self soundPosition];
		}
	});
	song.play();
}
-(void)pauseSound{
	soundManager.pause('aSong');
}
-(void)resumeSound{
	soundManager.resume('aSong');
}
-(void)togglePause{
	soundManager.togglePause('aSong');
}
-(void)isLoaded
{
	return isLoaded;
}
-(void)setVolume:(int)aVolume{
	console.log(aVolume);
	soundManager.setVolume('aSong', aVolume);
}
-(void)soundDidFinish{
	 console.log("Sound finished...posting notification...");
	 [[CPNotificationCenter defaultCenter] postNotificationName:"SongEnded" object:self]; 
}
-(void)soundPosition{
	var info = [CPDictionary dictionaryWithObject:song.position forKey:"time"];   
	[[CPNotificationCenter defaultCenter] postNotificationName:"pos" object:self userInfo:info]; 
}

@end

var setupSoundManager = function(obj)
{
	var script = document.createElement("script");
	
	script.type = "text/javascript";
	script.src = "Resources/soundmanager2.js";
	
	script.addEventListener("load", function()
	{
		soundManager.url = "Resources/"; // path to directory containing SoundManager2 .SWF file
		soundManager.onload = function() {
            [obj soundManagerDidLoad:soundManager];            
		};
        soundManager.beginDelayedInit();
		soundManager.debugMode = false;
	}, YES);	
	
	document.getElementsByTagName("head")[0].appendChild(script);
}