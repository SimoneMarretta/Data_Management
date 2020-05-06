ALTER TABLE PLAYER
ADD CONSTRAINT PRIMARY KEY (player_api_id);

ALTER TABLE PLAYER_ATTRIBUTES
ADD CONSTRAINT PRIMARY KEY (id);

ALTER TABLE TEAM
ADD CONSTRAINT PRIMARY KEY (team_api_id);

ALTER TABLE TEAM_ATTRIBUTES
ADD CONSTRAINT PRIMARY KEY (id);

ALTER TABLE MATCHES
ADD CONSTRAINT PRIMARY KEY (match_api_id);

ALTER TABLE LEAGUE
ADD CONSTRAINT PRIMARY KEY (country_id);

ALTER TABLE COUNTRY
ADD CONSTRAINT PRIMARY KEY (id);

ALTER TABLE PLAYER_ATTRIBUTES
ADD CONSTRAINT
FOREIGN KEY (player_api_id) REFERENCES PLAYER (player_api_id);

ALTER TABLE TEAM_ATTRIBUTES
ADD CONSTRAINT
FOREIGN KEY (team_api_id) REFERENCES TEAM (team_api_id);

ALTER TABLE LEAGUE
ADD CONSTRAINT
FOREIGN KEY (country_id) REFERENCES COUNTRY (id);

ALTER TABLE LEAGUE
ADD CONSTRAINT
FOREIGN KEY (country_id) REFERENCES COUNTRY (id);

ALTER TABLE MATCHES
ADD CONSTRAINT
FOREIGN KEY (home_team_api_id) REFERENCES TEAM (team_api_id);

ALTER TABLE MATCHES
ADD CONSTRAINT
FOREIGN KEY (away_team_api_id) REFERENCES TEAM (team_api_id);

ALTER TABLE MATCHES
ADD CONSTRAINT
FOREIGN KEY (country_id) REFERENCES COUNTRY (id);

ALTER TABLE `MATCHES` ADD INDEX `matches_idx_season_home_id_away_id` (`season`,`home_team_api_id`,`away_team_api_id`);

ALTER TABLE `player` ADD INDEX `player_idx_player_id` (`player_api_id`);

ALTER TABLE `player_attributes` ADD INDEX `player_attributes_idx_player_id` (`player_api_id`);