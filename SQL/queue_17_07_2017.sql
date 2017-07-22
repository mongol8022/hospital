-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Хост: 127.0.0.1
-- Час створення: Лип 17 2017 р., 15:12
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

DELIMITER $$
--
-- Процедури
--
CREATE DEFINER=`cs50`@`localhost` PROCEDURE `gen_appoints`()
    MODIFIES SQL DATA
BEGIN
	DECLARE day_incr INT default 0;
	DECLARE date_incr DATE;
	DECLARE datetime_incr DATETIME;
	DECLARE count_incr INT default 0;	
	DECLARE SchedId INT;
	DECLARE SchedCount DECIMAL(3,0);
	DECLARE SchedTime TIME;
	DECLARE SchedDuration SMALLINT;
	DECLARE done INT default 0;
	DECLARE SchedCursor CURSOR FOR SELECT schedule.id, schedule.count, schedule.time_begin, services.duration FROM schedule, services WHERE schedule.service_id = services.id and schedule.valid_from <= date_incr and (schedule.valid_to is NULL or schedule.valid_to >= date_incr) and weekday(date_incr) = schedule.week_day;
	DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done=1;	
	WHILE day_incr < 8 DO
		SELECT CURDATE() + INTERVAL day_incr DAY INTO date_incr;		
		SET done = 0;
		OPEN SchedCursor;		
		WHILE done = 0 DO 
			FETCH SchedCursor INTO SchedId,SchedCount,SchedTime,SchedDuration;
			SET count_incr = 0;
			WHILE count_incr < SchedCount DO
				SELECT ADDTIME(STR_TO_DATE(CONCAT(date_incr, ' ', '00:00:00'), '%Y-%m-%d %H:%i:%s'), SchedTime) + INTERVAL count_incr*SchedDuration MINUTE INTO datetime_incr;
				INSERT INTO queues (schedule_id, time_begin) SELECT * FROM (SELECT SchedId, datetime_incr) AS tmp
WHERE NOT EXISTS (select id from queues where schedule_id = SchedId and time_begin = datetime_incr);
				SET count_incr = count_incr + 1;
			END WHILE;
		END WHILE;
		CLOSE SchedCursor;
        SET day_incr = day_incr + 1;
	END WHILE;

END$$

