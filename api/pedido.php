<?php
header('Content-Type: application/json; charset=utf-8');
require __DIR__ . '/../config.php';

if (empty($_SESSION['cliente_id'])) {
    http_response_code(401);
    echo json_encode(['sucesso' => false, 'erro' => 'Você precisa estar logada para fechar um pedido.']);
    exit;
}
$clienteId = $_SESSION['cliente_id'];

$body        = json_decode(file_get_contents('php://input'), true);
$formaCodigo = $body['forma_pagamento'] ?? '';
$itens       = $body['itens'] ?? []; // [{ livro_id, quantidade }]

if (!$formaCodigo || !count($itens)) {
    http_response_code(400);
    echo json_encode(['sucesso' => false, 'erro' => 'Dados incompletos para fechar o pedido.']);
    exit;
}

try {
    $pdo->beginTransaction();

    // forma de pagamento (equivalente à EstrategiaPagamento escolhida)
    $stmt = $pdo->prepare("SELECT id FROM formas_pagamento WHERE codigo = ?");
    $stmt->execute([$formaCodigo]);
    $forma = $stmt->fetch();
    if (!$forma) {
        throw new Exception("Forma de pagamento inválida.");
    }
    $formaId = $forma['id'];

    // confere estoque e trava o preço atual de cada livro
    $itensValidados = [];
    $total = 0;
    $stmtLivro = $pdo->prepare("SELECT id, titulo, preco, estoque FROM livros WHERE id = ? FOR UPDATE");

    foreach ($itens as $item) {
        $stmtLivro->execute([$item['livro_id']]);
        $livro = $stmtLivro->fetch();

        if (!$livro) throw new Exception("Livro não encontrado.");
        if ($livro['estoque'] < $item['quantidade']) {
            throw new Exception("Estoque insuficiente para \"{$livro['titulo']}\".");
        }

        $subtotal = $livro['preco'] * $item['quantidade'];
        $total += $subtotal;
        $itensValidados[] = [
            'livro_id'       => $livro['id'],
            'quantidade'     => $item['quantidade'],
            'preco_unitario' => $livro['preco'],
        ];
    }

    // cria o pedido já confirmado (o "processar()" da estratégia acontece no front)
    $stmt = $pdo->prepare("
        INSERT INTO pedidos (cliente_id, forma_pagamento_id, status, total)
        VALUES (?, ?, 'confirmado', ?)
    ");
    $stmt->execute([$clienteId, $formaId, $total]);
    $pedidoId = $pdo->lastInsertId();

    // itens do pedido + baixa de estoque
    $stmtItem   = $pdo->prepare("INSERT INTO itens_pedido (pedido_id, livro_id, quantidade, preco_unitario) VALUES (?, ?, ?, ?)");
    $stmtBaixa  = $pdo->prepare("UPDATE livros SET estoque = estoque - ? WHERE id = ?");

    foreach ($itensValidados as $it) {
        $stmtItem->execute([$pedidoId, $it['livro_id'], $it['quantidade'], $it['preco_unitario']]);
        $stmtBaixa->execute([$it['quantidade'], $it['livro_id']]);
    }

    $pdo->commit();

    echo json_encode([
        'sucesso'   => true,
        'pedido_id' => $pedidoId,
        'total'     => (float) $total,
    ]);

} catch (Exception $e) {
    $pdo->rollBack();
    http_response_code(422);
    echo json_encode(['sucesso' => false, 'erro' => $e->getMessage()]);
}
