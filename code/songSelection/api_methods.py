import requests
import pandas as pd
from auth import *

#Formats strings for query
def string_formatter(s: str):
    strArr = list(s)
    for i, c in enumerate(strArr):
        if c == ' ': strArr[i] = "%20"
    return "".join(strArr).lower()

#Get respective spotify IDs for each song
def to_spotify_id(artist: str, track: str, header: dict):
    artist = string_formatter(artist)
    track = string_formatter(track)
    query = f"https://api.spotify.com/v1/search?q=track:{track}%20artist:{artist}&type=track&limit=1"
    obj = requests.get(query, headers = header).json()
    return obj

def audio_analysis(id, header):
    query = f"https://api.spotify.com/v1/audio-features/{id}"
    obj = requests.get(query, headers = header)
    r = obj.json()
    return r

def extractor(artist, song, header):
    o = to_spotify_id(artist, song, header)
    o = pd.DataFrame(o['tracks']['items'])
    o['artist_query'] = artist
    o['track_query'] = song
    print(f"finished song {song}")
    return o

def spotify_playlists(search_word, header: dict):
    query = f"https://api.spotify.com/v1/search?q={search_word}&type=playlist&limit=50"
    obj = requests.get(query, headers = header).json()
    return obj

#Getting info for tracks from id
def track_info(id, header):
    try:
        query = f"https://api.spotify.com/v1/audio-features?ids={id}"
        obj = requests.get(query, headers = header)
        r = obj.json()
        return r
    except:
        print('')
