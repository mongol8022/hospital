-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Хост: 127.0.0.1
-- Час створення: Лип 16 2017 р., 07:56
-- Версія сервера: 5.5.50-0ubuntu0.14.04.1
-- Версія PHP: 5.5.9-1ubuntu4.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- База даних: `queue`
--

-- --------------------------------------------------------

--
-- Структура таблиці `cities`
--

CREATE TABLE IF NOT EXISTS `cities` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Уник. Идентификатор',
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=17 ;

--
-- Дамп даних таблиці `cities`
--

INSERT INTO `cities` (`id`, `name`) VALUES
(2, 'Беленькое'),
(1, 'Краматорск'),
(11, 'Красноторка'),
(12, 'Малотарановка'),
(13, 'Софиевка'),
(14, 'Шабельковка'),
(15, 'Ясная Поляна'),
(16, 'Ясногорка');

-- --------------------------------------------------------

--
-- Структура таблиці `departments`
--

CREATE TABLE IF NOT EXISTS `departments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Уник. Идентификатор',
  `name` varchar(255) NOT NULL COMMENT 'Имя подразделения',
  `firm_id` int(10) unsigned NOT NULL COMMENT 'Идентификатоор фирмы',
  `info` text,
  PRIMARY KEY (`id`),
  KEY `firm_id` (`firm_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Дамп даних таблиці `departments`
--

INSERT INTO `departments` (`id`, `name`, `firm_id`, `info`) VALUES
(1, 'Терапевтическое отделение', 1, '<h4>Поликлиническое отделение</h4>\n		<p>Поликлиническое отделение КМУ «Городская больница №1» \n		проводит лечебно-консультативную работу. В отделении работают  \n		врачи узкой специализации:</p>\n		<ul type="disc"> \n			<li>врач - хирург Дегтяренко Сергей Александрович;</li> \n			<li>врач - детский хирург Боярко Ярослав Сергеевич;</li> \n			<li>врач - невролог Линёва Анна Владимиривна;</li> \n			<li>врач - невролог Горлов Владислав Валерьевич;</li>\n			<li>врач - невролог Штрикун Елена Викторовна;</li> \n			<li>врач – офтальмолог Толмачова Татьяна Михайловна;</li> \n			<li>врач – отоларинголог Пономарева Лариса Николаевна;</li>\n			<li>врач – отоларинголог Минаев Александр Анатольевич;</li> \n			<li>врач – эндокринолог Ерулович Анна Анатольвна;</li> \n			<li>врач – эндокринолог Закорвашевич Лидия Александровна;</li> \n			<li>врач – кардиолог Нескромная Елена Николаевна;</li> \n			<li>врач – травматолог Яловега Владимир Григорьевич;</li> \n			<li>врач – генеколог Попова Ирина Алексеевна;</li> \n			<li>врач – генеколог Титорчук Елена Сергеевна;</li>                         \n			<li>врач – генеколог Ростовская Виктория Викторовна;</li>\n			<li>врач – генеколог Овчаренко Елена Евгеньевна;</li>\n			<li>врач – генеколог Шевченко Евгений Александрович;</li>\n			<li>врач – генеколог Павлова Наталья Викторовна;</li>\n			<li>врач – генеколог Власенко Ирина Ивановна</li>\n			<li>врач – инфекционист Бугаёва Тамила Петровна;</li>\n			<li>врач кабинета функциональной диагностики Беженцева Галина Олександроівнавна;</li>\n			<li>врач - терапевт Тамаркина Алла Михайловна</li>\n		</ul>\n	<p>Специалисты поликлинического отделения проводят консультации больных в стационарных отделениях и больных, направленных с первого уровня медицинской помощи. Поликлиника обслуживает около 52 тыс. взрослого населения, а так же дитским хирургом проводятся профилактические осмотры и амбулаторное лечение детей города.</p>\n	<h4>Структура поликлиники:</h4>\n	<ul>\n		<li>териториальная поликлиника с узкими специалистами</li>\n		<li>женская консультация</li>\n		<li>эндоскопический кабинет</li>\n	</ul>\n	<p>Поликлиника выполняет: </p>\n	<ul>\n		<li>Комплексное клиническое, лабораторное, инструментальное диследование больных, включая новые методы функциональной диагностики;</li>\n		<li>Выполнение лечебно–профилактических и организационно–методических функций;</li>\n		<li>Профилактические и периодические медицинские осмотры работников КМУ «Городской больницы № 1».</li>\n	</ul>\n	<p>врачи и медсестры поликлиники регулярно посещают курсы повышения квалификации и специализации. Медсестры в совершенстве владеют техникой медицинских процедур. Все врачи поликлиники являются специалистами в своей области. Их действия всегда скоординованы и планомерны, благодаря большому опыту в научной и практичной работе. К каждому пациенту подбирают индивидуальный подход.</p>'),
(2, 'Офтальмологическое отделение', 1, NULL);

-- --------------------------------------------------------

--
-- Структура таблиці `firms`
--

