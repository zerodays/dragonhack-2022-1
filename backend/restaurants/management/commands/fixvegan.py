from django.core.management import BaseCommand

from restaurants.models import MenuEntry, MenuEntryAllergen


class Command(BaseCommand):
    help = 'Generates allergens for menu items'

    def handle(self, *args, **options):
        entries = MenuEntry.objects.all()
        for i, entry in enumerate(entries):
            if i % 100 == 0:
                print(f'Fixing vegan for {i} of {len(entries)}')

            generate_allergens_for_entry(entry)


def generate_allergens_for_entry(entry: MenuEntry):
    name = entry.name.lower()
    desc = entry.description.lower()

    if 'vegan' in name or 'vegan' in desc:
        MenuEntryAllergen.objects.filter(menu_entry=entry,
                                         allergen__in=(
                                             MenuEntryAllergen.Allergen.CEREALS,
                                             MenuEntryAllergen.Allergen.CRUSTACEANS,
                                             MenuEntryAllergen.Allergen.EGGS,
                                             MenuEntryAllergen.Allergen.FISH,
                                             MenuEntryAllergen.Allergen.MILK,
                                             MenuEntryAllergen.Allergen.MOLLUSCS,
                                         )).delete()
