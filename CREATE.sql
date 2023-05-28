CREATE SCHEMA projbd;

CREATE TABLE projbd.usuario (
  id int NOT NULL,
  nome varchar(255) NOT NULL,
  sobrenome varchar(255) NOT NULL,
  cpf varchar(14) NOT NULL,
  email varchar(255) NOT NULL,
  senha varchar(99) NOT NULL,
  data_nasc DATE NOT NULL,
  telefone varchar(20),
  id_loja int NOT NULL,
  PRIMARY KEY (ID)
);

CREATE TABLE projbd.cliente (
  id int NOT NULL,
  nome varchar(255) NOT NULL,
  sobrenome varchar(255) NOT NULL,
  cpf varchar(14) NOT NULL,
  email varchar(255) NOT NULL,
  senha varchar(99) NOT NULL,
  data_nasc DATE NOT NULL,
  telefone varchar(20) NOT NULL,
  PRIMARY KEY (ID)
);

CREATE TABLE projbd.fornecedor (
  id int NOT NULL,
  nome varchar(255) NOT NULL,
  sobrenome varchar(255) NOT NULL,
  razao_social varchar(255),
  num_inscricao varchar(14),
  email varchar(255) NOT NULL,
  senha varchar(99) NOT NULL,
  data_nasc DATE NOT NULL,
  telefone varchar(20),
  id_loja int NOT NULL,
  PRIMARY KEY (ID)
);

CREATE TABLE projbd.loja (
  id int NOT NULL,
  razao_social varchar(255) NOT NULL,
  cnpj varchar(14) NOT NULL,
  endereco varchar(999) NOT NULL,
  telefone varchar(11) NOT NULL,
  PRIMARY KEY (ID)
);

CREATE TABLE projbd.estoque (
  id int NOT NULL,
  nome varchar(255) NOT NULL,
  id_loja int NOT NULL,
  id_produto int NOT NULL,
  quantidade int NOT NULL,
  PRIMARY KEY (ID),
  FOREIGN KEY (id_loja) REFERENCES projbd.loja(id)
);

CREATE TABLE projbd.produto (
  id int NOT NULL,
  nome varchar(255) NOT NULL,
  cod_barra varchar(13) NOT NULL,
  preco DECIMAL(10,2) NOT NULL,
  id_estoque int NOT NULL,
  id_ultimo_usuario int NOT NULL,
  PRIMARY KEY (ID),
  FOREIGN KEY (id_estoque) REFERENCES projbd.estoque(id),
  FOREIGN KEY (id_ultimo_usuario) REFERENCES projbd.usuario(id)
);

CREATE TABLE projbd.categoria (
  id int NOT NULL,
  nome varchar(255) NOT NULL,
  tipo_categoria int NOT NULL,
  descricao varchar(999) NOT NULL,
  PRIMARY KEY (ID)
);

CREATE TABLE projbd.carrinho_compra (
  id int NOT NULL,
  data_compra DATE NOT NULL,
  id_loja int NOT NULL,
  id_cliente int NOT NULL,
  PRIMARY KEY (ID),
  FOREIGN KEY (id_loja) REFERENCES projbd.loja(id),
  FOREIGN KEY (id_cliente) REFERENCES projbd.cliente(id)
);

CREATE TABLE projbd.produtos_carrinhos_compra (
  id int NOT NULL,
  quantidade int NOT NULL,
  id_produto int NOT NULL,
  id_carrinho_compra int NOT NULL,
  PRIMARY KEY (ID),
  FOREIGN KEY (id_produto) REFERENCES projbd.produto(id),
  FOREIGN KEY (id_carrinho_compra) REFERENCES projbd.carrinho_compra(id)
);

CREATE TABLE projbd.endereco (
  id int NOT NULL,
  cep varchar(8) NOT NULL,
  logradouro varchar(255) NOT NULL,
  uf varchar(2) NOT NULL,
  complemento varchar(11),
  referencia varchar(255) NOT NULL,
  apartamento varchar(25),
  id_cliente int NOT NULL,
  PRIMARY KEY (ID),
  FOREIGN KEY (id_cliente) REFERENCES projbd.cliente(id)
);

ALTER TABLE projbd.usuario ADD CONSTRAINT fk_usuario_loja FOREIGN KEY (id_loja) REFERENCES projbd.loja(id);
ALTER TABLE projbd.fornecedor ADD CONSTRAINT fk_fornecedor_loja FOREIGN KEY (id_loja) REFERENCES projbd.loja(id);
ALTER TABLE projbd.produto ADD CONSTRAINT fk_produto_estoque FOREIGN KEY (id_estoque) REFERENCES projbd.estoque(id);
ALTER TABLE projbd.produtos_carrinhos_compra ADD CONSTRAINT fk_produtos_carrinhos_compra_produto FOREIGN KEY (id_produto) REFERENCES projbd.produto(id);
ALTER TABLE projbd.produtos_carrinhos_compra ADD CONSTRAINT fk_produtos_carrinhos_compra_carrinho FOREIGN KEY (id_carrinho_compra) REFERENCES projbd.carrinho_compra(id);
ALTER TABLE projbd.carrinho_compra ADD CONSTRAINT fk_carrinho_compra_loja FOREIGN KEY (id_loja) REFERENCES projbd.loja(id);
ALTER TABLE projbd.carrinho_compra ADD CONSTRAINT fk_carrinho_compra_cliente FOREIGN KEY (id_cliente) REFERENCES projbd.cliente(id);
ALTER TABLE projbd.endereco ADD CONSTRAINT fk_endereco_cliente FOREIGN KEY (id_cliente) REFERENCES projbd.cliente(id);
