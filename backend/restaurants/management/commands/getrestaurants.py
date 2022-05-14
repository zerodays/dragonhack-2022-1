import json
import re
from xml.etree import ElementTree

import requests
from bs4 import BeautifulSoup
from django.core.management import BaseCommand
from restaurants.models import *


class Command(BaseCommand):
    help = 'Gets restaurants from wolt'

    def add_arguments(self, parser):
        parser.add_argument('sitemap_url', nargs=1, type=str)

    def handle(self, *args, **options):
        sitemap_url = options['sitemap_url'][0]
        resp = requests.get(sitemap_url)
        tree = ElementTree.fromstring(resp.content)
        # tree = ElementTree.parse('/Users/vidd/Desktop/resp.xml').getroot()

        urls = set()

        for child in tree.iter():
            attr = child.attrib
            if child.tag == '{http://www.w3.org/1999/xhtml}link':
                if attr['hreflang'] == 'en':
                    urls.add(attr['href'])

        for i, url in enumerate(urls):
            print(f'Getting restaurant {i} of {len(urls)}')
            save_restaurant_from_url(url)


def save_restaurant_from_url(url: str):
    content = requests.get(url).content
    # with open('/Users/vidd/Desktop/lars.html') as f:
    #     content = f.read()

    soup = BeautifulSoup(content, 'html.parser')

    restaurant_data = soup.find('script', type='application/ld+json')
    restaurant_data = json.loads(restaurant_data.text)

    if Restaurant.objects.filter(name=restaurant_data['name']).exists():
        print(f'Restaurant "{restaurant_data["name"]}" exists, skipping...')
        return

    images = restaurant_data.get('image', [])
    if len(images) > 0:
        image_url = images[0]
    else:
        image_url = ''

    rating = None
    if 'aggregateRating' in restaurant_data:
        rating = restaurant_data['aggregateRating']['ratingValue']

    restaurant = Restaurant(
        name=restaurant_data['name'],
        description=find_description(soup),
        image_url=image_url,
        street_address=restaurant_data['address']['streetAddress'],
        address_locality=restaurant_data['address']['addressLocality'],
        postal_code=restaurant_data['address']['postalCode'],
        address_country=restaurant_data['address']['addressCountry'],
        latitude=restaurant_data['geo']['latitude'],
        longitude=restaurant_data['geo']['longitude'],
        telephone=restaurant_data.get('telephone', ''),
        price_range=restaurant_data['priceRange'],
        rating=rating,
    )
    restaurant.save()

    save_menu(soup, restaurant)


def find_description(soup) -> str:
    desc = soup.find('p', class_='VenueHeroBanner__Description-sc-3gkm9v-4')
    return desc.text


def save_menu(soup, restaurant: Restaurant):
    menu_items = soup.find_all('div', class_='MenuItem-module__contentBorderContainer___kdCha')
    for index, item in enumerate(menu_items):
        name = item.find('p', class_='MenuItem-module__name___iqvnU').text
        desc_item = item.find('p', class_='MenuItem-module__description___uzvuX')
        if desc_item:
            description = desc_item.text
        else:
            description = ''

        image_url = ''
        image_item = item.find('div', class_='ImageWithTransition-module__image___VEvNt')
        if image_item:
            urls = re.compile(r'\((.+)\)').findall(image_item.attrs['style'])
            if len(urls) > 0:
                image_url = urls[0]

        MenuEntry(
            restaurant=restaurant,
            name=name,
            description=description,
            photo_url=image_url,
            index=index,
        ).save()
