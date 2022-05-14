import json

from django.db.models import OuterRef, Exists, Q
from django.http import HttpResponse
from django.views.decorators.http import require_GET

from restaurants import util
from restaurants.models import Restaurant, MenuEntryAllergen


def json_response(data, status: int = 200) -> HttpResponse:
    return HttpResponse(json.dumps(data), content_type='application/json', status=status)


@require_GET
def restaurants_view(request):
    restaurants = Restaurant.objects.all()

    exclude_param = request.GET.get('exclude', '')
    if exclude_param != '':
        exclude_param = exclude_param.split(',')
        outer_query = MenuEntryAllergen.objects.filter(
            Q(menu_entry__restaurant=OuterRef('pk')) & ~Q(allergen__in=exclude_param))
        restaurants = restaurants.filter(Exists(outer_query))

    restaurants = restaurants.order_by('name')
    restaurants = util.to_list(restaurants)
    return json_response(restaurants)


@require_GET
def menu_view(request, restaurant_pk):
    restaurant = Restaurant.objects.filter(pk=restaurant_pk).first()
    if restaurant is None:
        return json_response({'error': 'not_found'}, status=404)

    menu = restaurant.menu_entries.all()

    exclude_param = request.GET.get('exclude', '')
    if exclude_param != '':
        exclude_param = exclude_param.split(',')
        outer_query = MenuEntryAllergen.objects.filter(menu_entry=OuterRef('pk'), allergen__in=exclude_param)
        menu = menu.exclude(Exists(outer_query))

    menu = menu.order_by('index')

    menu = util.to_list(menu)
    return json_response(menu)
