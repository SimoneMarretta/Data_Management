
/*-----1-----*/
						
						
/* Premier League Goal */
/* #We retrieved the total goals each team scored in the Premier League season 2008/2009 */

SELECT home_away_table.team_long_name,SUM(TOTAL)
FROM(SELECT team_long_name,SUM(home_team_goal) AS TOTAL
FROM matches m,team t
WHERE m.home_team_api_id=t.team_api_id AND season='2008/2009' AND country_id=1729
group by m.home_team_api_id
UNION ALL
SELECT team_long_name,SUM(away_team_goal) AS TOTAL
FROM matches m,team t
WHERE m.away_team_api_id=t.team_api_id AND season='2008/2009' AND country_id=1729
group by m.away_team_api_id) AS home_away_table
GROUP BY team_long_name
ORDER BY SUM(TOTAL) DESC

/*---------2--------*/
					    
					    
/* Serie a Rank for the seson 2008/2009 */

/* We want to select the final Rank of the season 2008/2009 we like to visualize also the total number of goal
conceded and the total number of goal scored. */

/* We have to divide this selection in 2 part: the first one is for the points earned in the home field, the second
part is for the points earned away. The two part have the name 'h' and 'a' respectively for 'home' and 'away'.*/

select h.team_long_name,h.punti + a.punti as punti,
h.goal_conceded + a.goal_conceded as goal_conceded,h.goal_scored + a.goal_scored as goal_scored from
(select distinct(t.team_long_name),sum(m.home_team_goal) as goal_scored,sum(m.away_team_goal) as goal_conceded,sum(
case 
	when m.home_team_goal > m.away_team_goal then 3
    when m.home_team_goal < m.away_team_goal then 0
    else 1
end) as punti 
from team t 
join matches m
on m.home_team_api_id = t.team_api_id
WHERE m.COUNTRY_ID = 10257 and m.season = '2008/2009'
group by t.team_long_name
order by goal_scored desc,goal_conceded asc) h

/* group by and order by are not neccessary, but i've used during programming for helping me for visualize how the results.
	inside the case we compare the home team goals with the away team goals, if the home team goals > away team goals so 3 
	points....
*/

join 
(select distinct(t.team_long_name),sum(m.home_team_goal) as goal_scored,sum(m.away_team_goal) as goal_conceded,sum(
case 
	when m.home_team_goal < m.away_team_goal then 3
    when m.home_team_goal > m.away_team_goal then 0
		else 1
end) as punti 
from team t 
join matches m
on m.away_team_api_id = t.team_api_id
WHERE m.COUNTRY_ID = 10257 and m.season = '2008/2009'
group by t.team_long_name
order by goal_scored desc,goal_conceded asc) a
on h.team_long_name = a.team_long_name
order by punti desc;

/* The same thing for the away points and after we join home points with away points to obtain a complete rank. */

/*--------3-------*/

/* HEIGHT-WEIGHT */
/* # We retrieved the player that has the maximum difference between his height and his weight between those players that 
have played as a striker in the season = '2008/2009' */

SELECT DISTINCT player_name,ABS(HEIGHT-WEIGHT)
FROM PLAYER p
WHERE p.player_api_id IN (SELECT home_player_11
FROM MATCHES m
WHERE season = '2008/2009'
GROUP BY home_team_api_id) AND ABS(height-weight)=(SELECT MAX(ABS(HEIGHT-WEIGHT)) AS difference
FROM PLAYER p
WHERE  p.player_api_id IN (SELECT home_player_11
FROM MATCHES m
WHERE season = '2008/2009'
GROUP BY home_team_api_id))
			   
			   
/*-----4------*/

