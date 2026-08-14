# 📚 E-Commerce de Livros (Bookstore)

Um projeto de plataforma de comércio eletrônico de livros desenvolvido em **HTML, CSS e JavaScript**, integrado a um banco de dados **MySQL** e estruturado com **Padrões de Projeto (Design Patterns)**.

---

## 📌 Visão Geral do Projeto

Este sistema simula o fluxo completo de navegação, checkout e eventos de compra de uma livraria virtual. O foco principal da aplicação é demonstrar a aplicação prática de **Padrões de Projeto GoF (Gang of Four)** para criar um código legível, reutilizável e desacoplado.

---

## 🧠 Padrões de Projeto Utilizados

### 1. 🎯 Strategy Pattern (Padrão Estratégia)
* **Objetivo:** Encapsular diferentes algoritmos ou regras de negócios e torná-los intercambiáveis em tempo de execução.
* **Aplicação no Projeto:**
  * **Cálculo de Frete:** Diferentes estratégias para cálculo de envio (ex: *PAC*, *Sedex*, *Retirada na Loja*, *Frete Grátis*).
  * **Métodos de Pagamento:** Algoritmos específicos para processar diferentes formas de pagamento (*Cartão de Crédito*, *Pix*, *Boleto Bancário*) sem poluir a regra principal com condicionais encadeadas (`if/else`).

### 2. 👁️ Observer Pattern (Padrão Observador)
* **Objetivo:** Definir uma dependência um-para-muitos entre objetos, onde a mudança de estado de um objeto notifica e atualiza automaticamente todos os seus dependentes.
* **Aplicação no Projeto:**
  * **Atualização de Carrinho e Totais:** Ao adicionar/remover um livro, componentes da interface (contador do carrinho, subtotal e resumo de preços) são notificados e atualizados automaticamente.
  * **Notificação de Estoque/Status do Pedido:** Sistema de ouvintes para alterações no status do pedido (ex: *Pagamento Aprovado* $\rightarrow$ *Notificar Cliente*, *Atualizar Estoque*).

---

## 🛠️ Tecnologias e Ferramentas

| Camada | Tecnologia |
| :--- | :--- |
| **Front-end** | HTML5, CSS3, JavaScript (ES6+) |
| **Banco de Dados** | MySQL |
| **Padrões de Arquitetura/Design** | Strategy Pattern, Observer Pattern |
| **Controle de Versão** | Git & GitHub |

---

## 🗄️ Estrutura do Banco de Dados (MySQL)

O banco de dados armazena informações relativas ao catálogo de livros, usuários, pedidos e itens do pedido:

* **`livros`**: Informações do catálogo (título, autor, preço, imagem, estoque, categoria).
* **`usuarios`**: Dados de cadastro dos clientes.
* **`pedidos`**: Histórico de compras, valor total, método de pagamento e status do pedido.
* **`itens_pedido`**: Mapeamento entre pedidos e livros comprados.

---

## 📁 Estrutura de Pastas

```text
.
├── css/
│   ├── main.css           # Estilos globais e layout
│   └── components.css     # Estilos de botões, cards e modais
├── js/
│   ├── patterns/
│   │   ├── strategy/      # Implementação das estratégias (Frete e Pagamento)
│   │   └── observer/      # Implementação do Subject/Observer (Carrinho/Status)
│   ├── models/            # Modelos de dados (Livro, Carrinho, Pedido)
│   └── app.js             # Script principal e manipulação da DOM
├── database/
│   └── schema.sql         # Script SQL para criação das tabelas no MySQL
├── index.html             # Página principal / Catálogo de Livros
├── carrinho.html          # Página do carrinho de compras
├── checkout.html          # Finalização da compra
└── README.md              # Documentação do projeto
