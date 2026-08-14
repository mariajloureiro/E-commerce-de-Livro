<?php
header('Content-Type: application/json; charset=utf-8');
require __DIR__ . '/../config.php';

$stmt = $pdo->query("
    SELECT l.id, l.titulo, l.autor, l.preco, l.estoque, l.cor1, l.cor2, l.capa,
           g.nome AS genero
    FROM livros l
    LEFT JOIN generos g ON g.id = l.genero_id
    ORDER BY l.id
");

$livros = $stmt->fetchAll();

// preco vem como string do PDO; converte pra número
foreach ($livros as &$l) {
    $l['preco'] = (float) $l['preco'];
    $l['estoque'] = (int) $l['estoque'];
}

echo json_encode($livros);
