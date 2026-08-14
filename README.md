# 📚 E-Commerce de Livros (Bookstore)

Um projeto de plataforma de comércio eletrônico de livros desenvolvido em **HTML, CSS e JavaScript**, integrado ao banco de dados **MySQL** e estruturado com **Padrões de Projeto (Design Patterns)**.

---

## 📌 Visão Geral do Projeto

O sistema simula o fluxo completo de uma livraria virtual em uma interface web simples e direta (`index.html`). O foco principal é a demonstração prática dos padrões de projeto para manter a organização e o desacoplamento do código.

---

## 🧠 Padrões de Projeto Utilizados

### 1. 🎯 Strategy Pattern (Padrão Estratégia)
* **Aplicação:** Utilizado para definir diferentes algoritmos de **Cálculo de Frete** (ex: *PAC*, *Sedex*, *Frete Grátis*) e **Métodos de Pagamento** (ex: *Cartão*, *Pix*, *Boleto*) de forma intercambiável, sem necessidade de condicionais complexas (`if/else`).

### 2. 👁️ Observer Pattern (Padrão Observador)
* **Aplicação:** Utilizado para gerenciar os eventos do **Carrinho de Compras** e **Status do Pedido**. Quando um item é adicionado ou alterado, todos os componentes observadores (contador de itens, subtotal e resumo de preços) são atualizados automaticamente na interface.

---

## 🛠️ Tecnologias Utilizadas

| Camada | Tecnologia |
| :--- | :--- |
| **Front-end** | HTML5, CSS, JavaScript|
| **Banco de Dados** | MySQL |
| **Design Patterns** | Strategy Pattern, Observer Pattern |
| **Controle de Versão** | Git e GitHub |

---

## 📁 Estrutura do Repositório

```text
.
├── capas/         # Imagens das capas dos livros do catálogo
├── index.html     # Aplicação completa (Estrutura, Estilos, Scripts e Integração)
└── README.md      # Documentação do projeto
