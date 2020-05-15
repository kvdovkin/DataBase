-- 1. Добавить внешние ключи
ALTER TABLE dealer
	ADD CONSTRAINT dealer_company_id_company_fk
		foreign key (id_company) REFERENCES company;

ALTER TABLE "order"
	ADD CONSTRAINT order_dealer_id_dealer_fk
		FOREIGN KEY (id_dealer) REFERENCES dealer;

ALTER TABLE "order"
	ADD CONSTRAINT order_pharmacy_id_pharmacy_fk
		FOREIGN KEY (id_pharmacy) REFERENCES pharmacy;

ALTER TABLE "order"
	ADD CONSTRAINT order_production_id_production_fk
		FOREIGN KEY (id_production) REFERENCES production;

ALTER TABLE production
	ADD CONSTRAINT production_company_id_company_fk
		FOREIGN KEY (id_company) REFERENCES company;

ALTER TABLE production
	ADD CONSTRAINT production_medicine_id_medicine_fk
		FOREIGN KEY (id_medicine) REFERENCES medicine;

-- 2. Выдать информацию по всем заказам лекарства “Кордерон” компании “Аргус” с
-- указанием названий аптек, дат, объема заказов.

SELECT pharmacy.name,
       "order".date,
       "order".quantity
FROM "order"
	LEFT JOIN pharmacy ON "order".id_pharmacy = pharmacy.id_pharmacy
	LEFT JOIN production ON "order".id_production = production.id_production
	LEFT JOIN company ON production.id_company = company.id_company
	LEFT JOIN medicine ON production.id_medicine = medicine.id_medicine
WHERE medicine.name = 'Кордерон'
  AND company.name = 'Аргус';

-- 3. Дать список лекарств компании “Фарма”, на которые не были сделаны заказы до 25 января

SELECT medicine.name
FROM medicine
	LEFT JOIN production ON medicine.id_medicine = production.id_medicine
	LEFT JOIN company ON production.id_company = company.id_company
	LEFT JOIN "order" ON production.id_production = [order].id_production
WHERE 
	company.name = 'Фарма' AND 
	production.id_production NOT IN (
		SELECT 
			"order".id_production
		FROM "order"
		WHERE "order".date < '2019-01-25'
	)
GROUP BY medicine.name;

-- 4. Дать минимальный и максимальный баллы лекарств каждой фирмы, которая оформила не менее 120 заказов

SELECT company.name,
		MIN(production.rating) AS MinRating,
		MAX(production.rating) AS MaxRating
FROM production
	LEFT JOIN company ON production.id_company = company.id_company
	LEFT JOIN "order" ON production.id_production = "order".id_production
GROUP BY company.name, company.id_company
HAVING COUNT("order".id_order) >= 120;

-- 5. Дать списки сделавших заказы аптек по всем дилерам компании “AstraZeneca”. Если у дилера нет заказов, в названии аптеки проставить NULL

SELECT dealer.id_dealer,
       dealer.name,
       pharmacy.name
FROM dealer
         LEFT JOIN company ON dealer.id_company = company.id_company
         LEFT JOIN "order" ON "order".id_dealer = dealer.id_dealer
         LEFT JOIN pharmacy ON pharmacy.id_pharmacy = "order".id_pharmacy
WHERE company.name = 'AstraZeneca';

-- 6. Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, а длительность лечения не более 7 дней

UPDATE production
SET production.price = production.price * 0.8
WHERE production.id_production IN (
	SELECT production.id_production 
	FROM production
		LEFT JOIN medicine ON production.id_medicine = medicine.id_medicine
	WHERE medicine.cure_duration <= 7 AND production.price > 3000
);
-- Для проверки
SELECT medicine.name,
		production.price
FROM medicine
	LEFT JOIN production ON medicine.id_medicine = production.id_medicine;

-- 7. Добавить необходимые индексы

CREATE NONCLUSTERED INDEX [IX_production_id_medicine] ON production (id_medicine)

CREATE NONCLUSTERED INDEX [IX_production_id_company] ON production (id_company)

CREATE NONCLUSTERED INDEX [IX_production_rating] ON production (rating)

CREATE NONCLUSTERED INDEX [IX_order_id_production] ON [order] (id_production)

CREATE NONCLUSTERED INDEX [IX_order_id_pharmacy] ON [order] (id_pharmacy)

CREATE NONCLUSTERED INDEX [IX_order_id_dealer] ON [order] (id_dealer)

CREATE NONCLUSTERED INDEX [IX_dealer_id_company] ON dealer (id_company)

CREATE NONCLUSTERED INDEX [IX_dealer_name] ON dealer (name)

CREATE NONCLUSTERED INDEX [IX_medicine_name] ON medicine (name)

CREATE NONCLUSTERED INDEX [IX_company_name] ON company (name)