> /asgi.py - нужен для асинхронных веб-серверов и прил.
> /wsgi.py - нужен для синхронных веб-серверов и прил.

### manage.py
> runserver - рансервер
> makemigrations - создать файл миграций
> migrate - мигрировать из файла ^
> createsuperuser - создать суперюзера


### settings.py

BASE_DIR = ... - корень проекта
DEBUG = True - режим отладки, на релизе  установить в фолс
ALLOWED_HOSTS = [] - домен сайта
PROJECT_ROOT = os.path.dirname(os.path.dirname(__file__)) - путь проекта, понадобиться в темплейтах

INSTALLED_APS = [] - приложения
MIDDLEWARE = [] - список промежуточных слоёв(проверки, авторизации ..)
ROOT_URLCONF = [] - модуль, к-рый содержит корневые шаблоны юрлов

TEMPLATES = [{..., 'DIRS': [os.path.join(PROJECT_ROOT, 'templates')],.... }]  - прописать путь для темплейтов
DATABASES ={} - настройки бд

STATIC_URL = '/static/'
STATIC_DIR = os.path.join(BASE_DIR, 'static')
STATICFILES_DIRS = [STATIC_DIR] - настройки статики

LANGUAGE_CODE = 'ru-ru' - язык адм. панели
USE_TZ = True 

### app

/app/admin.py - модели в адм. панели джанго, логика поведения админки
/app/apps.py - конфигурация приложения
/app/models.py - модели (бд)
/app/tests.py - тесты
/app/views.py - логика. Запрос-ответ (html, redirect, 404...)
/app/migrations - миграции
/app/urls.py - юрлы приложения
/app/forms.py - формы

### models
TODO: описать типы

get_absolute_url - могут использоваться другими классами, в админке появится ссылка на экземпляр модели на сайте
save - можно подмешать в запись в бд
```
def get_absolute_url(self):
	return reverse("url_name", kwargs = {"slug": self.some_field})
	
def save(self, *args, **kwargs):
    super.save(*args, **kwargs)

class Meta:
    verbose_name = 'Name'
    verbose_name_plural = 'Names'
    ordering = ["-value"]
```

SomeModel.objects.all() # вытащить всё
SomeModel.objects.create(field_1 = 'value', field_2 = 'value') # создать 
SomeModel.objects.count() # узнать кол-во строк
SomeModel.objects.filter(some_field=some_value) # вытащить по условию, вернет queryset (get вернет объект) 
подробнее django filter queries
SomeModel.objects.update_or_create() # обновить или создать
>  https://docs.djangoproject.com/en/3.1/ref/models/querysets/#django.db.models.query.QuerySet

SomeModel.objects.exclude(some_field=some_value) # исключить

SomeModel.objects.get(some_field__param='value') # вместо param, value подставить:
- param = iexact, value = "BlA-bLa" # Case-insensitive exact match. поиск по полю без учета регистра
- param = contains, value = "bla" # содержит bla


### templates

{{ view }} - вытаскивает вью для этого хтмл

m2m циклом, для обратной связи используется related_name в моделях, поле является менеджером

статика:
{% load static %}
<head>
<link rel = "stylesheeet" href = "{% static 'some_path/some_style.css' %}">

TODO: выяснить, как точно эта штука работает   \/
{% url name_from_url some_model.link_part %} # в урлах, в path должен быть 3-й атрибут. some_model.link_part - ссылка, которая будет передаваться в урлы 

{% some_model.get_absolute_url %} # вытащить урл с модели, если написать этот метод в модели
{% for item in main_model.fkitems_set %} # у модели fkitems есть foreign key main_model. из main_model можно вытащить fkitems_set

темплейт-теги в:
app/templatetags/some_tag.py
```
register = template.Library() 

@register.simple_tag()   # есть ещё @register.inclusion_tag('app_name/tags/tagname.html'), возвращает  {"tagname": queryset}
def get_something():
    return SomeModel.objects.all()
```
в темплейте:
```
{% load some_tag %}
{% get_something as something %}
{% for anything in something %}...
```


### admin

