-- =========================================================================
-- EPÍLOGO — banco de dados (MySQL 8+)
-- Espelha o modelo já usado no epilogo.html: Livro, Pedido, ItemPedido,
-- EstrategiaPagamento (formas_pagamento) e Cliente (que atua como Observador).
-- =========================================================================

CREATE DATABASE IF NOT EXISTS epilogo_livraria
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE epilogo_livraria;

-- -------------------------------------------------------------------------
-- Gêneros (evita repetir texto solto em cada livro)
-- -------------------------------------------------------------------------
CREATE TABLE generos (
  id    INT AUTO_INCREMENT PRIMARY KEY,
  nome  VARCHAR(60) NOT NULL UNIQUE
);

-- -------------------------------------------------------------------------
-- Livros — equivalente à classe Livro
-- -------------------------------------------------------------------------
CREATE TABLE livros (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  titulo     VARCHAR(150) NOT NULL,
  autor      VARCHAR(120) NOT NULL,
  preco      DECIMAL(10,2) NOT NULL,
  estoque    INT NOT NULL DEFAULT 0,
  genero_id  INT,
  cor1       VARCHAR(7),   -- hex, fallback quando não há capa
  cor2       VARCHAR(7),
  capa       VARCHAR(255), -- caminho do arquivo em /capas
  CONSTRAINT fk_livro_genero FOREIGN KEY (genero_id) REFERENCES generos(id)
);

