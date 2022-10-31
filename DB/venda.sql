CREATE DATABASE  IF NOT EXISTS `venda` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `venda`;
-- MySQL dump 10.13  Distrib 8.0.20, for Win64 (x86_64)
--
-- Host: localhost    Database: venda
-- ------------------------------------------------------
-- Server version	8.0.20

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `codigo` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `cidade` varchar(100) DEFAULT NULL,
  `uf` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`codigo`),
  KEY `INDEX_NOME` (`nome`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=819;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (1,'Eriveldo Mendonca','Caucaia','CE'),(2,'Fabiano Nascimento','Fortaleza','CE'),(3,'Mirlena Braga','Fortaleza','CE'),(4,'Evelyn Braga','Caucaia','CE'),(5,'Emily Braga','Caucaia','CE'),(6,'Raimundo Mendonça','Fortaleza','CE'),(7,'Valdecy Mendonça','Fortaleza','CE'),(8,'Rejane Mendonça','Fortaleza','CE'),(9,'Ana Paula Nascimento','Fortaleza','CE'),(10,'Kelly Mendonça','Fortaleza','CE'),(11,'Michelle Holanda','Fortaleza','CE'),(12,'Eneas Silva','Fortaleza','CE'),(13,'Deborah Holanda','Fortaleza','CE'),(14,'Luiz Matheus','Caucaia','CE'),(15,'William Braga','Caucaia','CE'),(16,'Valdilane Alves','Caucaia','CE'),(17,'Mirles Braga','Caucaia','CE'),(18,'Luiz Marcelo','Caucaia','CE'),(19,'Vinicius Alves','Caucaia','CE'),(20,'Nubia Mendonca','Fortaleza','CE');
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido`
--

DROP TABLE IF EXISTS `pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido` (
  `numero_pedido` int NOT NULL AUTO_INCREMENT,
  `data_emissao` date DEFAULT NULL,
  `codigo_cliente` int DEFAULT NULL,
  `valor_total` float DEFAULT NULL,
  PRIMARY KEY (`numero_pedido`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=16384;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido`
--

LOCK TABLES `pedido` WRITE;
/*!40000 ALTER TABLE `pedido` DISABLE KEYS */;
INSERT INTO `pedido` VALUES (2,'2001-01-01',20,43.3),(3,'2001-01-01',1,57);
/*!40000 ALTER TABLE `pedido` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `pedido_apaga` BEFORE DELETE ON `pedido` FOR EACH ROW /*
  Trigger: delete produtos

  Author   : Eriveldo Mendonca, 
  Date     :
  Purpose  : Exclui todos os produtos do pedido
*/
begin
/* code */
   DELETE FROM pedido_produto p WHERE p.numero_pedido = OLD.numero_pedido;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `pedido_produto`
--

DROP TABLE IF EXISTS `pedido_produto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido_produto` (
  `id` int NOT NULL AUTO_INCREMENT,
  `numero_pedido` int NOT NULL,
  `codigo_produto` int NOT NULL,
  `quantidade` float DEFAULT NULL,
  `valor_unitario` float DEFAULT NULL,
  `valor_total` float DEFAULT NULL,
  PRIMARY KEY (`id`,`numero_pedido`,`codigo_produto`),
  KEY `fk_pedido_produtos_pedido_idx` (`numero_pedido`),
  KEY `fk_pedido_produtos_produto1_idx` (`codigo_produto`),
  CONSTRAINT `fk_pedido_produtos_pedido` FOREIGN KEY (`numero_pedido`) REFERENCES `pedido` (`numero_pedido`),
  CONSTRAINT `fk_pedido_produtos_produto1` FOREIGN KEY (`codigo_produto`) REFERENCES `produto` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=16384;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido_produto`
--

LOCK TABLES `pedido_produto` WRITE;
/*!40000 ALTER TABLE `pedido_produto` DISABLE KEYS */;
INSERT INTO `pedido_produto` VALUES (18,2,6,10,4.33,43.3),(19,3,6,2,6,12),(20,3,3,9,5,45);
/*!40000 ALTER TABLE `pedido_produto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produto`
--

DROP TABLE IF EXISTS `produto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produto` (
  `codigo` int NOT NULL AUTO_INCREMENT,
  `descricao` varchar(50) NOT NULL,
  `valor_unitario` float DEFAULT NULL,
  PRIMARY KEY (`codigo`),
  KEY `INDEX_DESCRICAO` (`descricao`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=819;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produto`
--

LOCK TABLES `produto` WRITE;
/*!40000 ALTER TABLE `produto` DISABLE KEYS */;
INSERT INTO `produto` VALUES (1,'ARROZ',3.49),(2,'FEIJÃO',6.79),(3,'AÇUCAR',3.25),(4,'FARINHA',4.55),(5,'ÓLEO',9.99),(6,'FARINHA DE TRIGO',4.33),(7,'TOMATE',1.99),(8,'BANANA',4.99),(9,'MAÇA',7.99),(10,'SORVETE',19.99),(11,'CEBOLA',6.48),(12,'BANDEJA DE OVOS (20 UND)',13.99),(13,'PEITO DE FRANGO S/ OSSO',17.89),(14,'LINGUIÇA CALABRESA KG',14.29),(15,'LEITE EM PÓ (800 GR)',28.99),(16,'LEITE LONGA VIDA',4.99),(17,'MACARRÃO INSTANTÂNEO',3.49),(18,'MACARRÃO ESPAGUETE',4.99),(19,'ABACATE',6.59),(20,'GOIABA',4.65);
/*!40000 ALTER TABLE `produto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'venda'
--

--
-- Dumping routines for database 'venda'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-10-31 20:48:03
