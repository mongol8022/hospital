-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Хост: 127.0.0.1
-- Час створення: Сер 06 2017 р., 18:26
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
	DECLARE SchedCursor CURSOR FOR SELECT schedule.id, schedule.count, schedule.time_begin, services.duration, schedule.worplace_id FROM schedule, services WHERE schedule.service_id = services.id and schedule.valid_from <= date_incr and (schedule.valid_to is NULL or schedule.valid_to >= date_incr) and weekday(date_incr) = schedule.week_day and (date_incr not in (select date_holiday from holidays) or schedule.holiday_work <> 0) ORDER BY worplace_id, time_begin;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;	
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
		read_loop: LOOP
			FETCH SchedCursor INTO SchedId,SchedCount,SchedTime,SchedDuration, SchedWorkplace;
			IF done = 1 THEN
      			LEAVE read_loop;
			END IF;
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
		END LOOP;
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
-- Структура таблиці `feedbacks`
--

CREATE TABLE IF NOT EXISTS `feedbacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pacient_name` varchar(300) NOT NULL,
  `pacient_email` varchar(300) NOT NULL,
  `pacient_feedback` text NOT NULL,
  `datetime` varchar(20) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=10 ;

--
-- Дамп даних таблиці `feedbacks`
--

INSERT INTO `feedbacks` (`id`, `pacient_name`, `pacient_email`, `pacient_feedback`, `datetime`) VALUES
(6, 'je7744ka', 'je7744ka@gmail.com', 'Максим Пономарёв - самый лучший травмвтолог', '2017-07-31 16:36'),
(7, 'Кирилл Кудаев', 'kudaev.k@gmail.com', ' Здесь сильно штормит. Боимся как бы не потонуть. Приятель наш по болезни уволился. Шлю тебе с ним, Анюта, живой привет. За добрые слова одень, обуй и обогрей, да будь с ним ласкова.\r\nВечно твой друг...', '2017-07-31 16:44'),
(8, 'злой пациент', 'fghk@ghjk.hjkl;', 'где моя почка', '2017-07-31 17:05'),
(9, 'степан', 'trump@usa.yes', 'don''t warry, be happy.', '2017-07-31 17:35');

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
-- Структура таблиці `holidays`
--

