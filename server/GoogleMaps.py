import requests
from urllib.parse import urlencode

with open("private/apikey", 'r') as __tmpfd:
    API_KEY = __tmpfd.read()
URL = "https://maps.googleapis.com/maps/api/staticmap"

def request_to_GMap(**kwargs):
    return requests.get(URL, params={**kwargs, "api_key":API_KEY})


def get_maps_png(center, zoom=10, size=(256, 256), sensor=False):
    r = request_to_GMap(center=center, zoom=str(zoom), size=f"{size[0]}x{size[1]}", sensor=str(sensor).lower())
    with open("dbg", 'wb') as fd:
        fd.write(r.content)
    return r.content