from rest_framework.pagination import CursorPagination


class PageNumberPagination(CursorPagination):
    page_size = 10
    cursor_query_param = 'id'
    ordering = '-id'
