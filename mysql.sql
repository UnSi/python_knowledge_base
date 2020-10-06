> из коммандной строки к mysql:

-h ip -- коннект к субд по ип
-P port -- коннект по выбранному порту
mysql dbname -- открыть дб

команды mysql (клиента):
\u или USE --  выбор базы данных
\. или SOURCE -- выполнение sql-комманд из файла
\! или SYSTEM -- выполнение комманд ОС
\s или STATUS -- вывод информации о состоянии сервера
\q или EXIT -- выход ищ клиента
\G -- вывод результата в вертикальном формате

> дамп:
--сделать дамп базы database и сохранить в файл database.sql:
mysqldump database > database.sql

--выгрузить дамп database.sql в базу database
mysql database < database.sql

> внутри бд
CREATE DATABASE name; -- создание бд name
SHOW DATABASES; -- показать все базы
DROP DATABASE name; -- удалить базу
IF EXISTS -- или IF NOT EXISTS можно использовать проверку внутри удаления/создания, пример:
CREATE DATABASE IF NOT EXISTS shop;
SHOW TABLES FROM dbname; -- показать таблицы. FROM dbname не нужно, если используется USE dbname (команда клиента mysql)
SELECT mysql.User.User, mysql.User.Host FROM mysql.User; -- mysql.User - имя бд и таблицы, столбцы user и host. Полные имена = квалифицированные имена
CREATE TABLE IF NOT EXISTS users(k INT); -- создать таблицу users со столбцом k, в котором значения будут int
DESCRIBE table_name 'column_name'; -- посмотреть содержимое таблицы колонки column_name, если не использовать 'column_name', то покажет всю таблицу. Можно использовать 'm%' - выведет все столбцы, начинающиеся на m	
SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'shop';
ALTER TABLE tbl CHANGE id id INT UNSIGNED NOT NULL; -- изменить атрибуты столбца id 
TRUNCATE tbl; -- очистить таблицу
-- если имя столбца/таблицы и т.д. совпадает с ключевым словом, можно экранировать `anything`, кавычку внутри кавычек можно экранировать \' 'dasfasdf \'sad\' '
ALTER TABLE tbl ADD collect JSON; -- добавить столбец коллекция, тип json


----------------Атрибуты для столбцов
NULL или NOT NULL - позволяет элементам принимать null или запрещает
DEFAULT - по умолчанию
UNSIGNED - позволяет хранить только беззнаковые числа
ZEROFILL - заменит пробелы перед числом нулями (например 0000005)
PRIMARY KEY - первичный ключ, может быть 1, можно указать среди столбцов при создании: 
--CREATE...(...,PRIMARY KEY(column_name1, ciolumn_name2(10)),...) -- первичный ключ по column_name1 и первым 10 символам column_name2
SERIAL == BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
KEY - индекс



-----------------Типы:
Числовые
Целочисленные: TINYINT (1B), SMALLINT(2B), MEDIUMINT(3B), INT(4B), BIGINT(8B)
Вещественные: FLOAT(4B), DOUBLE(8B)
Точные: DECIMAL (строка, в которой записано число) -- медленное обращение

Строковые
Фиксированные: CHAR (сразу надо выделить память и именно столько они занимать и будут)
Переменные: VARCHAR (не имеет фиксированного размера, доспукается указание максимального объема в круглых скобках)
BLOB: TINYTEXT (256B), TEXT(65536B), MEDIUMTEXT(16777216B == 16MB), LONGTEXT(4GB) --медленнее, чем варчар 

Неизвестный
NULL

Календарные
TIME(время в течении суток), 
YEAR(год), 
DATE(дата с точностью до дня), 
DATETIME(дата и время), 
TIMESTAMP(дата и время, в 2раза меньше места (1970-2038)

1B	YEAR 		0000
3B	DATE		'0000-00-00'
3B	TIME		'00:00:00'
4B	TIMESTAMP	'0000-00-00 00:00:00'
8B	DATETIME	'0000-00-00 00:00:00'

Множества?




Пример числовых:

CREATE TABLE tbl (id INT(8)); -- 8 символов
INSERT INTO tbl VALUES (5);
SELECT * FROM tbl;

	DROP TABLES IF EXISTS tbl;
	CREATE TABLE tbl (id INT(8) ZEROFILL);
	INSERT INTO tbl VALUES (5);
	SELECT * FROM tbl;
	
DROP TABLES IF EXISTS tbl;
CREATE TABLE tbl (price DECIMAL(7,4)); --7B под число, 4B под дробную часть
INSERT INTO tbl VALUES (111.2);
INSERT INTO tbl VALUES (10000); -- уже не влезет

Пример строковых:
CREATE TABLE tbl (
	name CHAR(10) DEFAULT 'anonymous',
	description VARCHAR(255)
);

INSERT INTO tbl VALUES (DEFAULT, 'Новый пользователь');
SELECT * FROM tbl;
INSERT INTO tbl VALUES ('очень длинное имя', 'Новый пользователь'); -- ошибка, слишком длинное имя. Символ русского текста - 2 байта (иногда 3-4 байта)

Пример даты:

SELECT '2018-10-01 0:00:00' - INTERVAL 1 DAY; -- вычли 1 день из 2018-10-01
SELECT '2018-10-01 0:00:00' + INTERVAL 1 WEEK;
SELECT '2018-10-01 0:00:00' + INTERVAL 1 YEAR;
SELECT '2018-10-01 0:00:00' + INTERVAL '1-1' YEAR_MONTH; -- прибавили год и 1 месяц


Пример множеств:

ALTER TABLE tbl ADD collect JSON; -- добавить столбец коллекция, тип json
INSERT INTO tbl VALUES(1, '{"first": "Hello", "second": "World"}');

SELECT collect->>"$.second" FROM tbl;
/*
+----------------------+
| collect->>"$.second" |
+----------------------+
| World                |
+----------------------+
*/

--- ----------------------- Индексы
/*
+:скорость поиска (изначально данные несортированы, индексация создаст сортированную копию столбца)
-:долго добавлять/удалять, больше памяти занимает на жд и озу
*/
Индексы:
- обычные
- уникальные, первичный ключ
- полнотекстовый 

Пример уникального:

CREATE...(...,KEY index_of_catalog_id(catalog_id)),...) -- индексирует колонку catalog_id, в базе индекс будет называться index_of_catalog_id
-- создать индекс в существующей таблице:
CREATE INDEX index_of_catalog_id ON products (catalog_id);
-- удалить: 
DROP INDEX index_of_catalog_id ON products;

--может храниться в виде бинарного дерева или хэш. При создании можно принудительно указать тип:
CREATE INDEX index_of_catalog_id USING BTREE ON products (catalog_id);
CREATE INDEX index_of_catalog_id USING HASH ON products (catalog_id);

--Составные индексы (может быть несколько):
    KEY order_id (order_id, product_id),
    KEY product_id (product_id, order_id)
	
	
UNIQUE unique_name(name(10)) -- индексация по первым 10 символам
	
------------------------ CRUD опреации (create, read, update, delete)

-- INSERT INTO catalogs VALUES(NULL, 'Процессоры');
-- INSERT INTO catalogs (name, id) VALUES ('Мат. платы', NULL);
-- INSERT INTO catalogs VALUES (DEFAULT 'Видеокарты');

INSERT IGNORE INTO catalogs VALUES  -- игнор ошибки, при уникальном значени name должна вылетить ошибка на второй строчке с видеокартами, но эта вставка просто игнорируется
	(DEFAULT, 'Процессоры'),
	(DEFAULT, 'Мат. платы'),
	(DEFAULT, 'Видеокарты'),
	(DEFAULT, 'Видеокарты');
    
SELECT id, name from catalogs;

DELETE -- удаляет все или часть данных
TRUNCATE -- чистит таблицу, обнуляет автоинкремент

DELETE FROM catalogs WHERE id > 1 LIMIT 1; -- удалит 1 значение, при условии, что id >1



UPDATE 
	catalogs
SET
	name = "Процессоры (Intel)"
WHERE
	name = "Процессоры";
	

INSERT INTO
	cat
SELECT
	* 
FROM
	catalogs
ON DUPLICATE KEY UPDATE
	new_column_name = VALUES(old_column_name);


-- -----------------Арифметические операторы
+-*/%
div - целочисленное деление

любое действие с NULL - вернёт NULL

SELECT 5 div 3 AS division; -- AS - переименовывает заглавие столбца
/*
+----------+
| division |
+----------+
|        1 |
+----------+
*/

