--            _           (`-') (`-')  _ _(`-')    (`-')  _      (`-')
--   <-.     (_)         _(OO ) ( OO).-/( (OO ).-> ( OO).-/     _(OO )
--(`-')-----.,-(`-'),--.(_/,-.\(,------. \    .'_ (,------.,--.(_/,-.\
--(OO|(_\---'| ( OO)\   \ / (_/ |  .---' '`'-..__) |  .---'\   \ / (_/
-- / |  '--. |  |  ) \   /   / (|  '--.  |  |  ' |(|  '--.  \   /   / 
-- \_)  .--'(|  |_/ _ \     /_) |  .--'  |  |  / : |  .--' _ \     /_)
--  `|  |_)  |  |'->\-'\   /    |  `---. |  '-'  / |  `---.\-'\   /   
--   `--'    `--'       `-'     `------' `------'  `------'    `-'    

CREATE TABLE `user_contacts` (
  `id` int(11) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `number` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

ALTER TABLE `user_contacts`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `user_contacts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=801;

ALTER TABLE `users` 
ADD COLUMN `phone_number` INT NULL AFTER `position`;