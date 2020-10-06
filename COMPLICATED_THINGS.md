# Продвинутый уровень (для Кирилло-переводчиков всяких)
![meme_karina](https://cs9.pikabu.ru/images/big_size_comm/2017-01_3/148413032412518930.jpg)

## Позиционные и именованные аргументы
*args, **kwargs - передача нескольких параметров 
>(args - позиционные, kwargs - именные)  
```
def greeting(say, *args): # args создаёт кортеж
    print(say, args)  
greeting("hi", "Max", "Maya", "Cat", "Dog")
```

```
def get_person(**kwargs): # влетает словарь
    for k, v in kwargs.items():
        print k, v
get_person(name = "Leo", age = "20", has_car = True)
```

## Lambda-функции:
```
def my_filter(numbers, f): # принимаем функцию в кач-ве аргумента
    result = []
    for number in numbers:
        if f(number):
            result.append(number)
    return result
array = [1, 6, 2, 3, 4]
print(my filter(array, lambda number: number%2==0)) # return number%2 == 0

filter(function, iterable), map(function, iterable), # встроенные функции 
sorted(iterable, key=None, reverse = False)  # встроенная функция

print(list(filter(lambda number: number%2==0, array))) # отфильтрует все четные 
print(list(map(lambda number: number**2, array))) # помножит всё на себя
cities = [("Москва", 1000), ("Лас Вегас", 500), ("Антверпен", 2000)]
print(sorted(cities, key=lambda city: city[1]) # отсортирует по второму элемету тюплов ()
```

## Работа с файлами
```
with open("file_bytes.txt", "r", encoding="ascii") as f:  # with после отработки блока закроет файл 
     for line in f:  # читает файл построчно. 1 итерация - 1 строка
        print(line.replace("\n",""))
f.close() # закрыть файл Если открывать без with (типа f = open("file_bytes.txt", "r", encoding="ascii"))
with open("file_bytes.txt", "r", encoding="ascii") as f:  # with после отработки блока закроет файл 
     print(f.readlines()) # выведет список строк
```

#### params: r - чтение, w - запись (если нет - создаст) , x - запись (если нет - ошибка), a - (дозапись),
#### b - двоичный, + - чтение и запись
```
with open("file_bytes.txt", "w", encoding="utf-8") as f
    f.write("hello! \n") # запишет 1 строку
    f.writelines(["1234\n","123\n"]) # запишет список строк
```

## ***байты***

`str_b = b'stroka'` - записать стринг в байтах  
`print(str_b[1])`  -  выведет 116, а не t  
`str_string = str_b.decode("ascii")` -  декодирует из байт в строку  
`str_b = str_string.encode("ascii")` - кодирует из строки в байты  

## Сериализация
```
import json
import pickle
person = {"name": "MAX", "phones":[123,324]}
json_str = json.dumps(person, indent =4) # сохранит словарь в строку, indent делает отступы
pickle_str = pickle.dumps(person) # сохранит словарь в байты
person = json.loads(json_str) # загрузить словарь из строки
person = pickle.loads(pickle_str) # загрузить словарь из байт

with open("person.json", "w", encoding="utf-8") as f:
    json.dump(person, f) # сохранит словарь в файл в формате json
with open("person.pickle", "wb") as f:
    pickle.dump(person, f) # сохранит словарь в файл в байтах
with open("person.json", "r", encoding="utf-8") as f:
    person = json.load(f) # загрузит в словарь данные с json файла
with open("person.pickle", "rb") as f:
    person = pickle.load(f) # загрузит в словарь данные с файла байт
```

## Исключения; if, for, создание списка, словаря в 1 строку; or, and
```
is_russian = True
print('Привет' if is_russian else 'Hello') # Тернарный оператор. выведет Привет. Если бы False - Hello
numbers = [1, 2, 3, 4, 5, -1, -2, -3]
result = [number for number in numbers if number > 0]  # создаст список положительных чисел
pairs = [(1, 'a'), (2, 'b'),(3, 'c')]
result = {pair[0]:pair[1] for pair in pairs} # создаст словарь из списка 2йных тюплов
old_list = [1, -3, 4] # сложный пример формирования списка с if else и for внутри
new_list = [sqrt(number) if number >= 0 else number for number in some_list] 

a, b = 5, 6
print(f"{a} and {b} = {a&b}")
print(f"{a} or {b} = {a|b}")
print(f"{a} xor {b} = {a^b}")
print(f"not {a}  = {~a}")

генераторы - можно использовать 1 раз (в отличии от списка), но берут меньше памяти: 

gen = (i**2 for i in range(5))
print(list(gen)) # [0, 1, 4, 9, 16]
print(list(gen)) # []

```

#### для bool - False - пустые строки, списки, число 0. True - всё остальное

```
print([1] and 1 and 20 and 1.1 and None and 1) # вернет первый False, если нет - последний True
print([] or 0 or 0 or 0.0 or None or 1) # вернет первый True, если нет - последний False 

a = [1, 2, [0, 7]]
b = a  # создаст ссылку на a. МЕНЯЯ b БУДЕТ МЕНЯТЬСЯ И a !!!
b = a[:]  # создаёт не ссылку, а новый список, без учёта вложенных списков *
*#(меняя элемент с инд 2- поменяется везде)
b = a.copy() # создаёт не ссылку, а новый список, без учёта вложенных списков
b = list(a) # создаёт не ссылку, а новый список, без учёта вложенных списков
import copy
b = copy.deepcopy(a) # создаёт полную копию списка c учётом вложенных
```

## Исключения
```
raise Exception("что-то пошло не так") # специально вызвать исключение 
```

Пример:
```
try:  # попробовать выполнить, если ошибка - перейдёт в exept. каждый тип можно обработать отдельно
    number = int(input("Введите число: \n")) 
    result = 100 / number
except ZeroDivisionError as e: # обработка типа ошибки  ZeroDivisionError (деление на 0)
    print('Деление на 0')
    print("Ошбика: ", e)
except Exception as e: # обработка всех остальных ошибок
    print("Неизвестная ошибка")
    print("Информация:", e)
else: # если ошибок не было, выполнится этот код
    print("Ошибок не было")
finally: # в любом случае выполгится
    print("Полюбасу выполнится")
```   

Ещё пример:
```
def square(number=0):
    try:
        number = int(number)
        if number == 13:
            raise ValueError("несчастливое число")
        elif number < 1 or number > 100:
            raise ValueError("не тот диапазон")
        else:
            number = number ** 2
    except ValueError as e:
        print(e.args[0]) # e.args - список арг-в ошибки. выведет "несчастливое число" или "не тот диапазон"
    except Exception as e: # обработает неизвестные ошибки (например если передать строку)
        print(e)
    else:
        print("Ошибок не было")
    finally:
        return number
value = input("Введите число от 1 до 100\n")
print(square(value))

```
> Рекомендуется (более опытными коллегами) присваивать Exception переменной exc

## Регулярные выражения
```
import re
txt = "The rain in Spain"
x = re.search("^The.*Spain$", txt)  # вернет объект, если он начинается на the, заканч Spain
```
- \d - any digit  0-9
- \D - any non-digit 
- \w - any alphabet symbol (characters from a to Z, digits from 0-9, and the underscore _ character)
- \W - any non alphabet symbol
- \s - breakspace(white space, обычный пробел)
- \S - non breackspace
- [0-9] - аналогично \d
- [A-Z][a-z]+ - первая большая, остальные маленькие. + - сколько угодно последнего символа.


| функция| назначение                                                         |
| -------|:------------------------------------------------------------------:|
| findall|возвращает список, содержащий все совпадения                        |
| search |Возвращает объект Match, если в строке есть совпадение              |
| split  |Возвращает список, где строка была разбивается при каждом совпадении|
| sub    |Заменяет одно или несколько совпадений на строку                    |

TODO: перепилить таблицу в нормальные примеры, с использованием разных параметров
```
my_text = "vasya aaaa 1972, Kolya - 1972: Olesya 1981, aaaaa@intel.com," \
         "bbbbbbbbbbbbb@intel.com, Petya gggg, 1992, cccccc@yahoo.com" \
         "ddddddddddd@intel.com, vasya@yandex.net, hello hello, Misha#43 1984, " \
         "Vladimir 1977, Irina, 2001, annnnn@intel.net, yeeeee@yandex.com," \
         "oooooooooooooo@hotmail.gov, ggggggggggggggg@gov.gov, tutututut@giv.hot, " \
         "Вфы-в3ф.ы@фыв.ыв.sd-f, Вфы-в3ф.ы@фывsada"

text_look_for = r"yandex" # будет искать все яндексы (только само упоминание, не всё слово)
text_look_for = r"\d\d\d\d" # ищет 4 подряд цифры
text_look_for = r"[0-9]{4}" # аналогично, только другой вид записи
text_look_for = r"\w+" # ищет слова
text_look_for = r"[A-Z][a-z]+" # Ищет англ. слова с большой буквы
text_look_for = r"[\w.-]+@(?!intel.com)[\w-]+\.[\w.-]+" # ищет не интел почты, где:
# [\w.-]+ - сколько угодно любых букв, цифр (\w) ИЛИ точки (.) ИЛИ - (-) 
# потом @, потом исключаем (?!intel.com), ищем все [\w-]+, потом точка \. и [\w.-]+
# символ точки в скобках можно писать без "\", вне скобок это будет означать любой символ,
# кроме энетера, поэтому используется \
all_results = re.findall(text_look_for, my_text)
print(all_results)
```
>Потестить как работают (слева выбрать питон) - https://regex101.com
>
>Подробнее о выражениях - https://www.w3schools.com/python/python_regex.asp
## Рекурсия (вызов функции из самой себя)
>Глубина рекурсии - 1000 повторений. Более 1000 - выдаст ошибку
>sys.setrecursionlimit(3000) # увеличить стэк до 3000
```
def iterate(begin, end):
    if begin == end:
        return f"{end}"

    if begin > end:
        return f"{begin}, {iterate(begin-1, end)}"

    if begin < end:
        return f"{begin}, {iterate(begin+1, end)}"


print(iterate(20, 10))
```
> Числа Фибоначчи:
```
def fib_list(n):
    fib_l = [None] * 1000 # список на 1000 ячеек
    fib_l[:2] = [0, 1] # Частный случай, для 0 и 1 значения известны

    def _fib_list(n): # локальная рекурсивная функция
        if fib_l[n] is None:
            fib_l[n] = _fib_list(n - 1) + _fib_list(n - 2)
        return fib_l[n]

    return _fib_list(n)
```
## Тестирование
> cProfile юзается внутри кода:
```
import cProfile
cProfile.run('main()') # подробно покажет, что и сколько раз вызывалось, сколько времени ушло
```
>#### строку ниже запускать из терминала! 
```
python -m timeit -n 1000 -s "import fib2" "fib2.fib_dict(15)"
```
> ```-n 1000```  - сколько раз прогонять
> 
>```-s "import fib2"``` - какой модуль прогоняем
>
>```"fib2.fib_dict(15)"``` - какую функцию тестируем
>
> ####можно ещё тестировать время выполнения внутри кода: 
```
import timeit
print(timeit.timeit('x = sum(range(10))'))
```

## Замыкания (Closure)
непонятно зачем эта штука и как работает, но скорее всего это поможет в понимании декортаторов
```
def counter():
    count = 0

    def inner():
        nonlocal count
        count += 1
        # print(count)
        return count
    return inner


a = counter() # теперь a ссылается на функцию inner, которая может обращаться к переменной
# count, которая будет для неё глобальной
a()  # count = 1
a()  # count = 2
a()  # count = 3
a()  # count = 4
a()  # count = 5
b = counter()
b()  # new count = 1
c = a()  # count = 6
print(c)
print(type(c))  # <class 'int'>
print(type(a))  # <class 'function'>
```