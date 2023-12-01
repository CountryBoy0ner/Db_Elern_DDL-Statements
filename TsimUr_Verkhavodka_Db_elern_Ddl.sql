CREATE TABLE IF NOT EXISTS mountain (
    mountain_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    height INT NOT NULL CHECK (height > 0) -- Ограничение для положительных значений
);

CREATE TABLE IF NOT EXISTS area (
    mountain_id SERIAL NOT NULL REFERENCES mountain,
    climat VARCHAR(255) NOT NULL,
    city_id SERIAL NOT NULL REFERENCES city,
    CHECK (climat IS NOT NULL AND climat <> ''), -- Ограничение для непустых значений
);

CREATE TABLE IF NOT EXISTS country (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS city (
    city_id SERIAL PRIMARY KEY,
    city_name VARCHAR(255) NOT NULL,
    country_id SERIAL NOT NULL REFERENCES country,
    UNIQUE (city_name, country_id) -- Ограничение на уникальные комбинации
);

CREATE TABLE IF NOT EXISTS climber (
    climber_id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    full_name TEXT GENERATED ALWAYS AS (first_name || ' ' || last_name) STORED NOT NULL
);

CREATE TABLE IF NOT EXISTS guide (
    climber_id SERIAL REFERENCES climber,
    experiences DATE CHECK (experiences > '2000-01-01') -- Ограничение для дат после 1 января 2000 года
);

CREATE TABLE IF NOT EXISTS climbe (
    climbe_id SERIAL PRIMARY KEY,
    mountain_id SERIAL NOT NULL REFERENCES mountain,
    guide SERIAL REFERENCES climber
);

CREATE TABLE IF NOT EXISTS adress (
    climber_id SERIAL REFERENCES climber,
    city_id SERIAL NOT NULL REFERENCES city,
    adress VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS climbe_climber (
    climber_id SERIAL REFERENCES climber,
    climbe_id SERIAL NOT NULL REFERENCES climbe
);

CREATE TABLE IF NOT EXISTS dates (
    climbe_id SERIAL NOT NULL REFERENCES climbe,
    start_date DATE NOT NULL CHECK (start_date > '2000-01-01'), -- Ограничение для дат после 1 января 2000 года
    end_date DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS route (
    climbe_id SERIAL NOT NULL REFERENCES climbe,
    difficulty VARCHAR(255) NOT NULL
);

--One-to-Many

ALTER TABLE city
ADD CONSTRAINT fk_country_id
FOREIGN KEY (country_id)
REFERENCES country(country_id);

ALTER TABLE climbe_climber
ADD CONSTRAINT fk_climbe_id
FOREIGN KEY (climbe_id)
REFERENCES climbe(climbe_id),
ADD CONSTRAINT fk_climber_id
FOREIGN KEY (climber_id)
REFERENCES climber(climber_id);




ALTER TABLE mountain
ADD CONSTRAINT fk_area_id
FOREIGN KEY (mountain_id)
REFERENCES mountain(mountain_id);


ALTER TABLE climbe
ADD CONSTRAINT fk_mountain
FOREIGN KEY (mountain_id)
REFERENCES mountain(mountain_id),
ADD CONSTRAINT fk_guide_id
FOREIGN KEY (guide)
REFERENCES climber(climber_id);


ALTER TABLE dates 
ADD CONSTRAINT fk_climbe_id
FOREIGN KEY (climbe_id)
REFERENCES climbe(climbe_id);

ALTER TABLE route 
ADD CONSTRAINT fk_climbe_id
FOREIGN KEY (climbe_id)
REFERENCES climbe(climbe_id);

ALTER TABLE dates 
ADD CONSTRAINT fk_climbe_id
FOREIGN KEY (climbe_id)
REFERENCES climbe(climbe_id);

ALTER TABLE guide  
ADD CONSTRAINT fk_climbe_id
FOREIGN KEY (climbe_id)
REFERENCES climbe(climbe_id);

ALTER TABLE adress  
ADD CONSTRAINT fk_city_id
FOREIGN KEY (city_id)
REFERENCES city(city_id),
ADD CONSTRAINT fk_climber_id
FOREIGN KEY (climber_id)
REFERENCES climber(climber_id);


ALTER TABLE area 
ADD CONSTRAINT fk_city_id
FOREIGN KEY (city_id)
REFERENCES city(city_id);


-- Insert data into the 'country' table
INSERT INTO country (country_id,country_name) VALUES
(1,'Belarus'),
(2,'France'),
(3,'USA');
select* from country;
DELETE FROM country;

-- Insert data into the 'city' table
INSERT INTO city (city_id,city_name, country_id) VALUES
(1,'Minsk', 1),
(2,'Paris', 2),
(3,'New York', 3);
select* from city;

delete from city;
-- Insert data into the 'mountain' table
INSERT INTO mountain (mountain_id,name, height) VALUES
(1,'Mount Everest', 8848),
(2,'Mont Blanc', 4808),
(3,'Grand Teton', 4199);


select* from mountain;
DELETE FROM mountain;

-- Insert data into the 'area' table
INSERT INTO area (mountain_id, climat, city_id) VALUES
(1, 'Harsh', 1),
(2, 'Temperate', 2),
(3, 'Temperate', 3);
select* from area;

-- Insert data into the 'climber' table
INSERT INTO climber (climber_id,first_name, last_name) VALUES
(1,'John', 'Doe'),
(2,'Jane', 'Smith'),
(3,'Alex', 'Johnson');
select* from climber;

-- Insert data into the 'climbe' table
INSERT INTO climbe (climbe_id,mountain_id, guide) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 1);
select* from climbe;

-- Insert data into the 'guide' table
INSERT INTO guide (climber_id, experiences) VALUES
(1, '2023-01-01'),
(2, '2023-02-01'),
(3, '2023-03-01');
select* from guide;

-- Insert data into the 'adress' table
INSERT INTO adress (climber_id, city_id, adress) VALUES
(1, 1, 'Address1'),
(2, 2, 'Address2'),
(3, 3, 'Address3');

select* from adress;
delete from adress;
-- Insert data into the 'climbe_climber' table
INSERT INTO climbe_climber (climber_id, climbe_id) VALUES
(1, 1),
(2, 2),
(3, 3);
select* from climbe_climber;


-- Insert data into the 'dates' table
INSERT INTO dates (climbe_id, start_date, end_date) VALUES
(1, '2023-03-01', '2023-03-10'),
(2, '2023-04-01', '2023-04-15'),
(3, '2023-05-01', '2023-05-10');
select* from dates;

-- Insert data into the 'route' table
INSERT INTO route (climbe_id, difficulty) VALUES
(1, 'Difficult1'),
(2, 'Difficult2'),
(3, 'Easy');
select* from route;




--CONSTRAINT fk_Country
--        FOREIGN KEY(CountryID)
--            REFERENCES Countries(CountryID)


-- Добавить поле "record_ts" в таблицу mountain
ALTER TABLE mountain
ADD COLUMN record_ts DATE DEFAULT current_date;

-- Проверить, установлено ли значение по умолчанию для существующих строк
UPDATE mountain
SET record_ts = current_date
WHERE record_ts IS NULL;
select* from mountain;

-- Повторите тот же процесс для остальных таблиц
-- Таблица area
ALTER TABLE area
ADD COLUMN record_ts DATE DEFAULT current_date;

UPDATE area
SET record_ts = current_date
WHERE record_ts IS NULL;
select* from area;

-- Таблица country
ALTER TABLE country
ADD COLUMN record_ts DATE DEFAULT current_date;

UPDATE country
SET record_ts = current_date
WHERE record_ts IS NULL;
select* from country;

-- Таблица city
ALTER TABLE city
ADD COLUMN record_ts DATE DEFAULT current_date;

UPDATE city
SET record_ts = current_date
WHERE record_ts IS NULL;
select* from city;

-- Таблица climber
ALTER TABLE climber
ADD COLUMN record_ts DATE DEFAULT current_date;

UPDATE climber
SET record_ts = current_date
WHERE record_ts IS NULL;
select* from climber;

-- Таблица guide
ALTER TABLE guide
ADD COLUMN record_ts DATE DEFAULT current_date;

UPDATE guide
SET record_ts = current_date
WHERE record_ts IS NULL;
select* from guide;


-- Таблица climbe
ALTER TABLE climbe
ADD COLUMN record_ts DATE DEFAULT current_date;

UPDATE climbe
SET record_ts = current_date
WHERE record_ts IS NULL;
select* from climbe;

-- Таблица adress
ALTER TABLE adress
ADD COLUMN record_ts DATE DEFAULT current_date;

UPDATE adress
SET record_ts = current_date
WHERE record_ts IS NULL;
select* from adress;

-- Таблица climbe_climber
ALTER TABLE climbe_climber
ADD COLUMN record_ts DATE DEFAULT current_date;

UPDATE climbe_climber
SET record_ts = current_date
WHERE record_ts IS NULL;
select* from climbe_climber;

-- Таблица dates
ALTER TABLE dates
ADD COLUMN record_ts DATE DEFAULT current_date;

UPDATE dates
SET record_ts = current_date
WHERE record_ts IS NULL;
select* from dates;

-- Таблица route
ALTER TABLE route
ADD COLUMN record_ts DATE DEFAULT current_date;

UPDATE route
SET record_ts = current_date
WHERE record_ts IS NULL;

select* from route;


