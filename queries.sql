/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon%';
SELECT name FROM animals WHERE date_of_birth BETWEEN DATE '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = TRUE AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = TRUE;
SELECT * FROM animals WHERE name <> 'Gabumon';
SELECT * FROM animals WHERE weight_kg >= 7.3 AND weight_kg <= 10.4;

-- What animals belong to Melody Pond?
SELECT name FROM animals JOIN owners ON animals.owner_id = owners.id WHERE full_name = 'Melody Pond';
-- List of all animals that are pokemon (their type is Pokemon).
SELECT name FROM animals JOIN species ON animals.species_id = species.id WHERE species.name = 'Pokemon';
-- List all owners and their animals, remember to include those that don't own any animal.
SELECT full_name AS owners, name AS animals FROM animals RIGHT JOIN owners ON animals.owner_id = owners.id; 
-- How many animals are there per species?
SELECT species.name AS Species, COUNT(*) FROM animals JOIN species ON animals.species_id = species.id GROUP BY species.name;
-- List all Digimon owned by Jennifer Orwell.
SELECT animals.name AS digimon, owners.full_name AS owner FROM animals JOIN species ON animals.species_id = species.id JOIN owners on owners.id = animals.owner_id WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell'; 
-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT name AS animals, full_name AS owner, escape_attempts FROM animals JOIN owners ON animals.owner_id = owners.id WHERE escape_attempts = 0 AND owners.full_name = 'Dean Winchester';
-- Who owns the most animals?
SELECT full_name As owner, COUNT(animals) from animals JOIN owners ON animals.owner_id = owners.id GROUP BY full_name ORDER BY COUNT(animals) DESC;