DELIMITER ;

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=521 ;

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
(9, 1, '2017-07-17 08:00:00', 'awetrqwtr', 'dsfgdfsgdfsg', 'dfsgdfsg', '2017-07-10', NULL, NULL, 8589491765),
(10, 1, '2017-07-17 08:10:00', 'Fam', 'Name', 'o', '1995-02-03', NULL, NULL, 3169317008),
(11, 1, '2017-07-17 08:20:00', 'рпрглгл', 'РОЛРОЛРОЛ', 'ОЛРОЛРОЛ', '2017-07-21', 'Vm0tBmu3KySG123WPiuX', '2017-07-16 16:00:19', NULL),
(12, 1, '2017-07-17 08:30:00', 'счмисмчи', 'счмисмчи', 'счмисмчи', '2017-07-16', 'oRqfTP350LHhTJ1WSEXN', '2017-07-16 18:32:30', NULL),
(13, 1, '2017-07-17 08:40:00', 'ewrtewrterwt', 'ewrtewrtewrt', 'erwterwtwert', '1991-01-01', NULL, NULL, 4408456438),
(14, 1, '2017-07-17 08:50:00', 'dsgasdg', 'asdgadsgas', 'asdgfadsg', '1991-01-01', NULL, NULL, 5530754283),
(15, 1, '2017-07-17 09:00:00', 'ewrtewrt', 'ewrtwert', 'ewrterwt', '1990-01-01', NULL, NULL, 9524551202),
(16, 1, '2017-07-17 09:10:00', 'dafasgf', 'asdg', 'asdgadsg', '1990-01-01', NULL, NULL, 5382703037),
(289, 1, '2017-07-17 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(290, 1, '2017-07-17 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(291, 1, '2017-07-17 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(292, 1, '2017-07-17 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(293, 1, '2017-07-17 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(294, 1, '2017-07-17 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(295, 1, '2017-07-17 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(296, 1, '2017-07-17 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(297, 1, '2017-07-17 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(298, 1, '2017-07-17 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(299, 1, '2017-07-17 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(300, 1, '2017-07-17 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(301, 6, '2017-07-17 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(302, 6, '2017-07-17 13:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(303, 6, '2017-07-17 13:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(304, 6, '2017-07-17 13:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(305, 6, '2017-07-17 13:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(306, 6, '2017-07-17 13:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(307, 6, '2017-07-17 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(308, 6, '2017-07-17 14:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(309, 6, '2017-07-17 14:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(310, 6, '2017-07-17 14:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(311, 6, '2017-07-17 14:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(312, 6, '2017-07-17 14:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(313, 6, '2017-07-17 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(314, 6, '2017-07-17 15:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(315, 6, '2017-07-17 15:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(316, 2, '2017-07-18 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(317, 2, '2017-07-18 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(318, 2, '2017-07-18 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(319, 2, '2017-07-18 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(320, 2, '2017-07-18 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(321, 2, '2017-07-18 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(322, 2, '2017-07-18 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(323, 2, '2017-07-18 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(324, 2, '2017-07-18 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(325, 2, '2017-07-18 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(326, 2, '2017-07-18 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(327, 2, '2017-07-18 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(328, 2, '2017-07-18 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(329, 2, '2017-07-18 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(330, 2, '2017-07-18 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(331, 7, '2017-07-18 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(332, 7, '2017-07-18 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(333, 7, '2017-07-18 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(334, 7, '2017-07-18 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(335, 7, '2017-07-18 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(336, 7, '2017-07-18 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(337, 7, '2017-07-18 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(338, 7, '2017-07-18 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(339, 7, '2017-07-18 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(340, 7, '2017-07-18 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(341, 7, '2017-07-18 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(342, 7, '2017-07-18 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(343, 7, '2017-07-18 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(344, 7, '2017-07-18 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(345, 7, '2017-07-18 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(346, 7, '2017-07-18 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(347, 7, '2017-07-18 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(348, 7, '2017-07-18 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(349, 7, '2017-07-18 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(350, 7, '2017-07-18 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(351, 7, '2017-07-18 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(352, 7, '2017-07-18 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(353, 7, '2017-07-18 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(354, 7, '2017-07-18 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(355, 7, '2017-07-18 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(356, 3, '2017-07-19 08:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(357, 3, '2017-07-19 08:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(358, 3, '2017-07-19 08:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(359, 3, '2017-07-19 08:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(360, 3, '2017-07-19 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(361, 3, '2017-07-19 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(362, 3, '2017-07-19 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(363, 3, '2017-07-19 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(364, 3, '2017-07-19 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(365, 3, '2017-07-19 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(366, 3, '2017-07-19 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(367, 3, '2017-07-19 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(368, 3, '2017-07-19 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(369, 3, '2017-07-19 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(370, 3, '2017-07-19 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(371, 3, '2017-07-19 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(372, 3, '2017-07-19 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(373, 3, '2017-07-19 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(374, 3, '2017-07-19 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(375, 3, '2017-07-19 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(376, 3, '2017-07-19 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(377, 3, '2017-07-19 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(378, 3, '2017-07-19 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(379, 3, '2017-07-19 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(380, 3, '2017-07-19 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(381, 3, '2017-07-19 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(382, 3, '2017-07-19 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(383, 3, '2017-07-19 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(384, 3, '2017-07-19 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(385, 3, '2017-07-19 13:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(386, 3, '2017-07-19 13:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(387, 3, '2017-07-19 13:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(388, 3, '2017-07-19 13:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(389, 3, '2017-07-19 13:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(390, 3, '2017-07-19 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(391, 8, '2017-07-19 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(392, 8, '2017-07-19 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(393, 8, '2017-07-19 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(394, 8, '2017-07-19 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(395, 8, '2017-07-19 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(396, 8, '2017-07-19 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(397, 8, '2017-07-19 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(398, 8, '2017-07-19 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(399, 8, '2017-07-19 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(400, 8, '2017-07-19 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(401, 4, '2017-07-20 08:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(402, 4, '2017-07-20 08:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(403, 4, '2017-07-20 08:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(404, 4, '2017-07-20 08:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(405, 4, '2017-07-20 08:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(406, 4, '2017-07-20 08:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(407, 4, '2017-07-20 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(408, 4, '2017-07-20 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(409, 4, '2017-07-20 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(410, 4, '2017-07-20 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(411, 9, '2017-07-20 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(412, 9, '2017-07-20 14:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(413, 9, '2017-07-20 14:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(414, 9, '2017-07-20 14:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(415, 9, '2017-07-20 14:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(416, 9, '2017-07-20 14:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(417, 9, '2017-07-20 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(418, 9, '2017-07-20 15:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(419, 9, '2017-07-20 15:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(420, 9, '2017-07-20 15:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(421, 9, '2017-07-20 15:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(422, 9, '2017-07-20 15:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(423, 9, '2017-07-20 16:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(424, 9, '2017-07-20 16:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(425, 9, '2017-07-20 16:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(426, 9, '2017-07-20 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(427, 9, '2017-07-20 16:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(428, 9, '2017-07-20 16:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(429, 9, '2017-07-20 17:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(430, 9, '2017-07-20 17:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(431, 5, '2017-07-21 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(432, 5, '2017-07-21 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(433, 5, '2017-07-21 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(434, 5, '2017-07-21 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(435, 5, '2017-07-21 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(436, 5, '2017-07-21 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(437, 5, '2017-07-21 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(438, 5, '2017-07-21 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(439, 5, '2017-07-21 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(440, 5, '2017-07-21 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(441, 10, '2017-07-21 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(442, 10, '2017-07-21 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(443, 10, '2017-07-21 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(444, 10, '2017-07-21 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(445, 10, '2017-07-21 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(446, 10, '2017-07-21 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(447, 10, '2017-07-21 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(448, 10, '2017-07-21 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(449, 10, '2017-07-21 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(450, 10, '2017-07-21 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(451, 10, '2017-07-21 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(452, 10, '2017-07-21 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(453, 10, '2017-07-21 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(454, 10, '2017-07-21 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(455, 10, '2017-07-21 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(456, 10, '2017-07-22 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(457, 10, '2017-07-22 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(458, 10, '2017-07-22 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(459, 10, '2017-07-22 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(460, 10, '2017-07-22 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(461, 10, '2017-07-22 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(462, 10, '2017-07-22 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(463, 10, '2017-07-22 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(464, 10, '2017-07-22 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(465, 10, '2017-07-22 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(466, 10, '2017-07-22 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(467, 10, '2017-07-22 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(468, 10, '2017-07-22 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(469, 10, '2017-07-22 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(470, 10, '2017-07-22 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(471, 10, '2017-07-23 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(472, 10, '2017-07-23 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(473, 10, '2017-07-23 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(474, 10, '2017-07-23 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(475, 10, '2017-07-23 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(476, 10, '2017-07-23 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(477, 10, '2017-07-23 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(478, 10, '2017-07-23 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(479, 10, '2017-07-23 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(480, 10, '2017-07-23 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(481, 10, '2017-07-23 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(482, 10, '2017-07-23 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(483, 10, '2017-07-23 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(484, 10, '2017-07-23 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(485, 10, '2017-07-23 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(486, 1, '2017-07-24 08:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(487, 1, '2017-07-24 08:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(488, 1, '2017-07-24 08:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(489, 1, '2017-07-24 08:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(490, 1, '2017-07-24 08:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(491, 1, '2017-07-24 08:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(492, 1, '2017-07-24 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(493, 1, '2017-07-24 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(494, 1, '2017-07-24 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(495, 1, '2017-07-24 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(496, 1, '2017-07-24 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(497, 1, '2017-07-24 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(498, 1, '2017-07-24 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(499, 1, '2017-07-24 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(500, 1, '2017-07-24 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(501, 1, '2017-07-24 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(502, 1, '2017-07-24 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(503, 1, '2017-07-24 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(504, 1, '2017-07-24 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(505, 1, '2017-07-24 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(506, 6, '2017-07-24 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(507, 6, '2017-07-24 13:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(508, 6, '2017-07-24 13:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(509, 6, '2017-07-24 13:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(510, 6, '2017-07-24 13:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(511, 6, '2017-07-24 13:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(512, 6, '2017-07-24 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(513, 6, '2017-07-24 14:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(514, 6, '2017-07-24 14:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(515, 6, '2017-07-24 14:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(516, 6, '2017-07-24 14:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(517, 6, '2017-07-24 14:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(518, 6, '2017-07-24 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(519, 6, '2017-07-24 15:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(520, 6, '2017-07-24 15:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

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

DELIMITER $$
--
-- Події
--
CREATE DEFINER=`cs50`@`localhost` EVENT `generate_appoints` ON SCHEDULE EVERY 1 DAY STARTS '2017-07-17 00:00:01' ON COMPLETION PRESERVE ENABLE COMMENT 'генерация талонов по расписанию' DO call gen_appoints()$$

DELIMITER ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
