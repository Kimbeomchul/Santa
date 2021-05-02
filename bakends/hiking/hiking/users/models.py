from django.conf import settings
from django.contrib.auth.models import AbstractUser
from django.db import models
from django.urls import reverse
from django.utils.translation import gettext_lazy as _


class User(AbstractUser):
    name = models.CharField(_("Name of User"), blank=True, max_length=255)
    first_name = None
    last_name = None

    def get_absolute_url(self):
        """Get url for user's detail view.

        Returns:
            str: URL for user detail.

        """
        return reverse("users:detail", kwargs={"username": self.username})


class Profile(models.Model):
    """Default user for Santa_Mobile_Project."""

    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    phone = models.CharField(max_length=100)

    class Meta:
        db_table = 'account_profile'
        app_label = 'account'
