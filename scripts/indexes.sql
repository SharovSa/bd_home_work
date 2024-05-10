create index idx_player
on players(club_name);

create index idx_game_date
on games(game_date);

create index idx_game_host
on games(host);