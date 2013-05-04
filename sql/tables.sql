CREATE TABLE author
(
  id serial PRIMARY KEY,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  last_update timestamp without time zone NOT NULL DEFAULT now()
)


CREATE TABLE users
(
  id serial PRIMARY KEY,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  email VARCHAR(255) NOT NULL,
  last_update timestamp without time zone NOT NULL DEFAULT now()
)
