/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id INT GENERATED BY DEFAULT AS IDENTITY,
     name VARCHAR(100),
     date_of_birth DATE,
     escape_attempts INT,
     neutered BOOLEAN,
     weight_kg DECIMAL,
     PRIMARY KEY(id)
);

/* Add a species column of type string */
ALTER TABLE animals 
ADD COLUMN species VARCHAR(100);

-- Create a table named owners with the following columns:
-- id: integer (set it as autoincremented PRIMARY KEY), full_name: string, age: integer
CREATE TABLE owners(
  id INTEGER GENERATED BY DEFAULT AS IDENTITY,
  full_name VARCHAR(100) NOT NULL,
  age INTEGER,
  PRIMARY KEY(id)
);

-- Create a table named species with the following columns:
-- id: integer (set it as autoincremented PRIMARY KEY), name: string
CREATE TABLE species(
  id INTEGER GENERATED BY DEFAULT AS IDENTITY,
  name VARCHAR(100) NOT NULL,
  PRIMARY KEY(id)
);

-- Modify animals table:
-- Make sure that id is set as autoincremented PRIMARY KEY
ALTER TABLE animals
ALTER COLUMN id 
ADD GENERATED BY DEFAULT AS IDENTITY;

-- Remove column species
ALTER TABLE animals
DROP COLUMN species;

-- Add column species_id which is a foreign key referencing species table
ALTER TABLE animals
ADD COLUMN species_id INT REFERENCES species(id);

-- Add column owner_id which is a foreign key referencing the owners table
ALTER TABLE animals
ADD COLUMN owner_id INT REFERENCES owners(id);
