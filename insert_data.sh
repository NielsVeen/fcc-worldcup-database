#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

($PSQL "TRUNCATE TABLE games, teams")

# Do not change code above this line. Use the PSQL variable above to query your database.

while IFS=',' read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # SKIP FIRST ROW
  if [ "$WINNER" != "winner" ]
  then
    # CHECK IF THE WINNER EXISTS
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    # IF NOT WINNER EXISTS, INSERT
    if [ -z $WINNER_ID ]
    then
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
    
    # CHECK IF THE OPPONENT EXISTS
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # IF NOT OPPONENT EXISTS, INSERT
    if [ -z $OPPONENT_ID ]
    then
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(
      year,round,winner_id,opponent_id,winner_goals,opponent_goals) 
      VALUES(
        $YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS
        )")
  fi
  # 
done < games.csv