-- CREATE TABLE IF NOT EXISTS catalogs(id INT, name TEXT);
INSERT INTO catalogs VALUES (1, 'Процессоры'); -- добавить строку
-- INSERT INTO catalogs VALUES (2, 'Мат. платы');
-- INSERT INTO catalogs VALUES (3, 'Видеокарты');
UPDATE catalogs SET id = id + 10; -- добавить всем id 10
-- всё приводиться к инту. Т.е. если строка не может быть приведена к числу - она равна 0
SELECT 'asda' + 'gdfgbcv2' AS summ;
/*
+------+
| summ |
+------+
|    0 |
+------+
*/
SELECT !TRUE, NOT TRUE, !FALSE, TRUE; -- NOT или ! - отрицание, тру и фолс определяются, как 1 и 0
/*
+-------+----------+--------+------+
| !TRUE | NOT TRUE | !FALSE | TRUE |
+-------+----------+--------+------+
|     0 |        0 |      1 |    1 |
+-------+----------+--------+------+
*/

SELECT 2 <=> NULL, NULL <=> NULL, 2 = NULL, NULL = NULL; -- <=> - безопасное сравнение с null
SELECT 2 IS NULL, 2 IS NOT NULL;

/*
+------------+---------------+----------+-------------+
| 2 <=> NULL | NULL <=> NULL | 2 = NULL | NULL = NULL |
+------------+---------------+----------+-------------+
|          0 |             1 |     NULL |        NULL |
+------------+---------------+----------+-------------+
+-----------+---------------+
| 2 IS NULL | 2 IS NOT NULL |
+-----------+---------------+
|         0 |             1 |
+-----------+---------------+
*/

-- DROP TABLE IF EXISTS catalogs;
-- CREATE TABLE IF NOT EXISTS catalogs(id INT PRIMARY KEY AUTO_INCREMENT, name varchar(255));
-- INSERT INTO catalogs VALUES('Сетевое оборудование');
-- INSERT INTO catalogs VALUES(2, NULL);
SELECT * FROM catalogs WHERE name IS NOT NULL;
/*
+----+----------------------+
| id | name                 |
+----+----------------------+
|  1 | Сетевое оборудование |
+----+----------------------+
*/
-- -----------------Логические операции-------
AND, &&
OR, ||

 CREATE TABLE tbl (
    -> x INT,
    -> y INT,
    -> summ INT AS (x+y)
    -> );

INSERT INTO tbl (x, y) VALUES (1, 1), (5, 6), (11, 12);
/*
+------+------+------+
| x    | y    | summ |
+------+------+------+
|    1 |    1 |    2 |
|    5 |    6 |   11 |
|   11 |   12 |   23 |
+------+------+------+
*/
-- по умолчанию summ не будет сохранятся на жд, можно добавить сторед в параметр столбца, чтоб сохранялось: summ INT AS (x+y) STORED);

-- ------------------- Условная выборка

SELECT * FROM catalogs WHERE id > 2 AND id <= 4;
SELECT * FROM catalogs WHERE id BETWEEN 3 AND 4; -- аналогично верхнему, есть ещё NOT BETWEEN
SELECT * FROM catalogs WHERE id IN (1, 2, 5); -- если внутри списка будет NULL, вернёт null, есть ещё NOT IN
LIKE и = -- есть ещё not like,  выполняют одну и ту же функцию, но у LIKE есть спецсимволы:
% -- любое кол-во символов или их отсутствие
_ -- ровно 1 символ

RLIKE 
REGEXP -- регулярные выражения
SELECT 'программирование' RLIKE '^грам', 'граммпластинка' RLIKE '^грам'; -- ^ начинается с, $ - заканчивается на, | - или, [abc] - a или b или c.
-- есть классы, например цифры , пишутся в двойных квадратных скобках [[:digit:]]
-- квантификаторы  ? - символ входит 0 или 1 раз, * -  любое кол-во вхождений, включая 0, + - одно или более вхождений
-- описание цены: 
--SELECT 342.50 RLIKE '^[0-9]*\\.[0-9]{2}$' AS '342.50';
/*
+----------------------------------+--------------------------------+
| 'программирование' RLIKE '^грам' | 'граммпластинка' RLIKE '^грам' |
+----------------------------------+--------------------------------+
|                                0 |                              1 |
+----------------------------------+--------------------------------+
+--------+
| 342.50 |
+--------+
|      1 |
+--------+
*/

----------------- Сортировка

SELECT * FROM catalogs ORDER BY name; -- сортировка по имени
SELECT * FROM catalogs ORDER BY name DESC; -- сортировка по имени в обратном порядке
select id, catalog_id, price, name FROM products ORDER BY catalog_id, price; -- сортировка по цене в пределах каталога

select id, catalog_id, price, name FROM products LIMIT 4, 2; -- начиная с 4й позиции покажет 2 результата
select id, catalog_id, price, name FROM products LIMIT 2 OFFSET 4; -- альтернативная запись
select DISTINCT catalog_id FROM products; -- выведет только уникальные значения 
select id, catalog_id, price, name FROM products WHERE catalog_id = 2 AND price	> 5000; -- выведет только уникальные значения 
UPDATE products SET price = price * 0.9 WHERE catalog_id = 2 AND price> 5000; -- уменьшить цену на 10%, в каталоге с ид 2 и ценой > 5000
DELETE FROM products ORDER BY price DESC LIMIT 2;


------------------ Предопределенные функции
SELECT NOW(); -- текущее время
SELECT name, DATE(created_at), DATE(updated_at) FROM users WHERE name = 'Александр'; -- преобразование даты к дню (без времени)
-- чтобы выглядело лучше, столбцы переименовываются с пом. as, но его можно пропустить: 
SELECT id, name, birthday_at, DATE(created_at) as created_at, DATE(updated_at) updated_at FROM users;

-- форматирование:

SELECT DATE_FORMAT('2018-06-12 01:59:59', 'На дворе %Y год');
/*
+-------------------------------------------------------+
| DATE_FORMAT('2018-06-12 01:59:59', 'На дворе %Y год') |
+-------------------------------------------------------+
| На дворе 2018 год                                     |
+-------------------------------------------------------+
*/
SELECT name, DATE_FORMAT(birthday_at, '%d.%m.%Y') AS birthday_at FROM users;

-- unix timestamp
SELECT UNIX_TIMESTAMP('2018-10-10') as TIMESTAMP,
	FROM_UNIXTIME(1539155363) AS DATETIME;
	
/*
+------------+---------------------+
| TIMESTAMP  | DATETIME            |
+------------+---------------------+
| 1539118800 | 2018-10-10 10:09:23 |
+------------+---------------------+
*/

SELECT name, FLOOR((TO_DAYS(NOW()) - TO_DAYS(birthday_at)) / 365.25) as age FROM users; -- TO_DAYS - преобразование даты к дням, FLOOR - округление
SELECT name, TIMESTAMPDIFF(YEAR, birthday_at, NOW()) as age FROM users; -- TIMESTAMPDIFF - считает разницу во времени

-- random

SELECT * FROM users ORDER BY RAND(); -- вывести в случайном порядке
SELECT VERSION(); -- версия сервера mysql
SELECT LAST_INSERT_ID(); -- покажет последнее значение автоинкремента
SELECT DATABASE(); -- текущая БД
SELECT USER(); -- вернет текущего пользователя
/*
+----------------+
| USER()         |
+----------------+
| root@localhost |
+----------------+
*/

SELECT RAND(); -- случайное число от 0 до 1
...distance DOUBLE AS (SQRT(POW(x1 - x1, 2) + POW(y1 - y2, 2)))... -- POW - возведение в сетепень, sqrt - корень
SIN() -- синус
ROUND() - математическое округление
CEILING() - округляет в большую сторону	
FLOOR() - округляет в меньшую сторону	
SELECT id, SUBSTRING(name, 1, 5) as name FROM users; -- вывод первых 5ти символов. 1 - позиция, откуда начинаем резать, 5 - кол-во символов
SELECT id, CONCAT(name, ' ', TIMESTAMPDIFF(YEAR, birthday_at, NOW())) AS name FROM users; -- соединение строк
SELECT IF(TRUE, 'истина', 'ложь'), IF(FALSE, 'истина', 'ложь'); -- 1-й параметр - выражение, 2-й - если правда, 3 -й действие, если ложь)
SELECT INET_ATON('62.145.69.10'), INET_ATON('127.0.0.1'); -- перевод ip  в число
SELECT INET_NTOA(1049707786), INET_NTOA('2130706433'); -- перевод числа в ip
SELECT UUID(); -- универсальный уникальный идентификатор, всегда генереруется разное


---- примеры:
CREATE TABLE distances (
	id SERIAL PRIMARY KEY,
	x1 INT NOT NULL,
	y1 INT NOT NULL,
	x2 INT NOT NULL,
	y2 INT NOT NULL,
	distance DOUBLE AS (SQRT(POW(x1 - x1, 2) + POW(y1 - y2, 2))) -- POW - возведение в сетепень, sqrt - корень
) COMMENT = "Расстояние между 2мя точками"; 

