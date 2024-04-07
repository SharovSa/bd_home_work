create table if not exists Games (
    host varchar(30) not null,
    guest varchar(30) not null,
    hosts_goals smallint not null,
    guests_goals smallint not null,
    winer varchar(30) not null,
    mvp varchar(50) not null,
    game_date date not null,
    constraint PK_Games primary key (host, guest)
);

create table if not exists England (
    club_name varchar(30) not null primary key,
    championship_pos smallint not null,
    played smallint not null,
    pts smallint not null,
    wons smallint not null,
    looses smallint not null,
    draws smallint not null,
    constraint FK_EnglandGames foreign key (club_name) references Games (host) on delete restrict on update restrict
);

create table if not exists Germany (
    club_name varchar(30) not null primary key,
    championship_pos smallint not null,
    played smallint not null,
    pts smallint not null,
    wons smallint not null,
    looses smallint not null,
    draws smallint not null,
    constraint FK_GermanyGames foreign key (club_name) references Games (host) on delete restrict on update restrict
);

create table if not exists Russia (
    club_name varchar(30) not null primary key,
    championship_pos smallint not null,
    played smallint not null,
    pts smallint not null,
    wons smallint not null,
    looses smallint not null,
    draws smallint not null,
    constraint FK_RussiaGames foreign key (club_name) references Games (host) on delete restrict on update restrict
);

create table if not exists Spain (
    club_name varchar(30) not null primary key,
    championship_pos smallint not null,
    played smallint not null,
    pts smallint not null,
    wons smallint not null,
    looses smallint not null,
    draws smallint not null,
    constraint FK_SpainGames foreign key (club_name) references Games (host) on delete restrict on update restrict
);

create table if not exists Players (
    player_name varchar(50) not null primary key,
    club_name varchar(30) not null,
    age smallint not null,
    goals smallint not null,
    assists smallint not null,
    salary decimal(10,2) not null,
    transfer_cost decimal(10,2) not null,
    club_status varchar(20) not null,
    played  smallint not null,
    yellow_cards smallint not null,
    red_cards smallint not null,
    id integer not null unique,
    constraint FK_Players1 foreign key (club_name) references England (club_name) on delete cascade on update restrict,
    constraint FK_Players2 foreign key (club_name) references Germany (club_name) on delete cascade on update restrict,
    constraint FK_Players3 foreign key (club_name) references Russia (club_name) on delete cascade on update restrict,
    constraint FK_Players4 foreign key (club_name) references Spain (club_name) on delete cascade on update restrict,
    constraint FK_Players5 foreign key (player_name) references Games (mvp)
);