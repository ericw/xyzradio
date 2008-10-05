//
//  SFBrowser.j
//  XYZRadio
//
//  Created by Alos on 10/2/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

/*The Music browser*/
@implementation SFBrowser : CPWindowController
{
SFTable    libraryTable;
}

/*Una bonita contructora*/
- (id)initWithSource:(CPArray)list{
    //Initializing a window
    var win = [[CPPanel alloc] initWithContentRect:CGRectMake(0, 60, 800, 500)styleMask:CPHUDBackgroundWindowMask|CPClosableWindowMask];
    self = [super initWithWindow:win];
    if (self)//pa ver si no somos null :P
    {
        //le ponemos titulo al HUD lo centramos
        [win setTitle:@"Music Browser"];
        [win setFloatingPanel:YES];
        [win setDelegate:self];  
        var contentView = [win contentView];
        var bounds = [contentView bounds];
        //para los titulos
        var cmArray = [[CPArray alloc]init]; 
        var titleLabel =[[SFColumnModel alloc] initWithFrame:CGRectMake(0, 0, 248, 31) title:"Name" color:NULL];
        var artistLabel =[[SFColumnModel alloc] initWithFrame:CGRectMake(250, 0, 248, 31) title:"Artist" color: NULL];
        var timeLabel =[[SFColumnModel alloc] initWithFrame:CGRectMake(500, 0, 48, 31) title:"Time" color: NULL];
        var ratingLable =[[SFColumnModel alloc] initWithFrame:CGRectMake(550, 0, 48, 31) title:"Rating" color: NULL];
        [cmArray addObject: titleLabel]; 
        [cmArray addObject: artistLabel];
        [cmArray addObject: timeLabel];
        [cmArray addObject: ratingLable];
        //a table
        libraryTable = [[SFTable alloc] initWithColumnModel: cmArray model:list frame: bounds];
        
        [contentView addSubview: libraryTable];    
            
    }
    
    return self;
}
-(void)addItem:(CPObject)anObject{
    [libraryTable addItem:anObject];
}
-(void)addList:(CPArray)aModel
{   console.log("addlist here!");
    [libraryTable setModel: aModel];
}
-(void)removeSelectedItems{
   console.log("removeSlectedItems in SFBrowser got a msg");
   [libraryTable removeSelectedItems];
}


@end