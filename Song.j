//
//  Song.j
//  XYZRadio
//
//  Created by Alos on 10/2/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

import <Foundation/CPObject.j>

@implementation Song: CPObject
{
    CPString songTitle;
    CPString artist;
    CPString time;
    CPString genre
    int ID;
    BOOL isLocal;
	CPString pathToSong;
    id delegate;
    CPView superview;
}

-(id)initWithSongTitle:(CPString)aSongTitle setArtist:(CPString)anArtist setID:(int)anID time:(CPString)aTime pathToSong:(CPString)aPath{
    if(self = [super init]){
        songTitle = aSongTitle;
        artist = anArtist;
        ID = anID;
        isLocal = false;
        time=aTime;
		pathToSong=aPath;
    }
    return self;
}

- (void) setSongTitle:(CPString) aSong{
    songTitle = aSong;
}
- (CPString)songTitle{
    return songTitle;
}
- (void) setArtist:(CPString)anArtist{
    artist = anArtist;
}
- (CPString)artist{
    return artist;
}
-(void)setTime:(CPString)aTime{
    time=aTime;
}
-(CPString)time{
    return time;
}
-(void)setGenre:(CPString)aGenre{
    genre=aGenre;
}
-(CPString)genre{
    return genre;
}
-(void)setID:(int)anID{
    ID=anID;
}
- (int)ID{
    return ID;
}

-(void)setPathToSong:(CPString)aPath{
	pathToSong=aPath;
}
-(CPString)pathToSong{
	return pathToSong;
}

- (void) setLocal:(BOOL)local{
    isLocal=local;
}
- (BOOL)isLocal{
    return isLocal;
}
-(BOOL)isEqual:(id)anObject{
if([[anObject class] instancesRespondToSelector:@selector(ID)])
    if([anObject ID]==[self ID])
        return YES;
    else
        return NO;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:songTitle forKey:@"SongTitle"];
    [aCoder encodeObject:artist forKey:@"Artist"];
    [aCoder encodeObject:ID forKey:@"ID"];
    [aCoder encodeObject:isLocal forKey:@"isLocal"];
    [aCoder encodeObject:time forKey:@"time"];
	[aCoder encodeObject:pathToSong forKey:@"pathToSong"];
}

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
        songTitle = [aCoder decodeObjectForKey:@"SongTitle"];
        artist = [aCoder decodeObjectForKey:@"Artist"];
        ID = [aCoder decodeObjectForKey:@"ID"];
        isLocal = [aCoder decodeObjectForKey:@"isLocal"];
        time = [aCoder decodeObjectForKey:@"time"];
		pathToSong = [aCoder decodeObjectForKey:@"pathToSong"];
    }
    
    return self;
}

@end
