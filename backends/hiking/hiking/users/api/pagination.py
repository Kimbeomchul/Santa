from rest_framework.pagination import LimitOffsetPagination


class PageNumberPagination(LimitOffsetPagination):
    page_size = 10
    cursor_query_param = 'id'
    ordering = '-id'