импорт всех моделей, потом регистрация в админке: 
> admin.site.register(модель)
```
class AnythingInLine(admin.StackedInline): # admin.TabularInline поля модели Anything горизонтально
    model = Anything
    extra = 1 # добавить список чего-либо в модель (например список комментов к фильму). extra - количество новых пустых полей
	readonly_fields = ('field_1',) # только для чтения
 
@admin.register(AnyModel)
class AnyModelAdmin(admin.ModelAdmin):
    list_display = ('viewed_field', 'viewed_field_2') # отображать поля в админке
    list_display_links = ('viewed_field_2',) # кликабельные поля
    list_filter = ('viewed_field',) # можно фильтровать по полям 
    search_fields = ('viewed_field', 'viewed_field_2__field') # Поиск по полям viewed_field_2__field - поле field модели viewed_field_2
    inlines = [AnythingInLine] # добавить список 
	save_on_top = True # кнопка сохранения вверху
	save_as = True # добавить сохранить как
	list_editable = ("field",) # разрешить редактировать не открывая
	fields = (("field1", "field2", "field3"),) # поля, которые выведутся. в тюпле в одну строку 
```
	
### views
TODO: описать какой миксин, за что отвечает

class Views: # От него наследоваться, есть метод as_view(), можно вставлять в урлы
```
class AnyView(View):
	def get(self, request, pk): #принимает гет-запросы хттп, pk - primary key, если надо
		# anymodels = AnyModel.objects.all()  # сохраняем queryset всех объектов модели. вместо all можно использовать filter(some_attr = 'something')
		some_model = AnyModel.objects.get(id=pk)  
		return render(request, "some_template.html", {"some_model": some_model})  # в случае списка объектов - {"models_list": anymodels} в шаблонизаторе можно будет пройтись циклом по models_list 
```


class ListView # позволяет выводить список моделей
class DetailView # позволяет выводить определенную модель
```
class AnyView(ListView):
	model = AnyModel
	queryset = AnyModel.objects.all()
	template_name = "some_template.html" #если не указать, сгененрирует сам
```

```
class AnyView(DetailView):
	model = AnyModel
	slug_field = "link_part"  # TODO: разобраться. в примере было url, url в примере поле модели
	# detail будет автоматически подставлять суфикс detail.html для поиска в темплейтах (на основании model)
```


### urls

urlpatterns = [path("<int: pk>/", some_view)] # может принимать число можно <slug: variable>. Можно добавить name=name_for_templates TODO: уточнить про slug


### forms
```
class AnyForm(forms.ModelForm):
    class Meta:
        model = SomeModel
        fields = ('name', 'email', 'text') # тащит с хтмл поля c name = 'name', 'email', 'text' 
		# потом во вью можно сохранять в модель TODO разобраться, плохо понятно
```
		
		
### permissions
Миксин для проверки залогиненности:
> from django.contrib.auth.mixins import LoginRequiredMixin 
>
есть бул. поле raise_exception: тру(403), фолс(редирект на логин) 

в темплейтах проверить админа:
```
{% if request.user.is_authenticated and request.user.is_staff %} {% endif %}
```

### pagination
Вариант1 (требует ordering в модели):

теория :
```
from django.core.paginator import Paginator

OBJ_PER_PAGE = 10

paginator = Paginator(queryset, OBJ_PER_PAGE)
page1 = paginator.get_page(1)
dir(page1) # >>> 'count', 'end_index', 'has_next', 'has_other_pages', 'has_previous', 'index', 'next_page_number', 
# 'number', 'object_list', 'paginator', 'previous_page_number', 'start_index'
```

во вьюхах:
```
paginator = Paginator(queryset, OBJ_PER_PAGE)
page_number = request.GET.get('page', 1) # для ссылки типа blabla/?page=2 
page = paginator.get_page(page_number)
return render(request, template_name, context = {'page': page})
```
в темплейтах:
```
{% for p_number in page.paginator.page_range %}
    {% if page.number == p_number %}
        <a href="?page={{ p_number }}">текущая</a>
    {% elif p_number > page.number|add:-3 and p_number > page.number|add:3 %}
        <a href="?page={{ p_number }}">{{ p_number }}</a>
    {% endif %}
{% endfor %}
```


### libs

- from django.urls import path, include  # path для путей в урлах, include для подключения путей из файла
- from django.urls import reverse # формирование ссылки на основании name в urls
- from django.shortcuts import render, redirect 
- from django.views.generic import ListView, DetailView # дженерики (вьюхи, которые всё делают за тебя)  
- from django.core.paginator import Paginator 
- from django.contrib.auth.mixins import LoginRequiredMixin 
