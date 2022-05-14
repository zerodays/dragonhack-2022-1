from django.contrib import admin
from restaurants.models import *


@admin.register(Restaurant)
class RestaurantAdmin(admin.ModelAdmin):
    list_display = ('name', 'latitude', 'longitude', 'rating',)
    search_fields = ('name',)
    ordering = ('name',)


@admin.register(MenuEntry)
class MenuEntryAdmin(admin.ModelAdmin):
    list_display = ('name', 'restaurant', 'index',)
    list_editable = ('index',)
    ordering = ('restaurant', 'name',)
    search_fields = ('name',)


@admin.register(MenuEntryAllergen)
class MenuEntryAllergenAdmin(admin.ModelAdmin):
    list_display = ('menu_entry', 'allergen',)
    ordering = ('menu_entry', 'allergen',)
    search_fields = ('menu_entry__name', 'allergen',)
