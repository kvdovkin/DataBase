--Вариант 2.
--1. INSERT
	--1. Без указания списка полей
	INSERT INTO specialty VALUES (6, 'Баранина', 'Приготовление баранины', null, null);
	--2. С указанием списка полей
	INSERT INTO specialty (Id_specialty, name, kind_activity) VALUES (7, 'Хлеб', 'Приготовление булок');
	--3. С чтением значения из другой таблицы
	INSERT INTO specialty VALUES ((SELECT Id_dish FROM dish WHERE name = 'молоко'), 'Молочка', 'Приготовление молочной продукции', NULL, NULL);

--2. DELETE
	--1. Всех записей
	DELETE FROM dish;
	--2. По условию
		DELETE FROM dish WHERE name = 'вареники';
	--3. Очистить таблицу
		TRUNCATE TABLE dish;

--3. UPDATE
	--1. Всех записей
		 UPDATE dish SET price = 10;
	--2. По условию обновляя один атрибут
		UPDATE dish SET price = 20 WHERE name = 'масло';
	--3. По условию обновляя несколько атрибутов
		UPDATE dish SET price = 25, Id_dish = 15, Id_recipe = 15 WHERE name = 'молоко';

--4. SELECT
	--1. С определенным набором извлекаемых атрибутов (SELECT atr1, atr2 FROM...)
		SELECT name, experience FROM cook;
	--2. Со всеми атрибутами (SELECT * FROM...)
		SELECT * FROM cook;
	--3. С условием по атрибуту (SELECT * FROM ... WHERE atr1 = "")
		SELECT * FROM cook WHERE name ='Петров Петр';

--5. SELECT ORDER BY + TOP (LIMIT)
    --1. С сортировкой по возрастанию ASC + ограничение вывода количества записей
		SELECT TOP 3 * FROM cook ORDER BY Id_cook ASC;
    --2. С сортировкой по убыванию DESC
		SELECT * FROM cook ORDER BY name DESC;
    --3. С сортировкой по двум атрибутам + ограничение вывода количества записей
		SELECT TOP 2 * FROM cook ORDER BY data_birth, experience ASC;
    --4. С сортировкой по первому атрибуту, из списка извлекаемых
		SELECT * FROM cook ORDER BY data_birth, experience, Id_cook ASC;

--6. Работа с датами. Необходимо, чтобы одна из таблиц содержала атрибут с типом DATETIME.
    --Например, таблица авторов может содержать дату рождения автора.
    --1. WHERE по дате
		SELECT * FROM cook WHERE YEAR(data_birth) > 1980;
    --2. Извлечь из таблицы не всю дату, а только год. Например, год рождения автора.
		SELECT YEAR(data_birth), name FROM cook;

--7. SELECT GROUP BY с функциями агрегации
    --1. MIN
	SELECT MIN(price) FROM dish;
    --2. MAX
	SELECT MAX(price) FROM dish;
    --3. AVG
	SELECT AVG(price) FROM dish;
    --4. SUM
	SELECT SUM(price) FROM dish;
    --5. COUNT
	SELECT COUNT(price) FROM dish;

--8. SELECT GROUP BY + HAVING
    --1. Написать 3 разных запроса с использованием GROUP BY + HAVING
	SELECT YEAR(data_birth), COUNT(*) AS YearsCount
	FROM cook
	GROUP BY YEAR(data_birth)
	HAVING COUNT(*) > 1;

	SELECT YEAR(data_birth)
	FROM cook
	GROUP BY YEAR(data_birth)
	HAVING YEAR(data_birth) > 1980;

	SELECT price
	FROM dish
	GROUP BY price
	HAVING price <= 20;

--9. SELECT JOIN
    --1. LEFT JOIN двух таблиц и WHERE по одному из атрибутов
	SELECT *
	FROM dish
	LEFT JOIN supplier ON dish.name = supplier.name;
    --2. RIGHT JOIN. Получить такую же выборку, как и в 5.1
	SELECT *
	FROM dish
	RIGHT JOIN supplier ON dish.name = supplier.name;
    --3. LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
	SELECT *
	FROM dish
	LEFT JOIN supplier ON dish.Id_dish = supplier.Id_supplier
	LEFT JOIN cook ON dish.Id_dish = cook.Id_cook
	WHERE profit > 300 OR YEAR(data_birth) > 1980 OR price >= 20;
    --4. FULL OUTER JOIN двух таблиц
	SELECT *
	FROM dish
	FULL OUTER JOIN supplier ON dish.name = supplier.name;

--10. Подзапросы
    --1. Написать запрос с WHERE IN (подзапрос)
	SELECT * FROM dish
	WHERE dish.name IN(
		SELECT supplier.name FROM supplier
	);
    --2. Написать запрос SELECT atr1, atr2, (подзапрос) FROM ...  
	SELECT name, (SELECT Id_cook FROM cook WHERE experience >= 40) AS OldCookId 
	FROM cook;