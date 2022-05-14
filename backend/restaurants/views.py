import json

from django.http import HttpResponse
from django.views.decorators.http import require_GET

from restaurants import util
from restaurants.models import Restaurant


def json_response(data, status: int = 200) -> HttpResponse:
    return HttpResponse(json.dumps(data), content_type='application/json', status=status)


@require_GET
def restaurants_view(request):
    restaurants = Restaurant.objects.all().order_by('name')
    restaurants = util.to_list(restaurants)
    return json_response(restaurants)
