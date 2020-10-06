print(name,age,sep = "/") - выведет значение переменной name, потом / без пробела, потом переменную age.
print(name,age,end = " ") - вместо переноса строки после выполнения принта будет пробел.
- a//b - равносильно int(a/b) - округляет до целой части после деления
- a%b - остаток от деления (a%2 - для четных будет 0, для нечётных 1)
- pass - заглушка

## СТРОКИ

string = 'stroka'  
print(string[-1]) - выведет a  
print(string[2:]) - выведет roka  
print(string.find("ok"))) - выведет 3 - индекс совпадения. Если не нашло, выведет -1  
list = string.split("o") - разбивка. вернет список["str","ka"]  
string.isdigit() - вернет false - проверяет, из цифр ли строка.  
string = string.upper() - к верхнему регистру  
string = string.lower() - к нижнему регистру  
len(string) - длина строки  
print(f'добавлена {string}') - выведет "добавлена stroka"  
print('добавлена {}'.format(string)) - аналогично выведет "добавлена stroka"
for i in string:
    if i.islower(): # проверяет, маленькая ли буква? 
        i.upper()   
    elif i.isupper():
        i.swapcase() # поменять регистр

ord('a') # узнать код символа в таблице ascii
chr(96) # вывести символ по коду ascii

## ПОСЛЕДОВАТЕЛЬНОСТИ

********Списки********

friends = ["Max", "Leo", "Ron"]  
tuple_friends = ("Max", "Leo", "Ron") - неизменяемый список (tuple, кортеж)  
friends.append("Charlie") - добавить элемент в конец  
friends.pop() - удалить последний элемент и вернуть его  
friends.clear() - очистить список  
friends.remove("Ron") - удалить элемент  
del friends[0] - удалить элемент по индексу  
friends.reverse() - перевернуть  
sorted(friends) - по алфавиту  
friends[:1] - срезать до 2-го эл-та  
friends[::-1] - перевернуть список (-1 - это шаг)  
len(friends) - узнать длину списка  


********Словари********


friend = {  
    "name": "Max",  
    "age": 20  
}

friend["name"] - получить элемент по ключу  
friend["has_car"] = True - добавить ключ/параметр  
friend["has_car"] = False - Изменить параметр  
del friend["age"] - удалить пару ключ/значение age  
age in friend - найти age в ключах friend  

for key, val in friend.items():  
    print(key)
    print(val)

**********Сэты**********

Не может быть 2х одинаковых эл-тов  
cities = {"Las Vegas", "Moscow", "Paris"}  
cities.add("Burma") - добавить эл-т  
cities.remove("Moscow") - удалить  
max_things = {'телефон', 'бритва', 'рубашка', 'шорты'}  
kate_things = {'телефон', 'шорты', 'зонтик', 'помада'}  
print(max_things | kate_things) - выведет все элементы  
print(max_things & kate_things)   
max_things.intersection(kate_things) - выведет все совпадающие элементы  
print(max_things - kate_things)  
max_things.difference(kate_things) - выведет все элементы, которых нет в max_things  

## БИБЛИОТЕКИ
import random as rd  
number = rd.randint(1,100)  
friends = ["Max", "Leo", "Ron"]  
rd.choice(friends) # случайный эл-т последовательности  
rd.shufle(friends) # перемешать последовательность  
rd.random() # случайно число от 0 до 1  
rd.sample(friends, 2) # список длинной 2 из последовательности friends  

import math  
math.sin(38)
from math import factorial, exp, log,log2,log10, sqrt, sin,cos,asin,acos # sqrt - корень
math.pi # вычисляет Пи
math.pow(number, 3) # равносильно number**3, степень
math.ceil(2.1) - округление для ближайшего большего числа (округлит до 3х) 

import os
print(os.name) # название ос, для вин - nt
os.getcwd() # текущая папка
new_path = os.path.join(os.getcwd(), "new_folder") #создать новый путь. Не создаёт папку, *
*#  только путь! на основании пути уже можно создать папку
os.mkdir(new_path) # а эта команда уже создаёт папку на основании пути
print(os.listdir()) # выведет список файлов и папок в тек. дирректории
os.path.isdir('Название папки') - проверяет наличие папки
os.rmdir('Название папки') - удаляет папку
os.remove('Название файла') - удаляет файл
os.chdir('название папки') - изменить путь, по аналогии cd

import datetime
current_time = datetime.datetime.now() # текущее время
x = datetime.datetime(2020, 5, 17) # создать новый объект с определенной датой

import shutil
shutil.copytree('name', 'new_name') # копировать папку
shutil.copy('name', 'new_name') # копировать файл


import sys
sys.executable # путь к интерпретатору питон
sys.exit() # выход из python, завершает текущую прогу
sys.platform  # информация об ос (для винды выведет вин32)
sys.argv # список аргументов командной строки
for p in sys.path: # список путей поиска модулей. можно использовать append
    print(p)
sys.argv[0] # путь к запускаемому скрипту. Остальные параметры, укзанные через пробел, *  
*# записываются в следующие индексы

import copy - для копирования списков (метод deepcopy), подр. ниже
import json - для сериализации, подр. ниже
import pickle - для сериализации, подр. ниже

import re - подробнее в complicated_things.md
txt = "The rain in Spain"
x = re.search("^The.*Spain$", txt) # вернет объект, если он начинается на the, заканч Spain
## ФУНКЦИИ
встроенные:
abs(-10) - модуль
min(1, 2, 3, 1, 24), max(1, 2, 3, 1, 24) - минимальное, максимальное значение
round(12.312415, 2) - округлить до 2знач. после запятой
sum - сумма элементов последовательности
enumerate - нумерация последовательности
list_anything = [1, 23, 4, 54.2, 7]
for number, item in enumerate(list_anything):
    print(number, "and", item)
   
Параметр по умолчанию:  
def greeting(say="Hello", name): # если say не передаётся - становится "Hello"  
    print(say, name)  
greeting("Max")

Если надо поменять глобальную переменную внутри функции:
global var_name = "new value"

