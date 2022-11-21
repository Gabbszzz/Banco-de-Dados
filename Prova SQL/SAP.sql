-- Schema and data

create table candidates (
  id            int             not null,
  name          varchar,
  email         varchar,
  created_at    timestamptz,
  updated_at    timestamptz
);

insert into candidates values
  (1,   'John Snow',        'john@snow',    now()+interval '1 seconds', now()+interval '1 seconds'),
  (2,   'Bob Ross',         'bob@ross',     now()+interval '2 seconds', now()+interval '2 seconds'),
  (3,   'Kim Possible',     'kim@possible', now()+interval '3 seconds', now()+interval '3 seconds'),
  (4,   'Ash Ketchum',      'ash@ketchum',  now()+interval '4 seconds', now()+interval '4 seconds'),
  (5,   'Goku Son',         'goku@son',     now()+interval '5 seconds', now()+interval '5 seconds'),
  (6,   'Mortimer Smith',   'morty@smh',    now()+interval '6 seconds', now()+interval '6 seconds');

create table jobs (
  id            int             not null,
  title         varchar,
  positions     int,
  created_at    timestamptz,
  updated_at    timestamptz
);

insert into jobs values
  (1,   'Night Watch Commander',    1,      now()+interval '11 seconds',    now()+interval '11 seconds'),
  (2,   'Pokemon Master',           8,      now()+interval '12 seconds',    now()+interval '12 seconds'),
  (3,   'Blessed Painter',          100,    now()+interval '13 seconds',    now()+interval '13 seconds');

create table applications (
  id            int             not null,
  candidate_id  int             not null,
  job_id        int             not null,
  score         decimal,
  created_at    timestamptz,
  updated_at    timestamptz
);

insert into applications values
  (1,   1,  1,  90,     now()+interval '21 seconds',    now()+interval '21 seconds'),
  (2,   1,  3,  80,     now()+interval '22 seconds',    now()+interval '22 seconds'),
  (3,   2,  1,  10,     now()+interval '23 seconds',    now()+interval '23 seconds'),
  (4,   2,  2,  10,     now()+interval '24 seconds',    now()+interval '24 seconds'),
  (5,   2,  3,  99,     now()+interval '25 seconds',    now()+interval '25 seconds'),
  (6,   3,  1,  60,     now()+interval '26 seconds',    now()+interval '26 seconds'),
  (7,   3,  2,  70,     now()+interval '27 seconds',    now()+interval '27 seconds'),
  (8,   3,  3,  50,     now()+interval '28 seconds',    now()+interval '28 seconds'),
  (9,   4,  2,  90,     now()+interval '29 seconds',    now()+interval '29 seconds'),
  (10,  5,  1,  9000,   now()+interval '30 seconds',    now()+interval '30 seconds');
  
-- Atribuições:
--
-- 1. Os nomes e número de candidaturas de candidatos que se inscreveram para 
--    menos de 3 vagas.
SELECT candidates.name, COUNT(candidate_id) as count FROM candidates LEFT JOIN applications
ON candidates.id = applications.candidate_id GROUP BY candidates.name HAVING count < 3 ORDER BY count DESC, name DESC;
--
-- Expected output:
-- name             count
-- John Snow        2
-- Goku Son         1
-- Ash Ketchum      1
-- Mortimer Smith   0
--
-- 2. Os nomes, o título do trabalho da sua pontuação máxima de aplicação e a pontuação para
--    essa candidatura para cada candidato que tenha pelo menos uma candidatura.
--    (se houver um empate, escolha a candidatura que foi criada por último)
-- 
SELECT name, title, max(score) as score FROM applications INNER JOIN candidates ON candidates.id = applications.candidate_id 
INNER JOIN jobs on jobs.id = applications.job_id GROUP BY name;
-- Expected output:
-- name             title                   score
-- Ash Ketchum      Pokemon Master          90
-- Bob Ross         Blessed Painter         99
-- Goku Son         Night Watch Commander   9000
-- John Snow        Night Watch Commander   90
-- Kim Possible     Pokemon Master          70
--
-- 3. Para cada trabalho: título, quantidade de candidatos com pontuação superior a 25,
-- quantidade de candidatos com pontuação superior a 50, quantidade de candidatos com pontuação superior a 75.
--
SELECT title, COUNT(case when score > 25 then 1 else null end) as over25, COUNT(case when score > 50 then 1 else null end) as over50, COUNT(case when score > 75 then 1 else null end) as over75 
FROM applications INNER JOIN jobs on jobs.id = applications.job_id  GROUP BY title ORDER BY jobs.created_at DESC;
-- Expected output:
-- title                    over25  over50  over75
-- Blessed Painter          3       2       2
-- Pokemon Master           2       2       1
-- Night Watch Commander    3       3       2
