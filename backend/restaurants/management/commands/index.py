from django.core.management import BaseCommand

from restaurants.indexing import index_restaurant
from restaurants.models import Restaurant


class Command(BaseCommand):
    help = 'Index all restaurants'

    def handle(self, *args, **options):
        restaurants = Restaurant.objects.all()
        count = restaurants.count()

        for i, rest in enumerate(restaurants):
            if i % 100 == 0:
                print(f'Indexing restaurant {i} of {count}')

            index_restaurant(rest)
