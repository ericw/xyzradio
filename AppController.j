
import <Foundation/CPObject.j>
import "Song.j"
import "SFTable.j"
import "MyList.j"
import "SFBrowser.j"
import "SFColumnModel.j"
import "Player.j"
import "Preferences.j"
var BotonBrowserIdentifier = "BotonBrowserIdentifier" ,
    BotonMiListaIdentifier = "BotonMiListaIdentifier",
    AddSongToolbarItemIdentifier = "AddSongToolbarItemIdentifier",
    RemoveSongToolbarItemIdentifier = "RemoveSongToolbarItemIdentifier"
    preferencesItemIdentifier = "preferencesItemIdentifier";


@implementation AppController : CPObject
{
    CPArray librarySongs;
    CPToolbar toolbar;
    MyList iListController;
    SFBrowser musicBrowser;
    Player playerController;
    Preferences preferencesWindow;
    CPImage bgImage;
    CPWindow theWindow;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	

    theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask];
    var contentView = [theWindow contentView];
    //bg
    bgImage = [[CPImage alloc] initWithContentsOfFile:"Resources/theGoldenAgeOf60.jpg" size:CPSizeMake(30, 25)];
    [contentView setBackgroundColor:[CPColor colorWithPatternImage:bgImage]];
    //sizes
    var bounds = [contentView bounds];
    librarySongs = [[CPArray alloc]init];    
    //el rectangulo de los controles
    toolbar= [[CPToolbar alloc] initWithIdentifier:@"main-toolbar"];
    [theWindow setToolbar: toolbar]; 
    [toolbar setDelegate:self];
     
    //testing...
    var demoList = [[CPArray alloc]init]; 
    var song1 = [[Song alloc] initWithSongTitle:@"I just can live a lie" setArtist:@"Carrie Underwood" setID:1 time:"4:00" pathToSong:NULL];
    [demoList addObject:song1];
    var song2 = [[Song alloc] initWithSongTitle:@"Last night" setArtist:@"AZ Yet" setID:2 time:"4:28" pathToSong:NULL];
    [demoList addObject:song2];
    var song3 = [[Song alloc] initWithSongTitle:@"My Last Breath (Live version)" setArtist:@"Evanescence" setID:3 time:"3:59" pathToSong:NULL];
    [demoList addObject:song3];
    var song4 = [[Song alloc] initWithSongTitle:@"Heaven Knows" setArtist:@"Faith Evans" setID:4 time:"5:43" pathToSong:NULL];
    [demoList addObject:song4];
    var song5 = [[Song alloc] initWithSongTitle:@"Trouble" setArtist:@"Pink" setID:5 time:"3:12" pathToSong:NULL];
    [demoList addObject:song5];
    var song6 = [[Song alloc] initWithSongTitle:@"Jaded" setArtist:@"Aerosmith" setID:6 time:"3:27" pathToSong:NULL];
    [demoList addObject:song6];
    var song7 = [[Song alloc] initWithSongTitle:@"Who Knew" setArtist:@"Pink" setID:7 time:"3:21" pathToSong:NULL];
    [demoList addObject:song7];
	var song8 = [[Song alloc] initWithSongTitle:@"Rewrite" setArtist:@"Asian Kung Fu Generation" setID:8 time:"3:47" pathToSong:"Resources/LocalMusic/Rewrite.mp3"];	
    [demoList addObject:song8];
	var song9 = [[Song alloc] initWithSongTitle:@"o.O" setArtist:@"someone" setID:9 time:"??:??" pathToSong:"Resources/LocalMusic/1hz-10khz-sweep.mp3"];	
    [demoList addObject:song9];
    [self addSongList: demoList];
    //brings the window to the front
    [theWindow orderFront:self];
    [self openBrowser];
	[self openMyList];
    [self openPlayer];
}
-(void)addSong:(Song)aSong 
{   if(!musicBrowser)
         musicBrowser = [[SFBrowser alloc] initWithSource:librarySongs];
    [musicBrowser addItem: aSong];
}
- (void)addSongList:(CPArray)songs
{    
    if(!musicBrowser){
        musicBrowser = [[SFBrowser alloc] initWithSource:songs];
    }
    else{
        console.log("Just adding a song...");
        [musicBrowser addList:songs];
    }
}
-(void)removeSong{
    if(musicBrowser)
        [musicBrowser removeSelectedItems];
}
- (void)connection:(CPJSONPConnection)aConnection didReceiveData:(CPString)data
{
    [self addSongList: data.songs];
}