INSERT INTO distances
  (x1, y1, x2, y2)
VALUES
  (1, 1, 4, 5),
  (4, -1, 3, 2),
  (-2, 5, 1, 3);

/*
+----+----+----+----+----+----------+
| id | x1 | y1 | x2 | y2 | distance |
+----+----+----+----+----+----------+
|  1 |  1 |  1 |  4 |  5 |        4 |
|  2 |  4 | -1 |  3 |  2 |        3 |
|  3 | -2 |  5 |  1 |  3 |        2 |
+----+----+----+----+----+----------+
*/

CREATE TABLE distances (
	id SERIAL PRIMARY KEY,
	a JSON NOT NULL,
	b JSON NOT NULL,
	distance DOUBLE AS (SQRT(POW(a->>'$.x' - b->>'$.x', 2) + POW(a->>'$.y' - b->>'$.y', 2))) 
) COMMENT = "Расстояние между 2мя точками"; 

INSERT INTO distances (a, b) VALUES 
	('{"x": 1, "y":1}', '{"x": 4, "y": 5}'),
	('{"x": 4, "y":-1}', '{"x": 3, "y": 2}'),
	('{"x": -2, "y":5}', '{"x": 1, "y": 3}');


CREATE TABLE triangles(
	id SERIAL PRIMARY KEY,
	a DOUBLE NOT NULL comment 'сторона треугольника',
	b DOUBLE NOT NULL comment 'сторона треугольника',
	angle INT NOT NULL COMMENT 'угол треугольника в градусах',
	square DOUBLE AS (a * b * SIN(RADIANS(angle)) / 2.0)  -- RADIANS - преобразование к радианам
)COMMENT = 'площадь треугольника';

ALTER TABLE triangles CHANGE square square DOUBLE AS (ROUND(a * b * SIN(RADIANS(angle)) / 2.0, 4)); -- ROUND(..., x) - математическое округление до x знаков

INSERT INTO
  triangles (a, b, angle)
VALUES
  (1.414, 1, 45),
  (2.707, 2.104, 60),
  (2.088, 2.112, 56),
  (5.014, 2.304, 23),
  (3.482, 4.708, 38);

SELECT * FROM triangles;

CREATE TABLE rainbow (
	id SERIAL PRIMARY KEY,
	color VARCHAR(255)
) comment = 'Цвета радуги';

INSERT INTO
  rainbow (color)
VALUES
  ('red'),
  ('orange'),
  ('yellow'),
  ('green'),
  ('blue'),
  ('indigo'),
  ('violet');

SELECT
  CASE
	WHEN color = 'red' THEN 'красный'
	WHEN color = 'orange' THEN 'оранжевый'
	WHEN color = 'yellow' THEN 'желтый'
	WHEN color = 'green' THEN 'зеленый'
	WHEN color = 'blue' THEN 'голубой'
	WHEN color = 'indigo' THEN 'синий'
	ELSE 'фиолетовый'
  END AS russian
FROM
  rainbow;

------------------ агрегация данных

SELECT catalog_id from products GROUP BY catalog_id; 
SELECT COUNT(*), SUBSTRING(birthday_at, 1, 3) AS decade FROM users GROUP BY decade; -- count считает поля таблицы, в скобочках можно указать имя стобца (NULL пропускается) или *. * - будет считать поля всей таблицы вне зависимости от null. 
SELECT
	GROUP_CONCAT(name ORDER BY name DESC SEPARATOR ' '), -- separator можно не использовать, по умолчанию ','. order by name desc тоже можно не использовать
	SUBSTRING(birthday_at, 1, 3) AS decade 
FROM 
	users 
GROUP BY 
	decade;

MIN(); -- минимальное значение
MAX(); -- максимальное значение
AVG(); -- среднее
SUM(); -- сумма всех значений, кроме NULL

-- c GROUP BY нельзя использовать WHERE, вместо этого можно использовать HAVING
SELECT COUNT(*) AS total, SUBSTRING(birthday_at, 1, 3) as decade FROM users GROUP BY decade HAVING total >= 2;

WITH ROLLUP; -- суммирует значения последней строкой для агрегатных функций, для столбцов будет NULL

ANY_VALUE() -- выбирает любое значение из группы (когда не важно значение)



-- примеры
SELECT SUBSTRING(birthday_at, 1, 3) AS decade FROM users GROUP BY decade;

DROP TABLE IF EXISTS tbl;
CREATE TABLE tbl (
	id INT NOT NULL,
	value INT DEFAULT NULL
);

INSERT INTO tbl VALUES (1, 230);
INSERT INTO tbl VALUES (2, NULL);
INSERT INTO tbl VALUES (3, 405);
INSERT INTO tbl VALUES (4, NULL);

SELECT COUNT(id), COUNT(value) FROM tbl;
/*
+-----------+--------------+
| COUNT(id) | COUNT(value) |
+-----------+--------------+
|         4 |            2 |
+-----------+--------------+
*/
 SELECT COUNT(*) FROM tbl;
 /*
+----------+
| COUNT(*) |
+----------+
|        4 |
+----------+
*/

SELECT MIN(price) as min, MAX(price) as max FROM products;
SELECT catalog_id, MIN(price) as min, MAX(price) as max FROM products GROUP BY catalog_id;
/*
+------------+---------+----------+
| catalog_id | min     | max      |
+------------+---------+----------+
|          1 | 4780.00 | 12700.00 |
|          2 | 4790.00 | 19310.00 |
+------------+---------+----------+
*/

SELECT AVG(price) FROM products;
/*+-------------+
| AVG(price)  |
+-------------+
| 8807.142857 |
*/

SELECT 
	catalog_id,
	ROUND(AVG(price), 2)AS price
FROM
	products
GROUP BY
	catalog_id;
	
	
SELECT 
	catalog_id,
	ROUND(AVG(price)*1.2, 2)AS price  -- +20%
FROM
	products
GROUP BY
	catalog_id;
	

-- 2 раза вставил специально, работа с дублями
TRUNCATE products;
INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор Intel', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор Intel', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор AMD', 4780.00, 1),
  ('AMD FX-8320', 'Процессор AMD', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'B250, Socket 1151, DDR4, mATX', 5060.00, 2);
 
INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор Intel', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор Intel', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор AMD', 4780.00, 1),
  ('AMD FX-8320', 'Процессор AMD', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'B250, Socket 1151, DDR4, mATX', 5060.00, 2);

SELECT name, description, price, catalog_id FROM products GROUP BY name, description, price, catalog_id; -- уникальности добились с пом. group by, для того, чтобы попасть в группу, все значения должны совпадать

DROP TABLE IF EXISTS products_new;
CREATE TABLE products_new(
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'название',
	description TEXT COMMENT 'описание',
	price DECIMAL(11,2) COMMENT 'цена',
	catalog_id INT UNSIGNED, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP comment 'дата регистрации',
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY index_of_catalog_id(catalog_id)
) COMMENT = 'Товарные позицые';

INSERT INTO 
	products_new
SELECT 
	NULL, name, description, price, catalog_id, NOW(), NOW()
FROM 
	products 
GROUP BY 
	name, description, price, catalog_id;

DROP TABLE IF EXISTS products;
ALTER TABLE products_new RENAME products;
----------------------------


INSERT INTO users (name, birthday_at) VALUES
  ('Светлана', '1988-02-04'),
  ('Олег', '1998-03-20'),
  ('Юлия', '2006-07-12');

SELECT name, birthday_at FROM users ORDER BY birthday_at;
SELECT YEAR(birthday_at) FROM users ORDER BY birthday_at;
SELECT YEAR(birthday_at) AS birthday_year FROM users GROUP BY birthday_year ORDER BY birthday_year;
SELECT MAX(name), YEAR(birthday_at) AS birthday_year FROM users GROUP BY birthday_year ORDER BY birthday_year; -- просто name не выведет, т.к. там группа, нужно агрегационное значение, использовали макс
SELECT ANY_VALUE(name), YEAR(birthday_at) AS birthday_year FROM users GROUP BY birthday_year ORDER BY birthday_year; -- уместнее использовать ANY_VALUE
---------------------------------
SELECT
  SUBSTRING(birthday_at, 1, 3) AS decade,
  COUNT(*)
FROM
  users
GROUP BY
  decade
WITH ROLLUP; -- (суммирует значения последней строкой)

----------- многотабличные запросы

UNION -- медленные 
вложенные: SELECT id, <SUBQUERY> FROM <SUBQUERY> WHERE <SUBQUERY> GROUP BY id HAVING <SUBQUERY>; --  <SUBQUERY> - вложенный запрос
JOIN, LEFT JOIN, RIGHT JOIN

ALL -- с дублями
DISTINCT -- без дублей


