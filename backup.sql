-- Adminer 5.2.1 PostgreSQL 17.4 dump

DROP TYPE IF EXISTS "institution_type";
CREATE TYPE "institution_type" AS ENUM ('School', 'Kindergarten');

DROP TYPE IF EXISTS "institution_direction";
CREATE TYPE "institution_direction" AS ENUM ('Mathematics', 'Biology and Chemistry', 'Language Studies');

DROP TABLE IF EXISTS "children";
DROP SEQUENCE IF EXISTS children_child_id_seq;
CREATE SEQUENCE children_child_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 14 CACHE 1;

CREATE TABLE "public"."children" (
    "child_id" integer DEFAULT nextval('children_child_id_seq') NOT NULL,
    "first_name" character varying(50) NOT NULL,
    "last_name" character varying(50) NOT NULL,
    "birth_date" date NOT NULL,
    "year_of_entry" date,
    "age" integer,
    "class_id" integer NOT NULL,
    "institution_id" integer NOT NULL,
    CONSTRAINT "children_pkey" PRIMARY KEY ("child_id")
) WITH (oids = false);

INSERT INTO "children" ("child_id", "first_name", "last_name", "birth_date", "year_of_entry", "age", "class_id", "institution_id") VALUES
(1,	'Alice',	'Johnson',	'2010-05-14',	'2021-09-01',	14,	1,	1),
(2,	'Liam',	'Smith',	'2009-08-22',	'2020-09-01',	15,	2,	1),
(3,	'Emma',	'Brown',	'2011-02-11',	'2022-09-01',	13,	3,	2),
(4,	'Noah',	'Davis',	'2008-11-30',	'2019-09-01',	16,	4,	2),
(5,	'Olivia',	'Wilson',	'2012-07-07',	'2023-09-01',	12,	5,	2),
(6,	'William',	'Anderson',	'2009-01-20',	'2020-09-01',	15,	6,	3),
(7,	'Sophia',	'Thomas',	'2010-09-18',	'2021-09-01',	14,	7,	3),
(8,	'James',	'Moore',	'2011-12-12',	'2022-09-01',	13,	8,	3),
(9,	'Mia',	'Taylor',	'2012-03-23',	'2023-09-01',	12,	9,	4),
(10,	'Benjamin',	'Lee',	'2010-10-10',	'2021-09-01',	14,	10,	4),
(11,	'Charlotte',	'Martinez',	'2011-04-16',	'2022-09-01',	13,	11,	5),
(12,	'Daniel',	'White',	'2010-06-30',	'2021-09-01',	14,	12,	5),
(13,	'Ella',	'Walker',	'2011-08-08',	'2022-09-01',	13,	13,	5);

DROP TABLE IF EXISTS "classes";
DROP SEQUENCE IF EXISTS classes_class_id_seq;
CREATE SEQUENCE classes_class_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 14 CACHE 1;

CREATE TABLE "public"."classes" (
    "class_id" integer DEFAULT nextval('classes_class_id_seq') NOT NULL,
    "class_name" character varying(100) NOT NULL,
    "institution_id" integer NOT NULL,
    "institution_direction" institution_direction NOT NULL,
    CONSTRAINT "classes_pkey" PRIMARY KEY ("class_id")
) WITH (oids = false);

INSERT INTO "classes" ("class_id", "class_name", "institution_id", "institution_direction") VALUES
(1,	'Linear Algebra and Applications',	1,	'Mathematics'),
(2,	'Molecular Biology Techniques',	1,	'Biology and Chemistry'),
(3,	'Advanced Calculus',	2,	'Mathematics'),
(4,	'Organic Chemistry Lab',	2,	'Biology and Chemistry'),
(5,	'French Language and Literature',	2,	'Language Studies'),
(6,	'Statistics and Probability',	3,	'Mathematics'),
(7,	'Genetics and Evolution',	3,	'Biology and Chemistry'),
(8,	'German for Beginners',	3,	'Language Studies'),
(9,	'Everyday Math for Adults',	4,	'Mathematics'),
(10,	'Basic Spanish Conversation',	4,	'Language Studies'),
(11,	'High School Chemistry',	5,	'Biology and Chemistry'),
(12,	'English Composition',	5,	'Language Studies'),
(13,	'Geometry Fundamentals',	5,	'Mathematics');

DROP TABLE IF EXISTS "institutions";
DROP SEQUENCE IF EXISTS institutions_institution_id_seq;
CREATE SEQUENCE institutions_institution_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 6 CACHE 1;

CREATE TABLE "public"."institutions" (
    "institution_id" integer DEFAULT nextval('institutions_institution_id_seq') NOT NULL,
    "institution_name" character varying(100) NOT NULL,
    "institution_type" institution_type NOT NULL,
    "address" character varying(255) NOT NULL,
    CONSTRAINT "institutions_pkey" PRIMARY KEY ("institution_id")
) WITH (oids = false);

INSERT INTO "institutions" ("institution_id", "institution_name", "institution_type", "address") VALUES
(1,	'Massachusetts Institute of Technology',	'School',	'77 Massachusetts Ave, Cambridge, MA 02139, United States'),
(2,	'Harvard University',	'Kindergarten',	'Cambridge, MA 02138, United States'),
(3,	'Stanford University',	'School',	'450 Serra Mall, Stanford, CA 94305, United States'),
(4,	'New York Public Library',	'School',	'476 5th Ave, New York, NY 10018, United States'),
(5,	'Boston Public High School',	'Kindergarten',	'1010 Commonwealth Avenue, Boston, MA 02215, United States');

DROP TABLE IF EXISTS "parent";
DROP SEQUENCE IF EXISTS parent_parent_id_seq;
CREATE SEQUENCE parent_parent_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 11 CACHE 1;

CREATE TABLE "public"."parent" (
    "parent_id" integer DEFAULT nextval('parent_parent_id_seq') NOT NULL,
    "first_name" character varying(50) NOT NULL,
    "last_name" character varying(50) NOT NULL,
    "child_id" integer NOT NULL,
    "tuition_fee" real,
    CONSTRAINT "parent_pkey" PRIMARY KEY ("parent_id")
) WITH (oids = false);

INSERT INTO "parent" ("parent_id", "first_name", "last_name", "child_id", "tuition_fee") VALUES
(1,	'Michael',	'Johnson',	1,	5000),
(2,	'Sarah',	'Smith',	2,	5200),
(3,	'David',	'Brown',	3,	4900),
(4,	'Emily',	'Davis',	4,	5300),
(5,	'John',	'Wilson',	5,	5100),
(6,	'Laura',	'Anderson',	6,	5050),
(7,	'Mark',	'Thomas',	7,	4950),
(8,	'Rachel',	'Moore',	8,	4700),
(9,	'Brian',	'Taylor',	9,	4600),
(10,	'Anna',	'Lee',	10,	4800);

ALTER TABLE ONLY "public"."children" ADD CONSTRAINT "children_class_id_fkey" FOREIGN KEY (class_id) REFERENCES classes(class_id) ON DELETE CASCADE NOT DEFERRABLE;
ALTER TABLE ONLY "public"."children" ADD CONSTRAINT "children_institution_id_fkey" FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE NOT DEFERRABLE;

ALTER TABLE ONLY "public"."classes" ADD CONSTRAINT "classes_institution_id_fkey" FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE NOT DEFERRABLE;

ALTER TABLE ONLY "public"."parent" ADD CONSTRAINT "parent_child_id_fkey" FOREIGN KEY (child_id) REFERENCES children(child_id) ON DELETE CASCADE NOT DEFERRABLE;
