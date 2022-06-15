from custom import *
import os
from api_methods import *
from auth import *
import json

#Database from [[https://www.aicrowd.com/challenges/spotify-million-playlist-dataset-challenge][this]] dataset
def reader(path, file):
    a = json.loads(open(path+file).read())['playlists']
    a = pd.DataFrame(a)
    a = a.fillna('')
    return a

def chunk_generator(ob, n):
    return [ob[i:i+n] for i in range(0, len(ob), n)]

path = "../../../data/CoE/spotify_million_playlist_dataset/data/"
fname = os.listdir(path)

dt = [reader(path, i) for i in fname[0:20]]
dt = pd.concat(dt)

tracks_playlists = []
for i, j in zip(dt['pid'], dt['tracks']):
    a = pd.DataFrame(j)
    a['pid'] = i
    tracks_playlists.append(a)

tracks_playlists = pd.concat(tracks_playlists)
dt = dt[["name", "description", "collaborative", "pid", "num_tracks", "num_albums", "num_followers", "duration_ms", "num_artists"]]
dt = dt.merge(tracks_playlists, left_on = 'pid', right_on = 'pid')

track_ids = np.unique(dt['track_uri']).tolist()
track_ids = [i.replace("spotify:track:", "") for i in track_ids]

c = chunk_generator(track_ids, 100)
c = [",".join(i) for i in c]

#Fetching features for chunks of tracks
features = [track_info(i, header) for i in c]

dfs = []
for k in features: 
    try:
        dfs.append(pd.DataFrame(k['audio_features']))
    except:
        print()
        
dfs = pd.concat(dfs)
dfs.to_csv("../../data/batSongs.csv")
