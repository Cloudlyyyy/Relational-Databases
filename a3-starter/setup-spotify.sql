DROP TABLE IF EXISTS tracks;
DROP TABLE IF EXISTS artists;
DROP TABLE IF EXISTS albums;
DROP TABLE IF EXISTS playlists;

CREATE TABLE artists (
    artist_uri      VARCHAR(22),
    artist_name     VARCHAR(250)    NOT NULL,
    PRIMARY KEY (artist_uri)
);

CREATE TABLE albums (
    album_uri       VARCHAR(22),
    album_name      CHAR(250)       NOT NULL,
    release_date    TIMESTAMP       NOT NULL,
    PRIMARY KEY (album_uri)
);

CREATE TABLE playlists (
    playlist_uri    VARCHAR(22),
    playlist_name   CHAR(250)       NOT NULL, 
    PRIMARY KEY (playlist_uri)
);


CREATE TABLE tracks (
    track_uri    VARCHAR(22) NOT NULL,            
    playlist_uri VARCHAR(22) NOT NULL,  
    artist_uri   VARCHAR(22) NOT NULL ,
    album_uri    VARCHAR(22) NOT NULL,
    track_name   CHAR(250) NOT NULL, 
    preview_url  VARCHAR(300),
    added_by     VARCHAR(300), 
    duration_ms  INT NOT NULL,
    popularity   INT NOT NULL,
    added_at     TIMESTAMP NOT NULL,
    PRIMARY KEY (track_uri , playlist_uri),
    FOREIGN KEY (artist_uri) 
     REFERENCES artists(artist_uri) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (album_uri) 
     REFERENCES albums(album_uri) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (playlist_uri) 
     REFERENCES playlists(playlist_uri) ON UPDATE CASCADE ON DELETE CASCADE
);

-- can't load spotify -> ran into infile issue -> couldn't be resolved by command 