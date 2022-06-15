import pandas as pd

# Upper quartile of energy, danceability, and instrumentalness;
# BPM of 100 (or between 95 and 105 if there’s too few songs)
# Upper and lower quartiles of acousticness

df = pd.read_csv('../../data/batSongs.csv')

#Filter by energy, danceability and instrumentalness
features = ['danceability', 'energy', 'instrumentalness']
dfFiltered = df.copy()

#Selecting only instrumental
upperQuantile = dfFiltered['instrumentalness'].describe().loc['75%']
dfFiltered = dfFiltered[dfFiltered['instrumentalness'] >= upperQuantile]

#Selecting upper quantiles of energy and danceability
dfFiltered['sum'] = dfFiltered['danceability'] + dfFiltered['energy']

upperQuantile = dfFiltered['sum'].describe().loc['75%']
lowerQuantile = dfFiltered['sum'].describe().loc['25%']

upper = dfFiltered[dfFiltered['sum'] >= upperQuantile]
lower = dfFiltered[dfFiltered['sum'] <= lowerQuantile]

upper['beatClarity'] = 'high'
lower['beatClarity'] = 'low'

dfFiltered = pd.concat([upper, lower])

#LowHigh tempos
lowTempo = dfFiltered.loc[(dfFiltered['tempo']>=75) & (dfFiltered['tempo'] <= 85)]
midTempo = dfFiltered.loc[(dfFiltered['tempo']>=95) & (dfFiltered['tempo'] <= 105)]
highTempo = dfFiltered.loc[(dfFiltered['tempo']>=128) & (dfFiltered['tempo'] <= 138)]

lowTempo['tempoClass'] = '80'
midTempo['tempoClass'] = '100'
highTempo['tempoClass'] = '133'

dfFiltered = pd.concat([lowTempo, midTempo, highTempo])

#High vs low accousticness
upper = dfFiltered['acousticness'].describe().loc['75%']
lower = dfFiltered['acousticness'].describe().loc['25%']

lowerAccousticness = dfFiltered[dfFiltered['acousticness'] <= lower]
upperAccousticness = dfFiltered[dfFiltered['acousticness'] >= upper]

lowerAccousticness['accousticnessClass'] = 'low'
upperAccousticness['accousticnessClass'] = 'high'

dfFiltered = pd.concat([lowerAccousticness, upperAccousticness])

dfFiltered['link'] = [f"https://open.spotify.com/track/{i}" for i in dfFiltered["id"]]

dfFiltered = dfFiltered[['link', 'beatClarity', 'accousticnessClass', 'tempoClass', 'tempo']]
dfFiltered.to_csv("./selectedBAT.csv")