CREATE TABLE IF NOT EXISTS `holidays` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_holiday` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Дамп даних таблиці `holidays`
--

INSERT INTO `holidays` (`id`, `name`, `date_holiday`) VALUES
(1, '???? ?????????????', '2017-08-24'),
(2, 'День независимости', '2017-08-24');

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3806 ;

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
(3261, 2, '2017-08-01 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(3262, 2, '2017-08-01 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(3263, 2, '2017-08-01 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(3264, 2, '2017-08-01 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(3265, 2, '2017-08-01 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(3266, 2, '2017-08-01 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(3267, 2, '2017-08-01 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(3268, 2, '2017-08-01 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(3269, 2, '2017-08-01 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(3270, 2, '2017-08-01 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(3271, 2, '2017-08-01 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(3272, 2, '2017-08-01 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(3273, 2, '2017-08-01 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(3274, 2, '2017-08-01 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(3275, 2, '2017-08-01 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(3276, 7, '2017-08-01 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(3277, 7, '2017-08-01 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(3278, 7, '2017-08-01 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(3279, 7, '2017-08-01 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(3280, 7, '2017-08-01 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(3281, 7, '2017-08-01 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(3282, 7, '2017-08-01 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(3283, 7, '2017-08-01 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(3284, 7, '2017-08-01 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(3285, 7, '2017-08-01 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10);
INSERT INTO `queues` (`id`, `schedule_id`, `time_begin`, `person_surname`, `person_name`, `person_lastname`, `date_born`, `confirm_code`, `confirm_time`, `cancel_code`, `ticket_num`) VALUES
(3286, 7, '2017-08-01 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(3287, 7, '2017-08-01 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(3288, 7, '2017-08-01 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(3289, 7, '2017-08-01 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(3290, 7, '2017-08-01 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(3291, 7, '2017-08-01 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(3292, 7, '2017-08-01 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(3293, 7, '2017-08-01 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(3294, 7, '2017-08-01 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(3295, 7, '2017-08-01 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(3296, 7, '2017-08-01 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21),
(3297, 7, '2017-08-01 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22),
(3298, 7, '2017-08-01 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 23),
(3299, 7, '2017-08-01 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 24),
(3300, 7, '2017-08-01 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25),
(3526, 3, '2017-08-02 08:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(3527, 3, '2017-08-02 08:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(3528, 3, '2017-08-02 08:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(3529, 3, '2017-08-02 08:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(3530, 3, '2017-08-02 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(3531, 3, '2017-08-02 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(3532, 3, '2017-08-02 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(3533, 3, '2017-08-02 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(3534, 3, '2017-08-02 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(3535, 3, '2017-08-02 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(3536, 3, '2017-08-02 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(3537, 3, '2017-08-02 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(3538, 3, '2017-08-02 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(3539, 3, '2017-08-02 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(3540, 3, '2017-08-02 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(3541, 3, '2017-08-02 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(3542, 3, '2017-08-02 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(3543, 3, '2017-08-02 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(3544, 3, '2017-08-02 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(3545, 3, '2017-08-02 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(3546, 3, '2017-08-02 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21),
(3547, 3, '2017-08-02 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22),
(3548, 3, '2017-08-02 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 23),
(3549, 3, '2017-08-02 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 24),
(3550, 3, '2017-08-02 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25),
(3551, 3, '2017-08-02 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26),
(3552, 3, '2017-08-02 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 27),
(3553, 3, '2017-08-02 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28),
(3554, 3, '2017-08-02 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 29),
(3555, 3, '2017-08-02 13:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30),
(3556, 3, '2017-08-02 13:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 31),
(3557, 3, '2017-08-02 13:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 32),
(3558, 3, '2017-08-02 13:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 33),
(3559, 3, '2017-08-02 13:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 34),
(3560, 3, '2017-08-02 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 35),
(3561, 8, '2017-08-02 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(3562, 8, '2017-08-02 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(3563, 8, '2017-08-02 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(3564, 8, '2017-08-02 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(3565, 8, '2017-08-02 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(3566, 8, '2017-08-02 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(3567, 8, '2017-08-02 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(3568, 8, '2017-08-02 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(3569, 8, '2017-08-02 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(3570, 8, '2017-08-02 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(3571, 4, '2017-08-03 08:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(3572, 4, '2017-08-03 08:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(3573, 4, '2017-08-03 08:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(3574, 4, '2017-08-03 08:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(3575, 4, '2017-08-03 08:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(3576, 4, '2017-08-03 08:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(3577, 4, '2017-08-03 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(3578, 4, '2017-08-03 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(3579, 4, '2017-08-03 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(3580, 4, '2017-08-03 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(3581, 9, '2017-08-03 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(3582, 9, '2017-08-03 14:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(3583, 9, '2017-08-03 14:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(3584, 9, '2017-08-03 14:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(3585, 9, '2017-08-03 14:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(3586, 9, '2017-08-03 14:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(3587, 9, '2017-08-03 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(3588, 9, '2017-08-03 15:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(3589, 9, '2017-08-03 15:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(3590, 9, '2017-08-03 15:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(3591, 9, '2017-08-03 15:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(3592, 9, '2017-08-03 15:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(3593, 9, '2017-08-03 16:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(3594, 9, '2017-08-03 16:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(3595, 9, '2017-08-03 16:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(3596, 9, '2017-08-03 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(3597, 9, '2017-08-03 16:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(3598, 9, '2017-08-03 16:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(3599, 9, '2017-08-03 17:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(3600, 9, '2017-08-03 17:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(3601, 5, '2017-08-04 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(3602, 5, '2017-08-04 11:40:00', 'Пупкин', 'Василий', 'Васильевич', '1967-11-01', NULL, NULL, 5160176828, 2),
(3603, 5, '2017-08-04 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(3604, 5, '2017-08-04 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(3605, 5, '2017-08-04 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(3606, 5, '2017-08-04 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(3607, 5, '2017-08-04 12:30:00', 'Сидорова', 'Алевтина', 'Никоноровна', '1940-11-01', NULL, NULL, 1114096351, 7),
(3608, 5, '2017-08-04 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(3609, 5, '2017-08-04 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(3610, 5, '2017-08-04 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(3611, 10, '2017-08-04 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(3612, 10, '2017-08-04 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(3613, 10, '2017-08-04 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(3614, 10, '2017-08-04 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(3615, 10, '2017-08-04 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(3616, 10, '2017-08-04 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(3617, 10, '2017-08-04 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(3618, 10, '2017-08-04 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(3619, 10, '2017-08-04 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(3620, 10, '2017-08-04 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(3621, 10, '2017-08-04 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(3622, 10, '2017-08-04 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(3623, 10, '2017-08-04 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(3624, 10, '2017-08-04 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(3625, 10, '2017-08-04 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(3626, 1, '2017-08-07 08:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(3627, 1, '2017-08-07 08:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(3628, 1, '2017-08-07 08:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(3629, 1, '2017-08-07 08:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(3630, 1, '2017-08-07 08:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(3631, 1, '2017-08-07 08:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(3632, 1, '2017-08-07 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(3633, 1, '2017-08-07 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(3634, 1, '2017-08-07 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(3635, 1, '2017-08-07 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(3636, 1, '2017-08-07 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(3637, 1, '2017-08-07 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(3638, 1, '2017-08-07 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(3639, 1, '2017-08-07 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(3640, 1, '2017-08-07 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(3641, 1, '2017-08-07 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(3642, 1, '2017-08-07 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(3643, 1, '2017-08-07 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(3644, 1, '2017-08-07 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(3645, 1, '2017-08-07 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(3646, 11, '2017-08-07 16:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21),
(3647, 11, '2017-08-07 16:15:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22),
(3648, 11, '2017-08-07 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 23),
(3649, 11, '2017-08-07 16:45:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 24),
(3650, 11, '2017-08-07 17:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25),
(3651, 6, '2017-08-07 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(3652, 6, '2017-08-07 13:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(3653, 6, '2017-08-07 13:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(3654, 6, '2017-08-07 13:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(3655, 6, '2017-08-07 13:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(3656, 6, '2017-08-07 13:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(3657, 6, '2017-08-07 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(3658, 6, '2017-08-07 14:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(3659, 6, '2017-08-07 14:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(3660, 6, '2017-08-07 14:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(3661, 6, '2017-08-07 14:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(3662, 6, '2017-08-07 14:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(3663, 6, '2017-08-07 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(3664, 6, '2017-08-07 15:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(3665, 6, '2017-08-07 15:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(3666, 2, '2017-08-08 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(3667, 2, '2017-08-08 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(3668, 2, '2017-08-08 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(3669, 2, '2017-08-08 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(3670, 2, '2017-08-08 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(3671, 2, '2017-08-08 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(3672, 2, '2017-08-08 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(3673, 2, '2017-08-08 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(3674, 2, '2017-08-08 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(3675, 2, '2017-08-08 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(3676, 2, '2017-08-08 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(3677, 2, '2017-08-08 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(3678, 2, '2017-08-08 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(3679, 2, '2017-08-08 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(3680, 2, '2017-08-08 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(3681, 7, '2017-08-08 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(3682, 7, '2017-08-08 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(3683, 7, '2017-08-08 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(3684, 7, '2017-08-08 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(3685, 7, '2017-08-08 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(3686, 7, '2017-08-08 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(3687, 7, '2017-08-08 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(3688, 7, '2017-08-08 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(3689, 7, '2017-08-08 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(3690, 7, '2017-08-08 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(3691, 7, '2017-08-08 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(3692, 7, '2017-08-08 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(3693, 7, '2017-08-08 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(3694, 7, '2017-08-08 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(3695, 7, '2017-08-08 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(3696, 7, '2017-08-08 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(3697, 7, '2017-08-08 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(3698, 7, '2017-08-08 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(3699, 7, '2017-08-08 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(3700, 7, '2017-08-08 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(3701, 7, '2017-08-08 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21),
(3702, 7, '2017-08-08 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22),
(3703, 7, '2017-08-08 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 23),
(3704, 7, '2017-08-08 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 24),
(3705, 7, '2017-08-08 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25),
(3706, 3, '2017-08-09 08:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(3707, 3, '2017-08-09 08:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(3708, 3, '2017-08-09 08:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(3709, 3, '2017-08-09 08:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(3710, 3, '2017-08-09 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(3711, 3, '2017-08-09 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(3712, 3, '2017-08-09 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(3713, 3, '2017-08-09 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(3714, 3, '2017-08-09 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(3715, 3, '2017-08-09 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(3716, 3, '2017-08-09 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(3717, 3, '2017-08-09 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(3718, 3, '2017-08-09 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(3719, 3, '2017-08-09 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(3720, 3, '2017-08-09 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(3721, 3, '2017-08-09 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(3722, 3, '2017-08-09 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(3723, 3, '2017-08-09 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(3724, 3, '2017-08-09 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(3725, 3, '2017-08-09 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(3726, 3, '2017-08-09 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21),
(3727, 3, '2017-08-09 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22),
(3728, 3, '2017-08-09 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 23),
(3729, 3, '2017-08-09 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 24),
(3730, 3, '2017-08-09 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25),
(3731, 3, '2017-08-09 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26),
(3732, 3, '2017-08-09 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 27),
(3733, 3, '2017-08-09 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28),
(3734, 3, '2017-08-09 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 29),
(3735, 3, '2017-08-09 13:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30),
(3736, 3, '2017-08-09 13:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 31),
(3737, 3, '2017-08-09 13:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 32),
(3738, 3, '2017-08-09 13:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 33),
(3739, 3, '2017-08-09 13:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 34),
(3740, 3, '2017-08-09 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 35),
(3741, 8, '2017-08-09 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(3742, 8, '2017-08-09 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(3743, 8, '2017-08-09 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(3744, 8, '2017-08-09 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(3745, 8, '2017-08-09 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(3746, 8, '2017-08-09 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(3747, 8, '2017-08-09 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(3748, 8, '2017-08-09 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(3749, 8, '2017-08-09 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(3750, 8, '2017-08-09 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(3751, 4, '2017-08-10 08:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(3752, 4, '2017-08-10 08:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(3753, 4, '2017-08-10 08:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(3754, 4, '2017-08-10 08:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(3755, 4, '2017-08-10 08:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(3756, 4, '2017-08-10 08:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(3757, 4, '2017-08-10 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(3758, 4, '2017-08-10 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(3759, 4, '2017-08-10 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(3760, 4, '2017-08-10 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(3761, 9, '2017-08-10 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(3762, 9, '2017-08-10 14:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(3763, 9, '2017-08-10 14:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(3764, 9, '2017-08-10 14:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(3765, 9, '2017-08-10 14:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(3766, 9, '2017-08-10 14:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(3767, 9, '2017-08-10 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(3768, 9, '2017-08-10 15:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(3769, 9, '2017-08-10 15:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(3770, 9, '2017-08-10 15:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(3771, 9, '2017-08-10 15:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(3772, 9, '2017-08-10 15:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(3773, 9, '2017-08-10 16:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(3774, 9, '2017-08-10 16:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(3775, 9, '2017-08-10 16:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15),
(3776, 9, '2017-08-10 16:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16),
(3777, 9, '2017-08-10 16:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 17),
(3778, 9, '2017-08-10 16:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18),
(3779, 9, '2017-08-10 17:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19),
(3780, 9, '2017-08-10 17:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20),
(3781, 5, '2017-08-11 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(3782, 5, '2017-08-11 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(3783, 5, '2017-08-11 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(3784, 5, '2017-08-11 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(3785, 5, '2017-08-11 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(3786, 5, '2017-08-11 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(3787, 5, '2017-08-11 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(3788, 5, '2017-08-11 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(3789, 5, '2017-08-11 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(3790, 5, '2017-08-11 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(3791, 10, '2017-08-11 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(3792, 10, '2017-08-11 10:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
(3793, 10, '2017-08-11 10:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(3794, 10, '2017-08-11 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4),
(3795, 10, '2017-08-11 11:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(3796, 10, '2017-08-11 11:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6),
(3797, 10, '2017-08-11 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7),
(3798, 10, '2017-08-11 11:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8),
(3799, 10, '2017-08-11 11:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9),
(3800, 10, '2017-08-11 12:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10),
(3801, 10, '2017-08-11 12:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 11),
(3802, 10, '2017-08-11 12:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12),
(3803, 10, '2017-08-11 12:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13),
(3804, 10, '2017-08-11 12:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14),
(3805, 10, '2017-08-11 12:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 15);

--
-- Тригери `queues`
--
DROP TRIGGER IF EXISTS `queues_ins_pers_leadupcase`;
DELIMITER //
CREATE TRIGGER `queues_ins_pers_leadupcase` BEFORE INSERT ON `queues`
 FOR EACH ROW BEGIN
     SET NEW.person_lastname = CONCAT(UPPER(LEFT(TRIM(NEW.person_lastname), 1)), LOWER(RIGHT(TRIM(NEW.person_lastname), CHAR_LENGTH(TRIM(NEW.person_lastname)) - 1)));
	 SET NEW.person_name = CONCAT(UPPER(LEFT(TRIM(NEW.person_name), 1)), LOWER(RIGHT(TRIM(NEW.person_name), CHAR_LENGTH(TRIM(NEW.person_name)) - 1)));
	 SET NEW.person_surname = CONCAT(UPPER(LEFT(TRIM(NEW.person_surname), 1)), LOWER(RIGHT(TRIM(NEW.person_surname), CHAR_LENGTH(TRIM(NEW.person_surname)) - 1)));
END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `queues_upd_pers_leadupcase`;
DELIMITER //
CREATE TRIGGER `queues_upd_pers_leadupcase` BEFORE UPDATE ON `queues`
 FOR EACH ROW BEGIN
     SET NEW.person_lastname = CONCAT(UPPER(LEFT(TRIM(NEW.person_lastname), 1)), LOWER(RIGHT(TRIM(NEW.person_lastname), CHAR_LENGTH(TRIM(NEW.person_lastname)) - 1)));
	 SET NEW.person_name = CONCAT(UPPER(LEFT(TRIM(NEW.person_name), 1)), LOWER(RIGHT(TRIM(NEW.person_name), CHAR_LENGTH(TRIM(NEW.person_name)) - 1)));
	 SET NEW.person_surname = CONCAT(UPPER(LEFT(TRIM(NEW.person_surname), 1)), LOWER(RIGHT(TRIM(NEW.person_surname), CHAR_LENGTH(TRIM(NEW.person_surname)) - 1)));
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
  `holiday_work` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `worplace_id` (`worplace_id`),
  KEY `service_id` (`service_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=13 ;

