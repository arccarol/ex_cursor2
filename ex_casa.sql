CREATE DATABASE ex_aula
GO
USE ex_aula



CREATE TABLE Curso (
    Codigo INT PRIMARY KEY,
    Nome VARCHAR(100),
    Duracao INT
);

INSERT INTO Curso (Codigo, Nome, Duracao) VALUES
(48, 'Análise e Desenvolvimento de Sistemas', 2880),
(51, 'Logística', 2880),
(67, 'Polímeros', 2880),
(73, 'Comércio Exterior', 2600),
(94, 'Gestão Empresarial', 2600);


CREATE TABLE Disciplinas (
    Codigo VARCHAR(10) PRIMARY KEY,
    Nome VARCHAR(100),
    Carga_Horaria INT
);

INSERT INTO Disciplinas (Codigo, Nome, Carga_Horaria) VALUES
('ALG001', 'Algoritmos', 80),
('ADM001', 'Administração', 80),
('LHW010', 'Laboratório de Hardware', 40),
('LPO001', 'Pesquisa Operacional', 80),
('FIS003', 'Física I', 80),
('FIS007', 'Físico Química', 80),
('CMX001', 'Comércio Exterior', 80),
('MKT002', 'Fundamentos de Marketing', 80),
('INF001', 'Informática', 40),
('ASI001', 'Sistemas de Informação', 80);


CREATE TABLE Disciplina_Curso (
    Codigo_Disciplina VARCHAR(10),
    Codigo_Curso INT,
    FOREIGN KEY (Codigo_Disciplina) REFERENCES Disciplinas(Codigo),
    FOREIGN KEY (Codigo_Curso) REFERENCES Curso(Codigo),
    PRIMARY KEY (Codigo_Disciplina, Codigo_Curso)
);


INSERT INTO Disciplina_Curso (Codigo_Disciplina, Codigo_Curso) VALUES
('ALG001', 48),
('ADM001', 48),
('ADM001', 51),
('ADM001', 73),
('ADM001', 94),
('LHW010', 48),
('LPO001', 51),
('FIS003', 67),
('FIS007', 67),
('CMX001', 51),
('CMX001', 73),
('MKT002', 51),
('MKT002', 94),
('INF001', 51),
('INF001', 73),
('ASI001', 48),
('ASI001', 94);

CREATE FUNCTION fn_disciplina(@codigoC INT)
RETURNS @tabela TABLE (
    codigoD         VARCHAR(10),
    nomeD           VARCHAR(50),
    cargaHoraria    INT,
    nomeCurso       VARCHAR(50)
)
AS
BEGIN
    DECLARE @codigoD        VARCHAR(10),
            @nomeD          VARCHAR(50),
            @cargaHoraria   INT,
            @nomeCurso      VARCHAR(50)
    DECLARE c CURSOR FOR 
        SELECT d.Codigo, d.Nome, d.Carga_Horaria, cr.Nome
        FROM Disciplinas d
        INNER JOIN Disciplina_Curso dc ON dc.Codigo_Disciplina = d.Codigo
        INNER JOIN Curso cr ON cr.Codigo = dc.Codigo_Curso
        WHERE dc.Codigo_Curso = @codigoC -- Adicionando a condição para o código do curso
    OPEN c
    FETCH NEXT FROM c INTO @codigoD, @nomeD, @cargaHoraria, @nomeCurso
    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO @tabela VALUES (@codigoD, @nomeD, @cargaHoraria, @nomeCurso)
        FETCH NEXT FROM c INTO @codigoD, @nomeD, @cargaHoraria, @nomeCurso
    END
    CLOSE c
    DEALLOCATE c
    RETURN
END


SELECT * FROM fn_disciplina(48)

----EXERCICIO CASA 