- (void)connection:(CPJSONPConnection)aConnection didFailWithError:(CPString)error
{
    alert(error);
}

/*Habre el player*/
-(void)openPlayer{
    if(!playerController)
        playerController = [[Player alloc]initWithMainBrowser:musicBrowser userBrowser:iListController];
    if([[playerController window] isVisible]){
        [[playerController window] setFrameOrigin:(CPPointMake(500, 560))];
        [[playerController window] orderOut:self];
    }
    else    
    [[playerController window] orderFront:self];
}
-(void)openPreferences{
    if(!preferencesWindow)
        preferencesWindow = [[Preferences alloc]initWithParentWindow:theWindow];
    if([[preferencesWindow window] isVisible]){
        [[preferencesWindow window] setFrameOrigin:(CPPointMake(500, 50))];
        [[preferencesWindow window] orderOut:self];
    }
    else    
    [[preferencesWindow window] orderFront:self];
}
/*Habre la lista de canciones del usuario*/
-(void)openMyList{
    if(!iListController)
        iListController = [[MyList alloc]init];
    if([[iListController window] isVisible]){
        [[iListController window] setFrameOrigin:(CPPointMake(900, 60))];
        [[iListController window] orderOut:self];
    }
    else    
    [[iListController window] orderFront:self];
}
/*Abre la ventana de canciones*/
-(void)openBrowser{
    if(!musicBrowser){
        console.log("Intentando crear nueva ventana...");
        musicBrowser = [[SFBrowser alloc] initWithSource:librarySongs];
    }
    if([[musicBrowser window]isVisible]){
        [[musicBrowser window] setFrameOrigin:(CPPointMake(0, 60))];
        [[musicBrowser window] orderOut:self];
    }
    else    
        [[musicBrowser window] orderFront:self];
}

- (CPArray)toolbarAllowedItemIdentifiers:(CPToolbar)aToolbar
{
   return [CPToolbarFlexibleSpaceItemIdentifier, BotonBrowserIdentifier,BotonMiListaIdentifier,AddSongToolbarItemIdentifier,RemoveSongToolbarItemIdentifier,preferencesItemIdentifier];
}

- (CPArray)toolbarDefaultItemIdentifiers:(CPToolbar)aToolbar
{
   return [BotonBrowserIdentifier,BotonMiListaIdentifier,AddSongToolbarItemIdentifier,RemoveSongToolbarItemIdentifier, CPToolbarFlexibleSpaceItemIdentifier,preferencesItemIdentifier];
}

