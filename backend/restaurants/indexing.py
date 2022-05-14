import meilisearch
from django.db.models.signals import post_save
from django.dispatch import receiver

from restaurants.models import *

client = meilisearch.Client('http://127.0.0.1:7700')


@receiver(post_save, sender=Restaurant)
def index_restaurant_receiver(sender, **kwargs):
    instance = kwargs['instance']
    index_restaurant(instance)


@receiver(post_save, sender=MenuEntry)
def index_menu_entry_receiver(sender, **kwargs):
    instance: MenuEntry = kwargs['instance']
    index_restaurant(instance.restaurant)


@receiver(post_save, sender=MenuEntryAllergen)
def index_menu_entry_receiver(sender, **kwargs):
    instance: MenuEntryAllergen = kwargs['instance']
    index_restaurant(instance.menu_entry.restaurant)


def index_restaurant(restaurant: Restaurant):
    rest_dict = restaurant.to_dict()
    menu = restaurant.menu_entries.all().order_by('index')
    menu = util.to_list(menu)
    rest_dict['menu'] = menu

    client.index('restaurants').add_documents([rest_dict])
