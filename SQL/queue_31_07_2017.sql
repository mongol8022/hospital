-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Хост: 127.0.0.1
-- Час створення: Лип 31 2017 р., 12:58
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
	DECLARE last_date DATE;
	DECLARE days_incr SMALLINT;
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
	IF (SELECT value FROM settings WHERE name='gen_appoints_last_date') = '' THEN
		SET last_date = CURDATE();
		SET days_incr = 8;
	ELSE
		SELECT STR_TO_DATE(settings.value, '%Y-%m-%d') + INTERVAL 1 DAY INTO last_date FROM settings WHERE name='gen_appoints_last_date';
		SET days_incr = 1;
	END IF;
	WHILE day_incr < days_incr DO
		SELECT last_date + INTERVAL day_incr DAY INTO date_incr;		
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
        UPDATE settings SET value = date_incr WHERE name='gen_appoints_last_date';
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
(1, 'Городская больница №1', 84307, 1, ' ул. О. Тихого', 17, NULL, '<div class=''text-hosp-information''>\n                            <h5><b>Адрес:</b> г. Краматорск, ул. О. Тихого, 17.</h5>\n                            <h5><b>Телефоны:</b></h5>\n                                <ul>\n                                    <li>Приемная (06264) 41-78-25</li>\n                                    <li>Регистратура поликлиники (050) 756-92-01</li>\n                                    <li>Санпропускник хирургии (06264) 41-81-72</li>\n                                    <li>Санпропускник роддома (06264) 41-84-02</li>\n                                </ul>\n                            <h5><b>Время работы:</b></h5>\n                            <ul>\n                                <li>с 7:00 до 16.00 - в течении недели</li> \n                                <li>с 7:00 до 12 - в субботу</li> \n                                <li>выходной - воскресенье</li>\n                            </ul>\n                        </div>\n                        <div class=''frame''>\n                            <h5><b>Расположение на карте</b></h5>\n                        <iframe src=''https://www.google.com/maps/embed?pb=!1m16!1m12!1m3!1d2632.094489461981!2d37.562886541676754!3d48.722786143333344!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!2m1!1z0LHQvtC70YzQvdC40YbQsCAxINC60YDQsNC80LDRgtC-0YDRgdC6!5e0!3m2!1sru!2sua!4v1500322409448'' width=''400'' height=''300'' frameborder=''0'' style=''border:0;'' allowfullscreen ></iframe>\n                        </div>'),
(2, 'Городская больница №2', 84306, 1, 'ул. Днепропетровская', 14, NULL, '<div class=''text-hosp-information''>\n                            <h5><b>Адрес:</b> г. Краматорск, ул. ул. Днепропетровская, д. 17.</h5>\n                            <h5><b>Телефоны:</b></h5>\n                                <ul>\n                                    <li>Приемная (06264) 6-64-11</li>\n                                    <li>Регистратура поликлиники (050) 958-83-12</li>\n                                    <li>Терапия (06264) 6-95-75</li>\n                                    <li>Женская консультация (06264) 6-33-25</li>\n                                </ul>\n                            <h5><b>Время работы:</b></h5>\n                            <ul>\n                                <li>с 7:00 до 16.00 - в течении недели</li> \n                                <li>с 7:00 до 12 - в субботу</li> \n                                <li>выходной - воскресенье</li>\n                            </ul>\n                        </div>\n                        <div class=''frame''>\n                            <h5><b>Расположение на карте</b></h5>\n                        <iframe src=''https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d1105.784567560741!2d37.59429425412655!3d48.762533709257134!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x40df9737e79c4177%3A0x5ef17f7f79421b6a!2z0JPQvtGA0LHQvtC70YzQvdC40YbQsCDihJYgMiDQs9C-0YDQvtC0INCa0YDQsNC80LDRgtC-0YDRgdC60LAsINCy0YPQu9C40YbRjyDQlNC90ZbQv9GA0L7QstGB0YzQutCwLCAxNywg0JrRgNCw0LzQsNGC0L7RgNGB0YzQuiwg0JTQvtC90LXRhtGM0LrQsCDQvtCx0LvQsNGB0YLRjCwgODQzMDA!5e0!3m2!1sru!2sua!4v1500491690323'' width=''400'' height=''300''frameborder=''0'' style=''border:0'' allowfullscreen></iframe>\n                        </div>'),
(3, 'Городская больница №3', 84300, 1, 'ул. Героев Украины', 31, NULL, '<div class=''text-hosp-information''>\n                            <h5><b>Адрес:</b> г. Краматорск, ул. Героев Украины</h5>\n                            <h5><b>Телефоны:</b></h5>\n                                <ul>\n                                    <li>Приемная (06264) 3-24-35</li>\n                                    <li>Регистратура поликлиники (06264)3-42-14, (095) 689-16-00</li>\n                                </ul>\n                            <h5><b>Время работы:</b></h5>\n                            <ul>\n                                <li>с 7:00 до 16.00 - в течении недели</li> \n                                <li>с 7:00 до 12 - в субботу</li> \n                                <li>выходной - воскресенье</li>\n                            </ul>\n                        </div>\n                        <div class=''frame''>\n                            <h5><b>Расположение на карте</b></h5>\n                        <iframe src=''https://www.google.com/maps/embed?pb=!1m16!1m12!1m3!1d1106.1948310610069!2d37.59729910748491!3d48.743896829578006!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!2m1!1z0JrRgNCw0LzQsNGC0L7RgNGB0LosINCx0L7Qu9GM0L3QuNGG0LAgMw!5e0!3m2!1sru!2sua!4v1500491948938'' width=''400'' height=''300'' frameborder=''0'' style=''border:0'' allowfullscreen></iframe>\n                        </div>');

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
  KEY `schedule_id` (`schedule_id`),
  KEY `time_begin` (`time_begin`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2198 ;

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
(11, 1, '2017-07-17 08:20:00', 'Рпрглг', 'Ролролро', 'Олролро', '2017-07-21', 'Vm0tBmu3KySG123WPiuX', '2017-07-16 16:00:19', NULL, NULL),
(12, 1, '2017-07-17 08:30:00', 'Счмисмч', 'Счмисмчи', 'Счмисмчи', '2017-07-16', 'oRqfTP350LHhTJ1WSEXN', '2017-07-16 18:32:30', NULL, NULL),
(13, 1, '2017-07-17 08:40:00', 'Ewrtewrterw', 'Ewrtewrtewr', 'Erwterwtwer', '1991-01-01', NULL, NULL, 4408456438, NULL),
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
(401, 4, '2017-07-20 08:00:00', 'Asdfadsf', 'Asdasdf', 'Asdfasdf', '1998-01-01', NULL, NULL, NULL, NULL),
(402, 4, '2017-07-20 08:10:00', 'kj3jh4234', 'sfegsfdgsdf', 'werwegfrg', '1991-01-01', NULL, NULL, 4784600227, NULL),
(403, 4, '2017-07-20 08:20:00', '1', '1', '1', '2001-01-01', NULL, NULL, NULL, NULL),
(404, 4, '2017-07-20 08:30:00', 'Шгншгнгшн', 'Шгщшгщшг', 'Лшдллдолд', '2001-10-11', NULL, NULL, NULL, NULL),
(405, 4, '2017-07-20 08:40:00', '2234213', '21342314', '23142134', '0000-00-00', 'GT1YWXJMR6xZ62Ubvd03', '2017-07-19 13:29:45', NULL, NULL),
(406, 4, '2017-07-20 08:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(407, 4, '2017-07-20 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(408, 4, '2017-07-20 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(409, 4, '2017-07-20 09:20:00', 'Пономарьов', 'Максим', 'Анатолійович', '1994-06-02', NULL, NULL, NULL, NULL),
(410, 4, '2017-07-20 09:30:00', 'Пономарьов', 'Максим', 'Анатолійович', '1994-06-02', NULL, NULL, NULL, NULL),
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
(1131, 3, '2017-07-26 08:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1132, 3, '2017-07-26 08:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(1133, 3, '2017-07-26 08:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(1134, 3, '2017-07-26 08:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(1135, 3, '2017-07-26 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(1136, 3, '2017-07-26 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(1137, 3, '2017-07-26 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(1138, 3, '2017-07-26 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(1139, 3, '2017-07-26 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(1140, 3, '2017-07-26 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(1141, 3, '2017-07-26 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(1142, 3, '2017-07-26 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(1143, 3, '2017-07-26 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(1144, 3, '2017-07-26 10:30:00', 'Sdfdf', 'Dsfhsdfsh', 'Sdfhsdg', '1991-01-01', NULL, NULL, NULL, 14),
(1145, 3, '2017-07-26 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(1146, 3, '2017-07-26 10:50:00', 'fadsfasd', 'asdfasdfsad', 'asdfsadfasd', '1991-01-01', NULL, NULL, 8769370567, 16),
(1147, 3, '2017-07-26 11:00:00', 'thtr', 'rtyjy', 'tyjy', '1991-01-01', NULL, NULL, 9341084255, 17),
(1148, 3, '2017-07-26 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(1149, 3, '2017-07-26 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(1150, 3, '2017-07-26 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(1151, 3, '2017-07-26 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21),
(1152, 3, '2017-07-26 11:50:00', 'rttyurjr', 'rtyjtyj', 'ruyjruyuyt', '1987-01-01', NULL, NULL, 3628735948, 22),
(1153, 3, '2017-07-26 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 23),
(1154, 3, '2017-07-26 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 24),
(1155, 3, '2017-07-26 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25),
(1157, 3, '2017-07-26 12:40:00', 'sdfsdg', 'dghsghs', 'fgdhgd', '1988-01-01', 'TFiWabNHcIcLypvxXEw6', '2017-07-25 14:11:47', NULL, 27),
(1158, 3, '2017-07-26 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28),
(1159, 3, '2017-07-26 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 29),
(1160, 3, '2017-07-26 13:10:00', 'dsdas', 'sadfsadf', 'dsfgsdfg', '1991-01-01', NULL, NULL, 8229239292, 30),
(1161, 3, '2017-07-26 13:20:00', 'Петров', 'Петр', 'Петрович', '1977-01-01', NULL, NULL, 3334959919, 31),
(1162, 3, '2017-07-26 13:30:00', '23452345', '32453245', '3245234', '1991-01-01', NULL, NULL, 6027870274, 32),
(1163, 3, '2017-07-26 13:40:00', 'sdfasdf', 'adfadsfs', 'asdfadsf', '1991-01-01', NULL, NULL, 6491247714, 33),
(1164, 3, '2017-07-26 13:50:00', 't4yty', 'rtytehe', 'ytrreyre', '1966-01-01', NULL, NULL, 339726852, 34),
(1165, 3, '2017-07-26 14:00:00', 'hjtrhyj', 'ouipiuop', 'xzvczcxv', '1991-01-01', NULL, NULL, 4189146066, 35),
(1166, 8, '2017-07-26 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1167, 8, '2017-07-26 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(1168, 8, '2017-07-26 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(1169, 8, '2017-07-26 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(1170, 8, '2017-07-26 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(1171, 8, '2017-07-26 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(1172, 8, '2017-07-26 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(1173, 8, '2017-07-26 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(1174, 8, '2017-07-26 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(1175, 8, '2017-07-26 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(1176, 8, '2017-07-26 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(1177, 8, '2017-07-26 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(1178, 8, '2017-07-26 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(1179, 8, '2017-07-26 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(1180, 8, '2017-07-26 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(1181, 8, '2017-07-26 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(1182, 8, '2017-07-26 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(1183, 8, '2017-07-26 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(1184, 8, '2017-07-26 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(1185, 8, '2017-07-26 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(1186, 4, '2017-07-27 08:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1187, 4, '2017-07-27 08:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(1188, 4, '2017-07-27 08:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(1196, 9, '2017-07-27 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1197, 9, '2017-07-27 14:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(1198, 9, '2017-07-27 14:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(1199, 9, '2017-07-27 14:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(1200, 9, '2017-07-27 14:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(1201, 9, '2017-07-27 14:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(1202, 9, '2017-07-27 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(1203, 9, '2017-07-27 15:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(1204, 9, '2017-07-27 15:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(1205, 9, '2017-07-27 15:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(1206, 9, '2017-07-27 15:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(1207, 9, '2017-07-27 15:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(1208, 9, '2017-07-27 16:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(1209, 9, '2017-07-27 16:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(1210, 9, '2017-07-27 16:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(1211, 9, '2017-07-27 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(1212, 9, '2017-07-27 16:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(1213, 9, '2017-07-27 16:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(1214, 9, '2017-07-27 17:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(1215, 9, '2017-07-27 17:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(1216, 9, '2017-07-27 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21),
(1217, 9, '2017-07-27 14:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22),
(1218, 9, '2017-07-27 14:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 23),
(1219, 9, '2017-07-27 14:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 24),
(1220, 9, '2017-07-27 14:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25),
(1221, 9, '2017-07-27 14:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26),
(1222, 9, '2017-07-27 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 27),
(1223, 9, '2017-07-27 15:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28),
(1224, 9, '2017-07-27 15:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 29),
(1225, 9, '2017-07-27 15:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30),
(1226, 9, '2017-07-27 15:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 31),
(1227, 9, '2017-07-27 15:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 32),
(1228, 9, '2017-07-27 16:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 33),
(1229, 9, '2017-07-27 16:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 34),
(1230, 9, '2017-07-27 16:20:00', 'Сергеев', 'Сергей', 'Сергеевич', '1991-01-01', 'IyQtZFuXkXyuYEun4mJp', '2017-07-26 14:37:24', NULL, 35),
(1231, 9, '2017-07-27 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 36),
(1232, 9, '2017-07-27 16:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 37),
(1233, 9, '2017-07-27 16:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 38),
(1234, 9, '2017-07-27 17:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 39),
(1235, 9, '2017-07-27 17:10:00', 'Иванова', 'Вера', 'Сергеевна', '1991-01-01', 'IH7V8Yvko9Aogd2CS1AZ', '2017-07-26 14:32:25', NULL, 40),
(1236, 5, '2017-07-28 11:30:00', 'Сергеев', 'Сергей', 'Сергеевич', '1941-01-01', NULL, NULL, 1793742781, 1),
(1237, 5, '2017-07-28 11:40:00', 'Aerasd', 'Asdfasd', 'Asdfsad', '1991-01-01', NULL, NULL, 5656889158, 2),
(1238, 5, '2017-07-28 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(1239, 5, '2017-07-28 12:00:00', 'Hhhhhh', 'Dfg', 'He', '1988-12-22', NULL, NULL, NULL, 4),
(1240, 5, '2017-07-28 12:10:00', 'Gfdfsg', 'Dsfdsfgsd', 'Dsfgsdfgdsf', '1991-01-01', NULL, NULL, NULL, 5),
(1241, 5, '2017-07-28 12:20:00', 'Gfdfsg', 'Dsfdsfgsd', 'Dsfgsdfgdsf', '1991-01-01', NULL, NULL, 3045044110, 6),
(1242, 5, '2017-07-28 12:30:00', 'Тестов', 'Тест', 'Тестович', '1991-01-09', NULL, NULL, 9207193616, 7),
(1243, 5, '2017-07-28 12:40:00', 'John', 'Smith', 'Jr', '1997-01-01', NULL, NULL, NULL, 8),
(1244, 5, '2017-07-28 12:50:00', 'Qrtwert', 'Ewrtwertwert', 'Wertwert', '1980-01-22', NULL, NULL, NULL, 9),
(1245, 5, '2017-07-28 13:00:00', 'Кудаев', 'Кирилл', 'Николаевич', '0000-00-00', 'eZdHLLCTOhMhFBluRoPF', '2017-07-27 12:43:03', NULL, 10),
(1246, 10, '2017-07-28 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1247, 10, '2017-07-28 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(1248, 10, '2017-07-28 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(1249, 10, '2017-07-28 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(1250, 10, '2017-07-28 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(1251, 10, '2017-07-28 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(1252, 10, '2017-07-28 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(1253, 10, '2017-07-28 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(1254, 10, '2017-07-28 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(1255, 10, '2017-07-28 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(1256, 10, '2017-07-28 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(1257, 10, '2017-07-28 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(1258, 10, '2017-07-28 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(1259, 10, '2017-07-28 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(1260, 10, '2017-07-28 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(1261, 10, '2017-07-28 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(1262, 10, '2017-07-28 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(1263, 10, '2017-07-28 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(1264, 10, '2017-07-28 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(1265, 10, '2017-07-28 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(1266, 10, '2017-07-28 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21),
(1267, 10, '2017-07-28 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22),
(1268, 10, '2017-07-28 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 23),
(1269, 10, '2017-07-28 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 24),
(1270, 10, '2017-07-28 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25),
(1271, 10, '2017-07-28 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26),
(1272, 10, '2017-07-28 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 27),
(1273, 10, '2017-07-28 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28),
(1274, 10, '2017-07-28 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 29),
(1275, 10, '2017-07-28 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30),
(1276, 10, '2017-07-29 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 31),
(1277, 10, '2017-07-29 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 32),
(1278, 10, '2017-07-29 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 33),
(1279, 10, '2017-07-29 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 34),
(1280, 10, '2017-07-29 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 35),
(1281, 10, '2017-07-29 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 36),
(1282, 10, '2017-07-29 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 37),
(1283, 10, '2017-07-29 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 38),
(1284, 10, '2017-07-29 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 39),
(1285, 10, '2017-07-29 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 40),
(1286, 10, '2017-07-29 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 41),
(1287, 10, '2017-07-29 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 42),
(1288, 10, '2017-07-29 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 43),
(1289, 10, '2017-07-29 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 44),
(1290, 10, '2017-07-29 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 45),
(1291, 10, '2017-07-30 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 46),
(1292, 10, '2017-07-30 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 47),
(1293, 10, '2017-07-30 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 48),
(1294, 10, '2017-07-30 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 49),
(1295, 10, '2017-07-30 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 50),
(1296, 10, '2017-07-30 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 51),
(1297, 10, '2017-07-30 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 52),
(1298, 10, '2017-07-30 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 53),
(1299, 10, '2017-07-30 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 54),
(1300, 10, '2017-07-30 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 55),
(1301, 10, '2017-07-30 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 56),
(1302, 10, '2017-07-30 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 57),
(1303, 10, '2017-07-30 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 58),
(1304, 10, '2017-07-30 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 59),
(1305, 10, '2017-07-30 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 60),
(1306, 1, '2017-07-31 08:00:00', 'Ertrewt', 'Erterwterw', 'Ewrterwterw', '1991-01-01', NULL, NULL, 1321276939, 1),
(1307, 1, '2017-07-31 08:10:00', 'Werert', 'Tt', 'Qwetrqwetrqew', '1991-01-01', NULL, NULL, 7029246333, 2),
(1308, 1, '2017-07-31 08:20:00', 'Dyutryu', 'Tryutruty', 'Ryut', '1976-01-01', NULL, NULL, 3957096969, 3),
(1309, 1, '2017-07-31 08:30:00', 'Тестов', 'Тест', 'Тестович', '1991-05-13', NULL, NULL, 2961668761, 4),
(1310, 1, '2017-07-31 08:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(1311, 1, '2017-07-31 08:50:00', 'Тестов', 'Тест', 'Тестович', '1991-05-13', NULL, NULL, 8722689723, 6),
(1312, 1, '2017-07-31 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(1313, 1, '2017-07-31 09:10:00', 'Ewrerw', 'Erterwt', 'Erterwt', '1991-12-12', NULL, NULL, 6761553289, 8),
(1314, 1, '2017-07-31 09:20:00', 'Тестов', 'Тест', 'Тестович', '1991-05-13', NULL, NULL, 7409586110, 9),
(1315, 1, '2017-07-31 09:30:00', '123', 'Qad', 'Adsf', '2001-01-01', NULL, NULL, 4449891108, 10),
(1316, 1, '2017-07-31 09:40:00', 'Ewrerw', 'Erterwt', 'Erterwt', '1991-12-12', NULL, NULL, 341585066, 11),
(1317, 1, '2017-07-31 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(1318, 1, '2017-07-31 10:00:00', 'Сергеев', 'Сергей', 'Сергеевич', '1978-06-05', NULL, NULL, 5100008915, 13),
(1319, 1, '2017-07-31 10:10:00', 'Zbv', 'Dsfgvdfs', 'Dsfgsdfg', '1992-02-01', NULL, NULL, 714148938, 14),
(1320, 1, '2017-07-31 10:20:00', 'Erter', 'Rtyt', 'Etytrytyr', '1991-01-01', NULL, NULL, 9040975071, 15),
(1321, 1, '2017-07-31 10:30:00', 'Ertrewt', 'Erterwterw', 'Ewrterwterw', '1991-01-01', NULL, NULL, 1687228114, 16),
(1322, 1, '2017-07-31 10:40:00', 'Ertrewt', 'Erterwterw', 'Ewrterwterw', '1991-01-01', NULL, NULL, 5164499002, 17),
(1323, 1, '2017-07-31 10:50:00', 'Ertrewt', 'Erterwterw', 'Ewrterwterw', '1991-01-01', NULL, NULL, 5639863873, 18),
(1324, 1, '2017-07-31 11:00:00', 'Ertrewt', 'Erterwterw', 'Ewrterwterw', '1991-01-01', NULL, NULL, 9515699270, 19),
(1325, 1, '2017-07-31 11:10:00', 'Сидоров', 'Сидор', 'Сидорович', '1994-11-01', NULL, NULL, 6124673937, 20),
(1326, 6, '2017-07-31 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1327, 6, '2017-07-31 13:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(1328, 6, '2017-07-31 13:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(1329, 6, '2017-07-31 13:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(1330, 6, '2017-07-31 13:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(1331, 6, '2017-07-31 13:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(1332, 6, '2017-07-31 14:00:00', 'Esty', 'Dsgtdfgh', 'Dfghgfh', '1987-04-01', NULL, NULL, 3433568484, 7),
(1333, 6, '2017-07-31 14:10:00', 'Hjk', 'Llkl;', 'Hjkl', '1973-07-05', NULL, NULL, NULL, 8),
(1334, 6, '2017-07-31 14:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(1335, 6, '2017-07-31 14:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(1336, 6, '2017-07-31 14:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(1337, 6, '2017-07-31 14:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(1338, 6, '2017-07-31 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(1339, 6, '2017-07-31 15:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(1340, 6, '2017-07-31 15:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(1341, 6, '2017-07-31 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(1342, 6, '2017-07-31 13:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(1343, 6, '2017-07-31 13:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(1344, 6, '2017-07-31 13:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(1345, 6, '2017-07-31 13:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(1346, 6, '2017-07-31 13:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21),
(1347, 6, '2017-07-31 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22),
(1348, 6, '2017-07-31 14:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 23),
(1349, 6, '2017-07-31 14:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 24),
(1350, 6, '2017-07-31 14:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25),
(1351, 6, '2017-07-31 14:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26),
(1352, 6, '2017-07-31 14:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 27),
(1353, 6, '2017-07-31 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28),
(1354, 6, '2017-07-31 15:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 29),
(1355, 6, '2017-07-31 15:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30),
(1526, 4, '2017-07-27 08:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(1527, 4, '2017-07-27 08:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(1528, 4, '2017-07-27 08:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(1529, 4, '2017-07-27 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(1530, 4, '2017-07-27 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(1531, 4, '2017-07-27 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(1532, 4, '2017-07-27 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(1873, 2, '2017-08-01 10:00:00', 'John', 'Smith', 'Junior', '1985-01-01', NULL, NULL, NULL, 1),
(1874, 2, '2017-08-01 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(1875, 2, '2017-08-01 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(1876, 2, '2017-08-01 10:30:00', '32453425', '32453245', '2345342534', '1992-12-12', NULL, NULL, 3058705801, 4),
(1877, 2, '2017-08-01 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(1878, 2, '2017-08-01 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(1879, 2, '2017-08-01 11:00:00', 'Erasd', 'Asdfadsfas', 'Sdfsfs', '1946-01-01', '0oc4KKQdoDYGqOnhi36m', '2017-07-31 00:14:56', NULL, 7),
(1880, 2, '2017-08-01 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(1881, 2, '2017-08-01 11:20:00', 'Qwerqwer', 'Ewrerteter', 'Dfghgfhgfh', '1988-01-01', NULL, NULL, 6462987677, 9),
(1882, 2, '2017-08-01 11:30:00', 'Erasd', 'Asdfadsfas', 'Sdfsfs', '1946-01-01', 'D7oFOlzFsDCBnAGBqdIn', '2017-07-31 00:14:41', NULL, 10),
(1883, 2, '2017-08-01 11:40:00', 'Erasd', 'Asdfadsfas', 'Sdfsfs', '1946-01-01', 'S1Yy6g46qcqPf4eiLqPC', '2017-07-31 00:01:36', NULL, 11),
(1884, 2, '2017-08-01 11:50:00', 'Erasd', 'Asdfadsfas', 'Sdfsfs', '1946-01-01', NULL, NULL, 3672039405, 12),
(1886, 2, '2017-08-01 12:10:00', 'Etyert', 'Rtyerytr', 'Ertyerty', '1978-01-01', NULL, NULL, 9286483639, 14),
(1888, 7, '2017-08-01 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1889, 7, '2017-08-01 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(1890, 7, '2017-08-01 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(1891, 7, '2017-08-01 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(1892, 7, '2017-08-01 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(1893, 7, '2017-08-01 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(1894, 7, '2017-08-01 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7);
INSERT INTO `queues` (`id`, `schedule_id`, `time_begin`, `person_surname`, `person_name`, `person_lastname`, `date_born`, `confirm_code`, `confirm_time`, `cancel_code`, `ticket_num`) VALUES
(1895, 7, '2017-08-01 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(1896, 7, '2017-08-01 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(1897, 7, '2017-08-01 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(1898, 7, '2017-08-01 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(1899, 7, '2017-08-01 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(1900, 7, '2017-08-01 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(1901, 7, '2017-08-01 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(1902, 7, '2017-08-01 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(1903, 7, '2017-08-01 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(1904, 7, '2017-08-01 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(1905, 7, '2017-08-01 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(1906, 7, '2017-08-01 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(1907, 7, '2017-08-01 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(1908, 7, '2017-08-01 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21),
(1909, 7, '2017-08-01 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22),
(1910, 7, '2017-08-01 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 23),
(1911, 7, '2017-08-01 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 24),
(1912, 7, '2017-08-01 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25),
(1913, 7, '2017-08-01 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26),
(1914, 7, '2017-08-01 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 27),
(1915, 7, '2017-08-01 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28),
(1916, 7, '2017-08-01 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 29),
(1917, 7, '2017-08-01 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30),
(1918, 7, '2017-08-01 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 31),
(1919, 7, '2017-08-01 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 32),
(1920, 7, '2017-08-01 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 33),
(1921, 7, '2017-08-01 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 34),
(1922, 7, '2017-08-01 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 35),
(1923, 7, '2017-08-01 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 36),
(1924, 7, '2017-08-01 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 37),
(1925, 7, '2017-08-01 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 38),
(1926, 7, '2017-08-01 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 39),
(1927, 7, '2017-08-01 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 40),
(1928, 7, '2017-08-01 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 41),
(1929, 7, '2017-08-01 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 42),
(1930, 7, '2017-08-01 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 43),
(1931, 7, '2017-08-01 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 44),
(1932, 7, '2017-08-01 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 45),
(1933, 7, '2017-08-01 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 46),
(1934, 7, '2017-08-01 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 47),
(1935, 7, '2017-08-01 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 48),
(1936, 7, '2017-08-01 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 49),
(1937, 7, '2017-08-01 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 50),
(1938, 3, '2017-08-02 08:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1939, 3, '2017-08-02 08:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(1940, 3, '2017-08-02 08:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(1941, 3, '2017-08-02 08:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(1942, 3, '2017-08-02 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(1943, 3, '2017-08-02 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(1944, 3, '2017-08-02 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(1945, 3, '2017-08-02 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(1946, 3, '2017-08-02 09:40:00', 'Тестов', 'Тест', 'Ьесьович', '1994-04-05', NULL, NULL, 1564414002, 9),
(1947, 3, '2017-08-02 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(1948, 3, '2017-08-02 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(1949, 3, '2017-08-02 10:10:00', 'Сидоров', 'Сидор', 'Сидорович', '1969-05-12', NULL, NULL, 3621043472, 12),
(1950, 3, '2017-08-02 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(1951, 3, '2017-08-02 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(1952, 3, '2017-08-02 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(1953, 3, '2017-08-02 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(1954, 3, '2017-08-02 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(1955, 3, '2017-08-02 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(1956, 3, '2017-08-02 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(1957, 3, '2017-08-02 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(1958, 3, '2017-08-02 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21),
(1959, 3, '2017-08-02 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22),
(1960, 3, '2017-08-02 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 23),
(1961, 3, '2017-08-02 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 24),
(1962, 3, '2017-08-02 12:20:00', 'Иваненко', 'Иван', 'Иванович', '1975-08-14', NULL, NULL, 7852978505, 25),
(1963, 3, '2017-08-02 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26),
(1964, 3, '2017-08-02 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 27),
(1965, 3, '2017-08-02 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28),
(1966, 3, '2017-08-02 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 29),
(1967, 3, '2017-08-02 13:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30),
(1968, 3, '2017-08-02 13:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 31),
(1969, 3, '2017-08-02 13:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 32),
(1970, 3, '2017-08-02 13:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 33),
(1973, 8, '2017-08-02 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1974, 8, '2017-08-02 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(1975, 8, '2017-08-02 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(1976, 8, '2017-08-02 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(1977, 8, '2017-08-02 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(1978, 8, '2017-08-02 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(1979, 8, '2017-08-02 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(1980, 8, '2017-08-02 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(1981, 8, '2017-08-02 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(1982, 8, '2017-08-02 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(1983, 8, '2017-08-02 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(1984, 8, '2017-08-02 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(1985, 8, '2017-08-02 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(1986, 8, '2017-08-02 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(1987, 8, '2017-08-02 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(1988, 8, '2017-08-02 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(1989, 8, '2017-08-02 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(1990, 8, '2017-08-02 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(1991, 8, '2017-08-02 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(1992, 8, '2017-08-02 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(1993, 4, '2017-08-03 08:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(1994, 4, '2017-08-03 08:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(1995, 4, '2017-08-03 08:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(1996, 4, '2017-08-03 08:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(1997, 4, '2017-08-03 08:40:00', 'Dfsdfg', 'Dsfgdsfg', 'Dsfgdf', '2001-01-01', NULL, NULL, 906143779, 5),
(1998, 4, '2017-08-03 08:50:00', 'Dfsdfg', 'Dsfgdsfg', 'Dsfgdf', '2001-01-01', NULL, NULL, 7771349607, 6),
(1999, 4, '2017-08-03 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(2000, 4, '2017-08-03 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(2001, 4, '2017-08-03 09:20:00', 'Dfsdfg', 'Dsfgdsfg', 'Dsfgdf', '2001-01-01', NULL, NULL, 6717109917, 9),
(2002, 4, '2017-08-03 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(2003, 9, '2017-08-03 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(2004, 9, '2017-08-03 14:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(2005, 9, '2017-08-03 14:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(2006, 9, '2017-08-03 14:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(2007, 9, '2017-08-03 14:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(2008, 9, '2017-08-03 14:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(2009, 9, '2017-08-03 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(2010, 9, '2017-08-03 15:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(2011, 9, '2017-08-03 15:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(2012, 9, '2017-08-03 15:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(2013, 9, '2017-08-03 15:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(2014, 9, '2017-08-03 15:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(2015, 9, '2017-08-03 16:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(2016, 9, '2017-08-03 16:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(2017, 9, '2017-08-03 16:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(2018, 9, '2017-08-03 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(2019, 9, '2017-08-03 16:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(2020, 9, '2017-08-03 16:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(2021, 9, '2017-08-03 17:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(2022, 9, '2017-08-03 17:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(2023, 9, '2017-08-03 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21),
(2024, 9, '2017-08-03 14:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22),
(2025, 9, '2017-08-03 14:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 23),
(2026, 9, '2017-08-03 14:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 24),
(2027, 9, '2017-08-03 14:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25),
(2028, 9, '2017-08-03 14:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26),
(2029, 9, '2017-08-03 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 27),
(2030, 9, '2017-08-03 15:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28),
(2031, 9, '2017-08-03 15:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 29),
(2032, 9, '2017-08-03 15:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30),
(2033, 9, '2017-08-03 15:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 31),
(2034, 9, '2017-08-03 15:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 32),
(2035, 9, '2017-08-03 16:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 33),
(2036, 9, '2017-08-03 16:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 34),
(2037, 9, '2017-08-03 16:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 35),
(2038, 9, '2017-08-03 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 36),
(2039, 9, '2017-08-03 16:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 37),
(2040, 9, '2017-08-03 16:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 38),
(2041, 9, '2017-08-03 17:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 39),
(2042, 9, '2017-08-03 17:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 40),
(2043, 5, '2017-08-04 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(2044, 5, '2017-08-04 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(2045, 5, '2017-08-04 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(2046, 5, '2017-08-04 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(2047, 5, '2017-08-04 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(2048, 5, '2017-08-04 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(2049, 5, '2017-08-04 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(2050, 5, '2017-08-04 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(2051, 5, '2017-08-04 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(2052, 5, '2017-08-04 13:00:00', '3452345', 'Dsfgdf', 'Sfgsfd', '1991-01-01', NULL, NULL, 377091549, 10),
(2053, 10, '2017-08-04 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(2054, 10, '2017-08-04 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(2055, 10, '2017-08-04 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(2056, 10, '2017-08-04 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(2057, 10, '2017-08-04 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(2058, 10, '2017-08-04 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(2059, 10, '2017-08-04 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(2060, 10, '2017-08-04 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(2061, 10, '2017-08-04 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(2062, 10, '2017-08-04 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(2063, 10, '2017-08-04 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(2064, 10, '2017-08-04 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(2065, 10, '2017-08-04 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(2066, 10, '2017-08-04 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(2067, 10, '2017-08-04 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(2068, 10, '2017-08-04 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(2069, 10, '2017-08-04 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(2070, 10, '2017-08-04 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(2071, 10, '2017-08-04 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(2072, 10, '2017-08-04 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(2073, 10, '2017-08-04 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21),
(2074, 10, '2017-08-04 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22),
(2075, 10, '2017-08-04 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 23),
(2076, 10, '2017-08-04 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 24),
(2077, 10, '2017-08-04 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25),
(2078, 10, '2017-08-04 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26),
(2079, 10, '2017-08-04 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 27),
(2080, 10, '2017-08-04 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28),
(2081, 10, '2017-08-04 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 29),
(2082, 10, '2017-08-04 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30),
(2083, 1, '2017-08-07 08:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(2084, 1, '2017-08-07 08:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(2085, 1, '2017-08-07 08:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(2086, 1, '2017-08-07 08:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(2087, 1, '2017-08-07 08:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(2088, 1, '2017-08-07 08:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(2089, 1, '2017-08-07 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(2090, 1, '2017-08-07 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(2091, 1, '2017-08-07 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(2092, 1, '2017-08-07 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(2093, 1, '2017-08-07 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(2094, 1, '2017-08-07 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(2095, 1, '2017-08-07 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(2096, 1, '2017-08-07 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(2097, 1, '2017-08-07 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(2098, 1, '2017-08-07 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(2099, 1, '2017-08-07 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(2100, 1, '2017-08-07 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(2101, 1, '2017-08-07 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(2102, 1, '2017-08-07 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(2103, 6, '2017-08-07 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(2104, 6, '2017-08-07 13:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(2105, 6, '2017-08-07 13:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(2106, 6, '2017-08-07 13:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(2107, 6, '2017-08-07 13:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(2108, 6, '2017-08-07 13:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(2109, 6, '2017-08-07 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(2110, 6, '2017-08-07 14:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(2111, 6, '2017-08-07 14:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(2112, 6, '2017-08-07 14:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(2113, 6, '2017-08-07 14:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(2114, 6, '2017-08-07 14:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(2115, 6, '2017-08-07 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(2116, 6, '2017-08-07 15:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(2117, 6, '2017-08-07 15:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(2118, 6, '2017-08-07 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(2119, 6, '2017-08-07 13:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(2120, 6, '2017-08-07 13:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(2121, 6, '2017-08-07 13:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(2122, 6, '2017-08-07 13:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(2123, 6, '2017-08-07 13:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21),
(2124, 6, '2017-08-07 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22),
(2125, 6, '2017-08-07 14:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 23),
(2126, 6, '2017-08-07 14:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 24),
(2127, 6, '2017-08-07 14:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25),
(2128, 6, '2017-08-07 14:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26),
(2129, 6, '2017-08-07 14:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 27),
(2130, 6, '2017-08-07 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28),
(2131, 6, '2017-08-07 15:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 29),
(2132, 6, '2017-08-07 15:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30),
(2133, 2, '2017-08-08 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(2134, 2, '2017-08-08 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(2135, 2, '2017-08-08 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(2136, 2, '2017-08-08 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(2137, 2, '2017-08-08 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(2138, 2, '2017-08-08 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(2139, 2, '2017-08-08 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(2140, 2, '2017-08-08 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(2141, 2, '2017-08-08 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(2142, 2, '2017-08-08 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(2143, 2, '2017-08-08 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(2144, 2, '2017-08-08 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(2145, 2, '2017-08-08 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(2146, 2, '2017-08-08 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(2147, 2, '2017-08-08 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(2148, 7, '2017-08-08 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(2149, 7, '2017-08-08 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(2150, 7, '2017-08-08 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(2151, 7, '2017-08-08 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(2152, 7, '2017-08-08 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(2153, 7, '2017-08-08 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(2154, 7, '2017-08-08 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(2155, 7, '2017-08-08 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(2156, 7, '2017-08-08 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(2157, 7, '2017-08-08 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(2158, 7, '2017-08-08 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(2159, 7, '2017-08-08 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(2160, 7, '2017-08-08 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(2161, 7, '2017-08-08 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(2162, 7, '2017-08-08 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(2163, 7, '2017-08-08 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(2164, 7, '2017-08-08 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(2165, 7, '2017-08-08 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(2166, 7, '2017-08-08 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(2167, 7, '2017-08-08 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(2168, 7, '2017-08-08 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21),
(2169, 7, '2017-08-08 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22),
(2170, 7, '2017-08-08 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 23),
(2171, 7, '2017-08-08 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 24),
(2172, 7, '2017-08-08 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25),
(2173, 7, '2017-08-08 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26),
(2174, 7, '2017-08-08 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 27),
(2175, 7, '2017-08-08 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28),
(2176, 7, '2017-08-08 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 29),
(2177, 7, '2017-08-08 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30),
(2178, 7, '2017-08-08 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 31),
(2179, 7, '2017-08-08 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 32),
(2180, 7, '2017-08-08 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 33),
(2181, 7, '2017-08-08 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 34),
(2182, 7, '2017-08-08 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 35),
(2183, 7, '2017-08-08 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 36),
(2184, 7, '2017-08-08 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 37),
(2185, 7, '2017-08-08 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 38),
(2186, 7, '2017-08-08 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 39),
(2187, 7, '2017-08-08 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 40),
(2188, 7, '2017-08-08 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 41),
(2189, 7, '2017-08-08 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 42),
(2190, 7, '2017-08-08 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 43),
(2191, 7, '2017-08-08 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 44),
(2192, 7, '2017-08-08 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 45),
(2193, 7, '2017-08-08 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 46),
(2194, 7, '2017-08-08 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 47),
(2195, 7, '2017-08-08 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 48),
(2196, 7, '2017-08-08 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 49),
(2197, 7, '2017-08-08 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 50);

--
-- Тригери `queues`
--
DROP TRIGGER IF EXISTS `queues_ins_pers_leadupcase`;
DELIMITER //
CREATE TRIGGER `queues_ins_pers_leadupcase` BEFORE INSERT ON `queues`
 FOR EACH ROW BEGIN
     SET NEW.person_lastname = CONCAT(UPPER(LEFT(NEW.person_lastname, 1)), LOWER(RIGHT(NEW.person_lastname, CHAR_LENGTH(NEW.person_lastname) - 1)));
	 SET NEW.person_name = CONCAT(UPPER(LEFT(NEW.person_name, 1)), LOWER(RIGHT(NEW.person_name, CHAR_LENGTH(NEW.person_name) - 1)));
	 SET NEW.person_surname = CONCAT(UPPER(LEFT(NEW.person_surname, 1)), LOWER(RIGHT(NEW.person_surname, CHAR_LENGTH(NEW.person_surname) - 1)));
  END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `queues_upd_pers_leadupcase`;
DELIMITER //
CREATE TRIGGER `queues_upd_pers_leadupcase` BEFORE UPDATE ON `queues`
 FOR EACH ROW BEGIN
     SET NEW.person_lastname = CONCAT(UPPER(LEFT(NEW.person_lastname, 1)), LOWER(RIGHT(NEW.person_lastname, CHAR_LENGTH(NEW.person_lastname) - 1)));
	 SET NEW.person_name = CONCAT(UPPER(LEFT(NEW.person_name, 1)), LOWER(RIGHT(NEW.person_name, CHAR_LENGTH(NEW.person_name) - 1)));
	 SET NEW.person_surname = CONCAT(UPPER(LEFT(NEW.person_surname, 1)), LOWER(RIGHT(NEW.person_surname, CHAR_LENGTH(NEW.person_surname) - 1)));
  END
//
DELIMITER ;

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
-- Структура таблиці `settings`
--

CREATE TABLE IF NOT EXISTS `settings` (
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Дамп даних таблиці `settings`
--

INSERT INTO `settings` (`name`, `value`) VALUES
('gen_appoints_last_date', '2017-08-08');

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
