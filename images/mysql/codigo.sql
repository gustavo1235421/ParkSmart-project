-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema parksmart
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema parksmart
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `parksmart` DEFAULT CHARACTER SET utf8 ;
USE `parksmart` ;

-- -----------------------------------------------------
-- Table `parksmart`.`clients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parksmart`.`clients` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `doc_type` VARCHAR(20) NOT NULL,
  `doc_number` VARCHAR(30) NOT NULL,
  `full_name` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(20) NULL,
  `email` VARCHAR(100) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `parksmart`.`rates`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parksmart`.`rates` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `amount_hour` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `parksmart`.`vehicles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parksmart`.`vehicles` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `client_id` INT NOT NULL,
  `plate` VARCHAR(20) NOT NULL,
  `brand` VARCHAR(100) NULL,
  `description` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_client_vehicles_idx` (`client_id` ASC) VISIBLE,
  CONSTRAINT `fk_client_vehicles`
    FOREIGN KEY (`client_id`)
    REFERENCES `parksmart`.`clients` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `parksmart`.`employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parksmart`.`employees` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `full_name` VARCHAR(100) NOT NULL,
  `role` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `parksmart`.`shifts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parksmart`.`shifts` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `employee_id` INT NOT NULL,
  `start_time` TIMESTAMP NOT NULL,
  `end_time` TIMESTAMP NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_employee_shifts_idx` (`employee_id` ASC) VISIBLE,
  CONSTRAINT `fk_employee_shifts`
    FOREIGN KEY (`employee_id`)
    REFERENCES `parksmart`.`employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `parksmart`.`entries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parksmart`.`entries` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `vehicle_id` INT NOT NULL,
  `shift_id` INT NOT NULL,
  `entry_time` TIMESTAMP NOT NULL,
  `exit_time` TIMESTAMP NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_vehicle_entries_idx` (`vehicle_id` ASC) VISIBLE,
  INDEX `fk_shift_entries_idx` (`shift_id` ASC) VISIBLE,
  CONSTRAINT `fk_vehicle_entries`
    FOREIGN KEY (`vehicle_id`)
    REFERENCES `parksmart`.`vehicles` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_shift_entries`
    FOREIGN KEY (`shift_id`)
    REFERENCES `parksmart`.`shifts` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `parksmart`.`tickets`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parksmart`.`tickets` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `entry_id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_entry_tickets_idx` (`entry_id` ASC) VISIBLE,
  CONSTRAINT `fk_entry_tickets`
    FOREIGN KEY (`entry_id`)
    REFERENCES `parksmart`.`entries` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `parksmart`.`subscriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parksmart`.`subscriptions` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `client_id` INT NOT NULL,
  `vehicle_id` INT NOT NULL,
  `rate_id` INT NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_client_subscriptions_idx` (`client_id` ASC) VISIBLE,
  INDEX `fk_vehicle_subscriptions_idx` (`vehicle_id` ASC) VISIBLE,
  INDEX `fk_rate_subscriptions_idx` (`rate_id` ASC) VISIBLE,
  CONSTRAINT `fk_client_subscriptions`
    FOREIGN KEY (`client_id`)
    REFERENCES `parksmart`.`clients` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_vehicle_subscriptions`
    FOREIGN KEY (`vehicle_id`)
    REFERENCES `parksmart`.`vehicles` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_rate_subscriptions`
    FOREIGN KEY (`rate_id`)
    REFERENCES `parksmart`.`rates` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `parksmart`.`payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parksmart`.`payments` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `ticket_id` INT NOT NULL,
  `rate_id` INT NOT NULL,
  `method` VARCHAR(50) NOT NULL,
  `amount` BIGINT NOT NULL,
  `pay_date` DATE NOT NULL,
  `reference` VARCHAR(100) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_ticket_payments_idx` (`ticket_id` ASC) VISIBLE,
  INDEX `fk_rate_payments_idx` (`rate_id` ASC) VISIBLE,
  CONSTRAINT `fk_ticket_payments`
    FOREIGN KEY (`ticket_id`)
    REFERENCES `parksmart`.`tickets` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_rate_payments`
    FOREIGN KEY (`rate_id`)
    REFERENCES `parksmart`.`rates` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
