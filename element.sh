#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only --no-align -c"


# Look for an argument
if [[ ! $1 ]]
then
  echo Please provide an element as an argument.
else
  # Check to see if argument is an integer
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
    if [[ -z $ATOMIC_NUMBER ]]
    then 
      echo "I could not find that element in the database."
    else
      PERIODIC_TABLE_RESULT=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type FROM properties FULL JOIN elements USING (atomic_number) FULL JOIN types USING (type_id) WHERE atomic_number = $1")
      echo "$PERIODIC_TABLE_RESULT" | while IFS="|" read ATOMIC_MASS MELTING_POINT BOILING_POINT SYMBOL NAME TYPE
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi

  # Finding Atomic Symbol 
  elif [[ $1 =~ ^.{2}$  ]] || [[ $1 =~ ^.{1}$ ]]
  then
    ATOMIC_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1'")
    if [[ -z $ATOMIC_SYMBOL ]]
    then
      echo "I could not find that element in the database."
    else
      PERIODIC_TABLE_RESULT=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, atomic_number, name, type FROM properties FULL JOIN elements USING (atomic_number) FULL JOIN types USING (type_id) WHERE symbol = '$1'")
      echo "$PERIODIC_TABLE_RESULT" | while IFS="|" read ATOMIC_MASS MELTING_POINT BOILING_POINT NUMBER NAME TYPE
      do
        echo "The element with atomic number $NUMBER is $NAME ($ATOMIC_SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi

  # Finding Atomic Name
  elif [[ $1 =~ ^[a-zA-Z]+$ ]]
  then
    ATOMIC_NAME=$($PSQL "SELECT name FROM elements WHERE name = '$1'")
    if [[ -z $ATOMIC_NAME ]]
    then
      echo "I could not find that element in the database."
    else
      PERIODIC_TABLE_RESULT=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, atomic_number, type FROM properties FULL JOIN elements USING (atomic_number) FULL JOIN types USING (type_id) WHERE name = '$1'")
      echo "$PERIODIC_TABLE_RESULT" | while IFS="|" read ATOMIC_MASS MELTING_POINT BOILING_POINT SYMBOL NUMBER TYPE
      do
        echo "The element with atomic number $NUMBER is $ATOMIC_NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ATOMIC_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi

  fi
fi