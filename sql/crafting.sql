CREATE TABLE IF NOT EXISTS `player_crafting` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(50) NOT NULL,
    `table_id` int(11) NOT NULL,
    `level` int(11) NOT NULL DEFAULT 1,
    `xp` int(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `citizen_table` (`citizenid`, `table_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;