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

select p.player_name,gk.total 
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