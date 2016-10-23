#!/bin/bash
# Script para captar informações sobre atendimentos telefônicos na NET e direcionar para um arquivo txt

# Declarando as cores
LRED='\e[1;31m'; # Light Red
LGREEN='\e[1;32m'; #Light Green
NC='\e[0m'; #No Color

# DECLARANDO FUNÇÕES
# Função para agrupar os dados
imprimindo_dados(){
echo "DIA / HORA: $DATA"
echo "ATENDENTE: $ATEND"
echo "PROTOCOLO: $PROTO"
echo "DESCRIÇÃO: $DESCR"
echo
echo
}

procurando_data(){
echo "Insira os dados a serem procurados"
echo "(Deixe em branco caso queira pular para outro campo)"
echo
echo -n "DATA [dd-mm-aa]: "
read $DATA_PROC
echo
echo "Exibindo dados requisitados abaixo:"
echo
cat protocolos_BD.txt | grep -A 10 "$DATA_PROC"
}

inserindo_dados(){
while [ "$CONTINUA" != "n" ]
do
	# Interação inicial com o usuário
	echo "Insira as informações pedidas"
	echo
	DATA=`date +%d'-'%m'-'%y', '%H':'%M'h'`
	
	# Coleta de dados
	echo -e "${LRED}DIA / HORA:${NC} $DATA"
	echo -n -e "${LRED}ATENDENTE: ${NC}"
	read ATEND
	echo -n -e "${LRED}PROTOCOLO: ${NC}"
	read PROTO
	echo -n -e "${LRED}DESCRIÇÃO: ${NC}"
	read DESCR
	
	# Chamando a função e jogando o resultado para um arquivo de log
	imprimindo_dados >> protocolos_BD.txt

	# Vamos terminar ou fazer de novo?
	echo
	echo -n -e "${LGREEN}Você quer inserir outro protocolo?${NC} [s/n] "
	read CONTINUA
done
}

menu(){
clear
figlet Protocolos Net
echo "Versão 1.2 - Autor: Daniel Carvalho"
echo
echo
echo "O que você deseja fazer?"
echo
echo "[1] Inserir um protocolo"
echo "[2] Procurar um protocolo por data"
echo "[3] Sair"
echo
echo -n -e "${LGREEN}Opção:${NC} "
read OPCAO

# Fazendo as opções escolhidas acontecerem
case $OPCAO in
	1) inserindo_dados ;;
	2) procurando_data ;;
	3) echo ;
		 exit ;;
	*) echo ;
		echo -e "${LRED}Opção Inexistente${NC}";
		sleep 2 ;
		clear ;
	menu ;;
esac
}

menu
