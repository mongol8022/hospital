-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Хост: 127.0.0.1
-- Час створення: Лип 25 2017 р., 09:30
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
	DECLARE SchedWorkplace INT;
	DECLARE done INT default 0;
	DECLARE workplace_cur INT default 0;
	DECLARE talon_num SMALLINT default 1;
	DECLARE SchedCursor CURSOR FOR SELECT schedule.id, schedule.count, schedule.time_begin, services.duration, schedule.worplace_id FROM schedule, services WHERE schedule.service_id = services.id and schedule.valid_from <= date_incr and (schedule.valid_to is NULL or schedule.valid_to >= date_incr) and weekday(date_incr) = schedule.week_day ORDER BY worplace_id, time_begin;
	DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done=1;	
	WHILE day_incr < 8 DO
		SELECT CURDATE() + INTERVAL day_incr DAY INTO date_incr;		
		SET done = 0;
		OPEN SchedCursor;		
		WHILE done = 0 DO 
			FETCH SchedCursor INTO SchedId,SchedCount,SchedTime,SchedDuration, SchedWorkplace;
			IF  workplace_cur <> SchedWorkplace THEN 
				SET workplace_cur = SchedWorkplace;
				SET talon_num = 1;
			END IF;
			SET count_incr = 0;
			WHILE count_incr < SchedCount DO
				SELECT ADDTIME(STR_TO_DATE(CONCAT(date_incr, ' ', '00:00:00'), '%Y-%m-%d %H:%i:%s'), SchedTime) + INTERVAL count_incr*SchedDuration MINUTE INTO datetime_incr;
				INSERT INTO queues (schedule_id, time_begin, ticket_num) SELECT * FROM (SELECT SchedId, datetime_incr, talon_num) AS tmp
