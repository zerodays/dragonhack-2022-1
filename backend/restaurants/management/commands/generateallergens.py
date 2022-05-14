from django.core.management import BaseCommand

from restaurants.models import MenuEntry, MenuEntryAllergen


class Command(BaseCommand):
    help = 'Generates allergens for menu items'

    def handle(self, *args, **options):
        entries = MenuEntry.objects.all()
        for i, entry in enumerate(entries):
            if i % 100 == 0:
                print(f'Getting allergens for {i} of {len(entries)}')

            generate_allergens_for_entry(entry)


def generate_allergens_for_entry(entry: MenuEntry):
    dictionary = {
        MenuEntryAllergen.Allergen.CEREALS: {
            'gluten',
            'pizza',
            'ajd',
            'pira',
            'pire',
            'piro',
            'piri',
            'pirin',
            'bombetk',
            'tortilij',
            'kruh',
            'moka',
            'moke',
            'moki',
            'moko',
            'flour',
            'wheet',
            'burger',
            'burek',
            'skut',
        },
        MenuEntryAllergen.Allergen.CRUSTACEANS: {
            'crustacean',
            'crab',
            'lobster',
            'shrimp',
            'barnacle',
            'rak',
            'jastog',
            'škamp',
            'morski sadež',
        },
        MenuEntryAllergen.Allergen.EGGS: {
            'egg',
            'jajc',
            'majonez',
            'mayo',
        },
        MenuEntryAllergen.Allergen.FISH: {
            'fish',
            'riba',
            'ribe',
            'ribi',
            'ribo',
            'ribji',
            'ribja',
            'ribje',
            'ribjo',
            'oslič',
            'skuš',
            'postrv',
            'tuna',
            'tune',
            'tuni',
            'tuno',
        },
        MenuEntryAllergen.Allergen.PEANUTS: {
            'peanut',
            'arašid',
        },
        MenuEntryAllergen.Allergen.SOYBEANS: {
            'soy',
            'soj',
        },
        MenuEntryAllergen.Allergen.MILK: {
            'milk',
            'mleko',
            'mleka',
            'mleku',
            'mleko',
            'mlekom',
            'sir',
            'chees',
            'chedar',
            'gorgonzol',
            'gaud',
            'mozzarell',
            'mocarel',
            'brie',
            'parmez',
            'maslo',
            'masla',
            'maslu',
            'maslom',
            'butter',
        },
        MenuEntryAllergen.Allergen.NUTS: {
            'nut',
            'oreščk',
        },
        MenuEntryAllergen.Allergen.CELERY: {
            'celery',
            'zelena',
            'zelene',
            'zeleno',
        },
        MenuEntryAllergen.Allergen.MUSTARD: {
            'mustard',
            'gorčic',
        },
        MenuEntryAllergen.Allergen.SESAME_SEEDS: {
            'sesame',
            'sezam',
        },
        MenuEntryAllergen.Allergen.SULPHUR_DIOXIDE: {
            'sulphur',
            'žvepl',
            'sulfit',
        },
        MenuEntryAllergen.Allergen.LUPIN: {
            'lupin',
            'volčji bob',
        },
        MenuEntryAllergen.Allergen.MOLLUSCS: {
            'molluscs',
            'mekuščk',
            'mekušček',
            'mehkužc',
            'mehkužec',
        },
    }

    for key, keywords in dictionary.items():
        if MenuEntryAllergen.objects.filter(menu_entry=entry, allergen=key).exists():
            continue

        name = entry.name.lower()
        desc = entry.description.lower()

        for keyword in keywords:
            if keyword in name or keyword in desc:
                MenuEntryAllergen(
                    menu_entry=entry,
                    allergen=key,
                ).save()
                break
