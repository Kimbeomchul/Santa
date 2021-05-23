from django.conf import settings
from rest_framework.routers import DefaultRouter, SimpleRouter

from hiking.users.api.views import UserViewSet, BoardViewSet

if settings.DEBUG:
    router = DefaultRouter()
else:
    router = SimpleRouter()

router.register("users", UserViewSet)
router.register("board", BoardViewSet)


app_name = "api"
urlpatterns = router.urls