WHERE NOT EXISTS (select id from queues where schedule_id = SchedId and time_begin = datetime_incr and ticket_num = talon_num);
				SET count_incr = count_incr + 1;
				SET talon_num = talon_num + 1;
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
  UNIQUE KEY `name` (`name`,`firm_id`),
  KEY `firm_id` (`firm_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=34 ;

--
-- Дамп даних таблиці `departments`
--

INSERT INTO `departments` (`id`, `name`, `firm_id`, `info`) VALUES
(1, 'test. Терапевтическое отделение', 1, NULL),
(2, 'test. Офтальмологическое отделение', 1, NULL),
(3, 'Хирургическое отделение', 1, NULL),
(4, 'Неврологическое отделение', 1, NULL),
(5, 'Офтальмологическое отделение', 1, NULL),
(6, 'Отоларингологическое отделение', 1, NULL),
(7, 'Эндокринологическое отделение', 1, NULL),
(8, 'Кардиологическое отделение', 1, NULL),
(9, 'Травматологическое отделение', 1, NULL),
(10, 'Гинекологическое отделение', 1, NULL),
(11, 'Инфекционное отделение', 1, NULL),
(12, 'Кабинет функциональной диагностики', 1, NULL),
(13, 'Терапевтическое отделение', 1, NULL),
(14, 'Терапевтическое отделение', 2, NULL),
(15, 'Неврологическое отделение', 2, NULL),
(16, 'Отделение врачей общей практики', 2, NULL),
(17, 'Педиатрическое отделение', 2, NULL),
(18, 'Хирургическое отделение', 3, NULL),
(19, 'Травматологическое отделение', 3, NULL),
(20, 'Урологическое отделение', 3, NULL),
(21, 'Отоларингологическое отделение', 3, NULL),
(22, 'Эндокринологическое отделение', 3, NULL),
(23, 'Кардиологическое отделение', 3, NULL),
(24, 'Ревматологическое отделение', 3, NULL),
(25, 'Пульмонологическое отделение', 3, NULL),
(26, 'Офтальмологическое отделение', 3, NULL),
(27, 'Гастроэнтерологическое отделение', 3, NULL),
(28, 'Терапевтическое отделение', 3, NULL),
(29, 'Инфекционное отделение', 3, NULL),
(31, 'Гематологическое отделение', 3, NULL),
(32, 'Аллергологическое отделение', 3, NULL),
(33, 'Неврологическое отделение', 3, NULL);

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Дамп даних таблиці `firms`
--

INSERT INTO `firms` (`id`, `name`, `postindex`, `city_id`, `street`, `house`, `room`, `info`) VALUES
(1, 'Городская больница №1', 84307, 1, ' ул. О. Тихого', 17, NULL, '<div class="text-hosp-information">\n                            <h5><b>Адрес:</b> г. Краматорск, ул. О. Тихого, 17.</h5>\n                            <h5><b>Телефоны:</b></h5>\n                                <ul>\n                                    <li>Приемная (06264) 41-78-25</li>\n                                    <li>Регистратура поликлиники (050) 756-92-01</li>\n                                    <li>Санпропускник хирургии (06264) 41-81-72</li>\n                                    <li>Санпропускник роддома (06264) 41-84-02</li>\n                                </ul>\n                            <h5><b>Время работы:</b></h5>\n                            <ul>\n                                <li>с 7:00 до 16.00 - в течении недели</li> \n                                <li>с 7:00 до 12 - в субботу</li> \n                                <li>выходной - воскресенье</li>\n                            </ul>\n                        </div>\n                        <div class="frame">\n                            <h5><b>Расположение на карте</b></h5>\n                        <iframe src="https://www.google.com/maps/embed?pb=!1m16!1m12!1m3!1d2632.094489461981!2d37.562886541676754!3d48.722786143333344!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!2m1!1z0LHQvtC70YzQvdC40YbQsCAxINC60YDQsNC80LDRgtC-0YDRgdC6!5e0!3m2!1sru!2sua!4v1500322409448" width="400" height="300" frameborder="0" style="border:0;" allowfullscreen ></iframe>\n                        </div>'),
(2, 'Городская больница №2', 84306, 1, 'ул. Днепропетровская', 14, NULL, '<div class="text-hosp-information">\n                            <h5><b>Адрес:</b> г. Краматорск, ул. ул. Днепропетровская, д. 17.</h5>\n                            <h5><b>Телефоны:</b></h5>\n                                <ul>\n                                    <li>Приемная (06264) 6-64-11</li>\n                                    <li>Регистратура поликлиники (050) 958-83-12</li>\n                                    <li>Терапия (06264) 6-95-75</li>\n                                    <li>Женская консультация (06264) 6-33-25</li>\n                                </ul>\n                            <h5><b>Время работы:</b></h5>\n                            <ul>\n                                <li>с 7:00 до 16.00 - в течении недели</li> \n                                <li>с 7:00 до 12 - в субботу</li> \n                                <li>выходной - воскресенье</li>\n                            </ul>\n                        </div>\n                        <div class="frame">\n                            <h5><b>Расположение на карте</b></h5>\n                        <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d1105.784567560741!2d37.59429425412655!3d48.762533709257134!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x40df9737e79c4177%3A0x5ef17f7f79421b6a!2z0JPQvtGA0LHQvtC70YzQvdC40YbQsCDihJYgMiDQs9C-0YDQvtC0INCa0YDQsNC80LDRgtC-0YDRgdC60LAsINCy0YPQu9C40YbRjyDQlNC90ZbQv9GA0L7QstGB0YzQutCwLCAxNywg0JrRgNCw0LzQsNGC0L7RgNGB0YzQuiwg0JTQvtC90LXRhtGM0LrQsCDQvtCx0LvQsNGB0YLRjCwgODQzMDA!5e0!3m2!1sru!2sua!4v1500491690323" width="400" height="300" frameborder="0" style="border:0" allowfullscreen></iframe>\n                        </div>'),
(3, 'Городская больница №3', 84300, 1, 'ул. Героев Украины', 31, NULL, '<div class="text-hosp-information">\n                            <h5><b>Адрес:</b> г. Краматорск, ул. Героев Украины</h5>\n                            <h5><b>Телефоны:</b></h5>\n                                <ul>\n                                    <li>Приемная (06264) 3-24-35</li>\n                                    <li>Регистратура поликлиники (06264)3-42-14, (095) 689-16-00</li>\n                                </ul>\n                            <h5><b>Время работы:</b></h5>\n                            <ul>\n                                <li>с 7:00 до 16.00 - в течении недели</li> \n                                <li>с 7:00 до 12 - в субботу</li> \n                                <li>выходной - воскресенье</li>\n                            </ul>\n                        </div>\n                        <div class="frame">\n                            <h5><b>Расположение на карте</b></h5>\n                        <iframe src="https://www.google.com/maps/embed?pb=!1m16!1m12!1m3!1d1106.1948310610069!2d37.59729910748491!3d48.743896829578006!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!2m1!1z0JrRgNCw0LzQsNGC0L7RgNGB0LosINCx0L7Qu9GM0L3QuNGG0LAgMw!5e0!3m2!1sru!2sua!4v1500491948938" width="400" height="300" frameborder="0" style="border:0" allowfullscreen></iframe>\n                        </div>');

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
  `ticket_num` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `confirm_code` (`confirm_code`),
  UNIQUE KEY `cancel_code` (`cancel_code`),
  KEY `schedule_id` (`schedule_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1131 ;

--
-- Дамп даних таблиці `queues`
--

INSERT INTO `queues` (`id`, `schedule_id`, `time_begin`, `person_surname`, `person_name`, `person_lastname`, `date_born`, `confirm_code`, `confirm_time`, `cancel_code`, `ticket_num`) VALUES
(1, 5, '2017-07-14 08:00:00', '', '', '', NULL, NULL, NULL, NULL, NULL),
(2, 5, '2017-07-14 08:10:00', '', '', '', NULL, NULL, NULL, NULL, NULL),
(3, 5, '2017-07-14 08:20:00', '', '', '', NULL, NULL, NULL, NULL, NULL),
(4, 5, '2017-07-14 08:30:00', '', '', '', NULL, NULL, NULL, NULL, NULL),
(5, 5, '2017-07-14 08:40:00', '', '', '', NULL, NULL, NULL, NULL, NULL),
(6, 5, '2017-07-14 08:50:00', '', '', '', NULL, NULL, NULL, NULL, NULL),
(7, 5, '2017-07-14 13:00:00', '', '', '', NULL, NULL, NULL, NULL, NULL),
(8, 5, '2017-07-14 13:10:00', '', '', '', NULL, NULL, NULL, NULL, NULL),
(9, 1, '2017-07-17 08:00:00', 'awetrqwtr', 'dsfgdfsgdfsg', 'dfsgdfsg', '2017-07-10', NULL, NULL, 8589491765, NULL),
(10, 1, '2017-07-17 08:10:00', 'Fam', 'Name', 'o', '1995-02-03', NULL, NULL, 3169317008, NULL),
(11, 1, '2017-07-17 08:20:00', 'рпрглгл', 'РОЛРОЛРОЛ', 'ОЛРОЛРОЛ', '2017-07-21', 'Vm0tBmu3KySG123WPiuX', '2017-07-16 16:00:19', NULL, NULL),
(12, 1, '2017-07-17 08:30:00', 'счмисмчи', 'счмисмчи', 'счмисмчи', '2017-07-16', 'oRqfTP350LHhTJ1WSEXN', '2017-07-16 18:32:30', NULL, NULL),
(13, 1, '2017-07-17 08:40:00', 'ewrtewrterwt', 'ewrtewrtewrt', 'erwterwtwert', '1991-01-01', NULL, NULL, 4408456438, NULL),
(14, 1, '2017-07-17 08:50:00', 'dsgasdg', 'asdgadsgas', 'asdgfadsg', '1991-01-01', NULL, NULL, 5530754283, NULL),
(15, 1, '2017-07-17 09:00:00', 'ewrtewrt', 'ewrtwert', 'ewrterwt', '1990-01-01', NULL, NULL, 9524551202, NULL),
(16, 1, '2017-07-17 09:10:00', 'dafasgf', 'asdg', 'asdgadsg', '1990-01-01', NULL, NULL, 5382703037, NULL),
(289, 1, '2017-07-17 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(290, 1, '2017-07-17 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(291, 1, '2017-07-17 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(292, 1, '2017-07-17 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(293, 1, '2017-07-17 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(294, 1, '2017-07-17 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(295, 1, '2017-07-17 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(296, 1, '2017-07-17 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(297, 1, '2017-07-17 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(298, 1, '2017-07-17 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(299, 1, '2017-07-17 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(300, 1, '2017-07-17 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(301, 6, '2017-07-17 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(302, 6, '2017-07-17 13:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(303, 6, '2017-07-17 13:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(304, 6, '2017-07-17 13:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(305, 6, '2017-07-17 13:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(306, 6, '2017-07-17 13:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(307, 6, '2017-07-17 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(308, 6, '2017-07-17 14:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(309, 6, '2017-07-17 14:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(310, 6, '2017-07-17 14:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(311, 6, '2017-07-17 14:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(312, 6, '2017-07-17 14:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(313, 6, '2017-07-17 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(314, 6, '2017-07-17 15:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(315, 6, '2017-07-17 15:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(316, 2, '2017-07-18 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(317, 2, '2017-07-18 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(318, 2, '2017-07-18 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(319, 2, '2017-07-18 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(320, 2, '2017-07-18 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(321, 2, '2017-07-18 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(322, 2, '2017-07-18 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(323, 2, '2017-07-18 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(324, 2, '2017-07-18 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(325, 2, '2017-07-18 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(326, 2, '2017-07-18 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(327, 2, '2017-07-18 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(328, 2, '2017-07-18 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(329, 2, '2017-07-18 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(330, 2, '2017-07-18 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(331, 7, '2017-07-18 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(332, 7, '2017-07-18 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(333, 7, '2017-07-18 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(334, 7, '2017-07-18 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(335, 7, '2017-07-18 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(336, 7, '2017-07-18 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(337, 7, '2017-07-18 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(338, 7, '2017-07-18 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(339, 7, '2017-07-18 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(340, 7, '2017-07-18 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(341, 7, '2017-07-18 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(342, 7, '2017-07-18 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(343, 7, '2017-07-18 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(344, 7, '2017-07-18 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(345, 7, '2017-07-18 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(346, 7, '2017-07-18 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(347, 7, '2017-07-18 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(348, 7, '2017-07-18 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(349, 7, '2017-07-18 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(350, 7, '2017-07-18 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(351, 7, '2017-07-18 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(352, 7, '2017-07-18 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(353, 7, '2017-07-18 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(354, 7, '2017-07-18 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(355, 7, '2017-07-18 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(356, 3, '2017-07-19 08:20:00', 'wqeqwef', 'ewrgqewgtrqw', 'qwetrqwetrqew', '1991-01-01', NULL, NULL, NULL, NULL),
(357, 3, '2017-07-19 08:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(358, 3, '2017-07-19 08:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(359, 3, '2017-07-19 08:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(360, 3, '2017-07-19 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(361, 3, '2017-07-19 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(362, 3, '2017-07-19 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(363, 3, '2017-07-19 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(364, 3, '2017-07-19 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(365, 3, '2017-07-19 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(366, 3, '2017-07-19 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(367, 3, '2017-07-19 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(368, 3, '2017-07-19 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(369, 3, '2017-07-19 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(370, 3, '2017-07-19 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(371, 3, '2017-07-19 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(372, 3, '2017-07-19 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(373, 3, '2017-07-19 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(374, 3, '2017-07-19 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(375, 3, '2017-07-19 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(376, 3, '2017-07-19 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(377, 3, '2017-07-19 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(378, 3, '2017-07-19 12:00:00', 'Hgufufuf', 'Hfyfydyf', 'Ufydyfd', '2017-07-07', NULL, NULL, NULL, NULL),
(379, 3, '2017-07-19 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(380, 3, '2017-07-19 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(381, 3, '2017-07-19 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(382, 3, '2017-07-19 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(383, 3, '2017-07-19 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(384, 3, '2017-07-19 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(385, 3, '2017-07-19 13:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(386, 3, '2017-07-19 13:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(387, 3, '2017-07-19 13:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(388, 3, '2017-07-19 13:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(389, 3, '2017-07-19 13:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(390, 3, '2017-07-19 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(391, 8, '2017-07-19 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(392, 8, '2017-07-19 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(393, 8, '2017-07-19 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(394, 8, '2017-07-19 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(395, 8, '2017-07-19 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(396, 8, '2017-07-19 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(397, 8, '2017-07-19 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(398, 8, '2017-07-19 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(399, 8, '2017-07-19 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(400, 8, '2017-07-19 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(401, 4, '2017-07-20 08:00:00', 'asdfadsf', 'asdasdf', 'asdfasdf', '1998-01-01', NULL, NULL, 7098700347, NULL),
(402, 4, '2017-07-20 08:10:00', 'kj3jh4234', 'sfegsfdgsdf', 'werwegfrg', '1991-01-01', NULL, NULL, 4784600227, NULL),
(403, 4, '2017-07-20 08:20:00', '1', '1', '1', '2001-01-01', NULL, NULL, 6486785589, NULL),
(404, 4, '2017-07-20 08:30:00', 'шгншгнгшн', 'шгщшгщшг', 'лшдллдолд', '2001-10-11', NULL, NULL, 5747808700, NULL),
(405, 4, '2017-07-20 08:40:00', '2234213', '21342314', '23142134', '0000-00-00', 'GT1YWXJMR6xZ62Ubvd03', '2017-07-19 13:29:45', NULL, NULL),
(406, 4, '2017-07-20 08:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(407, 4, '2017-07-20 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(408, 4, '2017-07-20 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(409, 4, '2017-07-20 09:20:00', 'Пономарьов', 'Максим', 'Анатолійович', '1994-06-02', NULL, NULL, 6160419916, NULL),
(410, 4, '2017-07-20 09:30:00', 'Пономарьов', 'Максим', 'Анатолійович', '1994-06-02', NULL, NULL, 4355309069, NULL),
(411, 9, '2017-07-20 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(412, 9, '2017-07-20 14:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(413, 9, '2017-07-20 14:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(414, 9, '2017-07-20 14:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(415, 9, '2017-07-20 14:40:00', 'grhrgfh', 'ertherth', 'erther', '1991-01-01', NULL, NULL, 741989655, NULL),
(416, 9, '2017-07-20 14:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(417, 9, '2017-07-20 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(418, 9, '2017-07-20 15:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(419, 9, '2017-07-20 15:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(420, 9, '2017-07-20 15:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(421, 9, '2017-07-20 15:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(422, 9, '2017-07-20 15:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(423, 9, '2017-07-20 16:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(424, 9, '2017-07-20 16:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(425, 9, '2017-07-20 16:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(426, 9, '2017-07-20 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(427, 9, '2017-07-20 16:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(428, 9, '2017-07-20 16:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(429, 9, '2017-07-20 17:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(430, 9, '2017-07-20 17:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(431, 5, '2017-07-21 11:30:00', '14234', '12342134', '21341234', '1991-01-01', NULL, NULL, 4901729545, NULL),
(432, 5, '2017-07-21 11:40:00', 'egsfg', 'sdfgsdfg', 'dsfgsdfg', '1991-01-01', NULL, NULL, 7804717145, NULL),
(433, 5, '2017-07-21 11:50:00', 'qwrewer', 'wqerqwerqwe', 'qwerqwer', '1991-01-01', NULL, NULL, 6217638260, NULL),
(434, 5, '2017-07-21 12:00:00', 'Пономарьов', 'Максим', 'Пономарьов', '1994-06-02', NULL, NULL, 1466131324, NULL),
(435, 5, '2017-07-21 12:10:00', 'reety', 'retyt', 'retyty', '1991-01-01', NULL, NULL, 9657762137, NULL),
(436, 5, '2017-07-21 12:20:00', 'qwffg', 'werwergw', 'wergwerg', '1961-01-01', NULL, NULL, 170089282, NULL),
(437, 5, '2017-07-21 12:30:00', 'dfwd', 'qweqwer', 'qwerqwer', '1991-01-01', NULL, NULL, 8695011785, NULL),
(438, 5, '2017-07-21 12:40:00', 'agasfg', 'sdfsdfgsd', 'fgsdfgsdfg', '1991-01-01', NULL, NULL, 8578524670, NULL),
(439, 5, '2017-07-21 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(440, 5, '2017-07-21 13:00:00', 'Hgufufuf', 'Hfyfydyf', 'Ufydyfd', '2017-07-04', NULL, NULL, 1251971796, NULL),
(441, 10, '2017-07-21 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(442, 10, '2017-07-21 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(443, 10, '2017-07-21 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(444, 10, '2017-07-21 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(445, 10, '2017-07-21 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(446, 10, '2017-07-21 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(447, 10, '2017-07-21 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(448, 10, '2017-07-21 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(449, 10, '2017-07-21 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(450, 10, '2017-07-21 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(451, 10, '2017-07-21 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(452, 10, '2017-07-21 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(453, 10, '2017-07-21 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(454, 10, '2017-07-21 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(455, 10, '2017-07-21 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(456, 10, '2017-07-22 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(457, 10, '2017-07-22 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(458, 10, '2017-07-22 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(459, 10, '2017-07-22 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(460, 10, '2017-07-22 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(461, 10, '2017-07-22 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(462, 10, '2017-07-22 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(463, 10, '2017-07-22 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(464, 10, '2017-07-22 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(465, 10, '2017-07-22 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(466, 10, '2017-07-22 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(467, 10, '2017-07-22 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(468, 10, '2017-07-22 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(469, 10, '2017-07-22 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(470, 10, '2017-07-22 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(471, 10, '2017-07-23 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(472, 10, '2017-07-23 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(473, 10, '2017-07-23 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(474, 10, '2017-07-23 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(475, 10, '2017-07-23 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(476, 10, '2017-07-23 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(477, 10, '2017-07-23 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(478, 10, '2017-07-23 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(479, 10, '2017-07-23 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(480, 10, '2017-07-23 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(481, 10, '2017-07-23 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(482, 10, '2017-07-23 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(483, 10, '2017-07-23 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(484, 10, '2017-07-23 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(485, 10, '2017-07-23 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(486, 1, '2017-07-24 08:00:00', '12341234', '2134123421', '21341234', '1991-01-01', 'Ua3Kxgoq6L3cDUCUZVDs', '2017-07-19 12:52:07', 1097123551, NULL),
(487, 1, '2017-07-24 08:10:00', '1', '123', '11', '1991-01-01', 'pNLczKDwKdSz3T4GGtxv', '2017-07-24 00:40:31', NULL, NULL),
(488, 1, '2017-07-24 08:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(489, 1, '2017-07-24 08:30:00', '1223', '112333', '112233', '1981-01-01', NULL, NULL, 5022168008, NULL),
(490, 1, '2017-07-24 08:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(491, 1, '2017-07-24 08:50:00', 'цувйцук', 'йцукйцук', 'йцукйцук', '1991-01-01', NULL, NULL, 1957037716, NULL),
(492, 1, '2017-07-24 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(493, 1, '2017-07-24 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(494, 1, '2017-07-24 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(495, 1, '2017-07-24 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(496, 1, '2017-07-24 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(497, 1, '2017-07-24 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(498, 1, '2017-07-24 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(499, 1, '2017-07-24 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(500, 1, '2017-07-24 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(501, 1, '2017-07-24 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(502, 1, '2017-07-24 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(503, 1, '2017-07-24 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(504, 1, '2017-07-24 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(505, 1, '2017-07-24 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(506, 6, '2017-07-24 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(507, 6, '2017-07-24 13:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(508, 6, '2017-07-24 13:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(509, 6, '2017-07-24 13:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(510, 6, '2017-07-24 13:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(511, 6, '2017-07-24 13:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(512, 6, '2017-07-24 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(513, 6, '2017-07-24 14:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(514, 6, '2017-07-24 14:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(515, 6, '2017-07-24 14:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(516, 6, '2017-07-24 14:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(517, 6, '2017-07-24 14:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(518, 6, '2017-07-24 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(519, 6, '2017-07-24 15:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(520, 6, '2017-07-24 15:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(521, 2, '2017-07-25 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(522, 2, '2017-07-25 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(523, 2, '2017-07-25 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(524, 2, '2017-07-25 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(525, 2, '2017-07-25 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(526, 2, '2017-07-25 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(527, 2, '2017-07-25 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(528, 2, '2017-07-25 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(529, 2, '2017-07-25 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(530, 2, '2017-07-25 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(531, 2, '2017-07-25 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(532, 2, '2017-07-25 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(533, 2, '2017-07-25 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(534, 2, '2017-07-25 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(535, 2, '2017-07-25 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(536, 7, '2017-07-25 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(537, 7, '2017-07-25 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(538, 7, '2017-07-25 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(539, 7, '2017-07-25 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(540, 7, '2017-07-25 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(541, 7, '2017-07-25 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(542, 7, '2017-07-25 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(543, 7, '2017-07-25 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(544, 7, '2017-07-25 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(545, 7, '2017-07-25 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(546, 7, '2017-07-25 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(547, 7, '2017-07-25 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(548, 7, '2017-07-25 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(549, 7, '2017-07-25 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(550, 7, '2017-07-25 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(551, 7, '2017-07-25 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(552, 7, '2017-07-25 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(553, 7, '2017-07-25 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(554, 7, '2017-07-25 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(555, 7, '2017-07-25 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(556, 7, '2017-07-25 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(557, 7, '2017-07-25 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(558, 7, '2017-07-25 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(559, 7, '2017-07-25 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(560, 7, '2017-07-25 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(776, 2, '2017-07-25 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(777, 2, '2017-07-25 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(778, 2, '2017-07-25 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(779, 2, '2017-07-25 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(780, 2, '2017-07-25 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(781, 2, '2017-07-25 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(782, 2, '2017-07-25 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(783, 2, '2017-07-25 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(784, 2, '2017-07-25 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(785, 2, '2017-07-25 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(786, 2, '2017-07-25 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(787, 2, '2017-07-25 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(788, 2, '2017-07-25 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(789, 2, '2017-07-25 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(790, 2, '2017-07-25 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(791, 7, '2017-07-25 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(792, 7, '2017-07-25 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(793, 7, '2017-07-25 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(794, 7, '2017-07-25 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(795, 7, '2017-07-25 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(796, 7, '2017-07-25 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(797, 7, '2017-07-25 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(798, 7, '2017-07-25 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(799, 7, '2017-07-25 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(800, 7, '2017-07-25 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(801, 7, '2017-07-25 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(802, 7, '2017-07-25 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(803, 7, '2017-07-25 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(804, 7, '2017-07-25 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(805, 7, '2017-07-25 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(806, 7, '2017-07-25 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(807, 7, '2017-07-25 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(808, 7, '2017-07-25 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(809, 7, '2017-07-25 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(810, 7, '2017-07-25 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(811, 7, '2017-07-25 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21),
(812, 7, '2017-07-25 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22),
(813, 7, '2017-07-25 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 23),
(814, 7, '2017-07-25 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 24),
(815, 7, '2017-07-25 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25),
(816, 7, '2017-07-25 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26),
(817, 7, '2017-07-25 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 27),
(818, 7, '2017-07-25 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28),
(819, 7, '2017-07-25 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 29),
(820, 7, '2017-07-25 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30),
(821, 7, '2017-07-25 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 31),
(822, 7, '2017-07-25 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 32),
(823, 7, '2017-07-25 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 33),
(824, 7, '2017-07-25 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 34),
(825, 7, '2017-07-25 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 35),
(826, 7, '2017-07-25 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 36),
(827, 7, '2017-07-25 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 37),
(828, 7, '2017-07-25 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 38),
(829, 7, '2017-07-25 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 39),
(830, 7, '2017-07-25 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 40),
(831, 7, '2017-07-25 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 41),
(832, 7, '2017-07-25 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 42),
(833, 7, '2017-07-25 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 43),
(834, 7, '2017-07-25 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 44),
(835, 7, '2017-07-25 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 45),
(836, 7, '2017-07-25 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 46),
(837, 7, '2017-07-25 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 47),
(838, 7, '2017-07-25 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 48),
(839, 7, '2017-07-25 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 49),
(840, 7, '2017-07-25 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 50),
(841, 3, '2017-07-26 08:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(842, 3, '2017-07-26 08:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(843, 3, '2017-07-26 08:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(844, 3, '2017-07-26 08:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(845, 3, '2017-07-26 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(846, 3, '2017-07-26 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(847, 3, '2017-07-26 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(848, 3, '2017-07-26 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(849, 3, '2017-07-26 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(850, 3, '2017-07-26 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(851, 3, '2017-07-26 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(852, 3, '2017-07-26 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(853, 3, '2017-07-26 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(854, 3, '2017-07-26 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(855, 3, '2017-07-26 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(856, 3, '2017-07-26 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(857, 3, '2017-07-26 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(858, 3, '2017-07-26 11:10:00', 'tyrty', 'ertyet', 'ertyt', '1991-01-01', NULL, NULL, 9710214151, 18),
(859, 3, '2017-07-26 11:20:00', '1432341', '2341234', '12341234', '1991-01-01', NULL, NULL, 1611919612, 19),
(860, 3, '2017-07-26 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(861, 3, '2017-07-26 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21),
(862, 3, '2017-07-26 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22),
(863, 3, '2017-07-26 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 23),
(864, 3, '2017-07-26 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 24),
(865, 3, '2017-07-26 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25),
(866, 3, '2017-07-26 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26),
(867, 3, '2017-07-26 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 27),
(868, 3, '2017-07-26 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28),
(869, 3, '2017-07-26 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 29),
(870, 3, '2017-07-26 13:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30),
(871, 3, '2017-07-26 13:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 31),
(872, 3, '2017-07-26 13:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 32),
(873, 3, '2017-07-26 13:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 33),
(874, 3, '2017-07-26 13:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 34),
(875, 3, '2017-07-26 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 35),
(876, 8, '2017-07-26 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(877, 8, '2017-07-26 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(878, 8, '2017-07-26 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(879, 8, '2017-07-26 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(880, 8, '2017-07-26 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(881, 8, '2017-07-26 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(882, 8, '2017-07-26 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(883, 8, '2017-07-26 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(884, 8, '2017-07-26 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(885, 8, '2017-07-26 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(886, 8, '2017-07-26 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(887, 8, '2017-07-26 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(888, 8, '2017-07-26 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(889, 8, '2017-07-26 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(890, 8, '2017-07-26 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(891, 8, '2017-07-26 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(892, 8, '2017-07-26 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(893, 8, '2017-07-26 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(894, 8, '2017-07-26 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(895, 8, '2017-07-26 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(896, 4, '2017-07-27 08:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(897, 4, '2017-07-27 08:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(898, 4, '2017-07-27 08:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(899, 4, '2017-07-27 08:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(900, 4, '2017-07-27 08:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(901, 4, '2017-07-27 08:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(902, 4, '2017-07-27 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(903, 4, '2017-07-27 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(904, 4, '2017-07-27 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(905, 4, '2017-07-27 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(906, 9, '2017-07-27 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(907, 9, '2017-07-27 14:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(908, 9, '2017-07-27 14:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(909, 9, '2017-07-27 14:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(910, 9, '2017-07-27 14:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(911, 9, '2017-07-27 14:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(912, 9, '2017-07-27 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(913, 9, '2017-07-27 15:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(914, 9, '2017-07-27 15:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(915, 9, '2017-07-27 15:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(916, 9, '2017-07-27 15:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(917, 9, '2017-07-27 15:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(918, 9, '2017-07-27 16:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(919, 9, '2017-07-27 16:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(920, 9, '2017-07-27 16:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(921, 9, '2017-07-27 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(922, 9, '2017-07-27 16:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(923, 9, '2017-07-27 16:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(924, 9, '2017-07-27 17:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(925, 9, '2017-07-27 17:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(926, 9, '2017-07-27 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21),
(927, 9, '2017-07-27 14:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22),
(928, 9, '2017-07-27 14:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 23),
(929, 9, '2017-07-27 14:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 24),
(930, 9, '2017-07-27 14:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25),
(931, 9, '2017-07-27 14:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26),
(932, 9, '2017-07-27 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 27),
(933, 9, '2017-07-27 15:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28),
(934, 9, '2017-07-27 15:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 29),
(935, 9, '2017-07-27 15:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30),
(936, 9, '2017-07-27 15:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 31),
(937, 9, '2017-07-27 15:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 32),
(938, 9, '2017-07-27 16:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 33),
(939, 9, '2017-07-27 16:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 34),
(940, 9, '2017-07-27 16:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 35),
(941, 9, '2017-07-27 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 36),
(942, 9, '2017-07-27 16:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 37),
(943, 9, '2017-07-27 16:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 38),
(944, 9, '2017-07-27 17:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 39),
(945, 9, '2017-07-27 17:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 40),
(946, 5, '2017-07-28 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(947, 5, '2017-07-28 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(948, 5, '2017-07-28 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(949, 5, '2017-07-28 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(950, 5, '2017-07-28 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(951, 5, '2017-07-28 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(952, 5, '2017-07-28 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(953, 5, '2017-07-28 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(954, 5, '2017-07-28 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(955, 5, '2017-07-28 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(956, 10, '2017-07-28 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(957, 10, '2017-07-28 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(958, 10, '2017-07-28 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(959, 10, '2017-07-28 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(960, 10, '2017-07-28 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(961, 10, '2017-07-28 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(962, 10, '2017-07-28 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(963, 10, '2017-07-28 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(964, 10, '2017-07-28 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(965, 10, '2017-07-28 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(966, 10, '2017-07-28 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(967, 10, '2017-07-28 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(968, 10, '2017-07-28 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(969, 10, '2017-07-28 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(970, 10, '2017-07-28 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(971, 10, '2017-07-28 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(972, 10, '2017-07-28 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(973, 10, '2017-07-28 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(974, 10, '2017-07-28 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(975, 10, '2017-07-28 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(976, 10, '2017-07-28 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21),
(977, 10, '2017-07-28 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22),
(978, 10, '2017-07-28 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 23),
(979, 10, '2017-07-28 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 24),
(980, 10, '2017-07-28 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25),
(981, 10, '2017-07-28 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26),
(982, 10, '2017-07-28 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 27),
(983, 10, '2017-07-28 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28),
(984, 10, '2017-07-28 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 29),
(985, 10, '2017-07-28 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30),
(986, 10, '2017-07-29 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 31),
(987, 10, '2017-07-29 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 32),
(988, 10, '2017-07-29 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 33),
(989, 10, '2017-07-29 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 34),
(990, 10, '2017-07-29 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 35),
(991, 10, '2017-07-29 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 36),
(992, 10, '2017-07-29 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 37),
(993, 10, '2017-07-29 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 38),
(994, 10, '2017-07-29 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 39),
(995, 10, '2017-07-29 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 40),
(996, 10, '2017-07-29 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 41),
(997, 10, '2017-07-29 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 42),
(998, 10, '2017-07-29 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 43),
(999, 10, '2017-07-29 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 44),
(1000, 10, '2017-07-29 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 45),
(1001, 10, '2017-07-30 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 46),
(1002, 10, '2017-07-30 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 47),
(1003, 10, '2017-07-30 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 48),
(1004, 10, '2017-07-30 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 49),
(1005, 10, '2017-07-30 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 50),
(1006, 10, '2017-07-30 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 51),
(1007, 10, '2017-07-30 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 52),
(1008, 10, '2017-07-30 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 53),
(1009, 10, '2017-07-30 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 54),
(1010, 10, '2017-07-30 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 55),
(1011, 10, '2017-07-30 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 56),
(1012, 10, '2017-07-30 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 57),
(1013, 10, '2017-07-30 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 58),
(1014, 10, '2017-07-30 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 59),
(1015, 10, '2017-07-30 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 60),
(1016, 1, '2017-07-31 08:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1017, 1, '2017-07-31 08:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(1018, 1, '2017-07-31 08:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(1019, 1, '2017-07-31 08:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(1020, 1, '2017-07-31 08:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(1021, 1, '2017-07-31 08:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(1022, 1, '2017-07-31 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(1023, 1, '2017-07-31 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(1024, 1, '2017-07-31 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(1025, 1, '2017-07-31 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(1026, 1, '2017-07-31 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(1027, 1, '2017-07-31 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(1028, 1, '2017-07-31 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(1029, 1, '2017-07-31 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(1030, 1, '2017-07-31 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(1031, 1, '2017-07-31 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(1032, 1, '2017-07-31 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(1033, 1, '2017-07-31 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(1034, 1, '2017-07-31 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(1035, 1, '2017-07-31 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(1036, 6, '2017-07-31 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1037, 6, '2017-07-31 13:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(1038, 6, '2017-07-31 13:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(1039, 6, '2017-07-31 13:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(1040, 6, '2017-07-31 13:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(1041, 6, '2017-07-31 13:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(1042, 6, '2017-07-31 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(1043, 6, '2017-07-31 14:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(1044, 6, '2017-07-31 14:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(1045, 6, '2017-07-31 14:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(1046, 6, '2017-07-31 14:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(1047, 6, '2017-07-31 14:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(1048, 6, '2017-07-31 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(1049, 6, '2017-07-31 15:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(1050, 6, '2017-07-31 15:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(1051, 6, '2017-07-31 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(1052, 6, '2017-07-31 13:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(1053, 6, '2017-07-31 13:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(1054, 6, '2017-07-31 13:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(1055, 6, '2017-07-31 13:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(1056, 6, '2017-07-31 13:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21),
(1057, 6, '2017-07-31 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22),
(1058, 6, '2017-07-31 14:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 23),
(1059, 6, '2017-07-31 14:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 24),
(1060, 6, '2017-07-31 14:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25),
(1061, 6, '2017-07-31 14:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26),
(1062, 6, '2017-07-31 14:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 27),
(1063, 6, '2017-07-31 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28),
(1064, 6, '2017-07-31 15:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 29),
(1065, 6, '2017-07-31 15:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30),
(1066, 2, '2017-08-01 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1067, 2, '2017-08-01 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(1068, 2, '2017-08-01 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(1069, 2, '2017-08-01 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(1070, 2, '2017-08-01 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(1071, 2, '2017-08-01 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(1072, 2, '2017-08-01 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(1073, 2, '2017-08-01 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(1074, 2, '2017-08-01 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(1075, 2, '2017-08-01 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(1076, 2, '2017-08-01 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(1077, 2, '2017-08-01 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(1078, 2, '2017-08-01 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(1079, 2, '2017-08-01 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(1080, 2, '2017-08-01 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(1081, 7, '2017-08-01 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1082, 7, '2017-08-01 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(1083, 7, '2017-08-01 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(1084, 7, '2017-08-01 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(1085, 7, '2017-08-01 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(1086, 7, '2017-08-01 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(1087, 7, '2017-08-01 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(1088, 7, '2017-08-01 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(1089, 7, '2017-08-01 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(1090, 7, '2017-08-01 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(1091, 7, '2017-08-01 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(1092, 7, '2017-08-01 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(1093, 7, '2017-08-01 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(1094, 7, '2017-08-01 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(1095, 7, '2017-08-01 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(1096, 7, '2017-08-01 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(1097, 7, '2017-08-01 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(1098, 7, '2017-08-01 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(1099, 7, '2017-08-01 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(1100, 7, '2017-08-01 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(1101, 7, '2017-08-01 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21),
(1102, 7, '2017-08-01 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22),
(1103, 7, '2017-08-01 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 23),
(1104, 7, '2017-08-01 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 24),
(1105, 7, '2017-08-01 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25),
(1106, 7, '2017-08-01 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26),
(1107, 7, '2017-08-01 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 27),
(1108, 7, '2017-08-01 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28);
INSERT INTO `queues` (`id`, `schedule_id`, `time_begin`, `person_surname`, `person_name`, `person_lastname`, `date_born`, `confirm_code`, `confirm_time`, `cancel_code`, `ticket_num`) VALUES
(1109, 7, '2017-08-01 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 29),
(1110, 7, '2017-08-01 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30),
(1111, 7, '2017-08-01 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 31),
(1112, 7, '2017-08-01 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 32),
(1113, 7, '2017-08-01 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 33),
(1114, 7, '2017-08-01 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 34),
(1115, 7, '2017-08-01 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 35),
(1116, 7, '2017-08-01 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 36),
(1117, 7, '2017-08-01 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 37),
(1118, 7, '2017-08-01 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 38),
(1119, 7, '2017-08-01 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 39),
(1120, 7, '2017-08-01 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 40),
(1121, 7, '2017-08-01 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 41),
(1122, 7, '2017-08-01 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 42),
(1123, 7, '2017-08-01 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 43),
(1124, 7, '2017-08-01 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 44),
(1125, 7, '2017-08-01 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 45),
(1126, 7, '2017-08-01 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 46),
(1127, 7, '2017-08-01 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 47),
(1128, 7, '2017-08-01 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 48),
(1129, 7, '2017-08-01 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 49),
(1130, 7, '2017-08-01 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 50);

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
  UNIQUE KEY `workplace_id` (`workplace_id`),
  KEY `type` (`type`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Дамп даних таблиці `users`
--

INSERT INTO `users` (`id`, `name`, `pass`, `email`, `type`, `resetcode`, `workplace_id`) VALUES
(1, 'test', '$2y$07$BCryptRequires22Chrcte/VlQH0piJtjXl.0t1XkA8pw9dMXTpOq', 'kudaev.k@gmail.com', 1, NULL, 1);

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=62 ;

--
-- Дамп даних таблиці `workplaces`
--

INSERT INTO `workplaces` (`id`, `name`, `department_id`, `empl_surname`, `empl_name`, `empl_lastname`) VALUES
(1, 'test. Врач-терапевт (каб.201)', 1, 'Иванов', 'Иван', 'Иванович'),
(2, 'test. Врач-терапевт (каб. 202)', 1, 'Петрова', 'Петрина', 'Петровна'),
(3, 'test. Врач-терапевт (каб.203)', 1, 'Айболитов', 'Василий', 'Васильевич'),
(4, 'врач-хирург', 3, 'Дегтяренко ', 'С', 'Ф'),
(5, 'детский врач-хирург', 3, 'Боярко', 'Я', 'С'),
(6, 'врач-невролог', 4, 'Линёва', ' А', 'В'),
(7, 'врач-невролог', 4, 'Горлов', 'В', 'В'),
(8, 'врач-невролог', 4, 'Штрикун', 'Е', 'В'),
(9, 'врач-офтальмолог', 5, 'Толмачова', 'Т', 'М'),
(10, 'врач-отоларинголог', 6, 'Пономарева', 'Л', 'Н'),
(11, 'врач-отоларинголог', 6, 'Минаев', 'А', 'А'),
(12, 'врач-эндокринолог', 7, 'Ерулович', 'А', 'А'),
(13, 'врач-эндокринолог', 7, 'Закорвашевич', 'Л', 'А'),
(14, 'врач-кардиолог', 8, 'Нескромная', 'Елена', 'Николаевна'),
(15, 'врач-травматолог', 9, 'Яловега', 'В', 'Г'),
(16, 'врач-гинеколог', 10, 'Попова', 'И', 'А'),
(17, 'врач-гинеколог', 10, 'Титорчук', 'Е', 'С'),
(18, 'врач-гинеколог', 10, 'Ростовская', 'В', 'В'),
(19, 'врач-гинеколог', 10, 'Овчаренко', 'Е', 'Е'),
(20, 'врач-гинеколог', 10, 'Шевченко', 'Е', 'А'),
(21, 'врач-гинеколог', 10, 'Павлова', 'Н', 'В'),
(22, 'врач-гинеколог', 10, 'Власенко', 'И', 'И'),
(23, 'врач-инфекционист ', 11, 'Бугаёва', 'Т', 'П'),
(24, 'врач', 12, 'Беженцева', 'Г', 'О'),
(25, 'врач-терапевт', 13, 'Тамаркина', ' А', 'М'),
(26, 'врач-терапевт', 14, 'Аксенчук', 'Т', 'Ю'),
(27, 'врач-терапевт', 14, 'Иванова', 'Г', 'И'),
(28, 'врач-терапевт', 14, 'Селезнёва', 'О', 'С'),
(29, 'врач-невропатолог', 15, 'Щербак', 'С', 'В'),
(30, 'врач общей практики', 16, 'Боярко', 'А', 'В'),
(31, 'врач общей практики', 16, 'Хамид', 'А', 'Х'),
(32, 'врач общей практики', 16, 'Бодячук', 'Е', 'М'),
(33, 'врач общей практики', 16, 'Уколина', 'И', 'В'),
(34, 'врач общей практики', 16, 'Сакали', 'Р', 'В'),
(35, 'врач-педиатр', 17, 'Зильман', 'И', 'А'),
(36, 'врач-педиатр', 17, 'Беляева', 'О', 'А'),
(37, 'врач-педиатр', 17, 'Поспелова', 'Т', 'О'),
(38, 'зав. хирургическим отделением', 18, 'Пищиков', 'И', 'В'),
(39, 'врач-хирург', 18, 'Дужик', 'В', 'М'),
(40, 'врач-хирург', 18, 'Соколан', 'И', 'В'),
(41, 'врач-травматолог', 19, 'Кокорин', 'А', 'И'),
(42, 'врач-травматолог', 19, 'Крюченко', 'В', 'Г'),
(43, 'врач-уролог', 20, 'Тибасв', 'А', 'И'),
(44, 'врач-отоларинголог', 21, 'Кравченко', 'Н', 'В'),
(45, 'врач-эндокринолог', 22, 'Ергулович', 'А', 'А'),
(46, 'врач-эндокринолог', 22, 'Шашурина', 'И', 'Б'),
(47, 'врач-эндокринолог', 22, 'Грушко', 'Ю', 'Ю'),
(48, 'врач-кардиолог', 23, 'Настычук', 'А', 'А'),
(49, 'врач-ревматолог', 24, 'Рубцова', 'Е', 'Н'),
(50, 'врач-пульмонолог', 25, 'Горлова', 'В', 'Ю'),
(51, 'врач-офтальмолог', 26, 'Еременко', 'О', 'А'),
(52, 'врач-гастроэнтеролог', 27, 'Решетняк', 'Т', 'В'),
(53, 'врач-терапевт', 28, 'Васильева', 'Н', 'Д'),
(54, 'врач-инфекционист', 29, 'Альфимова', 'А', 'Ф'),
(55, 'врач-гематолог', 31, 'Чубатенко', 'в', 'А'),
(56, 'врач-аллерголог', 32, 'Елесеев', 'О', 'В'),
(57, 'зав. неврологическим кабинетом', 33, 'Заварзина', 'В', 'В'),
(58, 'врач-невропатолог', 33, 'Горбатюк', 'М', 'Н'),
(59, 'врач-невропатолог', 33, 'Слинько', 'Л', 'А'),
(60, 'врач-невропатолог', 33, 'Наумова', 'Ю', 'В'),
(61, 'врач-невропатолог', 33, 'Рыжков', 'А', 'Д');

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
