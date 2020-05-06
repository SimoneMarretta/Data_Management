

1)select p.player_name,gk.total 
from
(select h.home_player_1,h.total + a.total as total
from
(select m.home_player_1,count(m.home_player_1) as total
from matches m 
where m.league_id = 10257 and m.season = '2008/2009'
group by m.home_player_1) h
join
(select m.away_player_1,count(m.away_player_1) as total
from matches m
where m.league_id = 10257 and m.season = '2008/2009'
group by m.away_player_1) a
on h.home_player_1 = a.away_player_1) gk
join player p
on p.player_api_id = gk.home_player_1
group by player_name
order by gk.total desc,player_name;


2)CREATE view premier_league2 as
SELECT team_long_name,home_team_goal,away_team_goal,home_team_api_id,away_team_api_id
FROM matches m,team t
WHERE m.home_team_api_id=t.team_api_id AND season='2008/2009' AND country_id=1729

SELECT team_long_name,SUM(home_team_goal) AS TOTAL
FROM premier_league2
group by home_team_api_id
UNION ALL
SELECT team_long_name,SUM(away_team_goal) AS TOTAL
FROM premier_league2
group by away_team_api_id

3)ALTER TABLE `matches` ADD INDEX `matches_idx_country_id_season` (`COUNTRY_ID`,`season`);
ALTER TABLE `team` ADD INDEX `team_idx_team_id_team_name` (`team_api_id`,`team_long_name`);


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

4)select att.player_name,att.h from 
(select distinct(m.home_player_11),p.player_name,abs(p.height-p.weight) as h
from matches m
join player p
on p.player_api_id = m.home_player_11) att
group by att.h 
order by att.h desc
limit 1;


5)ALTER TABLE `matches` ADD INDEX `matches_idx_home_1` (`home_player_1`);
ALTER TABLE `matches` ADD INDEX `matches_idx_home_2` (`home_player_2`);
ALTER TABLE `matches` ADD INDEX `matches_idx_home_7` (`home_player_7`);
ALTER TABLE `matches` ADD INDEX `matches_idx_home_11` (`home_player_11`);

SELECT 'goalkeeper' AS position,AVG(OVERALL_RATING)
from player,player_attributes,matches
WHERE player_attributes.player_api_id=player.player_api_id AND player.player_api_id = home_player_1 AND season = '2008/2009'
union
SELECT 'defender',AVG(OVERALL_RATING)
from player,player_attributes,matches
WHERE player_attributes.player_api_id=player.player_api_id AND player.player_api_id = home_player_2 AND season = '2008/2009'
union
SELECT 'midfielder',AVG(OVERALL_RATING)
from player,player_attributes,matches
WHERE player_attributes.player_api_id=player.player_api_id AND player.player_api_id = home_player_7 AND season = '2008/2009'
union
SELECT 'attacker',AVG(OVERALL_RATING)
from player,player_attributes,matches
WHERE player_attributes.player_api_id=player.player_api_id AND player.player_api_id = home_player_11 AND season = '2008/2009'