/*Lineup SerieA teams */
select s.team_long_name, j1.player_name as p1,
j2.player_name as p2,
j3.player_name as p3,
j4.player_name as p4,
j5.player_name as p5,
j6.player_name as p6,
j7.player_name as p7,
j8.player_name as p8,
j9.player_name as p9,
j10.player_name as p10,
j11.player_name as p11
from
(select t.team_long_name,
		m.home_player_1 as p1,
		m.home_player_2 as p2,
	     m.home_player_3 as p3,
	     m.home_player_4 as p4,
		 m.home_player_5 as p5,
         m.home_player_6 as p6,
         m.home_player_7 as p7,
         m.home_player_8 as p8,
         m.home_player_9 as p9,
         m.home_player_10 as p10,
         m.home_player_11 as p11
from matches m
join team t
on t.team_api_id = m.home_team_api_id
where m.season = '2008/2009' and m.league_id = 10257
group by home_team_api_id) s
join player j1
on j1.player_api_id = s.p1
join player j2 
on j2.player_api_id = s.p2
join player j3
on j3.player_api_id = s.p3
join player j4
on j4.player_api_id = s.p4
join player j5
on j5.player_api_id = s.p5
join player j6
on j6.player_api_id = s.p6
join player j7
on j7.player_api_id = s.p7
join player j8
on j8.player_api_id = s.p8
join player j9
on j9.player_api_id = s.p9
join player j10
on j10.player_api_id = s.p10
join player j11
on j11.player_api_id = s.p11;
							       
/*-----5-----*/
							       
/* Climate influence */

/* We want to know if the climate influnces the capacity to make goal.*/
	
select l.name,s.goal,s.tot_matches,s.gol_x_matches,s.climate from
(select m.league_id,sum(m.home_team_goal)+sum(m.away_team_goal) as goal,count(m.id) as tot_matches,
 (sum(m.home_team_goal)+sum(m.away_team_goal))/count(m.id) as gol_x_matches,
case
	when date like '____%-10-%' or date like '____%-11-%' or date like  '____%-12-%' or date like '____%-01-%' or date like '____%-02-%' then 'winter' 
    else 'summer'
end as climate 
from matches m
where m.season = '2009/2010'
group by climate,m.league_id) s

/* So we take the league_id from matches, we sum the sum of home team goal + the sum of the away team goal, we count the m.id to understand how many matches are played 
	during a season beacause it could be less in winter due to Christmas holiday or in summer due to the calendar planning so we have the number of matches played during 
	a season, we do a case where we distinguish the season, so october,november,december,january and february are winter the other summer (for our convenction) we do this 
with wildcards and in particular the ____ underscore means thaht the months could be preceded by any 4 characters. */
join league l
on s.league_id = l.country_id;

/* after we join the table s 'season' with the name of the league to have the name insted of the league_id. */


/*-----6-----*/

/* RELEGATION */

select distinct(t.team_long_name),count(distinct(m.season)) as number_championship,

/*We select the name of the team, we count the season removing duplicates to know how 
	many Serie A they played*/
	
case
	when count(distinct(m.season)) = 8 then 'never been in SERIE B'
    else concat('been in SERIE B  ',8-count(distinct(m.season)),'  times')
end as PALMARES

/* The dataset is composed by 8 season from 2008 to 2016. So applying a case we can show 
	the Serie B with a simply subtraction*/
from team t 
join matches m
on m.home_team_api_id = t.team_api_id

/* the join is to connect the name of the team (in the table:'Team') with their season 
	that there is in the table 'Matches'*/

WHERE m.COUNTRY_ID = 10257
group by t.team_long_name;

							  
/*-------7--------*/
							       
/* Team confirmation */

/* With this query we want to know if a team in terms of team_skills is improved or got worse.*/ 
	
select sa.team_long_name,sa.season,round(a.t_attributes,2) from
(select t.team_long_name,s.season,s.home_team_api_id
from
(select m.season,m.home_team_api_id
from matches m 
where m.league_id = '10257') s
join team t
on t.team_api_id = s.home_team_api_id
group by season,team_long_name
order by team_long_name,season) sa
join (select ta.team_api_id,(ta.BuildUpPlaySpeedClass + ta.buildupplaydribbling + ta.buildupplaypassing + ta.chancecreationpassing + ta.chancecreationcrossing + ta.chancecreationshooting + ta.defencepressure + ta.defenceaggression + ta.defenceteamwidthclass)/9 as t_attributes,
(case 
	when ta.date like '2010-02%' then '2009/2010' 
	when ta.date like '2014-09%' then '2014/2015'
	when ta.date like '2015-09%' then '2015/2016'
	when ta.date like '2011-02%' then '2010/2011'
	when ta.date like '2012-02%' then '2011/2012'
	when ta.date like '2013-09%' then '2013/2014'
end) as season 
from team_attributes ta) a
on sa.home_team_api_id = a.team_api_id and sa.season = a.season
order by team_long_name,season;

/*------8------*/
					   