--
-- Дамп даних таблиці `schedule`
--

INSERT INTO `schedule` (`id`, `worplace_id`, `service_id`, `week_day`, `time_begin`, `count`, `valid_from`, `valid_to`, `holiday_work`) VALUES
(1, 1, 1, 0, '08:00:00', 20, '2017-01-01', NULL, 0),
(2, 1, 1, 1, '10:00:00', 15, '2017-01-01', NULL, 0),
(3, 1, 1, 2, '08:20:00', 35, '2017-01-01', NULL, 0),
(4, 1, 1, 3, '08:00:00', 10, '2017-01-01', NULL, 0),
(5, 1, 1, 4, '11:30:00', 10, '2017-01-01', NULL, 0),
(6, 2, 1, 0, '13:00:00', 15, '2017-01-01', NULL, 0),
(7, 2, 1, 1, '09:00:00', 25, '2017-01-01', NULL, 0),
(8, 2, 1, 2, '11:20:00', 10, '2017-01-01', NULL, 0),
(9, 2, 1, 3, '14:00:00', 20, '2017-01-01', NULL, 0),
(10, 2, 1, 4, '10:30:00', 15, '2017-01-01', NULL, 0),
(11, 1, 2, 0, '16:00:00', 5, '2017-01-01', NULL, 0),
(12, 1, 1, 0, '19:00:00', 10, '2017-01-01', NULL, 0);

