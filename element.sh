#!/bin/bash

if [[ -z "$1" ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

result=$(psql --username=freecodecamp --dbname=periodic_table -t --no-align -c "
SELECT elements.atomic_number, elements.name, elements.symbol, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type
FROM elements
JOIN properties ON elements.atomic_number = properties.atomic_number
JOIN types ON properties.type_id = types.type_id
WHERE elements.atomic_number::text = '$1' OR elements.symbol = '$1' OR elements.name = '$1';")

if [[ -z "$result" ]]; then
  echo "I could not find that element in the database."
else 
  IFS='|' read -r atomic_number name symbol atomic_mass melting_point_celsius boiling_point_celsius type <<< "$result"
  echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
fi