-- в select по умолчанию вставляется ALL (показывать с дублями)
-- в union по умолчанию вставляется DISTINCT (без дублей)

IN -- поиск в последовательности
ANY -- любой, можно использовать SOME ( используется логика ИЛИ)
ALL -- все(используется логика И)

EXISTS -- существуют
ROW -- строка

ON, WHERE -- where - после соединения таблиц, on - перед

---Примеры:
-- union
CREATE TABLE rubrics (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) comment 'Название раздела'
	) comment = 'разделы инет магаза';
	
INSERT INTO rubrics (name) VALUES ('Видеокарты'), ('Память');

SELECT name FROM catalogs UNION SELECT name FROM rubrics; -- соеденит без дублей. если нужно с дублями - UNION ALL

-- чтобы сортировка и limit работали на отдельные таблицы, а не на результирующую, надо взять в круглые скобки):
(SELECT name FROM catalogs ORDER BY name DESC LIMIT 2)
UNION ALL
(SELECT name FROM rubrics ORDER BY name DESC LIMIT 2);
---------------------------------
SELECT 
	id, name, catalog_id 
FROM 
	products
WHERE
	catalog_id = (SELECT id FROM catalogs WHERE name = "Процессоры");
	
SELECT 
	id, name, catalog_id 
FROM 
	products
WHERE
	price = (SELECT MAX(price) FROM products);

SELECT 
	id,
	name,
	(SELECT name FROM catalogs WHERE id = catalog_id) as 'catalog_id'
FROM
	products;
	/* Если подзапрос использует столбец из внешнего запроса, его называют коррелированным. Особенность коррелированных запросов — СУБД вынуждена их вычислять для каждой строки внешнего запроса. Это может быть довольно накладно для объемных таблиц. Источник: https://docs.google.com/document/d/1Poq5YUiWTSOUFtkC9GXNtwtO9Xwt5q1eH5FiGGcexUM/edit#*/
--------------
SELECT id, name, catalog_id
FROM products
WHERE catalog_id in (SELECT id FROM catalogs);


SELECT id, name, price, catalog_id
FROM products
WHERE catalog_id = 2 AND
	price < ANY(SELECT price FROM products WHERE catalog_id = 1); -- выведет все процы, которые дешевле какого-то из материнок
	
SELECT id, name, price, catalog_id
FROM products
WHERE catalog_id = 2 AND
	price > ALL(SELECT price FROM products WHERE catalog_id = 1); -- выведет все мамки, которые дороже любого процессора
	
SELECT * FROM catalogs WHERE EXISTS (SELECT * FROM products where catalog_id  = catalogs.id); -- извлечь каталоги, где есть товарные позиции
SELECT * FROM catalogs WHERE NOT EXISTS (SELECT 1 FROM products where catalog_id  = catalogs.id); -- извлечь каталоги, где нет товарных позиций (используется 1 вместо * для ускорения работы запроса).

SELECT id, name, price, catalog_id FROM products
WHERE ROW(catalog_id, 5060) IN (SELECT id, price FROM catalogs);

-- вывести среднюю минимальную цену
SELECT AVG(price)
FROM 
	(SELECT MIN(price) AS price
	FROM products
	GROUP BY catalog_id) AS prod;
-- join
DROP TABLE IF EXISTS tbl1;
CREATE TABLE tbl1 (
  value VARCHAR(255)
);
INSERT INTO tbl1
VALUES ('fst1'), ('fst2'), ('fst3');

DROP TABLE IF EXISTS tbl2;
CREATE TABLE tbl2 (
  value VARCHAR(255)
);
INSERT INTO tbl2
VALUES ('snd1'), ('snd2'), ('snd3');

SELECT * FROM tbl1 JOIN tbl2; -- вместо join можно использовать запятую. выведет общую таблицу "каждый с каждым"
-----
SELECT 
	p.name, p.price, c.name
FROM 
	catalogs AS c
JOIN 
	products AS p
ON 
	c.id = p.catalog_id;
	
SELECT * FROM 
	catalogs as fst 
	JOIN 
	catalogs as snd
ON fst.id = snd.id
USING id; -- совмещает идентичные id в один столбец

SELECT 
	p.name, p.price, c.name
FROM 
	catalogs AS c
LEFT JOIN				-- все данные с каталогов подтянуться, если нет соответствий в продактс, будет null
	products AS p
ON 
	c.id = p.catalog_id;
/*
+-------------------------+----------+------------+
| name                    | price    | name       |
+-------------------------+----------+------------+
| Intel Core i3-8100      |  7890.00 | Процессоры |
| Intel Core i5-7400      | 12700.00 | Процессоры |
| AMD FX-8320E            |  4780.00 | Процессоры |
| AMD FX-8320             |  7120.00 | Процессоры |
| ASUS ROG MAXIMUS X HERO | 19310.00 | Мат. платы |
| Gigabyte H310M S2H      |  4790.00 | Мат. платы |
| MSI B250M GAMING PRO    |  5060.00 | Мат. платы |
| NULL                    |     NULL | Видеокарты |
+-------------------------+----------+------------+
*/
	
UPDATE
	products as p
JOIN
	catalogs as c
ON 
	c.id = p.catalog_id
SET
	p.price = p.price*0.9
WHERE
	c.name = 'Мат. платы';
	
DELETE
	products, catalogs  -- из какой таблицы удалять
FROM
	catalogs
JOIN
	products
ON
	catalogs.id = products.catalog_id
WHERE
	catalogs.name = 'Мат. платы'; -- удалить из продуктов всё, что связано с мат. платами и из каталогов мат. платы
	
-------------- внешний ключ

FOREIGN KEY (col1, ...) REFERENCES tbl(tbl_col, ...)
[ON DELETE ...]
[ON UPDATE ...] -- стратегии на удаление, обновление:

CASCADE -- при удалении/обновлении предка, потомки автоматически удаляются/обновляются
SET NULL
NO ACTION
RESTRICT -- вылетит ошибка, если остануться ссылки
SET DEFAULT 

-- Примеры

ALTER TABLE products 
CHANGE catalog_id catalog_id BIGINT UNSIGNED DEFAULT NULL;

