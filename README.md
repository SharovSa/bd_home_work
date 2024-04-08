# Проект по БД.

Тема проекта: таблицы футбольных лиг, их игроки и игры.

## Логическая модель

[logical model](./uml_charts/logical_model.vsdx)

Нормальная форма - NF2. Чтобы достичь третью форму, нужно было бы изменить саму тему проекта. (Таблицы с футбольными лигами пришлось бы роазбивать).
Таблица с версионными данными - Games

## Физическая модель

[physical model](./uml_charts/physical_model.vsdx)

Для реализации базы данных в postgres сделан [DDL-](./scripts/ddl.sql)скрипт, а также csv файлы для каждой таблицы: [анлийская лига](./scripts/england.csv), [немецкая лига](./scripts/germany.csv), [российская лига](./scripts/russia.csv), [испанская лига](./scripts/spain.csv), [матчи](./scripts/games.csv), [игроки](./scripts/players.csv).
Кроме того, написаны 10 возможных [запросов](./scripts/queries.sql) к БД.
