# 1 выводим возраст самого молодого игрока в каждом клубе из Англии:

SELECT club_name, min(age)
FROM players 
WHERE club_name IN (SELECT club_name FROM england) 
group by club_name;

# 2 выводим игроков из немецких клубов, которые забили больше, чем 10 голов, по убыванию:

SELECT club_name, goals, player_name
FROM players 
WHERE club_name IN (SELECT club_name FROM germany) 
group by club_name, goals, player_name 
having goals > 10 
order by goals DESC;

# 3 выводим английский клуб и дату матча, в котором он на домашнем поле забил не менее 3 голов по позрастанию даты:

select host, game_date from games
where hosts_goals >= 3
group by host, game_date 
having host in (select club_name from england) 
order by game_date ASC;

# 4 Выводим количество игроков по клубам из России, которые получили званием mvp:

select count(DISTINCT player_name), club_name
from players join games on games.mvp = players.player_name
where club_name in (select club_name from russia)
group by club_name
order by count(DISTINCT player_name) DESC;

# 5 Выводим игроков из английских клубов, которые забили менее 10 голов и их зарплаты по возрастанию:

select player_name, salary, goals
from players join england on players.club_name = england.club_name
where goals < 10
group by player_name order by salary;

# 6 Выводим количество игроков из Германии, которые получили желтые карточки:

select count(player_name) as Count_players, yellow_cards
from players
where club_name in (select club_name from germany)
group by yellow_cards 
order by yellow_cards;

# 7 Вывод самых результативных игроков по клубам по убыванию:

select club_name, player_name, goals 
from players
where (club_name, goals) in (select club_name, max(goals) 
from players
group by club_name) order by goals DESC;

# 8 Выводим список самых дорогих трансферов среди лиг по убыванию:

select club_name, player_name, transfer_cost
from players
where transfer_cost in
((select max(max_cost) from (select players.club_name as cn, max(transfer_cost) as max_cost
from players join spain on players.club_name = spain.club_name
group by cn) as tb1),
(select max(max_cost) from (select players.club_name as cn, max(transfer_cost) as max_cost
from players join germany on players.club_name = germany.club_name
group by cn) as tb2),
(select max(max_cost) from (select players.club_name as cn, max(transfer_cost) as max_cost
from players join russia on players.club_name = russia.club_name
group by cn) as tb3),
(select max(max_cost) from (select players.club_name as cn, max(transfer_cost) as max_cost
from players join england on players.club_name = england.club_name
group by cn) as tb4))
group by club_name, player_name, transfer_cost
order by transfer_cost DESC;

# 9 Статистика всех команд из России за март:

with tb1 as (select host, count(winer) as wins from games
where game_date between '2024-03-01' and '2024-03-31'
group by host
having host in (select club_name from russia)),
tb2 as (select host, count(game_date) as cnt_games from games
where game_date between '2024-03-01' and '2024-03-31'
group by host
having host in (select club_name from russia))
select tb1.host, cnt_games, wins, (cnt_games - wins) as losses from tb1
right join tb2 on tb1.host = tb2.host;

# 10 Количество забитых голов, количество отданных ассистов, суммарная зп по клубам по убыванию:

select club_name, sum(goals) as cnt_goals, sum(assists) as cnt_assists, sum(salary) as sum_salary
from players
group by club_name order by cnt_goals DESC, cnt_assists DESC;