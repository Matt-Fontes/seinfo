-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema seinfo
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `seinfo` ;

-- -----------------------------------------------------
-- Schema seinfo
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `seinfo` DEFAULT CHARACTER SET utf8 ;
USE `seinfo` ;

-- -----------------------------------------------------
-- Table `seinfo`.`pessoa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `seinfo`.`pessoa` ;

CREATE TABLE IF NOT EXISTS `seinfo`.`pessoa` (
  `idPessoa` VARCHAR(64) NOT NULL,
  `nome` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `CPF` CHAR(11) NOT NULL,
  `senha` CHAR(32) NOT NULL,
  `nivel` INT NOT NULL COMMENT 'O nível seleciona quem vai ter acesso, 0 como usuário, 1 adm básico e 2 como super adm.',
  `classificacao` INT NOT NULL,
  PRIMARY KEY (`idPessoa`))
ENGINE = MyISAM;

CREATE UNIQUE INDEX `email_UNIQUE` ON `seinfo`.`pessoa` (`email` ASC);

CREATE UNIQUE INDEX `CPF_UNIQUE` ON `seinfo`.`pessoa` (`CPF` ASC);


-- -----------------------------------------------------
-- Table `seinfo`.`agenda`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `seinfo`.`agenda` ;

CREATE TABLE IF NOT EXISTS `seinfo`.`agenda` (
  `idAgenda` INT NOT NULL AUTO_INCREMENT,
  `dataHoraInicio` DATETIME NOT NULL,
  `dataHoraFim` DATETIME NOT NULL,
  `local` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idAgenda`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `seinfo`.`evento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `seinfo`.`evento` ;

CREATE TABLE IF NOT EXISTS `seinfo`.`evento` (
  `idEvento` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(255) NOT NULL,
  `descricao` VARCHAR(5000) NULL,
  `status` TINYINT NOT NULL DEFAULT 0,
  `idAgenda` INT NOT NULL,
  PRIMARY KEY (`idEvento`),
  CONSTRAINT `fk_evento_agenda1`
    FOREIGN KEY (`idAgenda`)
    REFERENCES `seinfo`.`agenda` (`idAgenda`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_evento_agenda1_idx` ON `seinfo`.`evento` (`idAgenda` ASC);


-- -----------------------------------------------------
-- Table `seinfo`.`categoria`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `seinfo`.`categoria` ;

