from django.urls import path

from restaurants import views

urlpatterns = [
    path('restaurants/', views.restaurants_view),
    path('restaurants/<restaurant_pk>/menu/', views.menu_view),
    path('cigani_cors/', views.cigani_cors_view),
]