--
-- Тригери `schedule`
--
DROP TRIGGER IF EXISTS `schedule_ins_check_dup`;
DELIMITER //
CREATE TRIGGER `schedule_ins_check_dup` BEFORE INSERT ON `schedule`
 FOR EACH ROW BEGIN
	DECLARE tmp_time_begin time;
	DECLARE tmp_time_end time;
	DECLARE new_time_end time; 
	DECLARE done INT default 0;
	DECLARE cursor1 CURSOR FOR SELECT schedule.time_begin, ADDTIME(schedule.time_begin, sec_to_time(services.duration*schedule.count*60)) as time_end from schedule, services where schedule.service_id = services.id and worplace_id=NEW.worplace_id and week_day=NEW.week_day and valid_from<=curdate() and (valid_to is NULL or valid_to >= curdate());
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	SET new_time_end = (SELECT ADDTIME(NEW.time_begin, sec_to_time(services.duration*NEW.count*60)) from services where services.id=NEW.service_id);
	OPEN cursor1;
	read_loop: LOOP
		FETCH cursor1 INTO tmp_time_begin, tmp_time_end;
		IF done = 1 THEN      		
			LEAVE read_loop;
		END IF;
		IF (new_time_end >= tmp_time_begin AND new_time_end <= tmp_time_end) OR (NEW.time_begin >= tmp_time_begin AND NEW.time_begin <= tmp_time_end) THEN
			signal sqlstate '45000' set message_text = 'Duplicate schedule record!';
		END IF;
	END LOOP;
	CLOSE cursor1;	
