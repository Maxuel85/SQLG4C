create schema G4C

CREATE TABLE G4C.Cliente (
    id_email SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    data_de_nascimento DATE,
    usuario VARCHAR(50) UNIQUE,
    senha VARCHAR(50),
    rua VARCHAR(100),
    numero INT,
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    cep VARCHAR(20)
);

CREATE TABLE G4C.Produto (
    id_produto SERIAL PRIMARY KEY,
    nome_produto VARCHAR(100),
    descricao TEXT,
    marca VARCHAR(100),
    preco DECIMAL(10, 2),
    estoque INT,
    categoria VARCHAR(50),
    CHECK (categoria IN ('feminino', 'masculino', 'infantil'))
);

CREATE TABLE G4C.Vendas (
    num_pedido SERIAL PRIMARY KEY,
    email_cliente INT REFERENCES G4C.Cliente(id_email),
    qtde_produtos INT,
    forma_pagamento VARCHAR(50),
    endereco VARCHAR(200),
    cod_produto INT REFERENCES G4C.Produto(id_produto)
);

CREATE INDEX idx_cliente_usuario ON G4C.Cliente(usuario);
CREATE INDEX idx_vendas_cliente ON G4C.Vendas(email_cliente);
CREATE INDEX idx_vendas_produto ON G4C.Vendas(cod_produto);

create FUNCTION g4c.calculo_desconto (preco float, desconto float)
	RETURNS float as $$
begin 
	return preco * (1 - desconto);
END
$$ language PLPGSQL

select * from g4c.cliente

alter table g4c.cliente
add column estado char(2);

INSERT INTO g4c.cliente (
    nome, 
    data_de_nascimento, 
    usuario, 
    senha, 
    rua, 
    numero, 
    bairro, 
    cidade, 
    cep,  
    estado
)
VALUES 
('Mariana Rissi', '1994-04-01', 'maririssi', 'M@ri1994', 'Av Europa', '1016', 'Tibery', 'Uberlândia', '38405-088', 'MG'),
('Suzy Elizabeth', '1971-12-28', 'suzy28', 'senh@1234', 'Rua Professor Honório Monteiro', '523', '2° Distrito Industrial', 'Araraquara', '14808-152', 'SP'),
('Roberto de Almeida', '1975-02-17', 'robalmeida', 'mkt!error', 'R. Capim Grosso', '179', 'Conceição', 'Feira de Santana', '44066-560', 'BA'),
('Mônica de Castro', '2000-03-13', 'mcastro', 'm0n1c@', 'R. 25 de Dezembro', '359', 'Centro', 'Palotina', '85950-000', 'PR'),
('Fátima Rita de Cássia', '1998-01-11', 'fatimacassia', '1998cassia*', 'R. Lima Duarte', '283', 'Bsq Dos Eucaliptos', 'São José dos Campos', '12233-230', 'SP'),
('Júnior Ferreira Lima', '1982-05-06', 'jrferreira', 'p1nkl3m0n', 'R. Miguel Fernandes', '271', 'Méier', 'Rio de Janeiro', '20780-060', 'RJ'),
('Anderson Kennedy', '1988-11-09', 'kennedy', 'qualminhasenha+', 'Rua Cel. Pimenta', '300', 'Centro', 'Itaperuna', '28300-000', 'RJ'),
('Ana Luz Marchetti', '2005-08-20', 'aluzmar', 'tvmonitor1500', 'Asa Norte Superquadra Norte', '402', 'Via L1 Norte', 'Brasília', '70834-000', 'DF');

