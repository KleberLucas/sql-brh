--Cadastrar o novo colaborador Fulano de Tal no novo projeto BI para exercer o papel de Especialista de Negócios.

--Informações sobre o colaborador
--Possui o telefone celular (61) 9 9999-9999;
--Possui o telefone residencial (61) 3030-4040;
--Email pessoal é fulano@email.com;
--Email de trabalho será é fulano.tal@brh.com;
--Possui dois dependentes:
--Filha Beltrana de Tal;
--Esposa Cicrana de Tal.


INSERT INTO brh.colaborador (matricula, nome, cpf, salario, departamento, cep, logradouro, complemento_endereco) 
VALUES 
('F124', 'Fulano de Tal', '999.888.270-86', '5000', 'SEOPE', '71111-100', 'Rua Rosa', 'Casa Muro Vermelho');

--Telefone

INSERT INTO brh.telefone_colaborador (colaborador, numero, tipo) VALUES ('F124', ' (61) 9 9999-9999', 'M');

INSERT INTO brh.telefone_colaborador (colaborador, numero, tipo) VALUES ('F124', ' (61) 3030-4040', 'R');

-- Emails

INSERT INTO brh.email_colaborador (colaborador, email, tipo) VALUES ('F124', ' fulano@email.com', 'P');
INSERT INTO brh.email_colaborador (colaborador, email, tipo) VALUES ('F124', 'fulano.tal@brh.com', 'T');

--Dependentes

INSERT INTO brh.dependente (cpf, colaborador, nome, parentesco, data_nascimento) VALUES ('989.232.122.22', 'F124', 'Beltrana de Tal', 'Filho(a)', to_date('2015-05-30', 'yyyy-mm-dd'));
INSERT INTO brh.dependente (cpf, colaborador, nome, parentesco, data_nascimento) VALUES ('092.238.123.11', 'F124', 'Esposa Cicrana de Tal', 'Cônjuge', to_date('1988-10-02', 'yyyy-mm-dd'));

-- Novo Projeto
INSERT INTO brh.projeto (id, nome, responsavel, inicio, fim) VALUES (5, 'projeto BI', 'F124', to_date('2024-06-19', 'yyyy-mm-dd'), null);


-- Novo Papel 
INSERT INTO brh.papel (id, nome) VALUES (8, 'Especialista de Negócios');

-- Nova Atribuição

INSERT INTO brh.atribuicao (projeto, colaborador, papel) VALUES (5, 'F124', 8);

--Crie uma consulta que liste a sigla e o nome do departamento;
--Adicione o código da consulta em sql/comandos.sql
--Faça commit do arquivo.
--Regras de aceitação
--O resultado da consulta deve ser ordenado pelo nome doo departamento.

SELECT sigla, nome FROM brh.departamento;


--Crie uma consulta que liste:
--nome do colaborador;
--nome do dependente;
--data de nascimento do dependente;
--parentesco do dependente.


SELECT c.nome, d.nome, d.data_nascimento, d.parentesco FROM brh.dependente d INNER JOIN brh.colaborador c ON d.colaborador = c.matricula;



--O departamento SECAP não é mais parte da nossa organização, e todos os colaboradores serão dispensados (somente para fins didáticos).

--Tarefa
--Remova o departamento SECAP da base de dados;

DELETE FROM brh.departamento WHERE sigla = 'SECAP';


--Tarefa
--Crie uma consulta que liste:
--O nome do Colaborador;
--O email de trabalho do Colaborador; e
--O telefone celular do Colaborador.

SELECT c.nome, e.email, t.numero FROM brh.email_colaborador e 
INNER JOIN brh.colaborador c ON  e.colaborador = c.matricula 
INNER JOIN brh.telefone_colaborador t ON c.matricula = t.colaborador
WHERE e.tipo = 'T' AND t.tipo = 'M';


--Tarefa
--Crie uma consulta que liste:
--O nome do Departamento;
--O nome do chefe do Departamento;
--O nome do Colaborador;
--O nome do Projeto que ele está alocado;
--O nome do papel desempenhado por ele;
--O número de telefone do Colaborador;
--O nome do Dependente do Colaborador.

SELECT d.nome as Departamento, cf.nome as "Chefe Departamento", 
c.nome as "Colaborador", prj.nome as Projeto, ppl.nome as Papel, t.numero as "Telefone", d.nome as "Nome Dependente"
FROM brh.departamento d
INNER JOIN brh.colaborador cf ON d.chefe = cf.matricula
INNER JOIN brh.colaborador c ON d.sigla = c.departamento
INNER JOIN brh.atribuicao a ON c.matricula = a.colaborador
INNER JOIN brh.projeto prj ON a.projeto = prj.id
INNER JOIN brh.papel ppl ON a.papel = ppl.id
INNER JOIN brh.telefone_colaborador t ON c.matricula = t.colaborador
INNER JOIN brh.dependente d ON c.matricula = d.colaborador;


