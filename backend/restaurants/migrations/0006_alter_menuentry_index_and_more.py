# Generated by Django 4.0.4 on 2022-05-14 15:16

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('restaurants', '0005_restaurant_price_range_restaurant_telephone'),
    ]

    operations = [
        migrations.AlterField(
            model_name='menuentry',
            name='index',
            field=models.IntegerField(db_index=True, default=0),
        ),
        migrations.AlterField(
            model_name='menuentryallergen',
            name='allergen',
            field=models.CharField(choices=[('CEREALS', 'Cereals'), ('CRUSTACEANS', 'Crustaceans'), ('EGGS', 'Eggs'), ('FISH', 'Fish'), ('PEANUTS', 'Peanuts'), ('SOYBEANS', 'Soybeans'), ('MILK', 'Milk'), ('NUTS', 'Nuts'), ('CELERY', 'Celery'), ('MUSTARD', 'Mustard'), ('SESAME_SEEDS', 'Sesame seeds'), ('SULPHUR_DIOXIDE', 'Sulphur dioxide'), ('LUPIN', 'Lupin'), ('MOLLUSCS', 'Molluscs')], db_index=True, max_length=128),
        ),
        migrations.AlterField(
            model_name='restaurant',
            name='name',
            field=models.CharField(db_index=True, max_length=512),
        ),
    ]