-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Окт 05 2020 г., 23:02
-- Версия сервера: 5.6.41-log
-- Версия PHP: 7.2.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `tyumen`
--

-- --------------------------------------------------------

--
-- Структура таблицы `points`
--

CREATE TABLE `points` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `description` text NOT NULL,
  `img_link` text NOT NULL,
  `updated_at` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `points`
--

INSERT INTO `points` (`id`, `name`, `x`, `y`, `description`, `img_link`, `updated_at`) VALUES
(1, 'Павильон', 57.1521, 65.5385, '                                                                                                                                                                                                                                                                                                нестационарный торговый объект со стабильным местом размещения, имеющий торговый зал, одно или несколько помещений для хранения товарного запаса, и рассчитанный на одно или несколько рабочих мест                                                                                                                                                                                                                                                                                                ', 'https://www.flaticon.com/svg/static/icons/svg/287/287623.svg', '1601926112'),
(2, 'Киоск', 57.1519, 65.5371, '                                                                                                нестационарный торговый объект со стабильным местом размещения, имеющий торговый зал, одно или несколько помещений для хранения товарного запаса, и рассчитанный на одно или несколько рабочих мест                                                                                                ', 'https://www.flaticon.com/svg/static/icons/svg/287/287623.svg', '1601921981'),
(3, 'Палатка', 57.1521, 65.536, '                                                                                                                                    нестационарный торговый объект со стабильным местом размещения, имеющий торговый зал, одно или несколько помещений для хранения товарного запаса, и рассчитанный на одно или несколько рабочих мест                                                                                                                                    ', 'https://www.svgrepo.com/show/217870/tent.svg', '1601919170');

-- --------------------------------------------------------

--
-- Структура таблицы `session_upload_points`
--

CREATE TABLE `session_upload_points` (
  `session` text NOT NULL,
  `date_upload_points` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `session_upload_points`
--

INSERT INTO `session_upload_points` (`session`, `date_upload_points`) VALUES
('7n4nok5jel29kru4pik86rb8jlj1so7n', '1601586144'),
('i7ccvgtkr0ld6v2mbjmufhc1d9e6j0os', '1601643233'),
('0vbsv4v5lvilmfpf2ojk5i5ho58n90jr', '1601640356'),
('qpc7409pv9h3n5fh12accj7e059593hg', '1601640558'),
('s82bgklafgn6npdtqm38sff42b56go6l', '1601640727'),
('js0c81no1nilh048q3leijm949eek338', '1601640775'),
('n234gn20btu7dipv7vo8qj140pa8uua7', '1601640903'),
('qe4cviduu8raeiruqmo9vj4vngrq1ta5', '1601641029'),
('l9r9tfrf3lci6nev2oa0bktg1nqc6826', '1601641102'),
('40h2ruadm76c0584k03hcq78ab7vcaq4', '1601641104'),
('l4pt1v7bcjlhsantlsu1o7n6vkbkdjac', '1601641262'),
('igotssk769ctes76kfb5b6n0p4sjoa1a', '1601641523'),
('4q3mi7fidas48eiav1mm8jq1mp75d70o', '1601643556'),
('nbjuucos60kpd57c03mq92h1gm32h5te', '1601643814'),
('em852iji6pa4g2jbdlv2ofoemtu67k1s', '1601643890'),
('hjfv376k7m8te8aed1sbmu7scrqdfo1f', '1601643902'),
('ens6m95472vgtbs7ogqkd1pi5opm9j33', '1601644340'),
('evbkobfd5t4j9msafdhnk9qkflhnk6me', '1601644400'),
('2alm10p4i4qnf6hilftsm07cjctsfhei', '1601644409'),
('frrqd7tkem0phsh2qgp240isud266udl', '1601644580'),
('oq5d2cdgcijk6doi44v94f8l5jcciaee', '1601656587'),
('bihkaebe6v6kemi9g7lgp799jqkf6d39', '1601657311'),
('ke52t8coltaoje6uj5jif2sahhv61al4', '1601657560'),
('1ssmou8n8mahmka3aju7vm8bo1gvb80b', '1601657613'),
('5uleqpv79onv6pq4stec6omn2u3nf6s6', '1601659446'),
('0l81p4q75679q9o030viuli1g2bm8rhl', '1601663367'),
('07aq4q0node17ia1n0r252d6i9nmofsc', '1601672657'),
('j3sjd6c132197gep7rl31gl1junib585', '1601670206'),
('cn4k7tegqg8irg8fddm0uvm6kd1fe82h', '1601672696'),
('snpj820scab6731tcnhkqgo46gnvkaia', '1601672797'),
('dhdohj70fa1ujmhke27crhq5gv9gk93h', '1601729693'),
('n295080ghjt63l5nh13qk2cljibu5c4c', '1601744441'),
('42lc3b8f04l55v7ehka221afkkp67khu', '1601746877'),
('lbu9lj6huuce8fm5cpckbbpv53tro68b', '1601749531'),
('22plv9run45l2fm8vvf40eh0vdk12rum', '1601835446'),
('vsinossgvrcqplqadbsasmdpf4bnokoc', '1601913194'),
('rm6a09k31i7ss38eotgtjb0uqtr7k6k8', '1601928121');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `points`
--
ALTER TABLE `points`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `points`
--
ALTER TABLE `points`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
