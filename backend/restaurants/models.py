from django.db import models
from django.utils.translation import gettext_lazy as _

from restaurants import util


class Restaurant(models.Model):
    name = models.CharField(max_length=512, db_index=True)
    description = models.TextField()
    image_url = models.CharField(max_length=1024, blank=True)

    street_address = models.CharField(max_length=1024, blank=True)
    address_locality = models.CharField(max_length=1024, blank=True)
    postal_code = models.CharField(max_length=1024, blank=True)
    address_country = models.CharField(max_length=1024, blank=True)

    telephone = models.CharField(max_length=512, blank=True)

    latitude = models.FloatField()
    longitude = models.FloatField()

    rating = models.FloatField(null=True, blank=True)
    price_range = models.CharField(max_length=128, blank=True)

    def __str__(self):
        return self.name

    def to_dict(self) -> dict:
        return {
            'id': self.pk,
            'name': self.name,
            'description': self.description,
            'image_url': self.image_url,
            'latitude': self.latitude,
            'longitude': self.longitude,
            'address': {
                'street_address': self.street_address,
                'address_locality': self.address_locality,
                'postal_code': self.postal_code,
                'address_country': self.address_country,
            },
            'rating': self.rating,
        }


class MenuEntry(models.Model):
    restaurant = models.ForeignKey(Restaurant,
                                   related_name='menu_entries',
                                   on_delete=models.CASCADE,
                                   db_index=True)

    name = models.CharField(max_length=1024)
    description = models.TextField(blank=True)
    photo_url = models.CharField(max_length=1024, blank=True)

    index = models.IntegerField(default=0, db_index=True)

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
            'photo_url': self.photo_url,
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

    menu_entry = models.ForeignKey(MenuEntry,
                                   related_name='allergens',
                                   on_delete=models.CASCADE,
                                   db_index=True)
    allergen = models.CharField(max_length=128, choices=Allergen.choices, db_index=True)

    def __str__(self):
        return self.get_allergen_display()

    class Meta:
        unique_together = ['menu_entry', 'allergen']