END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `schedule_upd_check_dup`;
DELIMITER //
CREATE TRIGGER `schedule_upd_check_dup` BEFORE UPDATE ON `schedule`
 FOR EACH ROW BEGIN
	DECLARE tmp_time_begin time;
	DECLARE tmp_time_end time;
	DECLARE new_time_end time; 
	DECLARE done INT default 0;
	DECLARE cursor1 CURSOR FOR SELECT schedule.time_begin, ADDTIME(schedule.time_begin, sec_to_time(services.duration*schedule.count*60)) as time_end from schedule, services where schedule.service_id = services.id and worplace_id=NEW.worplace_id and week_day=NEW.week_day and valid_from<=curdate() and (valid_to is NULL or valid_to >= curdate());
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	SET new_time_end = (SELECT ADDTIME(NEW.time_begin, sec_to_time(services.duration*NEW.count*60)) from services where services.id=NEW.service_id);
	OPEN cursor1;
	read_loop: LOOP
		FETCH cursor1 INTO tmp_time_begin, tmp_time_end;
		IF done = 1 THEN      		
			LEAVE read_loop;
		END IF;
		IF (new_time_end >= tmp_time_begin AND new_time_end <= tmp_time_end) OR (NEW.time_begin >= tmp_time_begin AND NEW.time_begin <= tmp_time_end) THEN
			signal sqlstate '45000' set message_text = 'Duplicate schedule record!';
		END IF;
	END LOOP;
	CLOSE cursor1;	
END
//
DELIMITER ;

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
('gen_appoints_last_date', '2017-08-11');

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
