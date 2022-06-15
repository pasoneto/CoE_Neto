import pandas as pd

# Upper quartile of energy, danceability, and instrumentalness;
# BPM of 100 (or between 95 and 105 if there’s too few songs)
# Upper and lower quartiles of acousticness

df = pd.read_csv('../../../data/CoE/outputs/danceSongsCoE.csv')

#Filter by energy, danceability and instrumentalness
features = ['danceability', 'energy', 'instrumentalness']
dfFiltered = df.copy()
dfFiltered['sum'] = dfFiltered['danceability'] + dfFiltered['energy'] + dfFiltered['instrumentalness']

upperQuantile = dfFiltered['sum'].describe().loc['75%']
dfFiltered = dfFiltered[dfFiltered['sum'] >= upperQuantile]

#Tempo between 95 and 105
dfFiltered = dfFiltered.loc[(dfFiltered['tempo']>=95) & (dfFiltered['tempo'] <= 105)]

#High vs low accousticness
upper = dfFiltered['acousticness'].describe().loc['75%']
lower = dfFiltered['acousticness'].describe().loc['25%']

lowerAccousticness = dfFiltered[dfFiltered['acousticness'] <= lower]
upperAccousticness = dfFiltered[dfFiltered['acousticness'] >= upper]

lowerAccousticness['upperAccousticness'] = False
upperAccousticness['upperAccousticness'] = True

dfFiltered = pd.concat([lowerAccousticness, upperAccousticness])
dfFiltered

dfFiltered['link'] = [f"https://open.spotify.com/track/{i}" for i in dfFiltered["id"]]

dfFiltered[['link', 'upperAccousticness', 'energy', 'loudness', 'instrumentalness', 'danceability']]
dfFiltered.to_csv("./selectedDanceable.csv")