CREATE TABLE IF NOT EXISTS `seinfo`.`categoria` (
  `idCategoria` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idCategoria`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `seinfo`.`atividade`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `seinfo`.`atividade` ;

CREATE TABLE IF NOT EXISTS `seinfo`.`atividade` (
  `idAtividade` INT NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(255) NOT NULL,
  `valor` FLOAT NOT NULL DEFAULT 0.00,
  `descricao` VARCHAR(5000) NULL,
  `horasParticipacao` TIME NOT NULL DEFAULT '00:00:00',
  `quantidadeVagas` INT NOT NULL DEFAULT 0,
  `idCategoria` INT NOT NULL,
  `idEvento` INT NOT NULL,
  PRIMARY KEY (`idAtividade`),
  CONSTRAINT `fk_categoria1`
    FOREIGN KEY (`idCategoria`)
    REFERENCES `seinfo`.`categoria` (`idCategoria`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_atividade_evento1`
    FOREIGN KEY (`idEvento`)
    REFERENCES `seinfo`.`evento` (`idEvento`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_categoria1_idx` ON `seinfo`.`atividade` (`idCategoria` ASC);

CREATE INDEX `fk_atividade_evento1_idx` ON `seinfo`.`atividade` (`idEvento` ASC);


-- -----------------------------------------------------
-- Table `seinfo`.`inscricaoEvento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `seinfo`.`inscricaoEvento` ;

CREATE TABLE IF NOT EXISTS `seinfo`.`inscricaoEvento` (
  `idEvento` INT NOT NULL,
  `idPessoa` VARCHAR(64) NOT NULL,
  `dataInscricao` DATE NOT NULL,
  PRIMARY KEY (`idEvento`, `idPessoa`),
  CONSTRAINT `fk_evento_has_Pessoa_evento1`
    FOREIGN KEY (`idEvento`)
    REFERENCES `seinfo`.`evento` (`idEvento`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_inscricaoEvento_pessoa1`
    FOREIGN KEY (`idPessoa`)
    REFERENCES `seinfo`.`pessoa` (`idPessoa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_evento_has_Pessoa_evento1_idx` ON `seinfo`.`inscricaoEvento` (`idEvento` ASC);

CREATE INDEX `fk_inscricaoEvento_pessoa1_idx` ON `seinfo`.`inscricaoEvento` (`idPessoa` ASC);


-- -----------------------------------------------------
-- Table `seinfo`.`inscricaoAtividade`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `seinfo`.`inscricaoAtividade` ;

CREATE TABLE IF NOT EXISTS `seinfo`.`inscricaoAtividade` (
  `idEvento` INT NOT NULL,
  `idPessoa` VARCHAR(64) NOT NULL,
  `idAtividade` INT NOT NULL,
  `dataInscricao` DATE NOT NULL,
  PRIMARY KEY (`idEvento`, `idPessoa`, `idAtividade`),
  CONSTRAINT `fk_inscricaoAtividade_atividade1`
    FOREIGN KEY (`idAtividade`)
    REFERENCES `seinfo`.`atividade` (`idAtividade`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_inscricaoAtividade_inscricaoEvento1`
    FOREIGN KEY (`idEvento` , `idPessoa`)
    REFERENCES `seinfo`.`inscricaoEvento` (`idEvento` , `idPessoa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_inscricaoAtividade_atividade1_idx` ON `seinfo`.`inscricaoAtividade` (`idAtividade` ASC);

CREATE INDEX `fk_inscricaoAtividade_inscricaoEvento1_idx` ON `seinfo`.`inscricaoAtividade` (`idEvento` ASC, `idPessoa` ASC);


-- -----------------------------------------------------
-- Table `seinfo`.`receitaInscricaoAtividade`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `seinfo`.`receitaInscricaoAtividade` ;

CREATE TABLE IF NOT EXISTS `seinfo`.`receitaInscricaoAtividade` (
  `idEvento` INT NOT NULL,
  `idPessoa` VARCHAR(64) NOT NULL,
  `idAtividade` INT NOT NULL,
  `dataPagamento` DATE NOT NULL,
  PRIMARY KEY (`idEvento`, `idPessoa`, `idAtividade`),
  CONSTRAINT `fk_receitaInscricaoAtividade_inscricaoAtividade1`
    FOREIGN KEY (`idEvento` , `idPessoa` , `idAtividade`)
    REFERENCES `seinfo`.`inscricaoAtividade` (`idEvento` , `idPessoa` , `idAtividade`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_receitaInscricaoAtividade_inscricaoAtividade1_idx` ON `seinfo`.`receitaInscricaoAtividade` (`idEvento` ASC, `idPessoa` ASC, `idAtividade` ASC);


-- -----------------------------------------------------
-- Table `seinfo`.`participaAtividade`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `seinfo`.`participaAtividade` ;

CREATE TABLE IF NOT EXISTS `seinfo`.`participaAtividade` (
  `idEvento` INT NOT NULL,
  `idPessoa` VARCHAR(64) NOT NULL,
  `idAtividade` INT NOT NULL,
  `presenca` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`idEvento`, `idPessoa`, `idAtividade`),
  CONSTRAINT `fk_participaAtividade_receitaInscricaoAtividade1`
    FOREIGN KEY (`idEvento` , `idPessoa` , `idAtividade`)
    REFERENCES `seinfo`.`receitaInscricaoAtividade` (`idEvento` , `idPessoa` , `idAtividade`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_participaAtividade_receitaInscricaoAtividade1_idx` ON `seinfo`.`participaAtividade` (`idEvento` ASC, `idPessoa` ASC, `idAtividade` ASC);


-- -----------------------------------------------------
-- Table `seinfo`.`despesa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `seinfo`.`despesa` ;

CREATE TABLE IF NOT EXISTS `seinfo`.`despesa` (
  `idDespesa` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(500) NOT NULL,
  `valor` FLOAT NOT NULL DEFAULT 0.00,
  `dataDespesa` DATE NOT NULL,
  `idEvento` INT NOT NULL,
  PRIMARY KEY (`idDespesa`),
  CONSTRAINT `fk_despesa_evento1`
    FOREIGN KEY (`idEvento`)
    REFERENCES `seinfo`.`evento` (`idEvento`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_despesa_evento1_idx` ON `seinfo`.`despesa` (`idEvento` ASC);


-- -----------------------------------------------------
-- Table `seinfo`.`receita`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `seinfo`.`receita` ;

CREATE TABLE IF NOT EXISTS `seinfo`.`receita` (
  `idReceita` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(500) NOT NULL,
  `valor` FLOAT NOT NULL DEFAULT 0.00,
  `dataReceita` DATE NOT NULL,
  `idEvento` INT NOT NULL,
  PRIMARY KEY (`idReceita`),
  CONSTRAINT `fk_receita_evento1`
    FOREIGN KEY (`idEvento`)
    REFERENCES `seinfo`.`evento` (`idEvento`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_receita_evento1_idx` ON `seinfo`.`receita` (`idEvento` ASC);


-- -----------------------------------------------------
-- Table `seinfo`.`receitaInscricaoEvento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `seinfo`.`receitaInscricaoEvento` ;

CREATE TABLE IF NOT EXISTS `seinfo`.`receitaInscricaoEvento` (
  `idEvento` INT NOT NULL,
  `idPessoa` VARCHAR(64) NOT NULL,
  `dataPagamento` DATE NOT NULL,
  PRIMARY KEY (`idEvento`, `idPessoa`),
  CONSTRAINT `fk_receitaInscricaoEvento_inscricaoEvento1`
    FOREIGN KEY (`idEvento` , `idPessoa`)
    REFERENCES `seinfo`.`inscricaoEvento` (`idEvento` , `idPessoa`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_receitaInscricaoEvento_inscricaoEvento1_idx` ON `seinfo`.`receitaInscricaoEvento` (`idEvento` ASC, `idPessoa` ASC);


-- -----------------------------------------------------
-- Table `seinfo`.`protagonista`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `seinfo`.`protagonista` ;

CREATE TABLE IF NOT EXISTS `seinfo`.`protagonista` (
  `atuacao` INT NOT NULL COMMENT 'O atributo atuação é destinado para palestrante e ministrante.\nSendo 0 para palestrante e 1 para ministrante.',
  `idPessoa` VARCHAR(64) NOT NULL,
  `idAtividade` INT NOT NULL,
  PRIMARY KEY (`idPessoa`, `idAtividade`),
  CONSTRAINT `fk_protagonista_pessoa1`
    FOREIGN KEY (`idPessoa`)
    REFERENCES `seinfo`.`pessoa` (`idPessoa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_protagonista_atividade1`
    FOREIGN KEY (`idAtividade`)
    REFERENCES `seinfo`.`atividade` (`idAtividade`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_protagonista_atividade1_idx` ON `seinfo`.`protagonista` (`idAtividade` ASC);


-- -----------------------------------------------------
-- Table `seinfo`.`organizacao`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `seinfo`.`organizacao` ;

CREATE TABLE IF NOT EXISTS `seinfo`.`organizacao` (
  `idEvento` INT NOT NULL,
  `idPessoa` VARCHAR(64) NOT NULL,
  `horasParticipacao` TIME NOT NULL DEFAULT '00:00:00',
  PRIMARY KEY (`idEvento`, `idPessoa`),
  CONSTRAINT `fk_pessoa_has_evento_evento1`
    FOREIGN KEY (`idEvento`)
    REFERENCES `seinfo`.`evento` (`idEvento`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_organizacao_pessoa1`
    FOREIGN KEY (`idPessoa`)
    REFERENCES `seinfo`.`pessoa` (`idPessoa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_pessoa_has_evento_evento1_idx` ON `seinfo`.`organizacao` (`idEvento` ASC);

CREATE INDEX `fk_organizacao_pessoa1_idx` ON `seinfo`.`organizacao` (`idPessoa` ASC);


-- -----------------------------------------------------
-- Table `seinfo`.`lote`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `seinfo`.`lote` ;

CREATE TABLE IF NOT EXISTS `seinfo`.`lote` (
  `idLote` INT NOT NULL AUTO_INCREMENT,
  `valor` FLOAT NOT NULL DEFAULT 0.00,
  `dataAbertura` DATE NOT NULL,
  `dataFechamento` DATE NOT NULL,
  `idEvento` INT NOT NULL,
  PRIMARY KEY (`idLote`),
  CONSTRAINT `fk_lote_evento1`
    FOREIGN KEY (`idEvento`)
    REFERENCES `seinfo`.`evento` (`idEvento`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_lote_evento1_idx` ON `seinfo`.`lote` (`idEvento` ASC);


-- -----------------------------------------------------
-- Table `seinfo`.`imagem`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `seinfo`.`imagem` ;

CREATE TABLE IF NOT EXISTS `seinfo`.`imagem` (
  `idImagem` INT NOT NULL AUTO_INCREMENT,
  `url` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idImagem`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `url_UNIQUE` ON `seinfo`.`imagem` (`url` ASC);


-- -----------------------------------------------------
-- Table `seinfo`.`carrossel`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `seinfo`.`carrossel` ;

CREATE TABLE IF NOT EXISTS `seinfo`.`carrossel` (
  `idCarrossel` INT NOT NULL AUTO_INCREMENT,
  `status` TINYINT NOT NULL DEFAULT 0,
  `idImagem` INT NOT NULL,
  PRIMARY KEY (`idCarrossel`),
  CONSTRAINT `fk_carrossel_imagem1`
    FOREIGN KEY (`idImagem`)
    REFERENCES `seinfo`.`imagem` (`idImagem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_carrossel_imagem1_idx` ON `seinfo`.`carrossel` (`idImagem` ASC);


-- -----------------------------------------------------
-- Table `seinfo`.`agendamentoAtividade`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `seinfo`.`agendamentoAtividade` ;

CREATE TABLE IF NOT EXISTS `seinfo`.`agendamentoAtividade` (
  `idAtividade` INT NOT NULL,
  `idAgenda` INT NOT NULL,
  PRIMARY KEY (`idAtividade`, `idAgenda`),
  CONSTRAINT `fk_atividade_has_agenda_atividade1`
    FOREIGN KEY (`idAtividade`)
    REFERENCES `seinfo`.`atividade` (`idAtividade`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_atividade_has_agenda_agenda1`
    FOREIGN KEY (`idAgenda`)
    REFERENCES `seinfo`.`agenda` (`idAgenda`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_atividade_has_agenda_agenda1_idx` ON `seinfo`.`agendamentoAtividade` (`idAgenda` ASC);

CREATE INDEX `fk_atividade_has_agenda_atividade1_idx` ON `seinfo`.`agendamentoAtividade` (`idAtividade` ASC);


-- -----------------------------------------------------
-- Table `seinfo`.`eventoImagem`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `seinfo`.`eventoImagem` ;

CREATE TABLE IF NOT EXISTS `seinfo`.`eventoImagem` (
  `idEvento` INT NOT NULL,
  `idImagem` INT NOT NULL,
  PRIMARY KEY (`idEvento`, `idImagem`),
  CONSTRAINT `fk_evento_has_imagem_evento1`
    FOREIGN KEY (`idEvento`)
    REFERENCES `seinfo`.`evento` (`idEvento`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_evento_has_imagem_imagem1`
    FOREIGN KEY (`idImagem`)
    REFERENCES `seinfo`.`imagem` (`idImagem`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_evento_has_imagem_imagem1_idx` ON `seinfo`.`eventoImagem` (`idImagem` ASC);

CREATE INDEX `fk_evento_has_imagem_evento1_idx` ON `seinfo`.`eventoImagem` (`idEvento` ASC);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
