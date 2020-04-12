--1. �������� ������� �����.
ALTER TABLE room
ADD
FOREIGN KEY(id_room_category) REFERENCES room_category(id_room_category)
ON DELETE CASCADE

ALTER TABLE room
ADD
FOREIGN KEY(id_hotel) REFERENCES hotel(id_hotel)
ON DELETE CASCADE

ALTER TABLE room_in_booking
ADD
FOREIGN KEY(id_room) REFERENCES room(id_room)
ON DELETE CASCADE

ALTER TABLE room_in_booking
ADD
FOREIGN KEY(id_booking) REFERENCES booking(id_booking)
ON DELETE CASCADE

ALTER TABLE booking
ADD
FOREIGN KEY(id_client) REFERENCES client(id_client)
ON DELETE CASCADE



--2. ������ ���������� � �������� ��������� �������, 
--	 ����������� � ������� ��������� ����� �� 1 ������ 2019�.
SELECT client.id_client, client.name, client.phone 
FROM client
INNER JOIN booking ON client.id_client = booking.id_client
INNER JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
INNER JOIN room ON room_in_booking.id_room = room.id_room
INNER JOIN hotel ON room.id_hotel = hotel.id_hotel
INNER JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE 
	hotel.name = '������' 
	and room_category.name = '����' 
	and room_in_booking.checkin_date <= DATEFROMPARTS ( 2019, 04, 1 ) 
	and DATEFROMPARTS ( 2019, 04, 1 )  < room_in_booking.checkout_date



--3. ���� ������ ��������� ������� ���� �������� �� 22 ������.
SELECT room.id_room, room.id_hotel, room.id_room_category, room.number, room.price 
FROM room

LEFT JOIN (SELECT id_room FROM room_in_booking 
		   WHERE  room_in_booking.checkin_date <= DATEFROMPARTS ( 2019, 04, 22 ) 
				  and DATEFROMPARTS ( 2019, 04, 22 )  < room_in_booking.checkout_date
		  ) AS room_in_booking
ON room_in_booking.id_room = room.id_room

WHERE room_in_booking.id_room IS NULL
ORDER BY room.id_room 



--4. ���� ���������� ����������� � ��������� ������� �� 23 ����� �� ������ ��������� �������.
SELECT room_category.id_room_category, room_category.name, COUNT(*) AS booked
FROM room_category
INNER JOIN room ON room_category.id_room_category = room.id_room_category
INNER JOIN hotel ON room.id_hotel = hotel.id_hotel
INNER JOIN room_in_booking ON room.id_room = room_in_booking.id_room

WHERE hotel.name = '������'
	  and room_in_booking.checkin_date <= DATEFROMPARTS ( 2019, 03, 23 ) 
	  and DATEFROMPARTS ( 2019, 03, 23 )  < room_in_booking.checkout_date

GROUP BY room_category.id_room_category, room_category.name


--5. ���� ������ ��������� ����������� �������� �� ���� �������� ��������� �������, 
--   ��������x � ������ � ��������� ���� ������.
SELECT room.id_room, client.id_client, client.name, client.phone, room_in_booking.checkout_date
FROM client
INNER JOIN booking ON client.id_client = booking.id_client
INNER JOIN room_in_booking ON room_in_booking.id_booking = booking.id_booking
INNER JOIN room ON room_in_booking.id_room = room.id_room

INNER JOIN (SELECT id_hotel, hotel.name FROM hotel 
		    WHERE hotel.name = '������'
		   ) AS hotel
		   ON hotel.id_hotel = room.id_hotel

INNER JOIN (SELECT room_in_booking.id_room,  MAX(room_in_booking.checkout_date) AS last_checkout_date
			FROM (
					SELECT *
					FROM room_in_booking
					WHERE DATEFROMPARTS ( 2019, 04, 1 ) <= checkout_date
						  and checkout_date < DATEFROMPARTS ( 2019, 05, 1 )
				 ) AS room_in_booking
			GROUP BY room_in_booking.id_room) AS b
ON b.id_room =  room_in_booking.id_room

WHERE (room_in_booking.id_room = b.id_room and b.last_checkout_date = room_in_booking.checkout_date)
ORDER BY  room.id_room



--6. �������� �� 2 ��� ���� ���������� � ��������� ������� 
--   ���� �������� ������ ��������� �������, ������� ���������� 10 ���.
UPDATE room_in_booking 
SET checkout_date = DATEADD(day, 2, checkout_date)
FROM room
INNER JOIN room_in_booking ON room.id_room = room_in_booking.id_room
INNER JOIN hotel ON room.id_hotel = hotel.id_hotel
INNER JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE
	hotel.name = '������' 
	and room_category.name = '������' 
	and room_in_booking.checkin_date = DATEFROMPARTS ( 2019, 05, 10 ) 



--7. ����� ��� "��������������" �������� ����������. <...>
SELECT *
FROM room_in_booking booked1
INNER JOIN room_in_booking AS booked2 ON booked1.id_room = booked2.id_room
WHERE (
	(booked1.id_room_in_booking != booked2.id_room_in_booking)
	and
	((booked1.checkin_date >= booked2.checkin_date and booked1.checkin_date < booked2.checkout_date) 
	or 
	(booked2.checkin_date >= booked1.checkin_date and booked2.checkin_date < booked1.checkout_date)) 
)
ORDER BY booked1.id_room_in_booking



--8. ������� ������������ � ����������.
BEGIN TRANSACTION;  
	INSERT INTO booking 
	VALUES(1, DATEFROMPARTS ( 2020, 04, 5 ));  
COMMIT;  



--9. �������� ����������� ������� ��� ���� ������.
-- hotel--
CREATE NONCLUSTERED INDEX [IX_hotel_id_hotel-name] ON hotel
(
	id_hotel ASC,
	name ASC
)
CREATE NONCLUSTERED INDEX [IX_hotel_name] ON hotel
(
	name ASC
)

--room_category--
CREATE NONCLUSTERED INDEX [IX_room_category_id_room_category-name] ON room_category
(
	id_room_category ASC,
	name ASC
)
CREATE NONCLUSTERED INDEX [IX_room_category_name] ON room_category
(
	name ASC
)

--room--
CREATE NONCLUSTERED INDEX [IX_room_id_hotel] ON room
(
	id_hotel ASC
)
CREATE NONCLUSTERED INDEX [IX_room_id_room_category] ON room
(
	id_room_category ASC
)

--booking--
CREATE NONCLUSTERED INDEX [IX_booking_id_client] ON booking
(
	id_client ASC
)

--room_in_booking--
CREATE NONCLUSTERED INDEX [IX_room_in_booking_id_room] ON room_in_booking
(
	id_room ASC
)
CREATE NONCLUSTERED INDEX [IX_room_in_booking_id_booking] ON room_in_booking
(
	id_booking ASC
)
CREATE NONCLUSTERED INDEX [IX_room_in_booking_checkin_date-checkout_date] ON room_in_booking
(
	checkin_date ASC,
	checkout_date ASC
)
CREATE NONCLUSTERED INDEX [IX_room_in_booking_checkout_date] ON room_in_booking
(
	checkout_date ASC
)