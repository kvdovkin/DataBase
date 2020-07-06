-- 1. �������� ������� �����
alter table student
	add constraint student_group_id_group_fk
		foreign key (id_group) references "group";

alter table lesson
	add constraint lesson_group_id_group_fk
		foreign key (id_group) references "group";

alter table lesson
	add constraint lesson_subject_id_subject_fk
		foreign key (id_subject) references subject;

alter table lesson
	add constraint lesson_teacher_id_teacher_fk
		foreign key (id_teacher) references teacher;

alter table mark
	add constraint mark_lesson_id_lesson_fk
		foreign key (id_lesson) references lesson;

alter table mark
	add constraint mark_student_id_student_fk
		foreign key (id_student) references student;

--2. ������ ������ ��������� �� ����������� ���� ��� ��������� ������� ��������. 
--   �������� ������ ������ � �������������� view.

CREATE VIEW study_computer_science AS
SELECT student.name, mark.mark
FROM mark
	LEFT JOIN student ON mark.id_student = student.id_student
	LEFT JOIN lesson ON mark.id_lesson = lesson.id_lesson
	LEFT JOIN subject on lesson.id_subject = subject.id_subject
WHERE subject.name = '�����������';

-- 3. ���� ���������� � ��������� � ��������� ������� �������� � ��������
--   ��������. ���������� ��������� ��������, �� ������� ������ �� ��������,
--   ������� ������� � ������. �������� � ���� ���������, �� �����
--   ������������� ������.

CREATE OR REPLACE FUNCTION debtor_info(identifier varchar)
    RETURNS TABLE
            (
                name    varchar,
                subject varchar
            )
    LANGUAGE SQL
AS
$$
SELECT student.name,
       subject.name
FROM student
         INNER JOIN "group" ON "group".id_group = student.id_group
         INNER JOIN lesson ON lesson.id_group = "group".id_group
         LEFT JOIN mark ON mark.id_student = student.id_student AND mark.id_lesson = lesson.id_lesson
         INNER JOIN subject ON subject.id_subject = lesson.id_subject
WHERE "group".name = identifier
GROUP BY student.name, subject.name
HAVING COUNT(mark.mark) = 0
ORDER BY student.name
$$;


SELECT *
FROM debtor_info('��');
SELECT *
FROM debtor_info('���');
SELECT *
FROM debtor_info('��');
SELECT *
FROM debtor_info('��');

-- 4. ���� ������� ������ ��������� �� ������� �������� ��� ��� ���������, ��
--    ������� ���������� �� ����� 35 ���������.

SELECT subject.name, AVG(mark.mark) AS Avg_mark
FROM mark
	LEFT JOIN lesson ON mark.id_lesson = lesson.id_lesson
	LEFT JOIN subject ON lesson.id_subject = subject.id_subject
	LEFT JOIN student ON mark.id_student = student.id_student
GROUP BY subject.name
HAVING (COUNT(DISTINCT student.id_student) >= 35)

-- 5. ���� ������ ��������� ������������� �� �� ���� ���������� ��������� �
--    ��������� ������, �������, ��������, ����. ��� ���������� ������ ���������
--    ���������� NULL ���� ������.

SELECT "group".name, student.name, subject.name, lesson.date, mark.mark
FROM student
         LEFT JOIN "group" ON student.id_group = "group".id_group
         LEFT JOIN lesson ON lesson.id_group = "group".id_group
         LEFT JOIN subject ON lesson.id_subject = subject.id_subject
         LEFT JOIN mark ON (lesson.id_lesson = mark.id_lesson AND student.id_student = mark.id_student)
WHERE "group".name = '��'

-- 6. ���� ��������� ������������� ��, ���������� ������ ������� 5 �� ��������
-- �� �� 12.05, �������� ��� ������ �� 1 ����.

UPDATE mark
SET mark = (mark + 1)
WHERE mark.id_student IN (
    SELECT student.id_student
    FROM student
             LEFT JOIN "group" ON student.id_group = "group".id_group
    WHERE "group".name = '��')
  AND mark.id_lesson IN (
    SELECT lesson.id_lesson
    FROM lesson
             LEFT JOIN "group" ON "group".id_group = lesson.id_group
             LEFT JOIN student ON "group".id_group = student.id_group
             LEFT JOIN subject ON lesson.id_subject = subject.id_subject
             LEFT JOIN mark ON (mark.id_student = student.id_student AND mark.id_lesson = lesson.id_lesson)
    WHERE lesson.date < CAST('2019-05-12' AS date)
      AND subject.name = '��'
)
  AND mark.mark < 5

-- 7. �������� ����������� �������.
create index group_name_index
	on "group" (name);

create index lesson_id_group_index
	on lesson (id_group);

create index lesson_id_subject_index
	on lesson (id_subject);

create index lesson_id_teacher_index
	on lesson (id_teacher);

create index mark_id_lesson_index
	on mark (id_lesson);

create index mark_id_student_index
	on mark (id_student);

create index mark_mark_index
	on mark (mark);
	
create index student_id_group_index
	on student (id_group);

create index student_name_index
	on student (name);

create index subject_name_index
	on subject (name);

create index teacher_name_index
	on teacher (name);