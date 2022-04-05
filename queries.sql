-- Queries that provide answers to the questions FROM all projects.

SELECT * FROM animals WHERE name LIKE '%mon%';
SELECT name FROM animals WHERE date_of_birth BETWEEN DATE '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = TRUE AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = TRUE;
SELECT * FROM animals WHERE name <> 'Gabumon';
SELECT * FROM animals WHERE weight_kg >= 7.3 AND weight_kg <= 10.4;

-- Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that species columns went back to the state before transaction.
BEGIN;
UPDATE animals
SET species = 'unspecified';
SELECT species FROM animals;
ROLLBACK;
SELECT species FROM animals;

--Inside a transaction Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
-- Update the animals table by setting the species column to pokemon for all animals that dont have species already set.
BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon%';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
-- Commit the transaction.
COMMIT;

-- Inside a transaction delete all records in the animals table, then roll back the transaction.
-- After the roll back verify if all records in the animals table still exist. After that you can start breath as usual;

BEGIN;
DELETE FROM animals;
BEGIN;
DELETE FROM animals;
ROLLBACK;
SELECT * FROM animals;

-- Inside a transaction:
-- Delete all animals born after Jan 1st, 2022.
BEGIN WORK;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
    
-- Create a savepoint for the transaction.
SAVEPOINT DELETE_DOB;

-- Update all animals' weight to be their weight multiplied by -1.
UPDATE animals SET weight_kg = weight_kg * -1;
-- Rollback to the savepoint
ROLLBACK TO DELETE_DOB;    
-- Update all animals' weights that are negative to be their weight multiplied by -1.
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;    
-- Commit transaction
COMMIT;
-- Write queries to answer the following questions:
-- How many animals are there?
SELECT COUNT(*) FROM animals;
-- How many animals have never tried to escape?
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;    
-- What is the average weight of animals?
SELECT ROUND(AVG(weight_kg), 2) from animals;
-- Who escapes the most, neutered or not neutered animals?
SELECT name, escape_attempts from animals WHERE escape_attempts = (SELECT MAX(escape_attempts) from animals);
-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg), MAX(weight_kg) from animals GROUP BY species;
-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, ROUND(AVG(escape_attempts), 2) from animals WHERE date_of_birth BETWEEN DATE '1990-01-01' AND '2000-12-31' GROUP BY species;

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

-- Write queries to answer the following:
-- Who was the last animal seen by William Tatcher?
SELECT animals.name, vets.name FROM vets JOIN visits ON vets.id = visits.vets_id JOIN animals ON visits.animals_id = animals.id WHERE vets.name = 'William Tatcher' ORDER BY visits.date_of_visit DESC LIMIT 1;
-- How many different animals did Stephanie Mendez see?
SELECT vets.name, COUNT(animals.name) AS number_of_animals_visited from vets JOIN visits ON vets.id = visits.vets_id JOIN animals ON visits.animals_id = animals.id WHERE vets.name = 'Stephanie Mendez' GROUP BY vets.name;
-- List all vets and their specialties, including vets with no specialties.
SELECT vets.name, species.name FROM vets LEFT JOIN specializations ON vets.id = specializations.vets_id LEFT JOIN species ON species.id = specializations.species_id; 
-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name AS animal, vets.name AS vet, date_of_visit FROM vets JOIN visits ON vets.id = visits.vets_id JOIN animals ON animals.id = visits.animals_id WHERE date_of_visit BETWEEN DATE '2020-04-01' AND '2020-08-30' AND vets.name = 'Stephanie Mendez';
-- What animal has the most visits to vets?
SELECT animals.name, COUNT(animals.name) AS number_of_visits FROM animals JOIN visits ON animals.id = visits.animals_id GROUP BY animals.name ORDER BY number_of_visits DESC LIMIT 1;
SELECT animals.name as animals, COUNT(*) AS number_of_visits FROM animals JOIN visits ON visits.animals_id = animals.id GROUP BY animals ORDER BY number_of_visits DESC LIMIT 1; 
-- Who was Maisy Smith's first visit?
SELECT vets.name AS vet, date_of_visit, animals.name AS first_visited FROM animals JOIN visits ON visits.animals_id = animals.id JOIN vets ON vets.id = visits.vets_id WHERE vets.name = 'Maisy Smith' ORDER BY date_of_visit ASC LIMIT 1;
-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT date_of_visit,
        animals.id AS animal_id,
        animals.name AS animal_name,
        animals.date_of_birth,
        animals.escape_attempts,
        animals.neutered,
        animals.weight_kg AS animal_weight_kg,
        vets.id AS vet_id,
        vets.name AS vet_name,
        vets.age AS vet_age,
        vets.date_of_graduation AS vet_date_of_graduation
FROM animals 
JOIN visits ON visits.animals_id = animals.id
JOIN vets ON vets.id = visits.vets_id 
WHERE vets.name = 'Maisy Smith' 
ORDER BY date_of_visit 
DESC
LIMIT 1;
-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*)
FROM visits
JOIN animals ON animals.id = visits.animals_id
JOIN vets ON vets.id = visits.vets_id
JOIN specializations ON specializations.vets_id = visits.vets_id
WHERE animals.species_id != specializations.species_id;

-- What specialty shoudl Maisy Smith consider getting? Look for the species she gets the most.
SELECT species.name as species, COUNT(*) from visits
join vets ON vets.id = visits.vets_id
JOIN animals ON animals.id = visits.animals_id
JOIN species ON species.id = animals.species_id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.name;

-- Check query speed
EXPLAIN ANALYZE SELECT COUNT(*) FROM visits where animal_id = 4;
EXPLAIN ANALYZE SELECT * FROM visits where vet_id = 2;
EXPLAIN ANALYZE SELECT * FROM owners where email = 'owner_18327@mail.com';
