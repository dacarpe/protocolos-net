#!/bin/bash

# Script para captar informações sobre atendimentos telefônicos em centrais de atendimento 
# e direcionar para um arquivo .csv
# Versão 2.1 | Autor: Daniel Carvalho

# CRIANDO OS ARQUIVOS NECESSÁRIOS
touch prot_reg.csv
if [ -s prot_reg.csv ]
	then touch prot_reg.csv
	else echo "CENTRAL|DATA|ATENDENTE|PROTOCOLO|DESCRIÇÃO|" >> prot_reg.csv
fi

# DECLARANDO VARIÁVEIS
VERSAO="2.1"
HOJE=`date +%d/%m/%Y`

# DECLARANDO ALIASES (ver sintaxe)
alias msg_erro='yad --button=OK --title="Ops!" --text="Algo deu errado. Tente novamente." --text-align=center --width=200 --height=120 --window-icon=error --image=dialog-error'

# DECLARANDO FUNÇÕES
organizando_procura(){
GREP_VAR=`grep "$SEARCH" -i prot_reg.csv`
TITULOS=(CENTRAL DATA ATENDENTE PROTOCOLO DESCRIÇÃO)
OLDIFS="$IFS"
echo -e "PROTOCOLOS $VERSAO - Organize seus direitos" >> result.inf
echo >> result.inf
echo "====================================" >> result.inf
echo >> result.inf
while IFS=$'\n' read -r LINE
do
	IFS="|"
	read -a CAMPOS <<< "$LINE"
	IFS="$OLDIFS"
	for ((x=0;x<5;x++))
	do
		echo -e "${TITULOS[$x]}: ${CAMPOS[$x]}" >> result.inf
		done
echo >> result.inf
done <<< "$GREP_VAR"
echo "------------------------------------" >> result.inf
echo "Pesquisado em $HOJE" >> result.inf
}

inserindo_dados(){
yad --form --width=450 --height=340 --title="Cadastrar" --image=logo48.png --text="Insira os dados pedidos"\
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
if [ "$?" = 0 ]
then
	organizando_procura
	cat result.inf | yad --text-info --title="Resultado da 	Pesquisa" --image=logo48.png\
	--text="Abaixo seguem os resultados encontrados" --width=500 --height=650\
	--button=gtk-ok:0 --button=gtk-print:300
	# IF dentro de IF para testar se quer imprimir ou não
	if [ "$?" = 300 ] 
		then yad --print --type=text --filename=result.inf
	fi
	rm -f result.inf # Remover o arquivo de resultados
elif [ "$?" = 1 ]
	then tela_inicio
else msg_erro
fi
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
ESCOLHA=`yad --list --width=350 --height=220 --no-headers --dialo-sep --image=logo60.png --text="Escolha a operação que você deseja fazer" --title="Escolha a opção - PROTOCOLOS $VERSAO" --separator='' --column="unica" "Cadastrar uma entrada" "Procurar uma entrada" "Sobre o script" "Sair"`
if [ -z "$ESCOLHA" ]
	then exit
	elif [ "$ESCOLHA" = "Cadastrar uma entrada" ]
		then inserindo_dados
	elif [ "$ESCOLHA" = "Procurar uma entrada" ]
		then procurando_dados
	elif [ "$ESCOLHA" = "Sobre o script" ]
		then sobre_about
	else exit
fi
}

sobre_about(){
yad --width=350 --height=400 --title="Sobre PROTOCOLOS $VERSAO" --image=logo60.png --text="<b>PROTOCOLOS $VERSAO</b>\n \n Este é um script desenvolvido em linguagem de <b> Shell Script</b> por <b><i>Daniel Carvalho</i></b> para fins de estudo e hobbie. É gratuito e <i>open source</i>. Pode e deve ser mexido e remexido por qualquer pessoa que queria contribuir com sua melhoria.\n \n Por favor, visite 'http://https://github.com/dacarpe/' para mais informações sobre como contribuir com o código." --button=gtk-ok:0 --buttons-layout=center
tela_inicio
}

# PARTINDO PRO PROGRAMA

# TELA DE ABERTURA
yad --undecorated --title="PROTOCOLOS $VERSAO" --image-on-top --image=logo60.png --text-align=center --text="<b>PROTOCOLOS - Organize seus direitos</b>\n \n<b>Versão $VERSAO</b>  -  Autor: <i>Daniel Carvalho</i>" --timeout=2 --no-buttons --center --on-top 

tela_inicio
