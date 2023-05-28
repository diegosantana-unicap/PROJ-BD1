-- Trigger para atualizar automaticamente a quantidade de produtos em estoque após uma compra:
DELIMITER //
CREATE TRIGGER atualizar_quantidade_estoque
AFTER INSERT ON projbd.produtos_carrinhos_compra
FOR EACH ROW
BEGIN
  DECLARE quantidade_comprada INT;
  
  -- Obtém a quantidade comprada do produto
  SELECT quantidade INTO quantidade_comprada
  FROM projbd.produtos_carrinhos_compra
  WHERE id = NEW.id;
  
  -- Atualiza a quantidade em estoque do produto
  UPDATE projbd.estoque
  SET quantidade = quantidade - quantidade_comprada
  WHERE id = NEW.id_estoque;
END //

DELIMITER ;


-- Trigger para registrar a data de atualização de um produto sempre que seu preço for alterado:
DELIMITER //
CREATE TRIGGER registrar_data_atualizacao
AFTER UPDATE ON projbd.produto
FOR EACH ROW
BEGIN
  -- Verifica se o preço foi alterado
  IF NEW.preco <> OLD.preco THEN
    -- Insere a data atual como data de atualização
    INSERT INTO projbd.data_atualizacao_produto (id_produto, data_atualizacao)
    VALUES (NEW.id, CURDATE());
  END IF;
END //

DELIMITER ;


-- Trigger para impedir a exclusão de um fornecedor se houver produtos associados a ele:
DELIMITER //
CREATE TRIGGER impedir_exclusao_fornecedor
BEFORE DELETE ON projbd.fornecedor
FOR EACH ROW
BEGIN
  DECLARE num_produtos INT;
  
  -- Verifica se existem produtos associados ao fornecedor
  SELECT COUNT(*) INTO num_produtos
  FROM projbd.produto
  WHERE id_fornecedor = OLD.id;
  
  -- Se houver produtos associados, cancela a exclusão
  IF num_produtos > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é possível excluir o fornecedor pois há produtos associados a ele.';
  END IF;
END //

DELIMITER ;
