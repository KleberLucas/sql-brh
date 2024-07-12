CREATE OR REPLACE PROCEDURE brh.insere_projeto
(
    p_NOME IN brh.projeto.nome%type,
    p_RESPONSAVEL IN brh.projeto.responsavel%type   
)

IS

BEGIN
    INSERT INTO brh.projeto (NOME, RESPONSAVEL, INICIO) VALUES (p_NOME, UPPER(p_RESPONSAVEL), SYSDATE);
    
    COMMIT; --NECESSARIO NO PL SQL

END;
