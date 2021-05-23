from django.contrib.auth import get_user_model
from rest_framework import serializers

from allauth.socialaccount.models import SocialAccount
from hiking.users.models import Board

User = get_user_model()


class UserSerializer(serializers.ModelSerializer):
    provider = serializers.SerializerMethodField('get_provider')
    photo = serializers.SerializerMethodField('get_photo')

    class Meta:
        model = User
        fields = ["id", "username", "name", "email", "provider", "photo", "url"]

        extra_kwargs = {
            "url": {"view_name": "api:user-detail", "lookup_field": "username"}
        }

    def get_provider(self, obj):
        social_account = SocialAccount.objects.get(user_id=obj.id)
        return social_account.provider

    def get_photo(self, obj):
        social_account = SocialAccount.objects.get(user_id=obj.id)
        print(social_account.extra_data['picture'])
        return social_account.extra_data['picture']


class BoardSerializer(serializers.ModelSerializer):
    user = serializers.ReadOnlyField(source='user.username')

    class Meta:
        model = Board
        fields = '__all__'