/* Goalkeeper Presence */
select gk.player_name,gk.presence
from 
(select p.player_name,sum(case
when p.player_api_id = m.home_player_1 then 1
when p.player_api_id = m.away_player_1 then 1
else 0
end) as presence
from player p,matches m
where m.league_id = 10257 and m.season = '2008/2009'
group by p.player_name) gk
where gk.presence>1
order by gk.presence desc,player_name;

/*-----9-----*/
    
/* New stars */

/* #We retrieve the players with overall rating > 70 and age < 35
#We used TIMESTAMPDIFF() function to retrieve the age of the players */

SELECT p.player_api_id, p.player_name, p.birthday, TIMESTAMPDIFF(YEAR, birthday, CURDATE()) AS Age, pa.overall_rating 
FROM player p
INNER JOIN player_attributes pa ON p.player_api_id = pa.player_api_id
WHERE pa.overall_rating > 70 AND TIMESTAMPDIFF(YEAR, birthday, CURDATE()) < 24
Group by player_name
ORDER BY overall_rating desc


/*--------10--------*/
					       
/* Who is the best goalkeeper? */

/* This query return to us the ranking of goalkeeper and his team */
	
select t.team_long_name,gk_2.player_name,gk_2.gk_reflexes from
(select p.player_name,gk.home_team_api_id,gk.gk_reflexes
from (select distinct(m.home_player_1),m.home_team_api_id,max(gk_reflexes) as gk_reflexes

/* We take the max(gk_reflexes) because of during the year change the value of the single player and we 
	decided to take his maximum value.*/

from matches m
join player_attributes pa 
on m.home_player_1 = pa.player_api_id
where pa.gk_reflexes > 60 and m.season = '2008/2009'

/* We filter for the player with gk_reflexes > 60 and that played during season 2008/2009 */

group by m.home_player_1) gk 
join player p
on gk.home_player_1 = p.player_api_id
group by player_name)gk_2
join team t
on gk_2.home_team_api_id = t.team_api_id
order by gk_reflexes desc,team_long_name;

					       
/*-------11-------*/
					       
					       
/* Fifa Rating */
/* #We retrieved the average Fifa rating for four categories of players:goalkeepers,defenders,midfielders and strikers */



SELECT 'goalkeeper' AS position,AVG(OVERALL_RATING)
from player p,player_attributes pa,matches m
WHERE pa.player_api_id=p.player_api_id AND p.player_api_id = home_player_1
union ALL
SELECT 'defender',AVG(OVERALL_RATING)
from player p,player_attributes pa,matches m
WHERE pa.player_api_id=p.player_api_id AND p.player_api_id = home_player_2
union ALL
SELECT 'midfielder',AVG(OVERALL_RATING)
from player p,player_attributes pa,matches m
WHERE pa.player_api_id=p.player_api_id AND p.player_api_id = home_player_7
union ALL
SELECT 'attacker',AVG(OVERALL_RATING)
from player p,player_attributes pa,matches m
WHERE pa.player_api_id=p.player_api_id AND p.player_api_id = home_player_11

					       
					       
/*-------12-------*/
					       
					       
/* The Best betting */

select b.outcome,t.team_long_name as home_team,ti.team_long_name as away_team,b.info from
(select m.B365H,m.B365D,m.B365A,m.home_team_api_id, m.away_team_api_id,
(case 
	when m.home_team_goal > m.away_team_goal then cast(m.B365H as decimal(10,2))
    when m.home_team_goal < m.away_team_goal then cast(m.B365A as decimal(10,2))
    else cast(m.B365D as decimal(10,2))
end) as outcome,
(case 
	when m.home_team_goal > m.away_team_goal then '1'
    when m.home_team_goal < m.away_team_goal then '2'
    else 'x'
end) as info
from matches m
where m.season = '2015/2016' and m.league_id = 10257) b

/* we want to visualize the quotations and the outcome of the match and the team that played the match, so the first 
	case is to assign the quotations, the second case is to know the outcome. After we renamed all of this part with b
for 'betting' and we join with the other table to have the name and not the id. */
join team t
on t.team_api_id = b.home_team_api_id
join team ti 
on ti.team_api_id = b.away_team_api_id
order by outcome desc;

/* At the end we orderd by outcome so to have the higher quotations that was really happen */
									  

