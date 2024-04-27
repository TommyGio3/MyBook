SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema MyBook
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema MyBook
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `MyBook` DEFAULT CHARACTER SET utf8 ;
USE `MyBook` ;

-- -----------------------------------------------------
-- Table `MyBook`.`Tessera`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MyBook`.`Tessera` (
  `idTessera` INT NOT NULL AUTO_INCREMENT,
  `Saldo` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`idTessera`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `MyBook`.`Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MyBook`.`Cliente` (
  `Username` VARCHAR(45) NOT NULL,
  `Password` VARCHAR(45) NOT NULL,
  `idTessera` INT NOT NULL,
  `Email` VARCHAR(45) NOT NULL,
  `Ruolo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Username`),
  INDEX `fk_Cliente_idTessera_idx` (`idTessera` ASC) VISIBLE,
  CONSTRAINT `fk_Cliente_idTessera`
    FOREIGN KEY (`idTessera`)
    REFERENCES `MyBook`.`Tessera` (`idTessera`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `MyBook`.`Anagrafica_Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MyBook`.`Anagrafica_Cliente` (
  `Nome` VARCHAR(45) NOT NULL,
  `Cognome` VARCHAR(45) NOT NULL,
  `CF` VARCHAR(45) NOT NULL,
  `Indirizzo` VARCHAR(45) NOT NULL,
  `Data_di_nascita` DATE NOT NULL,
  `Cliente_Username` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CF`),
  INDEX `fk_Anagrafica cliente_Cliente1_idx` (`Cliente_Username` ASC) VISIBLE,
  CONSTRAINT `fk_Cliente_Username`
    FOREIGN KEY (`Cliente_Username`)
    REFERENCES `MyBook`.`Cliente` (`Username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MyBook`.`Negozio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MyBook`.`Negozio` (
  `idNegozio` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NOT NULL,
  `Città` VARCHAR(45) NOT NULL,
  `Indirizzo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idNegozio`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MyBook`.`Magazzino`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MyBook`.`Magazzino` (
  `idMagazzino` INT NOT NULL AUTO_INCREMENT,
  `CIttà` VARCHAR(45) NOT NULL,
  `Indirizzo` VARCHAR(45) NOT NULL,
  `idNegozio` INT NOT NULL,
  PRIMARY KEY (`idMagazzino`),
  INDEX `fk_Negozio_idNegozio_idx` (`idNegozio` ASC) VISIBLE,
  CONSTRAINT `fk_Negozio_idNegozio`
    FOREIGN KEY (`idNegozio`)
    REFERENCES `MyBook`.`Negozio` (`idNegozio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MyBook`.`Genere`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MyBook`.`Genere` (
  `Nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MyBook`.`Libro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MyBook`.`Libro` (
  `Titolo` VARCHAR(150) NOT NULL,
  `Autore` VARCHAR(150) NOT NULL,
  `Genere` VARCHAR(45) NOT NULL,
  `Disponibilità` VARCHAR(45) NULL,
  `Prezzo` FLOAT NOT NULL,
  `Descrizione` VARCHAR(1000) NOT NULL,
  `Immagine` LONGBLOB NOT NULL,
  `ISBN` INT NOT NULL AUTO_INCREMENT,
  INDEX `fk_Genere_Tipo_idx` (`Genere` ASC) VISIBLE,
  PRIMARY KEY (`ISBN`),
  CONSTRAINT `fk_Genere_Tipo`
    FOREIGN KEY (`Genere`)
    REFERENCES `MyBook`.`Genere` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MyBook`.`Copia_Libro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MyBook`.`Copia_Libro` (
  `idCopia_libro` INT NOT NULL AUTO_INCREMENT,
  `idMagazzino` INT NOT NULL,
  `Libro_ISBN` INT NOT NULL,
  `Stato` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idCopia_libro`),
  INDEX `fk_Magazzino_idMagazzino_idx` (`idMagazzino` ASC) VISIBLE,
  INDEX `fk_Libro_ISBN_idx` (`Libro_ISBN` ASC) VISIBLE,
  CONSTRAINT `fk_Magazzino_idMagazzino`
    FOREIGN KEY (`idMagazzino`)
    REFERENCES `MyBook`.`Magazzino` (`idMagazzino`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Libro_Titolo_ISBN`
    FOREIGN KEY (`Libro_ISBN`)
    REFERENCES `MyBook`.`Libro` (`ISBN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MyBook`.`Ordine`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MyBook`.`Ordine` (
  `idOrdine` INT NOT NULL AUTO_INCREMENT,
  `Cliente_Username` VARCHAR(45) NOT NULL,
  `idTessera` INT NOT NULL,
  `Data_ordine` DATE NOT NULL,
  `idCopiaLibro` INT NOT NULL,
  PRIMARY KEY (`idOrdine`),
  INDEX `fk_Tessera_idTessera_idx` (`idTessera` ASC) VISIBLE,
  INDEX `fk_Copia_libro_id_idx` (`idCopiaLibro` ASC) VISIBLE,
  INDEX `fk_Cliente_Username_idx` (`Cliente_Username` ASC) VISIBLE,
  CONSTRAINT `fk_Cliente_Username_Ordine`
    FOREIGN KEY (`Cliente_Username`)
    REFERENCES `MyBook`.`Cliente` (`Username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Tessera_idTessera`
    FOREIGN KEY (`idTessera`)
    REFERENCES `MyBook`.`Tessera` (`idTessera`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Copia_libro_id`
    FOREIGN KEY (`idCopiaLibro`)
    REFERENCES `MyBook`.`Copia_Libro` (`idCopia_libro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `MyBook`;

DELIMITER $$
USE `MyBook`$$
CREATE DEFINER = CURRENT_USER TRIGGER `MyBook`.`Copia_Libro_AFTER_INSERT` AFTER INSERT ON `Copia_Libro` FOR EACH ROW
BEGIN
DECLARE c_disp int;/* Disponibilità copie dopo l'inserimento */
		SELECT COUNT(*) into c_disp
		FROM `Copia_Libro` 
		WHERE Libro_ISBN =  NEW.Libro_ISBN
		AND Stato = 'DISPONIBILE';

		UPDATE `Libro` SET disponibilità = c_disp
		WHERE ISBN = NEW.Libro_ISBN;
END$$

USE `MyBook`$$
CREATE DEFINER = CURRENT_USER TRIGGER `MyBook`.`Copia_Libro_AFTER_UPDATE` AFTER UPDATE ON `Copia_Libro` FOR EACH ROW
BEGIN
DECLARE c_disp int;/* Disponibilità copie dopo l'aggiornamento */
	IF (OLD.Stato = 'DISPONIBILE' && NEW.Stato = 'VENDUTO') THEN


		SELECT COUNT(*) into c_disp
		FROM `Copia_Libro` 
		WHERE Libro_ISBN =  NEW.Libro_ISBN
		AND Stato = 'DISPONIBILE';

		UPDATE `Libro` SET disponibilità = c_disp
		WHERE ISBN = NEW.Libro_ISBN;
		
	END IF;


END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
