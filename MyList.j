//
//  MyList.j
//  XYZRadio
//
//  Created by Alos on 10/2/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//
import <AppKit/CPPanel.j>
import <AppKit/CPWindowController.j>
import "Song.j"

@implementation MyList : CPWindowController
{
SFTable    userLibraryTable;
CPArray userList;
}

/*Una bonita contructora*/
- (id)init{
    var win = [[CPPanel alloc] initWithContentRect:CGRectMake(900, 60, 500, 500)styleMask:CPHUDBackgroundWindowMask|CPClosableWindowMask];
    self = [super initWithWindow:win];
    userList = [[CPArray alloc]init];   
    if (self)//pa ver si no somos null :P
    {
        //le ponemos titulo al HUD lo centramos
        [win setTitle:@"iList"];
        [win setFloatingPanel:YES];
        [win setDelegate:self];  
        var contentView = [win contentView];
        var bounds = [contentView bounds];
           
        
        var cmArray = [[CPArray alloc]init]; 
        var titleLabel =[[SFColumnModel alloc] initWithFrame:CGRectMake(0, 0, 248, 31) title:"Name" color:NULL];
        var artistLabel =[[SFColumnModel alloc] initWithFrame:CGRectMake(250, 0, 248, 31) title:"Artist" color: NULL];
        [cmArray addObject: titleLabel]; 
        [cmArray addObject: artistLabel];
        userLibraryTable = [[SFTable alloc] initWithColumnModel: cmArray model:userList frame: bounds];
        [contentView addSubview: userLibraryTable];
    }
    return self;
}
-(Song)getSelectedSong
{
	var index = [userLibraryTable getSelectedItem]; //we ask the table the selected item
	var aux = [userList objectAtIndex: index]; //we take said item from the list
	return aux;
}
- (CPTextField)labelWithTitle:(CPString)aTitle
{
    var label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
    
    [label setStringValue:aTitle];
    [label setTextColor:[CPColor whiteColor]];
    
    [label sizeToFit];

    return label;
}
@end