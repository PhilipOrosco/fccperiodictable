#!/bin/bash 

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
else
  # Check if the argument is a number
  if [[ $1 =~ ^[0-9]+$ ]]; then
    ELEMENT=$($PSQL "SELECT type_id, atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1")
  # Check if the argument is a symbol
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]; then
    ELEMENT=$($PSQL "SELECT type_id, atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1'")
  # Otherwise, treat the argument as a name
  else
    ELEMENT=$($PSQL "SELECT type_id, atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$1'")
  fi

  # Check if element was found
  if [[ -z $ELEMENT ]]; then
    echo "I could not find that element in the database."
  else
    # Read the element details
    echo "$ELEMENT" | while IFS='|' read TYPE_ID ATOMIC_NUMBER SYMBOL NAME MASS MELTING BOILING TYPE; do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
fi