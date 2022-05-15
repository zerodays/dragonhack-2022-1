# Backend

Backend includes scripts for scraping the restaurants, generating allergens and API endpoints.
It is written in python and uses postgresql database.

## Developing

1. Create a venv environment and install dependencies with
    ```shell
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    ```
2. Start a local database with
    ```shell
    docker run -p 5432:5432 -e POSTGRES_USER=dragonhack -e POSTGRES_PASSWORD=rootroot -v dragonhack:/var/lib/postgresql/data -d postgres:14
    ```
3. Configure environment variables with
    ```shell
    cp .env.example .env
    source .env
    ```
4. Run migrations
    ```shell=
    python manage.py migrate
    ```
5. Run the development server with
    ```shell
    python manage.py runserver
    ```
6. Write some code 🤓.

## API

All API endpoints have a prefix of `/api/v1`.
The following API endpoints are available:

### List restaurants

Lists all restaurants ordered by name or search score.

- **Method:** `GET`
- **URL:** `/restaurants`
- **GET Parameters:**
    - `search`: query string by which the restaurants are searched.
    - `exclude`: Items containing the specified allergens are excluded. Supported allergens are:
        - `CEREALS`
        - `CRUSTACEANS`
        - `EGGS`
        - `FISH`
        - `PEANUTS`
        - `SOYBEANS`
        - `MILK`
        - `NUTS`
        - `CELERY`
        - `MUSTARD`
        - `SESAME_SEEDS`
        - `SULPHUR_DIOXIDE`
        - `LUPIN`
        - `MOLLUSCS`
- **Returns:** Array of objects. Sample response:
   ```json
   [
    {
        "id": 294,
        "name": "3Roses",
        "description": "Bakery with meat, vegetarian and vegan daily fresh products",
        "image_url": "https://prod-wolt-venue-images-cdn.wolt.com/5e9cbd16f23c0e4bc0b0520d/bbab1430-8281-11ea-8538-0a586467b81d_3roses_listmenu_sps_005.jpg",
        "latitude": 46.055792251831626,
        "longitude": 14.505411697292555,
        "address": {
            "street_address": "Slovenska cesta 52",
            "address_locality": "Ljubljana",
            "postal_code": "1000",
            "address_country": "si"
        },
        "rating": 9.6
    },
    {
        "id": 259,
        "name": "5DU sendvič 4YOU",
        "description": "The best sandwiches - for you",
        "image_url": "https://prod-wolt-venue-images-cdn.wolt.com/6193d0eba2e115583e8804d6/38ad5ed2-4c63-11ec-9b69-120f7102529d_5dusendvic4u_menu_fe_5.jpg",
        "latitude": 46.0773752,
        "longitude": 14.5191468,
        "address": {
            "street_address": "This is a virtual venue",
            "address_locality": "Ljubljana",
            "postal_code": "1000",
            "address_country": "si"
        },
        "rating": null
    }
   ]
   ```
  
### Get menu for restaurant

Gets all menu items for restaurant, filtered by allergens.

- **Method:** `GET`
- **URL:** `/restaurants`
- **GET Parameters:**
    - `exclude`: Items containing the specified allergens are excluded. Supported allergens are:
        - `CEREALS`
        - `CRUSTACEANS`
        - `EGGS`
        - `FISH`
        - `PEANUTS`
        - `SOYBEANS`
        - `MILK`
        - `NUTS`
        - `CELERY`
        - `MUSTARD`
        - `SESAME_SEEDS`
        - `SULPHUR_DIOXIDE`
        - `LUPIN`
        - `MOLLUSCS`
- **Returns:** Array of objects. Sample response:
    ```json
    [
    {
        "id": 6977,
        "restaurant_id": 294,
        "name": "Pretzl",
        "description": "",
        "photo_url": "https://imageproxy.wolt.com/menu/menu-images/5e9cc00e2fd72eefb23102be/a359bbfe-8289-11ea-a427-0a58647f88f1_3roses_product_sps_002.jpeg",
        "allergens": []
    },
    {
        "id": 6978,
        "restaurant_id": 294,
        "name": "Butter croissant",
        "description": "",
        "photo_url": "https://imageproxy.wolt.com/menu/menu-images/5e9cc00e2fd72eefb23102be/b55477c2-8289-11ea-8c4b-0a586467167c_3roses_product_sps_003.jpeg",
        "allergens": [
            "Milk"
        ]
    }
    ]
    ```