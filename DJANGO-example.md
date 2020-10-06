_создано на основе видео:_ 
https://www.youtube.com/watch?v=w4nrT7emiVc

### Создать проект:
в cmd из папки, где будет проект:
> django-admin startproject projectname

### Запустить сервер:
в cmd из папки внутри проекта (в папке должен быть manage.py)
> python manage.py runserver

пока в конфиге(settings.py) "DEBUG = True", сервер будет писать все ошибки, в таком виде не заливать

### Создать приложение:
> python manage.py startapp articles

articles - это appname, можно любое
--
если создавать папку apps внутри проекта, то в settings.py добавить:
```
import sys

PROJECT_ROOT = os.path.dirname(__file__)
sys.path.insert(0, os.path.join(PROJECT_ROOT, 'apps'))

```
Сюда же можно добавить в установленные приложения (понадобится для миграции):

```
INSTALLED_APPS = [
    'articles.apps.ArticlesConfig',
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
]
```

---
Создаём urls.py
> articles/urls.py

```
from django.urls import path

from . import views

urlpatterns =[
    path('', views.index, name = 'index' )
]
```

в urls проекта добавляем urls приложения
> projectname/urls.py

```
from django.urls import path, include

# в список url_patterns добавляем  path('articles/', include('articles.urls'))

urlpatterns = [
    path('articles/', include('articles.urls')),
    path('admin/', admin.site.urls),
]
```

в views.py приложения удаляем всё и пишем:
> articles/views.py

```
from django.http import HttpResponse


def index(request):
    return HttpResponse("Привет мир!")
```

После этого, если открыть 
>http://127.0.0.1:8000/articles/

получим страницу "привет мир" 

---
Можем добавить тестовую страницу:

в urls.py приложения добавим ассоциацию в список urlpatterns:
> articles/urls.py (списко urlpatterns)

```
 path('test/', views.test, name='test')
# при переходе по 'http://127.0.0.1:8000/articles/test/' запустится views.test
```

теперь в views.py приложения нужно добавить эту функцию:
> articles/views.py
```
def test(request):
    return HttpResponse("Тестовая страница")
```

### Создаём модель (логическую структуру приложения, класс)
> articles/models.py

```
from django.db import models


class Article(models.Model):
    article_title = models.CharField('название статьи', max_length=200)
    article_text = models.TextField('текст статьи')
    pub_date = models.DateTimeField('дата публикации')


class Comment(models.Model):
    article = models.ForeignKey(Article, on_delete=models.CASCADE)  # on_delete - что-то сделать
    # во время удаления комментария. В данном случае, если будет удалена статья, будет удален и коммент
    author_name = models.CharField('имя автора', max_length=50)
    comment_text = models.CharField('текст комментария', max_length=200)
```

### Мигрируем модели в базу данных:
в cmd из папки внутри проекта (в папке должен быть manage.py):
> python manage.py makemigrations articles

Проверить sql команды:
> python manage.py sqlmigrate articles 0001

Выполнить миграцию:
> python manage.py migrate


### Django shell (api для работы с бд через джанго)
> python manage.py shell
> 
>| >>>> from articles.models import Article, Comment
>
>| >>> Article.objects.all()

вернет все статьи из бд 
>| >>> from django.utils import timezone

>| >>>  a = Article(article_title="Какая-то статья", article_text="Текст статьи", pub_date=timezone.now())

создали экземпляр модели
>| >>> a.save()

добавили в бд   
>|>>> a.article_title

>|>>> a.id

>|>>> a.article_title = "Какая-то другая статья"
>|>>> a.save()

Выше команды, с помощью которых можно посмотреть атрибут модели или id в базе данных, изменить какой-то параметр

Можно фильтровать:
>|>>>  Article.objects.filter(article_title__startswith = "Какая")

Если есть связь статьи с комментом, то можно подгрузить все комменты статьи 
(в моделе Comment article = models.ForeignKey(Article, on_delete=models.CASCADE)):

>|>>> a.comment_set.all()

>|>>> a.comment_set.create(author_name='John', comment_text="Крутая статья")

>>|>>> a.comment_set.create(author_name='Jack', comment_text="норм")

>|>>>a.comment_set.create(author_name='Волк', comment_text="отлично")
>
>|>>> a.comment_set.create(author_name='Стрелок', comment_text="ыыыы")
>
>|>>> a.comment_set.count()
>
>|>>> cs =  a.comment_set.filter(author_name__startswith='j')
>
>|>>> cs.delete()
---
### Создать админку:
> python manage.py createsuperuser

Язык админки можно поменять в settings.py. По умолчанию: LANGUAGE_CODE = 'en-us'
>LANGUAGE_CODE = 'ru-RU'
>
в admin.py добавляем
```
from .models import Article, Comment


admin.site.register(Article)
admin.site.register(Comment)
```

Изменить отображаемые имена можно в apps.py:
```
class ArticlesConfig(AppConfig):
    name = 'articles'
    verbose_name = 'Блог'  # добавить эту строчку
```
в models.py в каждую модель добавить класс мета. например в модель Article:
```
class Meta:
    verbose_name = 'Статья'
    verbose_name_plural = 'Статьи'
```

###templates/ шаблонизаторы
создаём папку templates/articles в подпапке проекта (там же, где и apps)

в settings.py в блок templates в DIRS добавляем:
```
'DIRS': [os.path.join(PROJECT_ROOT, 'templates')],
```

создаём templates/base.html
```
<!DOCTYPE html>
<html>
<head>
    <meta charset = "utf-8">
    <title>{% block title %}Мой сайт{% endblock %}</title>
</head>
<body>

    {% block content %}{% endblock %}

</body>
</html>
```
в templates/articles создаём list.html:
```
{% extends 'base.html' %}

{% block title %}Последние статьи{% endblock %}

{% block content %}

    блабла

{% endblock %}
```

Во views.py:
```
from django.shortcuts import render


def index(request):
    return render(request, 'articles/list.html')
```