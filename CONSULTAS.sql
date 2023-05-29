-- Encontrar o produto mais vendido em uma loja específica
SELECT pc.id_produto, p.nome AS nome_produto, SUM(pc.quantidade) AS total_vendido
FROM projbd.produtos_carrinhos_compra pc
JOIN projbd.produto p ON pc.id_produto = p.id
JOIN projbd.carrinho_compra cc ON pc.id_carrinho_compra = cc.id
WHERE cc.id_loja = 50
GROUP BY pc.id_produto
ORDER BY total_vendido DESC
LIMIT 1;


-- Obter o total de vendas de uma loja em um determinado período
SELECT SUM(pc.quantidade) AS total_vendido
FROM projbd.produtos_carrinhos_compra pc
JOIN projbd.carrinho_compra cc ON pc.id_carrinho_compra = cc.id
WHERE cc.id_loja = 1
AND cc.data_compra BETWEEN '2022-05-01' AND '2024-05-01';


-- Encontrar o cliente que mais comprou em uma loja
SELECT c.id, c.nome, c.sobrenome, COUNT(*) AS total_compras
FROM projbd.cliente c
JOIN projbd.carrinho_compra cc ON c.id = cc.id_cliente
WHERE cc.id_loja = 50
GROUP BY c.id
ORDER BY total_compras DESC
LIMIT 1;


-- Obter a média de vendas por categoria de produto em uma loja
SELECT c.nome AS nome_categoria, AVG(pc.quantidade) AS media_vendas
FROM projbd.produtos_carrinhos_compra pc
JOIN projbd.produto p ON pc.id_produto = p.id
JOIN projbd.categoria c ON p.id = c.id
JOIN projbd.carrinho_compra cc ON pc.id_carrinho_compra = cc.id
WHERE cc.id_loja = 50
GROUP BY c.id;


-- Encontrar o fornecedor que mais forneceu produtos para uma loja
SELECT f.id, f.nome, f.sobrenome, COUNT(*) AS total_fornecido
FROM projbd.fornecedor f
JOIN projbd.produto p ON f.id = p.id
JOIN projbd.estoque e ON p.id = e.id
JOIN projbd.loja l ON e.id_loja = l.id
WHERE l.id = 1
GROUP BY f.id
ORDER BY total_fornecido DESC
LIMIT 1;

					
-- Descobrir quais produtos de uma categoria específica são mais vendidos em uma loja
SELECT pc.id_produto, p.nome AS nome_produto, SUM(pc.quantidade) AS total_vendido
FROM projbd.produtos_carrinhos_compra pc
JOIN projbd.produto p ON pc.id_produto = p.id
JOIN projbd.categoria c ON p.id = c.id
JOIN projbd.carrinho_compra cc ON pc.id_carrinho_compra = cc.id
WHERE cc.id_loja = 50
AND c.nome = 'Hobbies'
GROUP BY pc.id_produto
ORDER BY total_vendido DESC;

						
-- TOP 5 produtos que possuem o maior preço em cada loja
SELECT l.id AS id_loja, l.razao_social, p.id AS id_produto, p.nome AS nome_produto, p.preco
FROM projbd.produto p
JOIN projbd.estoque e ON p.id = e.id
JOIN projbd.loja l ON e.id_loja = l.id
WHERE p.preco = (
  SELECT MAX(preco)
  FROM projbd.produto
  WHERE id = e.id
  LIMIT 1 
)
GROUP BY l.id, p.id
ORDER BY preco desc
LIMIT 5;

						
-- Encontrar os clientes que compraram mais de um tipo específico de produto
SELECT c.id, c.nome, c.sobrenome, COUNT(DISTINCT p.id) AS total_tipos_produto
FROM projbd.cliente c
JOIN projbd.carrinho_compra cc ON c.id = cc.id_cliente
JOIN projbd.produtos_carrinhos_compra pc ON cc.id = pc.id_carrinho_compra
JOIN projbd.produto p ON pc.id_produto = p.id
WHERE cc.id_loja = 1
GROUP BY c.id
HAVING COUNT(DISTINCT p.id) > 1;


-- TOP 5 Clientes
SELECT c.id, c.nome, c.sobrenome, COUNT(*) AS total_compras
FROM projbd.cliente c
JOIN projbd.carrinho_compra cc ON c.id = cc.id_cliente
GROUP BY c.id
ORDER BY total_compras DESC
LIMIT 5;	


-- TOP 10 lojas
SELECT l.id, l.razao_social, SUM(pc.quantidade) AS total_vendido
FROM projbd.loja l
JOIN projbd.carrinho_compra cc ON l.id = cc.id_loja
JOIN projbd.produtos_carrinhos_compra pc ON cc.id = pc.id_carrinho_compra
GROUP BY l.id
ORDER BY total_vendido DESC
LIMIT 10;