ALTER TABLE products
ADD CONSTRAINT fk_catalog_id -- "CONSTRAINT fk_catalog_id" можно пропустить, тогда имя укажеться автоматически
FOREIGN KEY (catalog_id)
REFERENCES catalogs(id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE products
DROP FOREIGN KEY fk_catalog_id;

ALTER TABLE products
ADD CONSTRAINT fk_catalog_id 
FOREIGN KEY (catalog_id)
REFERENCES catalogs(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

---------------транзакции

START TRANSACTION;
...blablabla...
COMMIT; -- подтвердить транзакцию
ROLLBACK; -- отменить транзакцию
SAVEPOINT pointname; -- создать точку сохранения
ROLLBACK TO SAVEPOINT pointname; -- откат к точке сохранения
SET AUTOCOMMIT = 1 -- автозавершение транзакции 1 -вкл, 0 - выкл (все запросы будут в транзакции)

--Изменить уровень изоляции транзацакции:
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

-- Комманды, которые нельзя откатить, лучше не помещать в транзакции:
CREATE INDEX
DROP INDEX
CREATE TABLE
DROP TABLE
TRUNCATE TABLE
ALTER TABLE
RENAME TABLE
CREATE DATABASE
DROP DATABASE
ALTER DATABASE

-- Комманды, которые неявно завершают транзакцию, как если бы был вызван оператор COMMIT:
ALTER TABLE
BEGIN
CREATE INDEX
CREATE TABLE
CREATE DATABASE
DROP DATABASE
DROP INDEX
DROP TABLE
DROP DATABASE
LOAD MASTER DATA
LOCK TABLES
RENAME
SET AUTOCOMMIT=1
START TRANSACTION
TRUNCATE TABLE

---------------- примеры

START TRANSACTION;
SELECT total FROM accounts WHERE user_id = 4;
SAVEPOINT accounts_4;
UPDATE accounts SET total = total - 2000 WHERE user_id = 4;
ROLLBACK TO SAVEPOINT accounts_4;

--------------переменные, временные таблицы

SELECT @total := COUNT(*) FROM products; -- переменная доступна только в текущей сессии
SET @last = NOW() - INTERVAL 7 DAY; -- присвоить, но не показывать
-- если присваивать столбец, присвоится  последнее его значение
-- регистр не важен

SHOW VARIABLES LIKE 'read_buffer_size'; -- показать системеные переменные
SHOW VARIABLES LIKE '%_format'; -- вместо % всё, что угодно
-- Системные переменные: GLOBAL (глобальные - влияют на весь сервер), SESSION (сессионные - влияют на текущее соединение клиента с сервером)
-- чтобы изменить системную глобальную переменную:
SET GLOBAL read_buffer_size = 2097152; -- альтернативный вариант записи SET @@global.read_buffer_size = 2097152;
SET SESSION read_buffer_size = 2097152; -- в этом случае примениться только на текущее соединение, не затрагивая соседних клиентов. Чтобы восстановить значение глобальной, надо присвоить DEFAULT
SET read_buffer_size = DEFAULT; 


CREATE TEMPORARY TABLE table_name(
	id SERIAL PRIMARY KEY,
	name VARCHAR (255)
); -- автоматически удаляется по завершению соединения с сервером

PREPARE ver FROM 'SELECT VERSION()'; -- динамический запрос. Время жизни: текущий сеанс
EXECUTE ver; -- его выполнение

---------------- примеры
SELECT @price := MAX(price) FROM products;

SELECT * FROM products WHERE price = @price;
SELECT @id := id from products;

/*mysql> SELECT @id := id from products;
+-----------+
| @id := id |
+-----------+
|         1 |
|         2 |
|         3 |
|         4 |
|         5 |
|         6 |
|         7 |
+-----------+
7 rows in set, 1 warning (0.00 sec)

mysql> SELECT @id;
+------+
| @id  |
+------+
|    7 |
+------+
1 row in set (0.00 sec)
*/

--нумерация:

 SET @start := 0;
 SELECT @start := @start + 1 as id, value from tbl;


CREATE TEMPORARY TABLE temp(
	id INT,
	name VARCHAR (255)
); -- автоматически удаляется по завершению соединения с сервером

PREPARE prd FROM 'SELECT id, name, price FROM products WHERE catalog_id = ?'; -- ? - параметр, будет подставляться переменная
SET @catalog_id = 1;
EXECUTE prd USING @catalog_id; -- если несколько параметров, переменные через запятую
DROP PREPARE prd; 



------ представления
CREATE OR REPLACE VIEW cat AS SELECT * FROM catalogs ORDER BY name; -- отсортировано, воспринимается сервером, как полноценная таблица. REPLACE - (заменить если существует)

-- Алгоритм формирования конечного запроса с участием представления: MERGE, TEMPTABLE (результат помещается во временную таблицу), UNDEFINED (mysql самостоятельно пытается выбрать алгоритм, чаще всего merge)
CREATE ALGORITHM = TEMPTABLE VIEW cat2 AS SELECT * FROM catalogs;



--------- Примеры:

CREATE VIEW cat_reverse (catalog, catalog_id) AS SELECT name, id FROM catalogs;
SELECT * FROM cat_reverse;  
CREATE OR REPLACE VIEW namecat (id, name, total) AS SELECT id, name, LENGTH(name) FROM catalogs; 
SELECT * FROM namecat ORDER BY total DESC;

CREATE OR REPLACE VIEW prod AS 
	SELECT id, name, price, catalog_id 
	FROM products
	ORDER BY catalog_id, name; -- вертикальное представление

 SELECT * FROM prod ORDER BY name DESC; 
 
 CREATE OR REPLACE VIEW processors AS 
	SELECT id, name, price, catalog_id 
	FROM products
	WHERE catalog_id = 1; -- горизонтальное представление

 SELECT * FROM processors; 
 
 
 CREATE VIEW v1 AS 
	SELECT * FROM tbl1 WHERE value < 'fst5'
	WITH CHECK OPTION ;

INSERT INTO v1 VALUES ('fst4');
INSERT INTO v1 VALUES ('fst5'); -- ERROR 1369 (HY000): CHECK OPTION failed 'shop.v1'

ALTER VIEW v1 AS  -- равносильно CREATE OR REPLACE VIEW 
	SELECT * FROM tbl1 WHERE value > 'fst4'
	WITH CHECK OPTION ;
	
	
------------------- администрирование mysql ----------------
'mysql --verbose --help' -- все параметры сервера mysql

SHOW VARIABLES LIKE 'transaction_isolation'; -- уровень изоляции транзакций
SHOW VARIABLES LIKE 'tmp_table_size'; -- макс размер временной таблицы
SHOW VARIABLES LIKE 'auto_increment_increment'; -- значение, на которое увеличивается при инкременте
SHOW VARIABLES LIKE 'log_error'; -- путь к журналу ошибок
SHOW VARIABLES LIKE 'general_log%'; -- путь к общему журналу запросов
SHOW VARIABLES LIKE 'slow_query_log%'; -- путь к журналу медленных запросов
SHOW VARIABLES LIKE 'long_query_time'; -- время выолнения запроса для попадания в журнал
SHOW VARIABLES LIKE 'log_output'; -- писать логи в файл или в бд (TABLE/FILE/NONE). Если таблица - SELECT * FROM mysql.slowlog
SHOW VARIABLES LIKE 'log_bin'; -- банарный лог, пишет все изменения в базе (напр. селект пропускается, т.к. не влияет на базу)
SHOW VARIABLES LIKE 'max_connections'; -- макс. кол-во соединений
SHOW PROCESSLIST; -- показать соединения
KILL id; -- вместо id - id соединения, убить коннект


-- параметры запуска для mysql можно прописывать в my.cnf
-- пример my.cnf:

/*
#Default Homebrew MySQL server config
[mysqld]
# Only allow connections from localhost
bind-address = 127.0.0.1
port = 3308
tmp_table_size = 87M
general_log = ON
slow_query_log = ON
*/

SELECT BENCHMARK(1000000000, (SELECT COUNT(*) FROM products)); -- чтоб попал в журнал медленных запросов

-- права пользователей

CREATE USER foo IDENTIFIED WITH sha256_password BY 'pass'; -- создать юзера, если без пароля, то пароль пустая строка
DROP USER foo; -- удалить уз
RENAME USER foo TO shop; -- переименовать
SELECT USER(); -- текущий пользователь
SELECT host, user FROM mysql.user;

GRANT -- назначить привилегии
REVOKE -- удалить привилегии

GRANT ALL ON *.* TO 'foo'@'localhost' IDENTIFIED WITH sha256_password BY 'pass'; -- ALL - все привелегии (USAGE - никаких привилегий), ON - таблица, база, TO - имя пользователя
GRANT GRANT OPTION ON *.* TO foo; -- разрешить назначать/удалять привилегии
WITH -- позволяет наложить ограничения

-- вариации ON:

GRANT USAGE ON *.* TO foo; -- доступ ко всем бд
GRANT USAGE ON * TO foo; -- если выбрана бд, доступ ко всем таблицам этой бд, если нет - аналогично предыдущему
GRANT USAGE ON shop.* TO foo; -- доступ ко всем таблицам базы шоп
GRANT USAGE ON shop.catalogs TO foo; -- доступ к таблице каталогс
GRANT SELECT (id, name), UPDATE (name) ON shop.catalogs TO foo; -- доступ к определенным столбцам

GRANT ALL ON shop.* TO 'foo'@'localhost' IDENTIFIED WITH sha256_password BY 'pass'
WITH MAX_CONNECTIONS_PER_HOUR 10
 	MAX_QUERIES_PER_HOUR 1000
 	MAX_UPDATES_PER_HOUR 200
 	MAX_USER_CONNECTIONS 3; -- TODO: походу неактульно, надо нагуглить, как и грант виз пассворд


Примеры:

GRANT SELECT, INSERT, DELETE, UPDATE ON *.* to foo;


-------------- Репликация (несколько серверов)--
-- в my.cnf:
/*
[mysqld]
# общее для 2х сервов
bind-address = 127.0.0.1
# не проверять пароль
# skip-grant-tables

[mysqld1]
socket      	= /tmp/mysql.sock1
port        	= 3306
pid-file    	= /usr/local/var/mysql1/mysqld1.pid
datadir     	= /usr/local/var/mysql1

[mysqld2]
socket      	= /tmp/mysql.sock2
port        	= 3307
pid-file    	= /usr/local/var/mysql2/mysqld2.pid
datadir     	= /usr/local/var/mysql2
*/

mysqld_multi start 1 -- запустить 1й сервер. Если не указать номер сервера, запустит оба
mysqld_multi stop 1 -- остановить 1й сервер

'mysql --socket=/tmp/mysql.sock2 -u root' -- подключиться к 1му серверу

--для мастер-сервера в майсиэнэф в секцию 1го сервера надо добавить:
/*
log-bin   	= master-bin
log-bin-index = master-bin.index
server-id 	= 1
*/

CREATE USER repl_user;
GRANT REPLICATION SLAVE ON *.* TO repl_user IDENTIFIED BY '321321'; -- позволяет пользователю получать доступ к двоичному журналу. 

-- для подчиненного сервера (slave) в секцию 2го серва:
/*
server-id   	= 2
relay-log-index = slave-relay-bin.index
relay-log   	= slave-relay-bin
*/

-- во 2м сервере нужно указать главный через консоль клиента:

CHANGE MASTER TO
MASTER_HOST = 'localhost',
MASTER_PORT = 3306,
MASTER_USER = 'repl_user',
MASTER_PASSWORD = '321321';

START SLAVE; -- запустить репликацию


SHOW SLAVE STATUS\G -- посмотреть состояние репликации


----------- процедуры и функции
DELIMITER // -- указать завершение процедуры на //, т.к. в mysql ';' используется для многих запросов, будут конфликты
CREATE PROCEDURE procedure_name; -- вызываются командой call
CREATE FUNCTION function_name; -- возвращает значение, их можно встраивать в эскуэльзапрос
SHOW PROCEDURE STATUS LIKE '%'; -- показать список хранимых процедур
SHOW CREATE PROCEDURE my_version; -- посмотреть содержимое процедуры
DROP PROCEDURE IF EXISTS my_version; -- удалить

DELIMITER //
DROP FUNCTION IF EXISTS get_version; -- удалить функцию
CREATE FUNCTION get_version() -- создать функция
RETURNS VARCHAR(255) DETERMINISTIC -- RETURNS - какой тип вернуть, DETERMINISTIC - кэширует ответ, если значение не будет меняться. Если будет - надо поставить NOT
BEGIN
	RETURN VERSION();
END//

SET GLOBAL log_bin_trust_function_creators = 1; -- разрешить NOT DETERMINISTIC

-- параметры процедур:
in -- данные внутрь процедуры
out -- данные из процедуры
inout -- в обе стороны

DECLARE days, hours, minutes INT; -- объявление локальных переменных

SELECT
	id,data
INTO
	@x, @y
FROM 
	test;

IF(условие) THEN действие; ELSEIF (условие) THEN действие; ELSE действие; END IF; -- условия

CASE переменная 
	WHEN 'значение' THEN
		действие;
	ELSE
		действие;
END CASE;

-- циклы
WHILE условие DO действие; END WHILE;
REPEAT действие; UNTIL условие END REPEAT; -- цикл с постусловием
метка: LOOP действие; IF условие THEN LEAVE метка; END LOOP метка; 
-- метка: тело цикла[внутри LEAVE метка]; конец цикла метка цикла; -- метка

Внутри процедуры можно сделать обработчик ошибок:

DECLARE CONTINUE HANDLER FOR SQLSTATE 'код ошибки' SET @переменная = 'текст';
  дейтсвие;
  IF @переменная IS NOT NULL THEN
	SELECT @переменная;
  END IF;

SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'message text' -- вызвать своё исключение


-- курсор. Внутри процедуры:
BEGIN

  DECLARE флаг INT DEFAULT 0;


  DECLARE курсор CURSOR FOR SELECT нужная таблица;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET флаг = 1; -- обработчик ошибок на отсутствие строки

  OPEN курсор;

  метка: LOOP
	FETCH курсор INTO переменные; -- перевести курсор на след. строку
	IF флаг THEN LEAVE метка; -- вывалиться, если нет строк
	END IF;
	действие;
  END LOOP метка;

  CLOSE курсор;
END//

-- триггеры привязываются к insert, delete, update. before/after
CREATE TRIGGER trigger_name AFTER/BEFORE INSERT ON catalogs
FOR EACH ROW
BEGIN
	действие
END

SHOW TRIGGERS \G -- показать триггеры
DROP TRIGGER IF EXISTS trigger_name; 
new.id -- новое значение (после вставки)
old.id -- старое, до вставки
COALESCE(...) -- возвращает 1е значение, отличное от NULL

---------------------- примеры -----------------------------
delimiter //
CREATE PROCEDURE my_version()
BEGIN
	SELECT VERSION(); 
END//

CALL my_version();

 SELECT * FROM information_schema.routines WHERE SPECIFIC_NAME LIKE 'my_version' \G -- здесь храниться процедура
 SELECT SPECIFIC_NAME, ROUTINE_TYPE FROM information_schema.routines ORDER BY CREATED DESC LIMIT 10; -- последнии 10 созданных
 
 
DELIMITER //
CREATE PROCEDURE set_x (IN value INT)
BEGIN
	SET @x := value;
END //

CALL set_x(123456)//

SELECT @x//
+--------+
| @x     |
+--------+
| 123456 |
+--------+

DROP PROCEDURE IF EXISTS set_x//
CREATE PROCEDURE set_x (IN value INT)
BEGIN
	SET @x = value;
	SET value = value - 1000;
END //
SET @y = 1000//
CALL set_x(@y)//
SELECT @x, @y//
/*
+------+------+
| @x   | @y   |
+------+------+
| 1000 | 1000 |
+------+------+
*/

DROP PROCEDURE IF EXISTS set_x//
CREATE PROCEDURE set_x (OUT value INT)
BEGIN
	SET @x = value;
	SET value = 1000;
END //

SET @y = 10000//
CALL set_x(@y)//

/*
SELECT @x, @y//
+------+------+
| @x   | @y   |
+------+------+
| NULL | 1000 |
+------+------+
*/

DROP PROCEDURE IF EXISTS set_x//
CREATE PROCEDURE set_x (INOUT value INT)
BEGIN
	SET @x = value;
	SET value = value - 1000;
END //
SET @y = 10000//
CALL set_x(@y)//
SELECT @x, @y//
/*
+-------+------+
| @x    | @y   |
+-------+------+
| 10000 | 9000 |
+-------+------+
*/

DELIMITER //
DROP FUNCTION IF EXISTS second_format//
CREATE FUNCTION second_format(seconds INT)
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	DECLARE days, hours, minutes INT;
	SET days = FLOOR (seconds / 86400);
	SET seconds = seconds - days * 86400;
	SET hours = FLOOR (seconds / 3600);
	SET seconds = seconds - hours * 3600;
	SET minutes = FLOOR (seconds / 60);
	SET seconds = seconds - minutes * 60;
	RETURN CONCAT(days, " days ",
				hours, " hours ",
				minutes, " minutes ",
				seconds, " seconds");
END//

SELECT second_format(123456)//
/*
+--------------------------------------+
| second_format(123456)                |
+--------------------------------------+
| 1 days 10 hours 17 minutes 36seconds |
+--------------------------------------+
*/

DROP PROCEDURE IF EXISTS numcatalogs// 
CREATE PROCEDURE numcatalogs (OUT total INT) 
BEGIN
	SELECT COUNT(*) INTO total FROM catalogs;
END//

CALL numcatalogs(@a)//
SELECT @a//

DROP PROCEDURE IF EXISTS format_now//
CREATE PROCEDURE format_now(format CHAR(4)) 
BEGIN 
	IF (format = 'date') THEN
		SELECT DATE_FORMAT(NOW(), "%d.%m.%Y") as format_now;
	ELSEIF (format = 'time') THEN
		SELECT DATE_FORMAT(NOW(), "%H:%i:%s") as format_now;
	ELSE 
		SELECT UNIX_TIMESTAMP(NOW()) as format_now;
	END IF;
END //

CALL format_now('date')//
CALL format_now('time')//
CALL format_now('sda')//

/*
+------------+
| format_now |
+------------+
| 01.09.2020 |
+------------+
*/

DROP PROCEDURE IF EXISTS format_now//
CREATE PROCEDURE format_now(format CHAR(4)) 
BEGIN 
	CASE format
		WHEN 'date' THEN 
			SELECT DATE_FORMAT(NOW(), "%d.%m.%Y") as format_now;
		WHEN 'time' THEN 
			SELECT DATE_FORMAT(NOW(), "%H:%i:%s") as format_now;
		WHEN 'secs' THEN
			SELECT UNIX_TIMESTAMP(NOW()) as format_now;
		ELSE 
			SELECT 'ошибка в параметре формат' as format_now;;
	END CASE;
END //

CALL format_now('date')//
CALL format_now('time')//
CALL format_now('sda')//


DROP PROCEDURE IF EXISTS nown//
CREATE PROCEDURE nown(IN num INT)
BEGIN
	DECLARE i INT default 0; 
	IF (num > 0) THEN	
		cycle: WHILE i < num DO -- cycle - метка 
			IF i >= 2 THEN LEAVE cycle; 
			END IF; 
			SELECT NOW(); 
			SET i = i + 1; 
		END WHILE cycle; 
	ELSE 
		SELECT 'ошибочное значение параметра'; 
	END IF; 	
END// 


DROP PROCEDURE IF EXISTS numbers_string//
CREATE PROCEDURE numbers_string (IN num INT)
BEGIN
  DECLARE i INT DEFAULT 0;
  DECLARE bin TINYTEXT DEFAULT '';
  IF (num > 0) THEN
	cycle : WHILE i < num DO
  	SET i = i + 1;
  	SET bin = CONCAT(bin, i);
  	IF i > CEILING(num / 2) THEN ITERATE cycle;
  	END IF;
  	SET bin = CONCAT(bin, i);
	END WHILE cycle;
	SELECT bin;
  ELSE
	SELECT 'Ошибочное значение параметра';
  END IF;
END//

CALL numbers_string(9)//


DROP PROCEDURE IF EXISTS now3//
CREATE PROCEDURE now3()
BEGIN
	DECLARE i INT default 3; 
	cycle: LOOP	 
		SELECT NOW(); 
		SET i = i - 1; 
		IF i <= 0 THEN LEAVE cycle; 
		END IF; 
	END LOOP cycle; 
END// 


DROP PROCEDURE IF EXISTS insert_to_catalog//
CREATE PROCEDURE insert_to_catalog (IN id INT, IN name VARCHAR(255))
BEGIN
  DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET @error = 'Ошибка вставки значения';
  INSERT INTO catalogs VALUES(id, name);
  IF @error IS NOT NULL THEN
	SELECT @error;
  END IF;
END//

SELECT * FROM catalogs//

CALL insert_to_catalog(4, 'Оперативная память')//
CALL insert_to_catalog(1, 'Процессоры')//

-- курсор

DROP PROCEDURE IF EXISTS copy_catalogs//
CREATE PROCEDURE copy_catalogs ()
BEGIN
  DECLARE id INT;
  DECLARE is_end INT DEFAULT 0;
  DECLARE name TINYTEXT;

  DECLARE curcat CURSOR FOR SELECT * FROM catalogs;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_end = 1;

  OPEN curcat;

  cycle : LOOP
	FETCH curcat INTO id, name;
	IF is_end THEN LEAVE cycle;
	END IF;
	INSERT INTO upcase_catalogs VALUES(id, UPPER(name));
  END LOOP cycle;

  CLOSE curcat;
END//

-- триггер 
DELIMITER //
CREATE TRIGGER catalogs_count AFTER INSERT ON catalogs
	FOR EACH ROW
	BEGIN
		SELECT COUNT(*) INTO @total FROM catalogs;
	END//
	
DROP TRIGGER IF EXISTS catalogs_count//


CREATE TRIGGER check_catalog_id_insert BEFORE INSERT ON products -- если не указан кат_ид, или указан NULL - автоматически вставит первый ид из таблицы каталогс
	FOR EACH ROW
	BEGIN
		DECLARE cat_id INT;
		SELECT id INTO cat_id FROM catalogs ORDER BY id LIMIT 1;
		SET NEW.catalog_id = COALESCE(NEW.catalog_id, cat_id);
	END//
	
CREATE TRIGGER check_catalog_id_update BEFORE UPDATE ON products  -- если не указан кат_ид, или указан NULL - автоматически оставит предыдущий, если он не подходит, первый ид из таблицы каталогс
	FOR EACH ROW
	BEGIN
		DECLARE cat_id INT;
		SELECT id INTO cat_id FROM catalogs ORDER BY id LIMIT 1;
		SET NEW.catalog_id = COALESCE(NEW.catalog_id, OLD.catalog_id, cat_id);
	END//
	
	

CREATE TRIGGER check_last_catalogs BEFORE DELETE ON catalogs
FOR EACH ROW BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM catalogs;
  IF total <= 1 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'DELETE canceled';
  END IF;
END//
 
----------------- типы таблиц

CREATE TABLE blabla ( blabla, .... blabla) COMMENT = 'comment' ENGINE=InnoDB; -- InnoDB - движок по умолчанию (подсистема хранения данных), Memory (разместить в ОЗУ), Archive - сжать данные
SHOW TABLE STATUS LIKE 'catalogs' \G -- посмотреть, какой движок используется
SHOW ENGINES \G -- список движков


-- выделение памяти. В my.cnf:
[mysqld]
...
# ядро 8G
query_cache_size = 0
key_buffer_size = 8M
innodb_buffer_pool_size = 8G
innodb_additional_mem_pool_size = 8M
innodb_log_buffer_size = 8M
...
max_connections = 500
...
read_buffer_size = 1M
read_rnd_buffer_size = 1M
sort_buffer_size = 2M
thread_stack = 256K
join_buffer_size = 128K
# макс 500 соединений по 3.5 Мб
---
SHOW VARIABLES LIKE "KEY%";  -- объём памяти, выделенный под кэш myisam индекса.  key_buffer_size          | 8388608 -- по дефолту 8 Мб, т.к. не используем myisam, можно увеличить до 4 Гб
SHOW STATUS LIKE "KEY%"; -- оценить использование кеша  Key_blocks_unused      | 6698  |, | Key_blocks_used        | 0
SHOW VARIABLES LIKE "innodb_buffer_pool_size"; -- буфер под иннодб, рекомендуется выделять 50-80% ОЗУ
SHOW STATUS LIKE "innodb_buffer_pool%"; -- оценить использование кеша иннодб
/*
Innodb_buffer_pool_pages_total        | 8192 -- количество блоков в кэше
Innodb_buffer_pool_pages_free         | 7026 -- количество свободных блоков
Innodb_buffer_pool_pages_data         | 1162 -- занятые блоки
*/

EXPLAIN SELECT * FROM catalogs; -- исследовать запрос

-- методы доступа (type)
ALL -- полное сканирование таблицы
index  
range -- 
ref -- доступ по индексу, несколько значений
eq_ref -- доступ по инедксу, не более одного значения
const
NULL

-----------nosql
- ключ-значение -- Riak, Dynamo DB, Memcached и Redis
- столбцовые базы данных -- каждый столбец в отдельном файле.  Cassandra, HBase, Clickhouse.
- документоориентированные бд (безсхемные, неструктурированные) -- В них единица хранения — целый документ, часто в формате JSON, XML или YML. CouchDB и MongoDB
- графовые базы -- (часто для соц. сетей) FlockDB, Neo4j, Polyglot.
- объектные базы --  db4o, InterSystems Cache.
- полнотекстового поиска -- (на поисковый механизм) Solr и ElasticSearch

--------- redis

redis-cli -- клиент редис. порт по умолчанию 6379
quit, exit -- выход
redis -benchmark -n 100000 -- оценть производительность сервера
HELP PING -- узнать инфу о команде ping
HELP @connections -- справка по коммандам группы connections
SET key 'value' -- key - ключ, 'value'  - значение
GET key -- вернет 'value'
MSET fst 1 snd 2 thd 3 fth 4 -- множественный сет, назначить 4 ключа, каждому присвоить числовое значение
MGET fst snd thd fth -- извлечь несколько значений

SET key 'Hello '
APPEND key 'World!' -- добавить к ключу значение

SET count 0
INCR count -- увеличит на 1
INCRBY count 5 -- увеличить на 5, можно отрицательные

DECR count
DECRBY count 5 -- обратное incr

INCRBYFLOAT count 3.2 -- увеличить на число с пл. точкой
DEL key -- удалить пару ключ-значение
KEYS * -- список ключей
RENAME key new_key -- переименовать ключ

SET timer 'one minute'
EXPIRE timer 60 -- запускает таймер для ключа timer на 60сек
EXISTS timer -- если срок жизни не истёк, вернёт 1, истёк 0, нет ограничения - вернёт -1
TTL timer -- сколько сек осталось 
PERSIST timer -- отменить ограничение на срок хранения

-- Типы данных:

строки ('fsdafasd')
числа (целые и пл. точка)
список 
хэш (хранит пары ключ-значение)
множество (неупорядоченные коллекции уникальных элементов)
отсортированное множество

 коллекция не может быть элементом другой коллекции

TYPE key -- узнать тип ключа

HSET admin login "root" -- admin - ключ хэша, login - ключ пары, "root" - значение пары
HSET admin pass "password"
HSET admin registered_at "2017-09-01"

HGET admin login -- вернет root

--равносильно:

HMSET admin login "root" pass "password" registered_at "2017-09-01"
HVALS admin -- вернёт все значения  ( 1) "root" 2) "password" 3) "2017-09-01" )
HEXISTS admin login -- проверить существование поля
HEXISTS admin name -- вернёт 0
HKEYS admin -- вернуть все ключи
HGETALL admin -- вернуть все ключи и значения. нечетные - ключи, чётные - значения
HLEN admin -- кол-во элементов в хэше (вернёт 3)

