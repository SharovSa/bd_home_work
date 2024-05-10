import psycopg2 as pg
import matplotlib.pyplot as plt
import matplotlib.dates as mpl_dates
import numpy as np

names = ["Liam",
         "Noah",
         "Oliver",
         "James",
         "Elijah",
         "William",
         "Henry",
         "Lucas",
         "Benjamin",
         "Theodore",
         "Mateo",
         "Levi",
         "Sebastian",
         "Daniel",
         "Jack",
         "Michael",
         "Alexander",
         "Owen",
         "Asher",
         "Samuel"]

surnames = ["Adams",
            "Bradley",
            "Cooper",
            "Dawson",
            "Elliott",
            "Ford",
            "Graham",
            "Holmes",
            "Jenkins",
            "Kennedy",
            "Lloyd",
            "Murphy",
            "Owen",
            "Payne",
            "Rogers",
            "Simpson",
            "Smith",
            "Turner",
            "Watson",
            "Wright"]

clubs = []

# Добавление данных в таблицу Players:
with pg.connect(dbname="pg_db", user="postgres", password="postgres") as conn:
    cur = conn.cursor()
    # Записываем все клубы из всех лиг
    clubs = []
    cur.execute("select club_name from england")
    for club in cur.fetchall():
        clubs.append(*club)
    cur.execute("select club_name from germany")
    for club in cur.fetchall():
        clubs.append(*club)
    cur.execute("select club_name from russia")
    for club in cur.fetchall():
        clubs.append(*club)
    cur.execute("select club_name from spain")
    for club in cur.fetchall():
        clubs.append(*club)

    # Генерируем данные
    rand_clubs = np.random.choice(clubs, 50)
    new_names = np.random.choice(names, 50)
    new_surnames = np.random.choice(surnames, 50)
    rand_names = []
    for i in range(len(new_names)):
        tmp = new_names[i] + ' ' + new_surnames[i]
        while tmp in rand_names:
            tmp = new_names[i] + ' ' + np.random.choice(new_surnames)
        rand_names.append(tmp)

    rand_ages = np.random.randint(18, 40, 50)

    rand_goals = np.random.randint(0, 30, 50)
    rand_assists = np.random.randint(0, 13, 50)

    rand_salary = np.random.uniform(low=0.0, high=100000000.0, size=50)
    rand_transfer_cost = np.random.uniform(low=0.0, high=200000000.0, size=50)

    statuses = ["FW", "D", "M", "FW, M", "FW, D", "FW, M, D", "M, D"]
    rand_club_status = np.random.choice(statuses, 50)

    rand_played = np.random.randint(1, 34, 50)

    rand_yellow_cards = np.random.randint(0, 10, 50)
    rand_red_cards = np.random.randint(0, 3, 50)

    # Добавляем новые данные в таблицу игроков
    cur.execute('select max(id) from players')
    curr_id = cur.fetchone()[0] + 1
    for i in range(50):
        cur.execute(
            f"insert into players values ('{rand_names[i]}', '{rand_clubs[i]}', {rand_ages[i]}, {rand_goals[i]},"
            f"{rand_assists[i]}, {rand_salary[i]}, {rand_transfer_cost[i]}, '{rand_club_status[i]}', "
            f"{rand_played[i]}, {rand_yellow_cards[i]}, {rand_red_cards[i]}, {curr_id + i})")
    conn.commit()

    # Добавляем реальные данные о матчах РПЛ в таблицу games
    f = open("new_games.txt")
    for s in f:
        data = s.split(';')
        cur.execute(f"insert into games values ('{data[0]}', '{data[1]}', {data[2]}, "
                    f"{data[3]}, '{data[4]}', '{data[5]}', '{data[6][:-1]}')")
    conn.commit()
    f.close()

    # Собираем данные из бд
    clubs_points = {}
    cur.execute("select club_name from russia")
    for club in cur.fetchall():
        clubs_points[club[0]] = [0]
    cur.execute(
        "select game_date, winer, host, guest from games where host in (select club_name from russia) order by game_date ASC")
    dates = ['2023-07-20']
    for (date, winer, g, h) in cur.fetchall():
        dates.append(str(date.strftime("%Y-%m-%d")))
        if winer == '':
            clubs_points[g].append(clubs_points[g][-1] + 1)
            clubs_points[h].append(clubs_points[h][-1] + 1)
            for club in clubs_points:
                if club != g and club != h:
                    clubs_points[club].append(clubs_points[club][-1])
        else:
            for club in clubs_points:
                if winer == club:
                    clubs_points[club].append(clubs_points[club][-1] + 3)
                else:
                    clubs_points[club].append(clubs_points[club][-1])

    # Строим график количества очков клубов на протяжении сезона
    fig = plt.figure(figsize=(15, 10))
    for (club_name, points) in clubs_points.items():
        plt.plot(dates, points, label=club_name)
    fig.autofmt_xdate()
    fig.tight_layout()
    plt.yticks(np.arange(0, 50, 1))
    plt.grid(True)
    plt.title("Количества очков клубов РПЛ на протяжении сезона")
    plt.legend()
    plt.show()
