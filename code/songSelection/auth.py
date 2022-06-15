import requests
import base64

#Requesting access to the spotify web API
client_id='c827578db9a348928a444f3bae71d5b3'
client_secret='94fed2893bb14b858d1b8a03098294c1'

auth_header_b64 = base64.b64encode(f'{client_id}:{client_secret}'.encode('ascii'))
auth_header = auth_header_b64.decode('ascii')

req_header =  {'Authorization' : f'Basic {auth_header}'}
payload = {"grant_type": "client_credentials"}
url = "https://accounts.spotify.com/api/token"
resp = requests.post(url, headers = req_header, data = payload)
token = resp.json()

#Defining header with access token
header = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": f"Bearer {token['access_token']}"
}