SADD email blabla@bla.net -- вставить во меножество  email почту blabla@bla.net
SADD email blablasdasda@bla.net 
SADD email blafasdfasfaghadfgasbla@bla.net 
SADD email blabgadfgdfgdfsgsdfgfdfsgla@bla.net 
SADD email blabgadfgdfgdfsgfsgla@bla.net blablassdfgdasda@bla.net 

SMEMBERS email -- элементы множества
SCARD email --  кол-во эл-тов во множестве
SREM email blabgadfgdfgdfsgsdfgfdfsgla@bla.net -- удалить эл-т
SPOP email -- вернет случайный эл-т и снесёт его

SADD subscribers blabgadfgdfgdfsgfsgla@bla.net blablassdfgdasda@bla.net 
SINTER email subscribers -- вернет общие эл-ты 2х множеств
SDIFF email subscribers -- вернет разные эл-ты 2х множеств
SUNION email subscribers -- объеденить 2 мн-ва в 1

SELECT 1 -- перейти в 1-ю бд
SELECT 0 -- перейти в 0-ю бд (по умолчанию)

в redis по умолчанию ограничено 16-ю бд

------------ MongoDB ---

-- хранение в json, обращение чз js
mongo -- запустить клиент
db.version() -- вывести версию 
db.version -- вывести код функции
use shop -- выбрать бд. если бд нет - создаст после добавления 1й записи
show dbs -- список бд.

