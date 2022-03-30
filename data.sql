/* Populate database with sample data. */

INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Agumon', date '2020-02-03', 10.23, TRUE, 0);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Gabumon', date '2018-11-15', 8, TRUE, 2);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Pikachu', date '2021-01-7', 15.04, FALSE, 1);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Devimon', date '2017-05-12', 11, TRUE, 5);

/* Second batch insertion */
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Plantmon', date '2021-11-15', -5.7, TRUE, 2);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Squirtle', date '1993-04-2', -12.13, FALSE, 3);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Angemon', date '2005-06-12', -45, TRUE, 1);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Boarmon', date '2005-06-7', 20.4, TRUE, 7);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Blossom', date '1998-10-13', 17, TRUE, 3);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Ditto', date '2022-05-14', 22, TRUE, 4);

-- Insert Sam Smith 34 years old into owners table
INSERT INTO owners (full_name, age) VALUES ('Sam Smith', 34);
-- Jennifer Orwell 19 years old.
INSERT INTO owners (full_name, age) VALUES ('Jennifer Orwell', 19);
-- Bob 45 years old.
INSERT INTO owners (full_name, age) VALUES ('Bob', 45);
-- Melody Pond 77 years old.
INSERT INTO owners (full_name, age) VALUES ('Melody Pond', 77);
-- Dean Winchester 14 years old.
INSERT INTO owners (full_name, age) VALUES ('Dean Winchester', 14);
-- Jodie Whittaker 38 years old.
INSERT INTO owners (full_name, age) VALUES ('Jodie Whittaker', 38);

-- Insert Pokemon and Digimon into the species table
INSERT INTO species (name)
VALUES ('Pokemon');
VALUES ('Digimon');

-- Modify your inserted animals so it includes the species_id value:
-- If the name ends in "mon" it will be Digimon
UPDATE animals
SET species_id = (SELECT id FROM species WHERE name = 'Digimon')
WHERE name LIKE '%mon';

-- All other animals are Pokemon
UPDATE animals
SET species_id = (SELECT id FROM species WHERE name = 'Pokemon')
WHERE name NOT LIKE '%mon';

-- Modify your inserted animals to include owner information (owner_id):

-- Sam Smith owns Agumon.
UPDATE animals
SET owner_id = (SELECT id FROM owners WHERE full_name = 'Sam Smith') 
WHERE name = 'Agumon';   

