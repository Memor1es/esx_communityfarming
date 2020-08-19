INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('farmer', 'Farmer', 0);

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('farmer', 0, 'farmer', 'Farmer', 0, '{}', '{}');

INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
('wheat', 'Wheat', 100, 0, 1);