- (CPToolbarItem)toolbar:(CPToolbar)aToolbar itemForItemIdentifier:(CPString)anItemIdentifier willBeInsertedIntoToolbar:(BOOL)aFlag
{
    var toolbarItem = [[CPToolbarItem alloc] initWithItemIdentifier: anItemIdentifier];

    if (anItemIdentifier == BotonBrowserIdentifier)
    {   //TODO crear una view y luego ponerle 
        // setAutoresizingMask: CPViewMinYMargin | CPViewMaxYMargin
		
		var image = [[CPImage alloc] initWithContentsOfFile:"Resources/listaGeneralIcon.png" size:CPSizeMake(30, 25)],
            highlighted = [[CPImage alloc] initWithContentsOfFile:"Resources/listaGeneralHightlighted.png" size:CPSizeMake(30, 25)];
			
		[toolbarItem setImage: image];
		[toolbarItem setAlternateImage: highlighted];
		
		[toolbarItem setTarget:self];
        [toolbarItem setAction:@selector(openBrowser)]; 
		[toolbarItem setLabel: "Music Browser"];
		 
        [toolbarItem setMinSize:CGSizeMake(32, 32)];
        [toolbarItem setMaxSize:CGSizeMake(32, 32)];
    }
    else if (anItemIdentifier == BotonMiListaIdentifier)
    {   //TODO crear una view y luego ponerle 
        // setAutoresizingMask: CPViewMinYMargin | CPViewMaxYMargin
		
		var image = [[CPImage alloc] initWithContentsOfFile:"Resources/iListIcon.png" size:CPSizeMake(30, 25)],
		highlighted = [[CPImage alloc] initWithContentsOfFile:"Resources/iListIconHightlighted.png" size:CPSizeMake(30, 25)];
		
		[toolbarItem setImage: image];
		[toolbarItem setAlternateImage: highlighted];
		
        [toolbarItem setTarget:self];
        [toolbarItem setAction:@selector(openMyList)]; 
		[toolbarItem setLabel:"iList"];

        [toolbarItem setMinSize:CGSizeMake(32, 32)];
        [toolbarItem setMaxSize:CGSizeMake(32, 32)];
    }
    else if (anItemIdentifier == AddSongToolbarItemIdentifier)
    {
        var image = [[CPImage alloc] initWithContentsOfFile:"Resources/add.png" size:CPSizeMake(30, 25)],
            highlighted = [[CPImage alloc] initWithContentsOfFile:"Resources/addHighlighted.png" size:CPSizeMake(30, 25)];
            
        [toolbarItem setImage: image];
        [toolbarItem setAlternateImage: highlighted];
        
        [toolbarItem setTarget: self];
        [toolbarItem setAction: @selector(addSong:)];
        [toolbarItem setLabel: "Add a song"];

        [toolbarItem setMinSize:CGSizeMake(32, 32)];
        [toolbarItem setMaxSize:CGSizeMake(32, 32)];
    }
    else if (anItemIdentifier == RemoveSongToolbarItemIdentifier)
    {        
        var image = [[CPImage alloc] initWithContentsOfFile:"Resources/remove.png" size:CPSizeMake(30, 25)],
        highlighted = [[CPImage alloc] initWithContentsOfFile:"Resources/removeHighlighted.png" size:CPSizeMake(30, 25)];
            
        [toolbarItem setImage: image];
        [toolbarItem setAlternateImage: highlighted];

        [toolbarItem setTarget: self];
        [toolbarItem setAction: @selector(removeSong)];
        [toolbarItem setLabel: "Remove a song"];
        
        [toolbarItem setMinSize:CGSizeMake(32, 32)];
        [toolbarItem setMaxSize:CGSizeMake(32, 32)];
    }
    else if (anItemIdentifier == preferencesItemIdentifier)
    {   //TODO crear una view y luego ponerle 
        // setAutoresizingMask: CPViewMinYMargin | CPViewMaxYMargin
        var image = [[CPImage alloc] initWithContentsOfFile:"Resources/prefrencesIcon.png" size:CPSizeMake(30, 25)],
            highlighted = [[CPImage alloc] initWithContentsOfFile:"Resources/prefrencesIconHightlighted.png" size:CPSizeMake(30, 25)];
		
		[toolbarItem setImage: image];
        [toolbarItem setAlternateImage: highlighted];
		
		[toolbarItem setTarget:self];
        [toolbarItem setAction:@selector(openPreferences)]; 
        [toolbarItem setLabel:"Prefrences"];
		
        [toolbarItem setMinSize:CGSizeMake(180, 32)];
        [toolbarItem setMaxSize:CGSizeMake(180, 32)];
    }

        
    return toolbarItem;
}

@end

