from django.contrib import admin
from restaurants.models import *


@admin.register(Restaurant)
class RestaurantAdmin(admin.ModelAdmin):
    list_display = ('name', 'latitude', 'longitude', 'google_rating',)
    ordering = ('name',)


@admin.register(GooglePhoto)
class GooglePhotoAdmin(admin.ModelAdmin):
    list_display = ('restaurant', 'height', 'width', 'index',)
    list_editable = ('index',)
    ordering = ('restaurant', 'index',)


@admin.register(MenuEntry)
class MenuEntryAdmin(admin.ModelAdmin):
    list_display = ('name', 'restaurant', 'index',)
    list_editable = ('index',)
    ordering = ('restaurant', 'name',)


@admin.register(MenuEntryAllergen)
class MenuEntryAllergenAdmin(admin.ModelAdmin):
    list_display = ('menu_entry', 'allergen',)
    ordering = ('menu_entry', 'allergen',)
