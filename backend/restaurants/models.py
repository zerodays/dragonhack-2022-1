from django.db import models
from django.utils.translation import gettext_lazy as _

from restaurants import util


class Restaurant(models.Model):
    name = models.CharField(max_length=512)
    description = models.TextField()

    latitude = models.FloatField()
    longitude = models.FloatField()

    google_place_id = models.CharField(max_length=512, blank=True)
    google_rating = models.FloatField(null=True, blank=True)
    google_icon = models.CharField(max_length=1024, blank=True)

    def __str__(self):
        return self.name

    def to_dict(self) -> dict:
        photos = self.google_photos.all().order_by('index')
        photos = util.to_list(photos)

        menu_entries = self.menu_entries.all().order_by('index')
        menu_entries = util.to_list(menu_entries)

        return {
            'id': self.pk,
            'name': self.name,
            'description': self.description,
            'latitude': self.latitude,
            'longitude': self.longitude,
            'google_rating': self.google_rating,
            'google_icon': self.google_icon,
            'photos': photos,
            'menu': menu_entries,
        }


class GooglePhoto(models.Model):
    restaurant = models.ForeignKey(Restaurant, related_name='google_photos', on_delete=models.CASCADE)

    height = models.IntegerField()
    width = models.IntegerField()

    photo_reference = models.CharField(max_length=1024)

    index = models.IntegerField(default=0)

    def __str__(self):
        return f'Photo for {self.restaurant}'

    def to_dict(self) -> dict:
        return {
            'id': self.pk,
            'restaurant_id': self.restaurant.pk,
            'height': self.height,
            'width': self.width,
            'photo_reference': self.photo_reference,
        }


class MenuEntry(models.Model):
    restaurant = models.ForeignKey(Restaurant, related_name='menu_entries', on_delete=models.CASCADE)

    name = models.CharField(max_length=1024)
    description = models.TextField(blank=True)

    index = models.IntegerField(default=0)

    def __str__(self):
        return f'"{self.name}" in "{self.restaurant}"'

    def to_dict(self) -> dict:
        allergens = self.allergens.all()
        allergens = list(map(str, allergens))

        return {
            'id': self.pk,
            'restaurant_id': self.restaurant.pk,
            'name': self.name,
            'description': self.description,
            'allergens': allergens,
        }


class MenuEntryAllergen(models.Model):
    class Allergen(models.TextChoices):
        CEREALS = 'CEREALS', _('Cereals')
        CRUSTACEANS = 'CRUSTACEANS', _('Crustaceans')
        EGGS = 'EGGS', _('Eggs')
        FISH = 'FISH', _('Fish')
        PEANUTS = 'PEANUTS', _('Peanuts')
        SOYBEANS = 'SOYBEANS', _('Soybeans')
        MILK = 'MILK', _('Milk')
        NUTS = 'NUTS', _('Nuts')
        CELERY = 'CELERY', _('Celery')
        MUSTARD = 'MUSTARD', _('Mustard')
        SESAME_SEEDS = 'SESAME_SEEDS', _('Sesame seeds')
        SULPHUR_DIOXIDE = 'SULPHUR_DIOXIDE', _('Sulphur dioxide')
        LUPIN = 'LUPIN', _('Lupin')
        MOLLUSCS = 'MOLLUSCS', _('Molluscs')

    menu_entry = models.ForeignKey(MenuEntry, related_name='allergens', on_delete=models.CASCADE)
    allergen = models.CharField(max_length=128, choices=Allergen.choices)

    def __str__(self):
        return self.get_allergen_display()
