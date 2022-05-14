import time

from django.core.management import BaseCommand
import requests
from django.conf import settings

from restaurants.models import Restaurant, GooglePhoto


class Command(BaseCommand):
    help = 'Gets restaurants from google maps api'

    def add_arguments(self, parser):
        parser.add_argument('lat', nargs=1, type=float)
        parser.add_argument('lon', nargs=1, type=float)

    def handle(self, *args, **options):
        lat = options['lat'][0]
        lon = options['lon'][0]

        results = []

        page_token = None
        more_results = True
        while more_results and len(results) < 100:
            print(f'Getting new page. Have {len(results)}')

            url = f'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location={lat},{lon}' \
                  f'&type=restaurant' \
                  f'&radius=2000' \
                  f'&key={settings.GOOGLE_MAPS_API_KEY}'

            if page_token is not None:
                url = f'https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken={page_token}' \
                      f'&key={settings.GOOGLE_MAPS_API_KEY}'
                time.sleep(2)

            resp = requests.get(url)
            data = resp.json()

            page_token = data.get('next_page_token')
            if page_token is None:
                more_results = False

            results += data['results']

        print(f'Got {len(results)} entries. Saving them to database.')

        for res in results:
            if Restaurant.objects.filter(google_place_id=res['place_id']).exists():
                print(f'Restaurant "{res["name"]}" with place id "{res["place_id"]}" exists. Skipping it...')
                continue

            restaurant = Restaurant(
                name=res['name'],
                latitude=res['geometry']['location']['lat'],
                longitude=res['geometry']['location']['lng'],
                google_place_id=res['place_id'],
                google_rating=res.get('rating'),
                google_icon=res['icon'],
            )
            restaurant.save()

            for index, photo in enumerate(res.get('photos', [])):
                GooglePhoto(
                    restaurant=restaurant,
                    height=photo['height'],
                    width=photo['width'],
                    photo_reference=photo['photo_reference'],
                    index=index,
                ).save()
