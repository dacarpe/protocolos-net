#!/bin/bash

# Script para captar informações sobre atendimentos telefônicos em centrais de atendimento 
# e direcionar para um arquivo .csv
# Versão 2.0 | Autor: Daniel Carvalho

# TELA DE ABERTURA
yad --text-info --undecorated --title="PROTOCOLOS 2.0" --image-on-top --image=logo.png --timeout=2 --no-buttons --center --on-top 

# Criando arquivos necessários
touch prot_reg.csv
if [ -s prot_reg.csv ]
	then touch prot_reg.csv
	else echo "CENTRAL|DATA|ATENDENTE|PROTOCOLO|DESCRIÇÃO|" >> prot_reg.csv
fi

# DECLARANDO FUNÇÕES
inserindo_dados(){
yad --form --width=450 --height=340 --title="Cadastrar" --text="Insira os dados pedidos"\
	--field="Central":CBE ^NET!Oi!TIM!Vivo\
	--field="Data":DT\
	--field="Atendente"\
	--field="Protocolo"\
	--field="Descrição do atendimento":TXT >> prot_reg.csv
unset DE_NOVO
DE_NOVO=`yad --title="Prosseguir?" --text="Deseja <b>adicionar</b> outra entrada?" --image=gtk-execute`
if [ "$?" = 0 ]
	then inserindo_dados
	elif [ "$?" = 1 ]
	then tela_inicio
	else msg_erro
fi
}

procurando_dados(){
SEARCH=`yad --form --width=350 --title="Procurar" --window-icon=gtk-search --image=system-search --text="Você pode procurar por qualquer campo que quiser. É só digitar o <b>termo de pesquisa</b> no formulário abaixo.\n \n <i> * Central\n * Data [dd/mm/aaaa]\n * Atendente\n * Protocolo\n * Palavra-chave</i> \n" --field="Digite o termo"`
grep -i "$SEARCH" prot_reg.csv | tr -s '|' '\n' | yad --text-info --title=Resultado da Pesquisa --text="Abaixo seguem os resultados encontrados" --width=500 --height=650 --button=gtk-ok:0
unset DE_NOVO
DE_NOVO=`yad --title="Prosseguir?" --text="Deseja <b>procurar</b> outra entrada?" --image=gtk-execute`
if [ "$?" = 0 ]
	then procurando_dados
	elif [ "$?" = 1 ]
	then tela_inicio
	else msg_erro
fi
}

tela_inicio(){
ESCOLHA=`yad --list --width=350 --height=220 --no-headers --dialo-sep --text="O que você deseja fazer?" --title="Escolha sua opção" --separator='' --column="unica" "Cadastrar uma entrada" "Procurar uma entrada" "Sair"`

# No próximo bloco de IF poderia ter condicionado à "$?", que retorna a saída do último comando. OK, retorna 0; CANCEL retorna 1; erros e outros retorna [2-255].
if [ -z "$ESCOLHA" ]
	then exit
	elif [ "$ESCOLHA" = "Cadastrar uma entrada" ]
		then inserindo_dados
	elif [ "$ESCOLHA" = "Procurar uma entrada" ]
		then procurando_dados
	else exit
fi
}

# DECLARANDO ALIASES (ver sintaxe)
alias msg_erro='yad --button=OK --title="Ops!" --text="Algo deu errado. Tente novamente." --text-align=center --width=200 --height=120 --window-icon=error --image=dialog-error'

# PARTINDO PRO PROGRAMA

tela_inicio