CREATE TABLE envio (
CPF					VARCHAR(20),
NR_LINHA_ARQUIV		INT,
CD_FILIAL			INT,
DT_ENVIO			DATETIME,
NR_DDD				INT,
NR_TELEFONE			VARCHAR(10),
NR_RAMAL			VARCHAR(10),
DT_PROCESSAMENT		DATETIME,
NM_ENDERECO			VARCHAR(200),
NR_ENDERECO			INT,
NM_COMPLEMENTO		VARCHAR(50),
NM_BAIRRO			VARCHAR(100),
NR_CEP				VARCHAR(10),
NM_CIDADE			VARCHAR(100),
NM_UF				VARCHAR(2)
)
GO
CREATE TABLE endereco(
CPF VARCHAR(20),
CEP VARCHAR(10),
PORTA int,
ENDEREÇO VARCHAR(200),
COMPLEMENTO VARCHAR(100),
BAIRRO VARCHAR(100),
CIDADE VARCHAR(100),
UF VARCHAR(2)
)
GO
CREATE PROCEDURE sp_insereenvio
as
declare @cpf as int
declare @cont1 as int
declare @cont2 as int
declare @conttotal as int
set @cpf = 11111
set @cont1 = 1
set @cont2 = 1
set @conttotal = 1
while @cont1 <= @cont2 and @cont2 < = 100
begin
insert into envio (CPF, NR_LINHA_ARQUIV, DT_ENVIO)
values (cast(@cpf as varchar(20)), @cont1,GETDATE())
insert into endereco (CPF,PORTA,ENDEREÇO)
values (@cpf,@conttotal,CAST(@cont2 as varchar(3))+'Rua '+CAST(@conttotal as varchar(5)))
set @cont1 = @cont1 + 1
set @conttotal = @conttotal + 1
if @cont1 > = @cont2
begin
set @cont1 = 1
set @cont2 = @cont2 + 1
set @cpf = @cpf + 1
end
end
 
exec sp_insereenvio
 
select * from envio order by CPF,NR_LINHA_ARQUIV asc
select * from endereco order by CPF asc
 
CREATE PROCEDURE MigrarEnderecos
AS
BEGIN
    DECLARE @CPF VARCHAR(20)
    DECLARE @NR_LINHA_ARQUIV INT
    DECLARE @CEP VARCHAR(10)
    DECLARE @PORTA INT
    DECLARE @ENDERECO VARCHAR(200)
    DECLARE @COMPLEMENTO VARCHAR(100)
    DECLARE @BAIRRO VARCHAR(100)
    DECLARE @CIDADE VARCHAR(100)
    DECLARE @UF VARCHAR(2)
 
    DECLARE cursor_enderecos CURSOR FOR
    SELECT CPF, PORTA, ENDEREÇO, COMPLEMENTO, BAIRRO, CEP, CIDADE, UF
    FROM endereco
 
    OPEN cursor_enderecos
    FETCH NEXT FROM cursor_enderecos INTO @CPF, @PORTA, @ENDERECO, @COMPLEMENTO, @BAIRRO, @CEP, @CIDADE, @UF
 
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Inserir os dados na tabela envio
        INSERT INTO envio (CPF, NR_LINHA_ARQUIV, CD_FILIAL, DT_ENVIO, NM_ENDERECO, NR_ENDERECO, NM_COMPLEMENTO, NM_BAIRRO, NR_CEP, NM_CIDADE, NM_UF)
        VALUES (@CPF, @NR_LINHA_ARQUIV, NULL, NULL, @ENDERECO, @PORTA, @COMPLEMENTO, @BAIRRO, @CEP, @CIDADE, @UF)
 
        FETCH NEXT FROM cursor_enderecos INTO @CPF, @PORTA, @ENDERECO, @COMPLEMENTO, @BAIRRO, @CEP, @CIDADE, @UF
    END
 
    CLOSE cursor_enderecos
    DEALLOCATE cursor_enderecos
END
 
 
EXEC MigrarEnderecos
 
select * from envio order by CPF,NR_LINHA_ARQUIV ascSELECT * FROM envio;
