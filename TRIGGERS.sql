USE projbd;

DELIMITER $$
-- Após a inserção em 'produto' para atualizar o 'estoque':
CREATE TRIGGER trg_after_insert_on_produto
AFTER INSERT ON projbd.produto
FOR EACH ROW
BEGIN
  UPDATE projbd.estoque 
  SET quantidade = quantidade + 1 
  WHERE id = NEW.id_estoque;
END $$

-- Acionado após a atualização em 'produto' para atualizar o 'estoque' quando o campo 'id_estoque' é alterado
CREATE TRIGGER trg_after_update_on_produto
AFTER UPDATE ON projbd.produto
FOR EACH ROW
BEGIN
  IF OLD.id_estoque != NEW.id_estoque THEN
    UPDATE projbd.estoque 
    SET quantidade = quantidade - 1 
    WHERE id = OLD.id_estoque;
    
    UPDATE projbd.estoque 
    SET quantidade = quantidade + 1 
    WHERE id = NEW.id_estoque;
  END IF;
END $$

-- Acionado após a inserção em 'produtos_carrinhos_compra' para atualizar o 'estoque' subtraindo a quantidade inserida.
CREATE TRIGGER trg_after_insert_on_produtos_carrinhos_compra
AFTER INSERT ON projbd.produtos_carrinhos_compra
FOR EACH ROW
BEGIN
  UPDATE projbd.estoque 
  SET quantidade = quantidade - NEW.quantidade
  WHERE id = (SELECT id_estoque FROM projbd.produto WHERE id = NEW.id_produto);
END $$

-- Acionado após a exclusão em 'produtos_carrinhos_compra' para atualizar o 'estoque' adicionando a quantidade excluída.
CREATE TRIGGER trg_after_delete_on_produtos_carrinhos_compra
AFTER DELETE ON projbd.produtos_carrinhos_compra
FOR EACH ROW
BEGIN
  UPDATE projbd.estoque 
  SET quantidade = quantidade + OLD.quantidade 
  WHERE id = (SELECT id_estoque FROM projbd.produto WHERE id = OLD.id_produto);
END $$

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
