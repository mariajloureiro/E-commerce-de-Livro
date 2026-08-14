# 📚 E-Commerce de Livros (Epílogo)

Um projeto de plataforma de comércio eletrônico de livros desenvolvido com **HTML, CSS, JavaScript, PHP e MySQL**, aplicando os padrões de projeto **Strategy** e **Observer**.

---

## 📌 Visão Geral do Projeto

O sistema simula uma livraria virtual completa, gerenciando a navegação do catálogo, o fluxo de compras e a gestão de usuários com autenticação de sessão. O foco principal da arquitetura é a aplicação de **Padrões de Projeto GoF (Gang of Four)** para manter a solução legível e desacoplada.

---

## 🧠 Padrões de Projeto Utilizados

### 1. 🎯 Strategy Pattern (Padrão Estratégia)
* **Cálculo de Frete:** Define estratégias intercambiáveis (ex: *PAC*, *Sedex*, *Frete Grátis*) sem poluir a regra principal com condicionais encadeadas (`if/else`).
* **Processamento de Pagamento:** Algoritmos específicos para validar e executar pagamentos em diferentes modalidades (*Cartão*, *Pix*, *Boleto*).

### 2. 👁️ Observer Pattern (Padrão Observador)
* **Gestão de Eventos e Carrinho:** Notificação automática para atualização dinâmica de componentes da interface (contador do carrinho, cálculo de totais e status de pedidos) quando o estado do pedido é alterado.

---

## 🛠️ Tecnologias Utilizadas

| Camada | Tecnologias |
| :--- | :--- |
| **Front-end** | HTML5, CSS3, JavaScript, PHP |
| **Back-end / API** | PHP |
| **Banco de Dados** | MySQL |
| **Design Patterns** | Strategy Pattern, Observer Pattern |

---

## 📁 Estrutura de Pastas

```text
.
├── api/                   # Endpoints PHP para comunicação do sistema
│   ├── cadastrar.php      # Processa o cadastro de novos usuários
│   ├── livros.php         # Gerencia a busca e catálogo de livros
│   ├── login.php          # Realiza a autenticação de usuários
│   ├── logout.php         # Encerra a sessão do usuário
│   ├── pedido.php         # Processa os pedidos e regras de negócio
│   └── sessao.php         # Valida o estado das sessões ativas
├── capas/                 # Imagens das capas dos livros do catálogo
├── config.php             # Configuração de conexão com o MySQL
├── epilogo_banco.sql      # Script de criação do banco de dados MySQL
├── epilogo.html           # Interface principal da aplicação (Livraria)
├── login.html             # Interface para autenticação e cadastro de usuários
└── README.md              # Documentação do projeto