INSERT INTO g4c.cliente (
    nome, 
    data_de_nascimento, 
    usuario, 
    senha, 
    rua, 
    numero, 
    bairro, 
    cidade, 
    cep,  
    estado
)
VALUES 
('Ana Souza', '1985-04-12', 'anasouza', 'as123456', 'Rua das Flores', '123', 'Centro', 'São Paulo', '01001-000', 'SP'),
('Bruno Lima', '1990-08-23', 'brunolima', 'bl789101', 'Av. Paulista', '456', 'Bela Vista', 'São Paulo', '01310-000', 'SP'),
('Carlos Oliveira', '1978-12-30', 'carlosoliveira', 'co112233', 'Rua do Comércio', '789', 'Vila Olímpia', 'São Paulo', '04547-130', 'SP'),
('Daniela Ferreira', '1995-06-14', 'daniferreira', 'df654321', 'Rua das Laranjeiras', '321', 'Botafogo', 'Rio de Janeiro', '22240-003', 'RJ'),
('Eduardo Silva', '1982-11-07', 'eduardosilva', 'es098765', 'Av. Rio Branco', '987', 'Centro', 'Rio de Janeiro', '20040-004', 'RJ');

select * from g4c.produto

ALTER TABLE g4c.produto
RENAME COLUMN nome_produto TO codigo;

INSERT INTO g4c.produto (
    codigo, 
    descricao, 
    marca, 
    preco, 
    estoque, 
    categoria
)
VALUES
('gfc_11', 'Kit Lola Cosmetics Morte Súbita Dupla Ação (2 Produtos)', 'LOLA FROM RIO', 54.90, 50, 'feminino'),
('gfc_24', 'Kit Oil Reflections & Refill Lively Mini (2 Produtos)', 'WELLA PROFESSIONALS', 135.90, 120, 'feminino'),
('gfc_56', 'Kit Pro-V Restauração Duo (2 Produtos)', 'Pantene', 30.71, 100, 'feminino'),
('gfc_71', 'Men Cabelos & Barba Shampoo Anticaspa 200ml', 'CLEAR', 21.99, 90, 'masculino'),
('gfc_05', 'Kit Homme Creme de Barbear + Creme Pós-Barba (3 Produtos)', 'OUJI', 158.00, 50, 'masculino'),
('gfc_69', 'Kit com Necessaire', 'NEW OLD MAN', 242.00, 80, 'masculino'),
('gfc_16', 'Kit Shampoo + Condicionador (2 Produtos)', 'EUDORA', 50.48, 60, 'infantil'),
('gfc_86', 'S.O.S Cachos Kids - Creme de Pentear 300ml', 'SALON LIN', 16.48, 100, 'infantil'),
('gfc_91', 'Kit Cabelos Liso Duo (2 Produtos)', 'BIO EXTRATUS', 9.99, 50, 'infantil');

select * from g4c.vendas

INSERT INTO g4c.vendas (
    num_pedido, 
    email_cliente, 
    qtde_produtos, 
    forma_pagamento, 
    endereco
)
VALUES
-- Dados de exemplo para os pedidos sem a coluna cod_produto
(1, 1, 2, 'Cartão de Crédito', 'Rua das Flores, 123, Centro, São Paulo - SP, 01001-000'),
(2, 2, 1, 'Boleto Bancário', 'Av. Paulista, 456, Bela Vista, São Paulo - SP, 01310-000'),
(3, 3, 3, 'Pix', 'Rua do Comércio, 789, Vila Olímpia, São Paulo - SP, 04547-130'),
(4, 4, 1, 'Cartão de Débito', 'Rua das Laranjeiras, 321, Botafogo, Rio de Janeiro - RJ, 22240-003'),
(5, 5, 2, 'Cartão de Crédito', 'Av. Rio Branco, 987, Centro, Rio de Janeiro - RJ, 20040-004'),
(6, 6, 1, 'Boleto Bancário', 'Rua Miguel Fernandes, 271, Méier, Rio de Janeiro - RJ, 20780-060'),
(7, 7, 2, 'Cartão de Débito', 'Rua Cel. Pimenta, 300, Centro, Itaperuna - RJ, 28300-000'),
(8, 8, 1, 'Pix', 'Asa Norte Superquadra Norte, 402, Via L1 Norte, Brasília - DF, 70834-000'),
(9, 9, 1, 'Cartão de Crédito', 'Rua Lima Duarte, 283, Bsq Dos Eucaliptos, São José dos Campos - SP, 12233-230');

ALTER TABLE g4c.vendas
DROP COLUMN cod_produto;

