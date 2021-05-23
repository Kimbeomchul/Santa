from allauth.socialaccount.providers.google.views import GoogleOAuth2Adapter
from allauth.socialaccount.providers.kakao.views import KakaoOAuth2Adapter
from django.contrib.auth import get_user_model
from dj_rest_auth.registration.views import SocialLoginView, SocialConnectView
from dj_rest_auth.registration.serializers import (SocialAccountSerializer,
                                                   SocialConnectSerializer,
                                                   SocialLoginSerializer,
                                                   VerifyEmailSerializer)
from rest_framework import status, viewsets
from rest_framework.decorators import action
from rest_framework.mixins import ListModelMixin, RetrieveModelMixin, UpdateModelMixin
from rest_framework.response import Response
from rest_framework.viewsets import GenericViewSet

from hiking.users.models import Board
from .serializers import UserSerializer, BoardSerializer
from .pagination import PageNumberPagination

User = get_user_model()


class UserViewSet(RetrieveModelMixin, ListModelMixin, UpdateModelMixin, GenericViewSet):
    serializer_class = UserSerializer
    queryset = User.objects.all()
    lookup_field = "username"

    def get_queryset(self, *args, **kwargs):
        print("겟 쿼리셋")
        return self.queryset.filter(id=self.request.user.id)

    @action(detail=False, methods=["GET"])
    def me(self, request):
        print("미 함수 작동")
        serializer = UserSerializer(request.user, context={"request": request})
        return Response(status=status.HTTP_200_OK, data=serializer.data)


class BoardViewSet(viewsets.ModelViewSet):
    queryset = Board.objects.all().order_by('-id')
    serializer_class = BoardSerializer
    pagination_class = PageNumberPagination

    # serlializer.save() 재정의
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class GoogleLogin(SocialLoginView):
    adapter_class = GoogleOAuth2Adapter
    # serializer_class = SocialLoginSerializer


class KaKaoLogin(SocialLoginView):
    adapter_class = KakaoOAuth2Adapter
