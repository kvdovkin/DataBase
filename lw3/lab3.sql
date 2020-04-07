--������� 2.
--1. INSERT
	--1. ��� �������� ������ �����
	INSERT INTO specialty VALUES (6, '��������', '������������� ��������', null, null);
	--2. � ��������� ������ �����
	INSERT INTO specialty (Id_specialty, name, kind_activity) VALUES (7, '����', '������������� �����');
	--3. � ������� �������� �� ������ �������
	INSERT INTO specialty VALUES ((SELECT Id_dish FROM dish WHERE name = '������'), '�������', '������������� �������� ���������', NULL, NULL);

--2. DELETE
	--1. ���� �������
	DELETE FROM dish;
	--2. �� �������
		DELETE FROM dish WHERE name = '��������';
	--3. �������� �������
		TRUNCATE TABLE dish;

--3. UPDATE
	--1. ���� �������
		 UPDATE dish SET price = 10;
	--2. �� ������� �������� ���� �������
		UPDATE dish SET price = 20 WHERE name = '�����';
	--3. �� ������� �������� ��������� ���������
		UPDATE dish SET price = 25, Id_dish = 15, Id_recipe = 15 WHERE name = '������';

--4. SELECT
	--1. � ������������ ������� ����������� ��������� (SELECT atr1, atr2 FROM...)
		SELECT name, experience FROM cook;
	--2. �� ����� ���������� (SELECT * FROM...)
		SELECT * FROM cook;
	--3. � �������� �� �������� (SELECT * FROM ... WHERE atr1 = "")
		SELECT * FROM cook WHERE name ='������ ����';

--5. SELECT ORDER BY + TOP (LIMIT)
    --1. � ����������� �� ����������� ASC + ����������� ������ ���������� �������
		SELECT TOP 3 * FROM cook ORDER BY Id_cook ASC;
    --2. � ����������� �� �������� DESC
		SELECT * FROM cook ORDER BY name DESC;
    --3. � ����������� �� ���� ��������� + ����������� ������ ���������� �������
		SELECT TOP 2 * FROM cook ORDER BY data_birth, experience ASC;
    --4. � ����������� �� ������� ��������, �� ������ �����������
		SELECT * FROM cook ORDER BY data_birth, experience, Id_cook ASC;

--6. ������ � ������. ����������, ����� ���� �� ������ ��������� ������� � ����� DATETIME.
    --��������, ������� ������� ����� ��������� ���� �������� ������.
    --1. WHERE �� ����
		SELECT * FROM cook WHERE YEAR(data_birth) > 1980;
    --2. ������� �� ������� �� ��� ����, � ������ ���. ��������, ��� �������� ������.
		SELECT YEAR(data_birth), name FROM cook;

--7. SELECT GROUP BY � ��������� ���������
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
    --1. �������� 3 ������ ������� � �������������� GROUP BY + HAVING
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
    --1. LEFT JOIN ���� ������ � WHERE �� ������ �� ���������
	SELECT *
	FROM dish
	LEFT JOIN supplier ON dish.name = supplier.name;
    --2. RIGHT JOIN. �������� ����� �� �������, ��� � � 5.1
	SELECT *
	FROM dish
	RIGHT JOIN supplier ON dish.name = supplier.name;
    --3. LEFT JOIN ���� ������ + WHERE �� �������� �� ������ �������
	SELECT *
	FROM dish
	LEFT JOIN supplier ON dish.Id_dish = supplier.Id_supplier
	LEFT JOIN cook ON dish.Id_dish = cook.Id_cook
	WHERE profit > 300 OR YEAR(data_birth) > 1980 OR price >= 20;
    --4. FULL OUTER JOIN ���� ������
	SELECT *
	FROM dish
	FULL OUTER JOIN supplier ON dish.name = supplier.name;

--10. ����������
    --1. �������� ������ � WHERE IN (���������)
	SELECT * FROM dish
	WHERE dish.name IN(
		SELECT supplier.name FROM supplier
	);
    --2. �������� ������ SELECT atr1, atr2, (���������) FROM ...  
	SELECT name, (SELECT Id_cook FROM cook WHERE experience >= 40) AS OldCookId 
	FROM cook;