#!/bin/bash
# Script para captar informações sobre atendimentos telefônicos na NET e direcionar para um arquivo txt

# Declarando as cores
LRED='\e[1;31m'; # Light Red
LGREEN='\e[1;32m'; #Light Green
NC='\e[0m'; #No Color

# Tela de apresentação do script
clear
figlet Protocolos Net
echo "Versão 1.1 - Autor: Daniel Carvalho"
echo
echo

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
	
	# Função para agrupar os dados
	dados(){
	echo "DIA / HORA: $DATA"
	echo "ATENDENTE: $ATEND"
	echo "PROTOCOLO: $PROTO"
	echo "DESCRIÇÃO: $DESCR"
	echo
	echo
	}
	
	# Chamando a função e jogando o resultado para um arquivo de log
	dados >> protocolos1.0.txt

	# Vamos terminar ou fazer de novo?
	echo -n -e "${LGREEN}Você quer inserir outro protocolo?${NC} [s/n] "
	read CONTINUA
done
	
# Terminando o script
clear
exit
