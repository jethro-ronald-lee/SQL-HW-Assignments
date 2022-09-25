USE premierleej;

-- 4) Generate a list of matches for match day 1, in which the home team won. The result should contain match number, home team and the away 
-- team name. 
SELECT match_num, team_1, team_2 FROM soccer_match
	WHERE full_time_score_team_1 > full_time_score_team_2 
		AND match_day = 1;
    
-- 5) Which teams had more than one manager in the season? The result should contain team name and the number of managers. 
SELECT team, COUNT(team) AS manager_count FROM manager
	GROUP BY team
		HAVING manager_count > 1;

-- 6) Which manager/managers worked for more than one team? The result should contain manager name and number of teams.
SELECT manager, COUNT(manager) AS team_count FROM manager
	GROUP BY manager
		HAVING team_count > 1;

-- 7) Generate a list of managers, teams and the number of goals scored by the team in the home stadium for each team for the season. 
-- Consider only the active managers. The list should be in descending order of number of goals. The result should contain the manager’s 
-- name, the team name, and the number of goals. 
SELECT manager, team, SUM(full_time_score_team_1) FROM manager
	INNER JOIN soccer_match ON team = team_1 
		WHERE status = "Active"
			GROUP BY manager, team
				ORDER BY SUM(full_time_score_team_1) DESC;

-- 8) Generate a list consisting of a manager’s name, total number of matches won by the manager in the season. The list should be in 
-- descending order of number of matches. Consider only the active managers. 

SELECT m1 AS manager, SUM(c1 + c2) AS matches_won FROM 
(SELECT manager AS m1, COUNT(manager) AS c1 FROM manager
	INNER JOIN soccer_match ON team = team_1
		WHERE full_time_score_team_1 > full_time_score_team_2 AND status = "Active"
			GROUP BY m1) AS home_manager_1
LEFT JOIN
(SELECT manager AS m2, COUNT(manager) AS c2 FROM manager
	INNER JOIN soccer_match ON team = team_2
		WHERE full_time_score_team_2 > full_time_score_team_1 AND status = "Active"
			GROUP BY m2) AS away_manager_1
ON m1 = m2
GROUP BY m1
UNION 
SELECT m1 AS manager, SUM(c1 + c2) AS matches_won FROM 
(SELECT manager AS m1, COUNT(manager) AS c1 FROM manager
	INNER JOIN soccer_match ON team = team_1
		WHERE full_time_score_team_1 > full_time_score_team_2 AND status = "Active"
			GROUP BY m1) AS home_manager_2
RIGHT JOIN 
(SELECT manager AS m2, COUNT(manager) AS c2 FROM manager
	INNER JOIN soccer_match ON team = team_2
		WHERE full_time_score_team_2 > full_time_score_team_1 AND status = "Active"
			GROUP BY m2) AS away_manager_2
ON m1 = m2
GROUP BY m1
ORDER BY matches_won DESC;
        
-- 9) Determine the stadium, where the most number of goals were scored. The result should only contain the stadium name.
SELECT venue FROM 
	(SELECT venue, SUM(full_time_score_team_1 + full_time_score_team_2) AS total_goals_scored FROM stadium 
		INNER JOIN soccer_match
			ON team = team_1
				GROUP BY venue
					ORDER BY total_goals_scored DESC
						LIMIT 1) AS top_stadium_stats;

-- 10) Determine the number of matches ended as a draw per team. The result should contain the team name and the number of matches.
SELECT team, COUNT(*) FROM soccer_match INNER JOIN stadium
	ON team = team_1 OR team = team_2
		WHERE full_time_score_team_1 = full_time_score_team_2
			GROUP BY team;

-- 11) Clean sheets means that the team did not allow an opponent to score a goal in the match. Determine the top 5 teams ranked by number of 
-- clean sheets in the season. The result should contain the team’s name and the count of the clean sheets. The result should be ordered in 
-- descending order by the count of clean sheets. 

SELECT team_1, SUM(clean_sheet_count_1 + clean_sheet_count_2) AS clean_sheet_count FROM 
(SELECT team_1, COUNT(*) AS clean_sheet_count_1 FROM soccer_match
	WHERE full_time_score_team_2 = 0  
		GROUP BY team_1) AS home1 LEFT JOIN 
(SELECT team_2, COUNT(*) AS clean_sheet_count_2 FROM soccer_match  
	WHERE full_time_score_team_1 = 0  
		GROUP BY team_2) AS away2 ON team_1 = team_2 GROUP BY team_1
