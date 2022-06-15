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

def dance_finder(data_frame, key_words):
    names_in = []
    for k, p in zip(data_frame['name'], data_frame['description']):
        for i in words:
            if (i in k) or (i in p):
                names_in.append(k)
    data_frame = data_frame[data_frame['name'].isin(names_in)]
    return data_frame

def doit(path, file, words):
    a = reader(path, file)
    a = dance_finder(a, words)
    return a

def chunk_generator(ob, n):
    return [ob[i:i+n] for i in range(0, len(ob), n)]

path = "../../../data/CoE/spotify_million_playlist_dataset/data/"
fname = os.listdir(path)

words = []
english = ['dance', 'dancing', 'move', 'moving', 'party', 'dancer', 'danceability']
portuguese = ['dança', 'dançando', 'movimento', 'movimentando', 'festa', 'dançar', 'dançabilidade']

for i in [english, portuguese]:
    for k in i:
        words.append(k)

dance = [doit(path, i, words) for i in fname]
dance = pd.concat(dance)

tracks_playlists = []
for i, j in zip(dance['pid'], dance['tracks']):
    a = pd.DataFrame(j)
    a['pid'] = i
    tracks_playlists.append(a)

tracks_playlists = pd.concat(tracks_playlists)
dance = dance[["name", "description", "collaborative", "pid", "num_tracks", "num_albums", "num_followers", "duration_ms", "num_artists"]]
dance = dance.merge(tracks_playlists, left_on = 'pid', right_on = 'pid')

track_ids = np.unique(dance['track_uri']).tolist()
track_ids = [i.replace("spotify:track:", "") for i in track_ids]

path = "../data/popscores/"

c = chunk_generator(track_ids, 100)
c = [",".join(i) for i in c]

#Fetching features for chunks of tracks
features = [track_info(i, header) for i in c]
features = pd.concat([pd.DataFrame(k['audio_features']) for k in features])


features.to_csv("../data/danceSongsCoE.csv")

#Re-reading songs for BAT selection
allSongs = [reader(path, i) for i in fname]