--SEMANA 3 ------------------------------------------------------------------------------------------------------------------------
--Tarefa
--Criar uma consulta que liste os dependentes que nasceram em abril, maio ou junho, ou tenham a letra "h" no nome.;
--Adicione o código da consulta em sql/comandos.sql
--Faça commit do arquivo.

SELECT * FROM brh.dependente;

SELECT * FROM brh.dependente WHERE TO_CHAR(data_nascimento, 'MM') IN ('04', '05', '06') OR nome LIKE '%h%';

--Tarefa
--Criar consulta que liste nome e o salário do colaborador com o maior salário;

SELECT * FROM brh.colaborador ORDER BY salario desc; 

SELECT nome, salario FROM (
    SELECT nome, salario FROM brh.colaborador ORDER BY salario DESC
) WHERE ROWNUM = 1;


--A senioridade dos colaboradores é determinada a faixa salarial:

--Júnior: até R$ 3.000,00;
--Pleno: R$ 3.000,01 a R$ 6.000,00;
--Sênior: R$ 6.000,01 a R$ 20.000,00;
--Corpo diretor: acima de R$ 20.000,00.
--Tarefa
--Criar uma consulta que liste a matrícula, nome, salário, e nível de senioridade do colaborador;
--Adicione o código da consulta em sql/comandos.sql
--Faça commit do arquivo.

SELECT matricula, nome, salario,
    (
        CASE WHEN salario <= 3000 THEN 'Júnior'
        WHEN salario <= 6000 THEN 'Pleno'
        WHEN salario <= 20000 THEN 'Senior'
        ELSE 'Corpo Diretor'
        END
    ) as senoridade
FROM brh.colaborador ORDER BY senoridade, nome;


--Tarefa
--Criar consulta que liste o nome do departamento, nome do projeto e quantos colaboradores daquele departamento fazem parte do projeto;
--Adicione o código da consulta em sql/comandos.sql
--Faça commit do arquivo.
--Regras de aceitação
--Ordene a consulta pelo nome do departamento e nome do projeto.

SELECT d.nome as Departamento, p.nome as Projeto, COUNT(*) as Quantos_Participantes FROM brh.departamento d
INNER JOIN brh.colaborador c ON d.sigla = c.departamento
INNER JOIN brh.atribuicao a ON c.matricula = a.colaborador
INNER JOIN brh.projeto p ON a.projeto = p.id
GROUP BY d.nome, p.nome ORDER BY d.nome, p.nome;

-- IMPORTANTES SEMANA 3 (OPCIONAIS) -----------------------------------------------
--Tarefa
--Criar consulta que liste nome do colaborador e a quantidade de dependentes que ele possui;
--Adicione o código da consulta em sql/comandos.sql
--Faça commit do arquivo.
--Regras de aceitação
--No relatório deve ter somente colaboradores com 2 ou mais dependentes.
--Ordenar consulta pela quantidade de dependentes em ordem decrescente, e colaborador crescente.

SELECT c.nome, count(*) as num_dependentes FROM brh.dependente d
INNER JOIN brh.colaborador c ON d.colaborador = c.matricula
GROUP BY c.nome HAVING count(*) >= 2 ORDER BY num_dependentes DESC, c.nome;


--Tarefa
--Criar consulta que liste o CPF do dependente, o nome do dependente, a data de nascimento (formato brasileiro), parentesco, matrícula do colaborador, a idade do dependente e sua faixa etária;
--Adicione o código da consulta em sql/comandos.sql
--Faça commit do arquivo.
--Regras de aceitação
--Se o dependente tiver menos de 18 anos, informar a faixa etária Menor de idade;
--Se o dependente tiver 18 anos ou mais, informar faixa etária Maior de idade;
--Ordenar consulta por matrícula do colaborador e nome do dependente.

SELECT d.cpf, d.nome, d.data_nascimento, d.parentesco, d.colaborador, TRUNC(MONTHS_BETWEEN(SYSDATE, d.data_nascimento)/12) as idade,
(
    CASE WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, d.data_nascimento)/12) >= 18 THEN 'Maior de idade'
    ELSE 'Menor de idade'
    END
) AS Faixa_Etaria
FROM brh.dependente d ORDER BY d.colaborador, d.nome;

--Contexto
--O usuário quer paginar a listagem de colaboradores em páginas de 10 registros cada. Há 26 colaboradores na base, então há 3 páginas:

--Página 1: da Ana ao João (registros 1 ao 10);
--Página 2: da Kelly à Tati (registros 11 ao 20); e
--Página 3: do Uri ao Zico (registros 21 ao 26).
--Tarefa
--Crie uma consulta que liste a segunda página;
--OBS.: pense que novos registros podem ser inclusos à tabela; logo, a consulta não deve levar em consideração matrícula, etc.
--Adicione o código da consulta em sql/comandos.sql
--Faça commit do arquivo.
--Regras de aceitação
--Ordene pelo nome do colaborador.


COMMIT;
