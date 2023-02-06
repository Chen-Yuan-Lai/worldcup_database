#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # get team name
  TEAM1=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
  # get team name
  TEAM2=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")

  #if winner not found or is header
  if [[ -z $TEAM1 && $WINNER != "winner" ]]
  then
    # insert team
    INSERT_TEAM1_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    echo $INSERT_TEAM1_RESULT
  fi
  #if opponent not found or is header
  if [[ -z $TEAM2 && $OPPONENT != "opponent" ]]
  then
    #insert team
    INSERT_TEAM1_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    echo $INSERT_TEAM2_RESULT
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # find winner_id and opponent_id in teams
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
                                                VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi

done

    