-- Jennifer Orwell owns Gabumon and Pikachu.
UPDATE animals
SET owner_id = (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell')
WHERE name IN ('Gabumon', 'Pikachu');
-- Bob owns Devimon and Plantmon.
UPDATE animals
SET owner_id = (SELECT id from owners WHERE full_name = 'Bob')
WHERE name IN ('Devimon', 'Plantmon');  

-- Melody Pond owns Charmander, Squirtle, and Blossom.
UPDATE animals
SET owner_id = (SELECT id FROM owners WHERE full_name = 'Melody Pond')
WHERE name IN ('Charmander', 'Squirtle', 'Blossom');

-- Dean Winchester owns Angemon and Boarmon.
UPDATE animals
SET owner_id = (SELECT id FROM owners WHERE full_name = 'Dean Winchester')
WHERE name IN ('Angemon', 'Boarmon');

-- Insert the following data for vets:
-- Vet William Tatcher is 45 years old and graduated Apr 23rd, 2000.
INSERT INTO vets(name, age, date_of_graduation)
VALUES ('William Tatcher', 45, date '2000-04-23');
-- Vet Maisy Smith is 26 years old and graduated Jan 17th, 2019.
INSERT INTO vets(name, age, date_of_graduation)
VALUES ('Maisy Smith', 26, date '2019-01-17');
-- Vet Stephanie Mendez is 64 years old and graduated May 4th, 1981.
INSERT INTO vets(name, age, date_of_graduation)
VALUES ('Stephanie Mendez', 64, date '1981-05-04');
-- Vet Jack Harkness is 38 years old and graduated Jun 8th, 2008.
INSERT INTO vets(name, age, date_of_graduation)
VALUES ('Jack Harkness', 38, date '2008-06-08');

-- Insert the following data for specialties:
-- Vet William Tatcher is specialized in Pokemon.
INSERT INTO specializations(species_id, vets_id)
VALUES ((SELECT id FROM species WHERE name = 'Pokemon'), (SELECT id FROM vets WHERE name = 'William Tatcher'));
-- Vet Stephanie Mendez is specialized in Digimon and Pokemon.
INSERT INTO specializations(species_id, vets_id)
VALUES ((SELECT id FROM species WHERE name = 'Digimon'), (SELECT id FROM vets  WHERE name = 'Stephanie Mendez'));
INSERT INTO specializations(species_id, vets_id)
VALUES ((SELECT id FROM species WHERE name = 'Pokemon'), (SELECT id FROM vets  WHERE name = 'Stephanie Mendez'));
-- Vet Jack Harkness is specialized in Digimon.
INSERT INTO specializations(species_id, vets_id)
VALUES((SELECT id FROM species WHERE name = 'Digimon'), (SELECT id FROM vets WHERE name = 'Jack Harkness'));

-- Insert the following data for visits:
INSERT INTO visits(date_of_visit, animals_id, vets_id)
        --   Agumon visited William Tatcher on May 24th, 2020.  
VALUES  (date '2020-05-24', (SELECT id FROM animals WHERE name = 'Agumon'), (SELECT id FROM vets WHERE name = 'William Tatcher')),
        -- Agumon visited Stephanie Mendez on Jul 22th, 2020.
        (date '2020-07-22', (SELECT id FROM animals WHERE name = 'Agumon'), (SELECT id FROM vets WHERE name = 'Stephanie Mendez')),
        -- Gabumon visited Jack Harkness on Feb 2nd, 2021.
        (date '2021-02-02', (SELECT id FROM animals WHERE name = 'Gabumon'), (SELECT id FROM vets WHERE name = 'Jack Harkness')),
        -- Pikachu visited Maisy Smith on Jan 5th, 2020.
        (date '2020-01-05', (SELECT id FROM animals WHERE name = 'Pikachu'), (SELECT id FROM vets WHERE name = 'Maisy Smith')),
        -- Pikachu visited Maisy Smith on Mar 8th, 2020.
        (date '2020-03-08', (SELECT id FROM animals WHERE name = 'Pikachu'), (SELECT id FROM vets WHERE name = 'Maisy Smith')),
        -- Pikachu visited Maisy Smith on May 14th, 2020.
        (date '2020-05-14', (SELECT id FROM animals WHERE name = 'Pikachu'), (SELECT id FROM vets WHERE name = 'Maisy Smith')),
        -- Devimon visited Stephanie Mendez on May 4th, 2021.
        (date '2021-05-04', (SELECT id FROM animals WHERE name = 'Devimon'), (SELECT id FROM vets WHERE name = 'Stephanie Mendez')),
        -- Charmander visited Jack Harkness on Feb 24th, 2021.
        (date '2021-02-24', (SELECT id FROM animals WHERE name = 'Charmander'), (SELECT id FROM vets WHERE name = 'Jack Harkness')),
        -- Plantmon visited Maisy Smith on Dec 21st, 2019.
        (date '2019-12-21', (SELECT id FROM animals WHERE name = 'Plantmon'), (SELECT id FROM vets WHERE name = 'Maisy Smith')),
        -- Plantmon visited William Tatcher on Aug 10th, 2020.
        (date '2020-08-10', (SELECT id FROM animals WHERE name = 'Plantmon'), (SELECT id FROM vets WHERE name = 'William Tatcher')),
        -- Plantmon visited Maisy Smith on Apr 7th, 2021.
        (date '2021-04-07', (SELECT id FROM animals WHERE name = 'Plantmon'), (SELECT id FROM vets WHERE name = 'Maisy Smith')),
        -- Squirtle visited Stephanie Mendez on Sep 29th, 2019.
        (date '2019-09-29', (SELECT id FROM animals WHERE name = 'Squirtle'), (SELECT id FROM vets WHERE name = 'Stephanie Mendez')),
        -- Angemon visited Jack Harkness on Oct 3rd, 2020.
        (date '2020-10-03', (SELECT id FROM animals WHERE name = 'Angemon'), (SELECT id FROM vets WHERE name = 'Jack Harkness')),
        -- Angemon visited Jack Harkness on Nov 4th, 2020.
        (date '2020-11-04', (SELECT id FROM animals WHERE name = 'Angemon'), (SELECT id FROM vets WHERE name = 'Jack Harkness')),
        -- Boarmon visited Maisy Smith on Jan 24th, 2019.
        (date '2019-01-24', (SELECT id FROM animals WHERE name = 'Boarmon'), (SELECT id FROM vets WHERE name = 'Maisy Smith')),
        -- Boarmon visited Maisy Smith on May 15th, 2019.
        (date '2019-05-15', (SELECT id FROM animals WHERE name = 'Boarmon'), (SELECT id FROM vets WHERE name = 'Maisy Smith')),
        -- Boarmon visited Maisy Smith on Feb 27th, 2020.
        (date '2020-02-27', (SELECT id FROM animals WHERE name = 'Boarmon'), (SELECT id FROM vets WHERE name = 'Maisy Smith')),
        -- Boarmon visited Maisy Smith on Aug 3rd, 2020.
        (date '2020-08-03', (SELECT id FROM animals WHERE name = 'Boarmon'), (SELECT id FROM vets WHERE name = 'Maisy Smith')),
        -- Blossom visited Stephanie Mendez on May 24th, 2020.
        (date '2020-05-24', (SELECT id FROM animals WHERE name = 'Blossom'), (SELECT id FROM vets WHERE name = 'Stephanie Mendez')),
        -- Blossom visited William Tatcher on Jan 11th, 2021.
        (date '2021-01-11', (SELECT id FROM animals WHERE name = 'Blossom'), (SELECT id FROM vets WHERE name = 'William Tatcher'));
