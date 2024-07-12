
--Tarefa
--Crie o arquivo sql/plsql.sql;
--Crie a procedure brh.insere_projeto para cadastrar um novo projeto na base de dados:
--Parâmetros da procedure:
--Nome do projeto: varchar com nome do novo projeto.
--Responsável do projeto: varchar com a matrícula do colaborador responsável.
--Faça commit do arquivo.
--Regras de aceitação

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

--Tarefa
--Crie a function brh.calcula_idade, que informa a idade a partir de uma data:
--Parâmetros da function:
--Data: date com a data de referência para calcular a idade.
--Retorno da function:
--Deve retornar um número inteiro com a idade.
--Adicione o código no arquivo sql/plsql.sql;
--Faça commit do arquivo.

CREATE OR REPLACE FUNCTION brh.calcula_idade
(p_DATA IN VARCHAR2)
RETURN INTEGER
IS 
v_IDADE INTEGER;
BEGIN
    v_IDADE := TRUNC(MONTHS_BETWEEN(SYSDATE, to_date(p_data,'dd/mm/yyyy')) / 12);
    RETURN v_IDADE;
END;

VARIABLE g_IDADE INTEGER;
EXECUTE :g_IDADE:=brh.calcula_idade('01/02/1987');
print g_IDADE;