-- -------------------------------------------------------------------------
-- Clientes — equivalente à classe Cliente (Observador), agora com login
-- -------------------------------------------------------------------------
CREATE TABLE clientes (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  nome        VARCHAR(120) NOT NULL,
  email       VARCHAR(160) NOT NULL UNIQUE,
  senha_hash  VARCHAR(255) NOT NULL,
  criado_em   DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- -------------------------------------------------------------------------
-- Formas de pagamento — equivalente às subclasses de EstrategiaPagamento
-- -------------------------------------------------------------------------
CREATE TABLE formas_pagamento (
  id      INT AUTO_INCREMENT PRIMARY KEY,
  codigo  VARCHAR(20) NOT NULL UNIQUE, -- 'cartao' | 'pix' | 'boleto'
  nome    VARCHAR(60) NOT NULL
);

-- -------------------------------------------------------------------------
-- Pedidos — equivalente à classe Pedido
-- -------------------------------------------------------------------------
CREATE TABLE pedidos (
  id                  INT AUTO_INCREMENT PRIMARY KEY,
  cliente_id          INT NOT NULL,
  forma_pagamento_id  INT,
  status              ENUM('aberto','confirmado','falhou') NOT NULL DEFAULT 'aberto',
  total               DECIMAL(10,2) NOT NULL DEFAULT 0,
  criado_em           DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_pedido_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(id),
  CONSTRAINT fk_pedido_pagamento FOREIGN KEY (forma_pagamento_id) REFERENCES formas_pagamento(id)
);

-- -------------------------------------------------------------------------
-- Itens do pedido — equivalente à classe ItemPedido
-- preco_unitario guarda o preço no momento da compra (histórico, não muda
-- se o preço do livro for reajustado depois)
-- -------------------------------------------------------------------------
CREATE TABLE itens_pedido (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  pedido_id       INT NOT NULL,
  livro_id        INT NOT NULL,
  quantidade      INT NOT NULL DEFAULT 1,
  preco_unitario  DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_item_pedido FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
  CONSTRAINT fk_item_livro  FOREIGN KEY (livro_id)  REFERENCES livros(id)
);

CREATE INDEX idx_livros_genero      ON livros(genero_id);
CREATE INDEX idx_pedidos_cliente    ON pedidos(cliente_id);
CREATE INDEX idx_itens_pedido       ON itens_pedido(pedido_id);
CREATE INDEX idx_itens_livro        ON itens_pedido(livro_id);

-- =========================================================================
-- DADOS INICIAIS — mesmo acervo que já está no array `acervo` do JS
-- =========================================================================

INSERT INTO generos (nome) VALUES
  ('Clássico Nacional'), ('Mistério'), ('Realismo Mágico'),
  ('Gótico'), ('Clássico Estrangeiro'), ('Suspense');

INSERT INTO formas_pagamento (codigo, nome) VALUES
  ('cartao', 'Cartão de Crédito'),
  ('pix',    'Pix'),
  ('boleto', 'Boleto Bancário');

INSERT INTO livros (titulo, autor, preco, estoque, genero_id, cor1, cor2, capa) VALUES
  ('Dom Casmurro',              'Machado de Assis',        42.90, 7,  (SELECT id FROM generos WHERE nome='Clássico Nacional'),   '#7a2e22','#b9924a','capas/Dom-Casmurro.png'),
  ('O Nome da Rosa',            'Umberto Eco',              58.50, 4,  (SELECT id FROM generos WHERE nome='Mistério'),              '#2f4a37','#d9b774','capas/O-nome-da-Rosa.png'),
  ('Cem Anos de Solidão',       'G. G. Márquez',            64.00, 5,  (SELECT id FROM generos WHERE nome='Realismo Mágico'),       '#5c3826','#efe3c8','capas/Cem-anos-de-Solidao.png'),
  ('Frankenstein',              'Mary Shelley',             39.90, 9,  (SELECT id FROM generos WHERE nome='Gótico'),                '#241712','#7a2e22','capas/Frankenstein.png'),
  ('Grande Sertão: Veredas',    'Guimarães Rosa',           55.00, 6,  (SELECT id FROM generos WHERE nome='Clássico Nacional'),   '#7a2e22','#efe3c8','capas/Grande-sertao-veredas.png'),
  ('Drácula',                   'Bram Stoker',              36.50, 8,  (SELECT id FROM generos WHERE nome='Gótico'),                '#241712','#d9b774','capas/Dracula.png'),
  ('A Hora da Estrela',         'Clarice Lispector',        33.90, 10, (SELECT id FROM generos WHERE nome='Clássico Nacional'),   '#2f4a37','#b9924a','capas/A-hora-da-estrela.png'),
  ('O Processo',                'Franz Kafka',              41.00, 5,  (SELECT id FROM generos WHERE nome='Mistério'),              '#3b241a','#efe3c8','capas/O-processo.png'),
  ('Rebecca',                   'Daphne du Maurier',        44.90, 6,  (SELECT id FROM generos WHERE nome='Gótico'),                '#7a2e22','#efe3c8','capas/Rebecca.png'),
  ('Ensaio sobre a Cegueira',   'José Saramago',            49.90, 4,  (SELECT id FROM generos WHERE nome='Realismo Mágico'),       '#241712','#b9924a','capas/Ensaio-sobre-cegueira.png'),
  ('O Pequeno Príncipe',        'Antoine de Saint-Exupéry', 20.00, 12, (SELECT id FROM generos WHERE nome='Clássico Estrangeiro'), '#dce9ef','#f4f4f4','capas/pequeno-principe.png'),
  ('O Colecionador',            'John Fowles',              20.00, 5,  (SELECT id FROM generos WHERE nome='Suspense'),              '#0d3b44','#1c1c1c','capas/colecionador.png'),
  ('Jantar Secreto',            'Raphael Montes',           20.00, 6,  (SELECT id FROM generos WHERE nome='Suspense'),              '#e8e6e2','#c0392b','capas/jantar-secreto.png'),
  ('Uma Família Feliz',         'Raphael Montes',           20.00, 6,  (SELECT id FROM generos WHERE nome='Suspense'),              '#e6b8c9','#f0d3df','capas/familia-feliz.png'),
  ('Dias Perfeitos',            'Raphael Montes',           20.00, 6,  (SELECT id FROM generos WHERE nome='Suspense'),              '#111318','#2c3033','capas/dias-perfeitos.png');

-- cliente de exemplo — senha "123456" (troque depois de testar)
INSERT INTO clientes (nome, email, senha_hash) VALUES
  ('Nicolly', 'nicolly@correio.com', '$2b$10$tY8px3mmReLR5MsSYpyRf.60QbFESGmMa2MfCNpJYhlKCtc0W34.q');

-- =========================================================================
-- MIGRAÇÃO — só rode isto se você JÁ tinha importado o banco antes (sem
-- login) e não quer perder os pedidos que já tem. Se for importar do zero,
-- ignore esta parte, o CREATE TABLE lá em cima já vem com senha_hash.
-- =========================================================================
-- ALTER TABLE clientes ADD COLUMN senha_hash VARCHAR(255) NOT NULL DEFAULT '' AFTER email;
-- UPDATE clientes SET senha_hash = '$2b$10$tY8px3mmReLR5MsSYpyRf.60QbFESGmMa2MfCNpJYhlKCtc0W34.q' WHERE senha_hash = '';
-- (a linha acima dá a senha "123456" pra quem já existia — troque depois)