CREATE TABLE IF NOT EXISTS `firms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `postindex` decimal(5,0) DEFAULT NULL COMMENT 'Поштовий індекс',
  `city_id` int(10) unsigned NOT NULL,
  `street` varchar(255) NOT NULL,
  `house` decimal(5,0) unsigned NOT NULL,
  `room` decimal(5,0) unsigned DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `address_city` (`city_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Дамп даних таблиці `firms`
--

INSERT INTO `firms` (`id`, `name`, `postindex`, `city_id`, `street`, `house`, `room`, `info`) VALUES
(1, 'Городская больница №1', 84307, 1, 'ул. Орджоникидзе', 17, NULL, '<h4>Время работы:</h4>\n		<ul>\n			<li>с 7:00 до 16:)) - в течении недели;</li> \n			<li>с 7:00 до 12 - в субботу;</li> \n			<li>выходной - воскресенье</li>\n		</ul>\n		<h4>Схема проезда к КМУ "Городская больница №1"</h4>\n		<h5> от ЖД вокзала:</h5>\n		<ul>\n			<li>троллейбус №6</li> \n			<li>автобусы 10, 21, 31, 30</li> \n		</ul>\n	<h5> от автовокзала:</h5>\n		<ul>\n			<li>троллейбус №6</li> \n			<li>автобусы 10, 21, 31, 8A</li> \n		</ul>\n	<h5> остановка "Новый свет"</h5>\n	<h5>При заезде со стороны Дружковки</h5> \n	<p>ориентир путепровод, за ним после переезда трамвайных путей 400м поворот направо (Следющий поворот после Шиномонтажной мастерской).</p>\n	<h5>При заезде со стороны Славянска </h5>\n	<p>ориентир автомагазины по левой стороне, после перекрестка с ул.Аэроклубной(Кима) через 250 м поворот налево за автобусной остановкой</p>\n</div>'),
(2, 'Городская больница №2', 84306, 1, 'ул. Днепропетровская', 14, NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблиці `queues`
--

CREATE TABLE IF NOT EXISTS `queues` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Уник. идентификатор',
  `schedule_id` int(10) unsigned NOT NULL,
  `time_begin` datetime NOT NULL,
  `person_surname` varchar(255) DEFAULT NULL,
  `person_name` varchar(255) DEFAULT NULL,
  `person_lastname` varchar(255) DEFAULT NULL,
  `date_born` date DEFAULT NULL,
  `confirm_code` char(20) DEFAULT NULL,
  `confirm_time` datetime DEFAULT NULL,
  `cancel_code` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `confirm_code` (`confirm_code`),
  UNIQUE KEY `cancel_code` (`cancel_code`),
  KEY `schedule_id` (`schedule_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=17 ;

--
-- Дамп даних таблиці `queues`
--

INSERT INTO `queues` (`id`, `schedule_id`, `time_begin`, `person_surname`, `person_name`, `person_lastname`, `date_born`, `confirm_code`, `confirm_time`, `cancel_code`) VALUES
(1, 5, '2017-07-14 08:00:00', '', '', '', NULL, NULL, NULL, NULL),
(2, 5, '2017-07-14 08:10:00', '', '', '', NULL, NULL, NULL, NULL),
(3, 5, '2017-07-14 08:20:00', '', '', '', NULL, NULL, NULL, NULL),
(4, 5, '2017-07-14 08:30:00', '', '', '', NULL, NULL, NULL, NULL),
(5, 5, '2017-07-14 08:40:00', '', '', '', NULL, NULL, NULL, NULL),
(6, 5, '2017-07-14 08:50:00', '', '', '', NULL, NULL, NULL, NULL),
(7, 5, '2017-07-14 13:00:00', '', '', '', NULL, NULL, NULL, NULL),
(8, 5, '2017-07-14 13:10:00', '', '', '', NULL, NULL, NULL, NULL),
(9, 1, '2017-07-17 08:00:00', 'zdsgfdfsg', 'dfsgdfsgdfs', 'dfsgdfsg', '1991-10-10', NULL, NULL, 7748966262),
(10, 1, '2017-07-17 08:10:00', 'trfdsg', 'dfgdfsg', 'dfgdfsg', '2017-07-21', NULL, NULL, NULL),
(11, 1, '2017-07-17 08:20:00', 'erfd', 'gfdfgf', 'gfgfggfgf', '1991-01-01', NULL, NULL, NULL),
(12, 1, '2017-07-17 08:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(13, 1, '2017-07-17 08:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(14, 1, '2017-07-17 08:50:00', 'fdf', 'ffvfd', 'dfsdfs', '1994-01-01', NULL, NULL, NULL),
(15, 1, '2017-07-17 09:00:00', 'dfsdfs', 'dfsdfdf', 'dsfdfsdfs', '1991-01-01', NULL, NULL, 3887250187),
(16, 1, '2017-07-17 09:10:00', 'фвіа', 'фівафвіа', 'парпакрар', '1980-01-01', NULL, NULL, 7505553794);

-- --------------------------------------------------------

--
-- Структура таблиці `schedule`
--

CREATE TABLE IF NOT EXISTS `schedule` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `worplace_id` int(10) unsigned NOT NULL,
  `service_id` int(10) unsigned NOT NULL,
  `week_day` tinyint(1) NOT NULL,
  `time_begin` time NOT NULL,
  `count` decimal(3,0) unsigned NOT NULL,
  `valid_from` date NOT NULL,
  `valid_to` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `worplace_id` (`worplace_id`),
  KEY `service_id` (`service_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=11 ;

--
-- Дамп даних таблиці `schedule`
--

INSERT INTO `schedule` (`id`, `worplace_id`, `service_id`, `week_day`, `time_begin`, `count`, `valid_from`, `valid_to`) VALUES
(1, 1, 1, 0, '08:00:00', 20, '2017-01-01', NULL),
(2, 1, 1, 1, '10:00:00', 15, '2017-01-01', NULL),
(3, 1, 1, 2, '08:20:00', 35, '2017-01-01', NULL),
(4, 1, 1, 3, '08:00:00', 10, '2017-01-01', NULL),
(5, 1, 1, 4, '11:30:00', 10, '2017-01-01', NULL),
(6, 2, 1, 0, '13:00:00', 15, '2017-01-01', NULL),
(7, 2, 1, 1, '09:00:00', 25, '2017-01-01', NULL),
(8, 2, 1, 2, '11:20:00', 10, '2017-01-01', NULL),
(9, 2, 1, 3, '14:00:00', 20, '2017-01-01', NULL),
(10, 2, 1, 4, '10:30:00', 15, '2017-01-01', NULL);

-- --------------------------------------------------------

--
-- Структура таблиці `services`
--

CREATE TABLE IF NOT EXISTS `services` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT 'Наименование услуги',
  `duration` smallint(3) unsigned NOT NULL COMMENT 'Длительность (в мин)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Дамп даних таблиці `services`
--

INSERT INTO `services` (`id`, `name`, `duration`) VALUES
(1, 'Консультация', 10),
(2, 'Первичная консультация', 15);

-- --------------------------------------------------------

--
-- Структура таблиці `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `pass` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `type` int(10) unsigned NOT NULL,
  `resetcode` char(20) DEFAULT NULL,
  `workplace_id` int(10) unsigned DEFAULT NULL COMMENT 'Рабочее место (если юзер сотрудник)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `pass` (`pass`),
  KEY `workplace_id` (`workplace_id`),
  KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Структура таблиці `usertypes`
--

CREATE TABLE IF NOT EXISTS `usertypes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `code` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Дамп даних таблиці `usertypes`
--

INSERT INTO `usertypes` (`id`, `name`, `code`) VALUES
(1, 'Працівник', 'employ'),
(2, 'Адміністратор', 'admin');

-- --------------------------------------------------------

--
-- Структура таблиці `workplaces`
--

CREATE TABLE IF NOT EXISTS `workplaces` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `department_id` int(10) unsigned NOT NULL,
  `empl_surname` varchar(255) NOT NULL,
  `empl_name` varchar(255) NOT NULL,
  `empl_lastname` varchar(255) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `name` (`name`),
  KEY `department_id` (`department_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Дамп даних таблиці `workplaces`
--

INSERT INTO `workplaces` (`id`, `name`, `department_id`, `empl_surname`, `empl_name`, `empl_lastname`) VALUES
(1, 'Врач-терапевт (каб.201)', 1, 'Иванов', 'Иван', 'Иванович'),
(2, 'Врач-терапевт (каб. 202)', 1, 'Петрова', 'Петрина', 'Петровна'),
(3, 'Врач-терапевт (каб.203)', 1, 'Айболитов', 'Василий', 'Васильевич');

--
-- Обмеження зовнішнього ключа збережених таблиць
--

--
-- Обмеження зовнішнього ключа таблиці `departments`
--
ALTER TABLE `departments`
  ADD CONSTRAINT `departments_ibfk_1` FOREIGN KEY (`firm_id`) REFERENCES `firms` (`id`);

--
-- Обмеження зовнішнього ключа таблиці `firms`
--
ALTER TABLE `firms`
  ADD CONSTRAINT `firms_ibfk_1` FOREIGN KEY (`city_id`) REFERENCES `cities` (`id`);

--
-- Обмеження зовнішнього ключа таблиці `queues`
--
ALTER TABLE `queues`
  ADD CONSTRAINT `queues_ibfk_1` FOREIGN KEY (`schedule_id`) REFERENCES `schedule` (`id`);

--
-- Обмеження зовнішнього ключа таблиці `schedule`
--
ALTER TABLE `schedule`
  ADD CONSTRAINT `schedule_ibfk_3` FOREIGN KEY (`worplace_id`) REFERENCES `workplaces` (`id`),
  ADD CONSTRAINT `schedule_ibfk_4` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`);

--
-- Обмеження зовнішнього ключа таблиці `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`type`) REFERENCES `usertypes` (`id`),
  ADD CONSTRAINT `users_ibfk_2` FOREIGN KEY (`workplace_id`) REFERENCES `workplaces` (`id`);

--
-- Обмеження зовнішнього ключа таблиці `workplaces`
--
ALTER TABLE `workplaces`
  ADD CONSTRAINT `workplaces_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
