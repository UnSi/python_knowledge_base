#  Как я датабазу на постгре менял  (+ удалял переводы)

---
##### 1. - бекап sqlite3 базы из старого проекта (далее old_p). 
#####  	 - Поудалял колонки с переводами и ударения в текстах(manage.py с ними не якшается) 
##### 2. скопировал новый проект (далее new_p) в отдельную папку (далее в temp_p), в настройках поставил sqlite
##### 3. подменил базу в temp_p базой из old_p, выполнил миграции
##### 4. в temp_p: 
##### - ```python manage.py dumpdata > dump.json```
##### - дамп на выходе переместить в папку с new_p
##### 5. в new_p: python manage.py loaddata dump.json

##### удалить все лишнее (temp_p, оба dump.json), откатить sqlite3 в old_p с бекапа, вы великолепны.
+ скопировать бд postgres:
    
    
    CREATE DATABASE newdb WITH TEMPLATE originaldb OWNER dbuser;