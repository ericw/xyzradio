//
//  Player.j
//  XYZRadio
//
//  Created by Alos on 10/2/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

import <AppKit/CPPanel.j>
import <AppKit/CPWindowController.j>
import "SMSoundManager.j"
import "Song.j"
@implementation Player : CPWindowController
{
    CPButton backButton;
    CPButton playButton;
    CPButton forwardButton;
	CPSlider volumeSlider;
    CPTextField currentlyPlaying;
	Song currentlyPlayingSong;
	BOOL local;
	SMSoundManager theSoundManager;
	//the browsers
	SFBrowser theMainBrowser;
	MyList theUserList;
	//flags for playing
	BOOL playing;
	BOOL paused;
	//timer
	CPString time;
}

/*Una bonita contructora*/
- (id)initWithMainBrowser:(SFBrowser)mainBrowser userBrowser:(MyList)userBrowser{
    var win = [[CPPanel alloc] initWithContentRect:CGRectMake(500, 560, 400, 200)styleMask:CPHUDBackgroundWindowMask|CPBorderlessWindowMask];
    self = [super initWithWindow:win];
	theMainBrowser=mainBrowser;
	theUserList=userBrowser;
    if (self)//pa ver si no somos null :P
    {
        //le ponemos titulo al HUD lo centramos
        [win setTitle:@"Player"];
        [win setFloatingPanel:YES];
        [win setDelegate:self];  
        var contentView = [win contentView];
        var bounds = [contentView bounds];  
        var center= CGRectGetWidth(bounds)/2.0 -35;
        
        var backImage = [[CPImage alloc] initWithContentsOfFile:"Resources/backButton.png" size:CPSizeMake(50, 50)];
        var backImagePressed = [[CPImage alloc] initWithContentsOfFile:"Resources/backButtonPressed.png" size:CPSizeMake(50, 50)];
        backButton = [[CPButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(bounds)/2.0-100 , 30, 50, 50)];
        [backButton setImage: backImage];
        [backButton setAlternateImage: backImagePressed];
        [backButton setBordered:NO];
        
        var playImage = [[CPImage alloc] initWithContentsOfFile:"Resources/playButtonPressed.png" size:CPSizeMake(70, 70)];
        var playImagePressed = [[CPImage alloc] initWithContentsOfFile:"Resources/playButton.png" size:CPSizeMake(70, 70)];
        playButton = [[CPButton alloc] initWithFrame:CGRectMake(center, 15, 70, 70)];
        [playButton setImage: playImage];
        [playButton setBordered:NO];
        [playButton setAction:@selector(playSong)];
		
		
        var forwardImage = [[CPImage alloc] initWithContentsOfFile:"Resources/nextButton.png" size:CPSizeMake(50, 50)];
        var forwardImagePressed = [[CPImage alloc] initWithContentsOfFile:"Resources/nextButtonPressed.png" size:CPSizeMake(50, 50)];
        forwardButton = [[CPButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(bounds)/2.0+50, 30, 50, 50)];
        [forwardButton setImage: forwardImage];
        [forwardButton setAlternateImage: forwardImagePressed];
        [forwardButton setBordered:NO];
         
		//VOLUME 
		volumeSlider = [[CPSlider alloc]
        initWithFrame:CGRectMake(CGRectGetWidth(bounds)/2.0 - 100, 100, 200, 16)];
        [volumeSlider setMinValue:0];
        [volumeSlider setMaxValue:100];
        [volumeSlider setValue:100];        
        [contentView addSubview:volumeSlider];
        //Ponemos las labeles al rededor del slider
        var volumeStartLabel = [self labelWithTitle:"0%"],
        volumeEndLabel = [self labelWithTitle:"100%"];
        [volumeStartLabel setFrameOrigin:CGPointMake(CGRectGetWidth(bounds)/2.0 - CGRectGetWidth([volumeStartLabel frame]) - 100 , 95)];
        [volumeEndLabel setFrameOrigin:CGPointMake(CGRectGetMaxX([volumeSlider frame]), 95)];
        //Las agregamos a la vista
        [contentView addSubview:volumeStartLabel];
        [contentView addSubview:volumeEndLabel];  
		[volumeSlider setTarget:self];
        [volumeSlider setAction:@selector(setVolume:)]; 
		 
		//Currenlyplaying bar 
        var currentlyPlayingString="Nothing...";
        currentlyPlaying= [[CPTextField alloc]initWithFrame: CGRectMake(20, 130, 350, 18)];
        [currentlyPlaying setStringValue:currentlyPlayingString];//currentlyPlayingString
        [currentlyPlaying setTextColor: [CPColor colorWithHexString:"33FF00"]];
        [currentlyPlaying setBackgroundColor:[CPColor colorWithHexString:"003300"]];
        [currentlyPlaying setAlignment:CPCenterTextAlignment];
        [contentView addSubview: backButton];
        [contentView addSubview: playButton];
        [contentView addSubview: forwardButton];
        [contentView addSubview: currentlyPlaying];
		
		playing = NO;
		paused = NO;
		//testing...
		theSoundManager = [[SMSoundManager alloc]init];
		[[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(setTime:) name:"pos" object:theSoundManager];
		[[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(songDidFinishPlaying:) name:"SongEnded" object:theSoundManager];
		local=true;
                 
    }
    return self;
}
-(void) playSong{
	console.log("Clicked play!");
	if(local){
		console.log("Mode is local");
		if([theSoundManager isLoaded]){
			if(!playing){
				var aSong = [theUserList getSelectedSong];
				console.log("Will try to play: %s", [aSong songTitle]);
				if([aSong pathToSong]==NULL)
					console.log("No path in the song selected!");//TODO poner aqui una ventana de alerta
				else{
					console.log("Playing: %s", [aSong pathToSong]);
					currentlyPlayingSong=aSong;
					var currentlyPlayingString= [aSong songTitle]+" by "+[aSong artist]+" Time: "+[aSong time];
					[currentlyPlaying setStringValue:currentlyPlayingString];
					[theSoundManager playSound:[aSong pathToSong]];
					var pausedIcon = [[CPImage alloc] initWithContentsOfFile:"Resources/pausedIcon.png" size:CPSizeMake(70, 70)];
					[playButton setImage:pausedIcon];
					playing = YES;
				}
			}else{
				if(paused){
					console.log("Resumming...");
					[theSoundManager togglePause];
					var pausedIcon = [[CPImage alloc] initWithContentsOfFile:"Resources/pausedIcon.png" size:CPSizeMake(70, 70)];
					[playButton setImage: pausedIcon];
					paused = NO;
				}else{
					console.log("Pausing...");
					[theSoundManager togglePause];
					var playImage = [[CPImage alloc] initWithContentsOfFile:"Resources/playButton.png" size:CPSizeMake(70, 70)];
					[playButton setImage:playImage];
					paused = YES;
				}
			}
		}
		else
			console.log("El sound manager aun no esta funcionando..espere un momento....");
	}else{
		//IP mode
	}		
}
- (void)songDidFinishPlaying:(CPNotification)aNotification{
	console.log("Song finished playing");
	var playImage = [[CPImage alloc] initWithContentsOfFile:"Resources/playButtonPressed.png" size:CPSizeMake(70, 70)];
	var playImagePressed = [[CPImage alloc] initWithContentsOfFile:"Resources/playButton.png" size:CPSizeMake(70, 70)];
	[playButton setImage: playImage];
	[playButton setAlternateImage: playImagePressed];
	var currentlyPlayingString="Nothing...";
	[currentlyPlaying setStringValue:currentlyPlayingString];
	paused=NO;
	playing=NO;
}

-(void)setTime:(CPNotification)aNotification{
	var info = [aNotification userInfo];
	var aux = [info objectForKey:"time"];
	time = [self getTime: aux];
	if(time==NULL)
		return;
	var values = [currentlyPlayingSong songTitle]+" by "+[currentlyPlayingSong artist]+" Time: "+time;
	[currentlyPlaying setStringValue:values];
}
//TODO move this to a util class
-(CPString)getTime:(int)timeInMilis{
	var nSec = Math.floor(timeInMilis/1000);
    var min = Math.floor(nSec/60);
    var sec = nSec-(min*60);
    if (min == 0 && sec == 0) return null; // return 0:00 as null
	if(sec>=10)
		return min+":"+sec;
	else
		return min+":0"+sec;
}
- (CPTextField)labelWithTitle:(CPString)aTitle
{
    var label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
    
    [label setStringValue:aTitle];
    [label setTextColor:[CPColor colorWithHexString:"33FF00"]];
    
    [label sizeToFit];

    return label;
}
- (void)setVolume:(id)aVolume{
	[theSoundManager setVolume:[aVolume value]];
}
@end