db.shop.insert({name: 'Ольга'})
db.shop.find() -- посмотреть содержимое бд
db.shop.insert({name: 'Александр'})
db.shop.count() -- кол-во документов (в этом случае 2)
db.shop.find({name: 'Ольга'}) -- найти документ
db.shop.update({name: 'Ольга'}, {%set: {email: 'olga@mail.com'}}) -- добавить в документ Ольга почту 
db.shop.update({name: 'Ольга'}, {%unset: {email: ''}}) -- удалить значение


db.shop.update({name: 'Ольга'}, {$set: { contacts: { email: ['olga@gmail.com', 'olga@mail.ru'], skype: 'olgashop' }}}) -- вставить коллекцию
db.shop.update({name: 'Александр'}, {$set: { contacts: { email: ['alex@gmail.com'], skype: 'alexander' }}})
db.shop.find()
db.shop.find({'contacts.skype': 'alexander'}) -- поиск по полю скайп

db.shop.update({name: 'Александр'}, {$push: { 'contacts.email': 'alex@mail.ru' }}) -- добавить ещё 1 почту
db.shop.remove({name: 'Ольга'}) -- удалить документ

db.shop.drop() -- удалить все из бд

------------------- ElasticSearch (скопировал всё отсюда https://docs.google.com/document/d/1EoqVvggI0IzF8MUOQLSf5XWOQlp9YvBriT-jXDCXeKE/edit# ) ---

MUST - должен, лог. И, должно совпадать
SHOULD - может, лог. ИЛИ. Не обязательно совпадает с искомым запросом, но совпадения имеют более высокий ранг
MUST_NOT - не должен - все, что совпадает - не выведется

отбрасываются предлоги, отбрасываются слова, которые очень часто фигурируют в результатах, имеет значение порядок слов и расстояние между ними
порт с завода 9200
взаимодействие через http (rest)
на примере утилиты curl (macos)



curl -H 'Content-Type: application/json' -X PUT 'http://localhost:9200/shop/products/1?pretty' -d'
{
  "name" : "Intel Core i5-7400",
  "description" : "Процессор для настольных персональных компьютеров, основанных на платформе Intel.",
  "price" : "12700.0",
  "tags" : [
	"комплектующие",
	"процессоры",
	"Intel"
  ],
  "created_at" : "2018-10-10T20:35:12+00:00"
}'


/*
index - имя бд
все ключи, которые начинаются с _  - служебное
*/

curl 'http://localhost:9200/shop/products/1/_source?pretty' -- посмотреть всё, кроме служебных ключей
curl 'http://localhost:9200/shop/products/1/?_source=description&pretty' -- запросить поле description


-- вставим еще несколько записей, соответствующих процессорам:
curl -H 'Content-Type: application/json' -X PUT 'http://localhost:9200/shop/products/2' -d'
{
  "name" : "Intel Core i3-8100",
  "description" : "Процессор для настольных персональных компьютеров, основанных на платформе Intel.",
  "price" : "7890.00",
  "tags" : [
	"комплектующие",
	"процессоры",
	"Intel"
  ],
  "created_at" : "2018-10-10T20:40:23+00:00"
}'

curl -H 'Content-Type: application/json' -X PUT 'http://localhost:9200/shop/products/3' -d'
{
  "name" : "AMD FX-8320E",
  "description" : "Процессор AMD.",
  "price" : "4780.00",
  "tags" : [
	"комплектующие",
	"процессоры",
	"AMD"
  ],
  "created_at" : "2018-10-10T20:42:06+00:00"
}'

-- И материнским платам:
curl -H 'Content-Type: application/json' -X PUT 'http://localhost:9200/shop/products/4' -d'
{
  "name" : "ASUS ROG MAXIMUS X HERO",
  "description" : "Материнская плата Z370, Socket 1151-V2, DDR4, ATX",
  "price" : "19310.00",
  "tags" : [
	"комплектующие",
	"материнские платы",
	"ASUS"
  ],
  "created_at" : "2018-10-10T20:40:23+00:00"
}'

curl -H 'Content-Type: application/json' -X PUT 'http://localhost:9200/shop/products/5' -d'
{
  "name" : "Gigabyte H310M S2H",
  "description" : "Материнская плата H310, Socket 1151-V2, DDR4, mATX",
  "price" : "4790.00",
  "tags" : [
	"комплектующие",
	"материнские платы",
	"Gigabyte"
  ],
  "created_at" : "2018-10-10T20:44:36+00:00"
}'

------------- 

curl 'http://localhost:9200/shop/products/_search?pretty&size=2' -- ограничить выборку 2мя элементами


curl -H 'Content-Type: application/json' 'http://localhost:9200/shop/products/_search?pretty' -d'
{
  "query": {
	"bool": {
  	"filter": {
    	"term": {
      	"tags": "процессоры"
    	}
  	}
	}
  }
}'

-- поиск по тегу процессоры. Елси ввести процессор - ничего не найдет из-за тега term. чтобы нашло, надо настроить mapping

curl 'http://localhost:9200/shop/products/_mapping?pretty' -- посмотреть настройки mapping

--Сейчас он не поддерживает русский язык, давайте включим такую поддержку. Для начала удалим существующий индекс:
curl -X DELETE 'http://localhost:9200/shop?pretty'

-- И явно создадим новый mapping с поддержкой русского языка:
curl  -H 'Content-Type: application/json' -X PUT 'http://localhost:9200/shop?pretty' -d'
{
  "settings": {
	"analysis": {
  	"filter": {
    	"ru_stop": {
      	"type": "stop",
      	"stopwords": "_russian_"
    	},
    	"ru_stemmer": {
      	"type": "stemmer",
      	"language": "russian"
    	}
  	},
  	"analyzer": {
    	"default": {
      	"char_filter": [
        	"html_strip"
      	],
      	"tokenizer": "standard",
      	"filter": [
        	"lowercase",
        	"ru_stop",
        	"ru_stemmer"
      	]
    	}
  	}
	}
  },
  "mappings": {
	"products": {
  	"properties": {
    	"description": {
      	"type": "text"
    	},
    	"name": {
      	"type": "text"
    	},
    	"price": {
      	"type": "double"
    	},
    	"tags": {
      	"type": "text"
    	},
    	"created_at": {
      	"type": "date"
    	}
  	}
	}
  }
}'

-- теперь найдёт все процессоры
curl -H 'Content-Type: application/json' 'http://localhost:9200/shop/products/_search?pretty' -d'
{
  "query": {
	"query_string": {
  	"query": "процессор"
	}
  }
}'

-------------------------- ClickHouse (колоночная дб, аналитика)---------------

SELECT 1 -- равносильно mysql - выведет число
SHOW DATABASES;  -- показать дб
CREATE DATABASE shop; -- создать

use shop
CREATE TABLE `visits` (
	`VisitDate` Date,
	`Hits` UInt32
) ENGINE = MergeTree(VisitDate, (VisitDate), 8192); -- создание таблицы `` - необяз., как в mysql. INT - 8 16 32 64. ; - необяз

INSERT INTO visits VALUES
	('2018-10-01', 45324),
	('2018-10-02', 72241); -- вставка


SELECT COUNT() FROM visits; -- кол-во записей
SELECT * FROM visits LIMIT 1;  
SELECT * FROM visits LIMIT 1 \G 

SELECT toRelativeWeekNum(VisitDate) AS week, sum(Hits) From visits GROUP by week; -- toRelativeWeekNum узнать номер недели. Актуально, при наличии записей за несколько разных недель. Покажет кол-во посещений по неделям
SELECT toRelativeWeekNum(VisitDate) AS week, sum(Hits), bar (hits, 0, 500000, 20) AS bar From visits GROUP by week; -- bar - диаграмма. 500000 - 100%, 0 - 0%, 20 - ширина столбца

SHOW TABLES; -- список таблиц
DROP TABLE visits -- удалить

  