-- Excluir tabelas existentes se elas existirem
DROP TABLE IF EXISTS Transacoes CASCADE;
DROP TABLE IF EXISTS Clientes CASCADE;
DROP TABLE IF EXISTS Cidades CASCADE;
DROP TABLE IF EXISTS Estados CASCADE;
DROP TABLE IF EXISTS TaxasCambio CASCADE;

-- Criar tabela Estados
CREATE TABLE Estados (
    estado_id SERIAL PRIMARY KEY,
    nome_estado VARCHAR(20) NOT NULL
);

INSERT INTO Estados (nome_estado) VALUES
('BA'),
('RJ'),
('SP'),
('SC');

-- Criar tabela Cidades
CREATE TABLE Cidades (
    cidade_id SERIAL PRIMARY KEY,
    nome_cidade VARCHAR(60) NOT NULL,
    estado_id INTEGER REFERENCES Estados(estado_id)
);

INSERT INTO Cidades (nome_cidade, estado_id) VALUES
('Salvador', 1),
('Rio de Janeiro', 2),
('Guarulhos', 3),
('Lauro de Freitas', 1),
('Florianópolis', 4),
('Camaçari', 1);

-- Criar tabela Clientes
CREATE TABLE Clientes (
    cliente_id SERIAL PRIMARY KEY,
    nome VARCHAR(40) NOT NULL,
    email VARCHAR(50) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    endereco TEXT NOT NULL,
    cidade_id INTEGER REFERENCES Cidades(cidade_id),
    saldo DECIMAL(10, 2) NOT NULL,
    numero_cartao VARCHAR(16) NOT NULL,
    validade_cartao DATE NOT NULL
);

INSERT INTO Clientes (nome, email, telefone, endereco, cidade_id, saldo, numero_cartao, validade_cartao) VALUES
('Thomas Edison', 'thomas@site.com', '71999998888', '123 Lapa', 1, 254800.00, '1234567890123456', '2028-12-31');

-- Criar tabela Transacoes
CREATE TABLE Transacoes (
    transacao_id SERIAL PRIMARY KEY,
    cliente_id INTEGER REFERENCES Clientes(cliente_id) ON DELETE CASCADE,
    data DATE NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    tipo_transacao VARCHAR(50) NOT NULL
);

INSERT INTO Transacoes (cliente_id, data, descricao, valor, tipo_transacao) VALUES
((SELECT cliente_id FROM Clientes WHERE nome = 'Thomas Edison'), '2023-06-01', 'Transferência G20', -250.00, 'Despesa'),
((SELECT cliente_id FROM Clientes WHERE nome = 'Thomas Edison'), '2023-06-05', 'Recarga de Celular', 280.00, 'Renda'),
((SELECT cliente_id FROM Clientes WHERE nome = 'Thomas Edison'), '2023-06-10', 'Pagamento Recebido', 280.00, 'Renda');

-- Criar tabela TaxasCambio
CREATE TABLE TaxasCambio (
    codigo_moeda VARCHAR(3) PRIMARY KEY,
    nome_moeda VARCHAR(50) NOT NULL,
    taxa_venda DECIMAL(10, 4) NOT NULL,
    taxa_compra DECIMAL(10, 4) NOT NULL
);

INSERT INTO TaxasCambio (codigo_moeda, nome_moeda, taxa_venda, taxa_compra) VALUES
('USD', 'Dólar Americano', 1.0211, 1.0121),
('SGD', 'Dólar de Singapura', 0.9801, 0.9701),
('GBP', 'Libra Esterlina', 1.1610, 1.1512),
('AUD', 'Dólar Australiano', 0.6810, 0.6710),
('EUR', 'Euro', 1.0912, 1.0812);


-- Operações CRUD

-- Criar: Inserir novos dados

-- Inserir novo estado
INSERT INTO Estados (nome_estado) VALUES ('MG');

-- Inserir nova cidade
INSERT INTO Cidades (nome_cidade, estado_id) VALUES ('Belo Horizonte', (SELECT estado_id FROM Estados WHERE nome_estado = 'MG'));

-- Inserir novo cliente
INSERT INTO Clientes (nome, email, telefone, endereco, cidade_id, saldo, numero_cartao, validade_cartao) VALUES
('Nikola Tesla', 'nikola@site.com', '601987654321', '456 Rua da Inovação', (SELECT cidade_id FROM Cidades WHERE nome_cidade = 'Belo Horizonte'), 150000.00, '6543210987654321', '2027-11-30');

-- Inserir nova transação
INSERT INTO Transacoes (cliente_id, data, descricao, valor, tipo_transacao) VALUES
((SELECT cliente_id FROM Clientes WHERE nome = 'Nikola Tesla'), '2023-07-01', 'Salário', 5000.00, 'Renda');

-- Inserir nova taxa de câmbio
INSERT INTO TaxasCambio (codigo_moeda, nome_moeda, taxa_venda, taxa_compra) VALUES ('JPY', 'Iene Japonês', 0.0092, 0.0091);

-- Ler: Selecionar dados

-- Selecionar todos os clientes
SELECT * FROM Clientes;

-- Selecionar todas as transações para um cliente específico
SELECT * FROM Transacoes WHERE cliente_id = (SELECT cliente_id FROM Clientes WHERE nome = 'Thomas Edison');

-- Selecionar todas as taxas de câmbio
SELECT * FROM TaxasCambio;

-- Atualizar: Modificar dados existentes

-- Atualizar email do cliente
UPDATE Clientes SET email = 'novoemailthomas@site.com' WHERE nome = 'Thomas Edison';

-- Atualizar valor da transação
UPDATE Transacoes SET valor = -300.00 WHERE descricao = 'Transferência G20' AND cliente_id = (SELECT cliente_id FROM Clientes WHERE nome = 'Thomas Edison');

-- Atualizar taxa de câmbio
UPDATE TaxasCambio SET taxa_venda = 1.0311, taxa_compra = 1.0221 WHERE codigo_moeda = 'USD';

-- Excluir: Remover dados

-- Excluir todas as transações do cliente antes de excluir o cliente
DELETE FROM Transacoes WHERE cliente_id = (SELECT cliente_id FROM Clientes WHERE nome = 'Nikola Tesla');

-- Excluir um cliente
DELETE FROM Clientes WHERE nome = 'Nikola Tesla';

-- Excluir uma transação
DELETE FROM Transacoes WHERE descricao = 'Recarga de Celular' AND cliente_id = (SELECT cliente_id FROM Clientes WHERE nome = 'Thomas Edison');

-- Excluir uma taxa de câmbio
DELETE FROM TaxasCambio WHERE codigo_moeda = 'JPY';