UNION 
SELECT team_1, SUM(clean_sheet_count_1 + clean_sheet_count_2) FROM 
(SELECT team_1, COUNT(*) AS clean_sheet_count_1 FROM soccer_match
	WHERE full_time_score_team_2 = 0  
		GROUP BY team_1) AS home1
RIGHT JOIN
(SELECT team_2, COUNT(*) AS clean_sheet_count_2 FROM soccer_match  
	WHERE full_time_score_team_1 = 0  
		GROUP BY team_2) AS home2
ON team_1 = team_2 GROUP BY team_1
ORDER BY clean_sheet_count DESC
LIMIT 5;

-- 12) Generate a list of matches played between Christmas and 3rd January where the home team scored 3 or more goals. Consider the date range 
-- 25th December to 3rd January(Including). Display all the fields for the match. 
SELECT * FROM soccer_match
	WHERE date BETWEEN "2017-12-25" AND "2018-01-03"
     AND full_time_score_team_1 >= 3;
SELECT * FROM soccer_match;

-- 13) Generate the list of all the matches, where a team came back from losing the game at the end of the first half of the game, to winning 
-- at the end of the second half. The result should contain all the columns in the match tuple. 
SELECT * FROM soccer_match
	WHERE ((half_time_score_team_1 > half_time_score_team_2) AND full_time_score_team_2 > full_time_score_team_1)
		OR ((half_time_score_team_2 > half_time_score_team_1) AND full_time_score_team_1 > full_time_score_team_2);

-- 14) Determine the top 5 teams by the number of matches won by the teams. The result should just contain team names.

SELECT team_1 FROM
(SELECT team_1, SUM(home_wins + away_wins) AS wins FROM 
(SELECT team_1, COUNT(team_1) AS home_wins FROM soccer_match
	WHERE full_time_score_team_1 > full_time_score_team_2  
		GROUP BY team_1) AS home_team_stats_1
LEFT JOIN
(SELECT team_2, COUNT(team_2) AS away_wins FROM soccer_match  
	WHERE full_time_score_team_2 > full_time_score_team_1
		GROUP BY team_2) AS away_team_stats_1
ON team_1 = team_2
GROUP BY team_1
UNION 
SELECT team_1, SUM(home_wins + away_wins) AS wins FROM 
(SELECT team_1, COUNT(team_1) AS home_wins FROM soccer_match
	WHERE full_time_score_team_1 > full_time_score_team_2  
		GROUP BY team_1) AS home_team_stats_2
RIGHT JOIN 
(SELECT team_2, COUNT(team_2) AS away_wins FROM soccer_match  
	WHERE full_time_score_team_2 > full_time_score_team_1
		GROUP BY team_2) AS away_team_stats_2
ON team_1 = team_2
GROUP BY team_1
ORDER BY wins DESC) AS win_stats
LIMIT 5;

-- 15) What is the average number of goals scored and conceded in home games for each team? What is the average number of goals scored and 
-- conceded in away games for each team? The results should contain the team name, the average number of goals scored while home, the average  
-- number of goals conceded while home, the average number of goals scored while away, and the average number of goals conceded while away. 

SELECT team_1 AS team_name, avg_num_of_goals_scored_while_home, avg_num_of_goals_conceded_while_home, avg_num_of_goals_scored_while_away, 
	avg_num_of_goals_conceded_while_away FROM 
(SELECT team_1, AVG(full_time_score_team_1) AS avg_num_of_goals_scored_while_home, AVG(full_time_score_team_2) AS 
	avg_num_of_goals_conceded_while_home FROM soccer_match
	GROUP BY team_1) AS home_stats_1
LEFT JOIN
(SELECT team_2, AVG(full_time_score_team_1) AS avg_num_of_goals_conceded_while_away, AVG(full_time_score_team_2) AS 
	avg_num_of_goals_scored_while_away FROM soccer_match
	GROUP BY team_2) AS away_stats_1
ON team_1 = team_2
GROUP BY team_1
UNION 
SELECT team_1, avg_num_of_goals_scored_while_home, avg_num_of_goals_conceded_while_home, avg_num_of_goals_scored_while_away, 
	avg_num_of_goals_conceded_while_away  FROM 
(SELECT team_1, AVG(full_time_score_team_1) AS avg_num_of_goals_scored_while_home, AVG(full_time_score_team_2) AS 
	avg_num_of_goals_conceded_while_home FROM soccer_match
	GROUP BY team_1) AS home_stats_2
RIGHT JOIN 
(SELECT team_2, AVG(full_time_score_team_1) AS avg_num_of_goals_conceded_while_away, AVG(full_time_score_team_2) AS 
	avg_num_of_goals_scored_while_away FROM soccer_match
	GROUP BY team_2) AS away_stats_2
ON team_1 = team_2;






