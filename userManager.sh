#!/bin/bash
#DICHIARAZIONE FILE DI CONFIGURAZIONE
FC=$(grep "^[^#]" user.txt)
#DICHIARAZIONE DI VARIABILE
finish=$(wc -l etc/passwd | cut -b 1-3) #conto le righe del file etc/passwd
red=`tput setaf 1` #variabile per colore rosso
green=`tput setaf 2`  #variabile per colore verde
yellow=`tput setaf 3`  #variabile per colore giallo
magenta=`tput setaf 5` #variabile per colore rosa
reset=`tput sgr0` #variabile per colore standard

function funzione1(){
	echo -e "${yellow}Questa operazione visualizza elenco utenti completo in formato ordinato e tabellare${reset}\n"
	echo -e "\n${yellow}Elenco degli utenti:${reset}"
	for utente in `cat etc/passwd | cut -d: -f1-6 | sort -t: -k3 -n` #ciclo per estrarre le righe
	do
		if [[ $(echo $utente | cut -d: -f3) -ge FC ]]; then #verifica con FC
			echo $utente | cut -d: -f1,3,4,6 | column -t -s: #stampa della riga
		fi
	done
	echo -e "\n${green}Digita INVIO per continuare${reset}"
}

function funzione2(){
	echo -e "${yellow}Questa operazione consente di visualizzare in modo tabellare e ordinato l'elenco di utenti ricercati${reset}\n"
	echo "${green}Inserisci parte iniziale del nome utente${reset}";
	read name
	indice=false
        while [ $indice != true ]
        do
		count=0 #contatore
        	for user in `cat etc/passwd | cut -d: -f1`
        	do
        		if [[ $(echo $user |  cut -d: -f1) -eq $name ]]; then
                		let count+=1 #se ho inserito un numero che non equivale a nessun utente incremento la variabile
			fi
        	done
        	if [[ $count -eq 0 ]]; then #non esiste nessun utente con nome = numero
               		echo -e "${red}ALERT: hai inserito un UID inserisci un nome utente!${reset}\n"
			read name #utente rinserisci la variabile
		else
			indice=true
		fi
	done
	echo -e "\n${yellow}Elenco degli utenti:${reset}\n"
	for utente in `cat etc/passwd | cut -d: -f1-6 | sort -t: -k3 -n`
	do
		if [[ $(echo $utente | cut -d: -f3) -ge FC ]]; then
			echo $utente | grep $name | cut -d: -f1,3,4,6 | column -t -s: #riconoscere le righe contenenti nome utente inserito
		fi
	done
	echo -e "\n${green}Digita INVIO per continuare${reset}"
}

function funzione3(){
	echo -e "Questa operazione stampa in modo chiaro tutti i dati dell'utente associato all'user ID\n"
	echo "${green}Inserici un user ID${reset}";
	read userID
	indice=false
	#CONTROLLO SU UID SE INESISTENTE RINSERISCI
	re='^[0-9]+$' #RICONOSCERE VALORI INTERI
        while [ $indice != true ]
        do
                if ! [[ $userID =~ $re ]] ; then #CONTROLLO SULL'USER ID
                        echo -e "\n${red}ALERT: NON hai inserito un userID ma un nome utente, RINSERISCI!${reset}" 
                        read  userID
                else
                        indice=fasedue
                fi
                while [ $indice == fasedue  ]
                do
                        count=0
                        for user in `cat etc/passwd | cut -d: -f3`
                        do
                                if [[ $(echo $user | cut -d: -f3) -eq $userID ]]; then
                                        let count+=1
                                fi
                        done
                        if [[ $count -eq 0 ]]; then
                                echo -e "\n${red}ALERT: UID inserito non corrisponde a nessun utente appartenente a etc/passwd! RINSERISCI${reset}\n"
                                read userID #se UID non esistente inserisco un nuovo userID
                                indice=false
                        else
                                indice=true
                        fi
                done
        done
	#CONTROLLO SEI UID DI UTENTI SPECIALI
	if [[ $userID -lt FC ]]; then
		echo -e "\n${red}User ID destinato ad utente speciale, per continuare digiti 1 altrimenti 0${reset}"
		read value #se inserisci 1 continuo l'operazione
		if [[ $value -eq 1 ]]; then
			echo -e "\n${yellow}USERNAME:${reset}"
			cat etc/passwd | grep $userID | cut -d: -f1
			echo -e "\n${yellow}USER ID:${reset}"
			cat etc/passwd | grep $userID | cut -d: -f3
			echo -e "\n${yellow}GROUP ID:${reset}"
			cat etc/passwd | grep $userID | cut -d: -f4
			echo -e "\n${yellow}HOME DIRECTORY:${reset}"
			cat etc/passwd | grep $userID | cut -d: -f6
		else
			#inserito 0 annullo l'operazione
			echo "${magenta}Operazione annullata con successo${reset}"
		fi
	else
		echo -e "\n${yellow}USERNAME:${reset}"
      		cat etc/passwd | grep $userID | cut -d: -f1
               	echo -e "\n${yellow}USER ID:${reset}"
               	cat etc/passwd | grep $userID | cut -d: -f3
               	echo -e "\n${yellow}GROUP ID:${reset}"
               	cat etc/passwd | grep $userID | cut -d: -f4
               	echo -e "\n${yellow}HOME DIRECTORY:${reset}"
               	cat etc/passwd | grep $userID | cut -d: -f6
	fi
	echo -e "\n${green}Digita INVIO per continuare${reset}"
}

function funzione4(){
	echo -e "${yellow}Questa operazione cancella un solo utente basandosi sul suo userID${reset}\n"
	echo "${green}Inserisci lo userID per il quale vuoi cancellare l'utente${reset}"
	read userID
	indice=false
	#CONTROLLO CHE USERID SIA INSERITO CORRETTAMENTE
	re='^[0-9]+$' #RICONOSCERE VALORI INTERI
	while [ $indice != true ]
	do
		if ! [[ $userID =~ $re ]] ; then #CONTROLLO SULL'USER ID
     			echo -e "\n${red}ALERT: NON hai inserito un userID ma un nome utente, RINSERISCI!${reset}" 
			read  userID
		else
			indice=fasedue
		fi
        	while [ $indice == fasedue  ]
        	do
                	count=0
                	for user in `cat etc/passwd | cut -d: -f3`
                	do
                        	if [[ $(echo $user | cut -d: -f3) -eq $userID ]]; then
                                	let count+=1
                        	fi
                	done
                	if [[ $count -eq 0 ]]; then
                        	echo -e "\n${red}ALERT: UID inserito non corrisponde a nessun utente appartenente a etc/passwd! RINSERISCI${reset}\n"
                        	read userID #se UID non esistente inserisco un nuovo userID
				indice=false
                	else
                        	indice=true
                	fi
        	done
	done
	if [[ $userID -lt FC ]]; then
		#CONTROLLO SULL'USER ID INSERITO, SE SPECIALE CHIEDO CONFERMA
		echo -e "\n${red}ALERT: questo UserID è destinato ad utente speciale! Per continuare digiti 1, altrimenti 0${reset}"
		read $value
		if [[ $value -eq 1 ]]; then
			echo -e "\nUser:"
			cat etc/passwd | grep $userID | cut -d: -f1
			#CHIEDO CONFERMA PER L'ELIMINAZIONE
			echo "${green}Conferma l'operazione di eliminazione digitando 1 o 0 per annullare${reset}"
			read value
			if [[ $value -eq uno ]]; then
				for utente in `cat etc/passwd | cut -d: -f1-3`
			        do
               				if [[ $(echo $utente | cut -d: -f3) -eq $userID ]]; then
						#COMANDO PER ELIMINARE L'UTENTE
                        			bin/userdel $(echo $utente | cut -d: -f1)
						echo "${magenta}Utente eliminato con successo${reset}"
                			fi
        			done
			else
				echo "${magenta}Operazione annullata con successo${reset}"
			fi
		else
			echo "${magenta}Operazione annullata con successo${reset}"
		fi
	else
		echo -e "\nUser:"
		cat etc/passwd | grep $userID | cut -d: -f1
		#CHIEDO CONFERMA PER ELIMINAZIONE
		echo "${green}Conferma l'operazione di eliminazione digitando 1 altrimenti 0 per annullare${reset}"
		read value
		if [[ $value -eq 1 ]]; then
			for utente in `cat etc/passwd | cut -d: -f1-3`
			do
				if  [[ $(echo $utente | cut -d: -f3) -eq $userID ]]; then
					#COMANDO PER ELIMINARE UTENTE
					bin/userdel $(echo $utente | cut -d: -f1)
					echo "${magenta}Utente eliminato con successo${reset}"
				fi
			done
		else
			echo "Operazione annullata con successo"
		fi
	fi
	echo -e "\n${green}Digita INVIO per continuare${reset}"
}

function funzione5(){
	echo -e "${yellow}Questa operazione digitando l'inizio del nome visualizza l'elenco degli utenti da eliminare${reset}\n"
	echo "${green}Inserisci il nome iniziale del gruppo di utenti che vuoi eliminare${reset}"
	read nomeGruppo
	indice=false
        #CONTROLLO CHE NOMEGRUPPO SIA INSERITO CORRETTAMENTE
        re='^[0-9]+$' #RICONOSCERE VALORI INTERI
        while [ $indice != true ]
        do
                if ! [[ $nomeGruppo =~ $re ]] ; then #CONTROLLO SU NOME GRUPPO
			indice=true
                else
                        echo -e "\n${red}ALERT: NON hai inserito nome iniziale di un gruppo ma un UID, RINSERISCI!${reset}"
			read nomeGruppo
                fi
        done

	echo "Gruppo utenti:"
	for utente in `cat etc/passwd | cut -d: -f1`
	do
		echo $utente | grep $nomeGruppo | cut -d: -f1,3,4,6 | column -t -n #STAMPO UTENTI DA ELIMINARE
	done
	echo "${green}Confermi l'operazione di eliminazione digitando 1 altrimenti 0 per annullare${reset}"
	read value
	if [[ $value -eq 1 ]]; then
		for utente in `cat etc/passwd | grep $nomeGruppo | cut -d: -f1`
		do
			utenteE=$(echo $utente | grep $nomeGruppo | cut -d: -f1) #CREO UTENTE TEMPORANEO DA ELIMINARE
			bin/userdel $utenteE #ELIMINAZIONE DELL'UTENTE
			#ELIMINAZIONE DELLE PASSWORD
			grep -v "${utenteE}" password.txt > passwordTemp.txt #SALVO TEMPORANEAMENTE PASSOWORD DA RECUPERARE
			cat passwordTemp.txt > password.txt #SOVRASCRIVO FILE PASSWORD.TXT
			rm passwordTemp.txt #ELIMINO FILE TEMPORANEO
		done
		echo "${magenta}Utenti eliminati con successo${reset}" #STAMPA DI CONFERMA
	else
		echo "${magenta}Operazione annullata con successo${reset}"
	fi
	echo -e "\n${green}Digita INVIO per continuare${reset}"
}

function funzione6(){
	echo -e "${yellow}Questa operazione permette di creare un nuovo utente${reset}\n"
	echo "${green}Inserisci nome utente:${reset}"
	read nomeU;
	re='^[0-9]+$' #RICONOSCERE VALORI INTERI
        indice=false
	while [ $indice != true ]
	do
		if  ! [[ $nomeU =~ $re ]] ; then #CONTROLLO SUl NOME UTENTE
                	#SE CORRETTO STAMPO
                	echo -e "${yellow}Hai inserito nome utente: $nomeU${reset}\n" #STAMPA DELL'USERNAME
			indice=true
        	else
                #SE INSERITO UID RINSERISCO E RISTAMPO
                echo -e "\n${red}ALERT: Hai inserito un UID e non un nome utente, RINSERISCI!${reset}" #VERIFICA DI ERRORE CHIEDO UN ALTRO USERNAME
                read nomeU
        	fi
	done
	indice=false
	while [ $indice != true ]
	do
		for utente in `cat etc/passwd | cut -d: -f1`
		do
			if [[ $nomeU == $(echo $utente | cut -d: -f1) ]]; then
				echo "${red}ALERT: Il nome utente è già stato utilizzato${reset}" #SEGNALO USERNAME GIA' UTILIZZATO
				echo "${green}Inserisci un nuovo nome utente${reset}" #INSERIMENTO DI UN ALTRO USERNAME	
				read nomeU
			else
				indice=true
			fi
		done
	done
	indice=false
	echo -e "\n${green}Inserisci userID:${reset}"
        read userID;
	while [ $indice != true ]
	do
		#CONTROLLO CHE USERID SIA INSERITO CORRETTAMENTE
        	if ! [[ $userID =~ $re ]] ; then #CONTROLLO SULL'USER ID
                	echo -e "\n${red}ALERT: NON hai inserito un userID ma un nome utente, RINSERISCI!${reset}" 
			read userID
		else
			indice=true
       		fi
	done
	if [[ $userID -lt FC ]]; then #GESTIONE DI UID IN ZONA UTENTI SPECIALI
		echo "${red}ALERT: stai creando un utente nella zona degli utenti speciali!%{reset}"
		echo "${green}Inserisci 1 per continuare o 0 altrimenti${reset}"
		read value
		if [[ $value -eq 0 ]]; then
			echo "${magenta}Operazione annullata con successo${reset}"
		else
			echo -e "\n${green}Inserisci GID:${reset}"
                        read gid;
			indice=false
			while [ $indice != true ]
			do
				#VERIFICA SU GID
       				#VERIFICA CHE VENGA INSERITO UN NUMERO ALTRIMENTI RICHIEDI
        			if ! [[ $gid =~ $re ]] ; then #CONTROLLO SU GID
                			echo -e "\n${red}ALERT: NON hai inserito un valore numerico ma una stringa, RINSERISCI!${reset}" 
                			read gid
				else
					indice=true
        			fi
			done
               		echo -e "\n${green}Inserisci SHELL:${reset}"
                	read shell;
			#CONTROLLO SU SHELL
			indice=false
			while [ $indice != true ]
			do
			        if ! [[ $shell =~ $re ]] ; then #CONTROLLO SUl SHELL
                			#SE CORRETTO STAMPO
                			echo -e "${yellow}Hai inserito shell: $shell${reset}\n" #STAMPA DELLA SHELL
					indice=true
        			else
                			#SE INSERITO VALORE NUMERICO RINSERISCO E RISTAMPO
                			echo -e "\n${red}ALERT: Hai inserito un valore numerico e non shell unica, RINSERISCI!${reset}" #VERIFICA DI ERRORE$
                			read shell
        			fi
			done
			#GESTIONE DELLE PASSWORD
                	echo "${green}Inserisci password manualmente digitando 0 o crea password casuale di 8 caratteri digitando 1${reset}"
                	read value;
                	if [[ $value -eq 1 ]]; then
                        	password=(`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 8`) #CREA PASSWORD CASUALE
				echo "${magenta}Password generata correttamente${reset}" #STAMPA DI CONFERMA
                	else
                        	echo -e "\n${green}Inserisci la password:${reset}" #UTENTE INSERISCE PASSWORD
                        	read password
                	fi

                	bin/useradd -u $userID -g $gid -p $password -s/bin/bash $nomeU #CREAZIONE DELL'UTENTE
                	echo "${magenta}Utente creato con successo, con password:${reset}" #STAMPA DI CONFERMA
                	echo "$password"
        	        echo -e "\n${green}Digita INVIO per continuare${reset}"
		fi
	else
		echo -e "\n${green}Inserisci GID:${reset}"
               	read gid
		#VERIFICA SU GID
		#VERIFICA CHE VENGA INSERITO UN NUMERO ALTRIMENTI RICHIEDI
        	indice=false
		while [ $indice != true ]
		do
			if ! [[ $gid =~ $re ]] ; then #CONTROLLO SU GID
                		echo -e "\n${red}ALERT: NON hai inserito un valore numerico ma una stringa, RINSERISCI!${reset}" 
                		read gid
			else
				indice=true
        		fi
		done
		indice=false
                echo -e "\n${green}Inserisci SHELL:${reset}"
                read shell
		#CONTROLLO SU SHELL
       		while [ $indice != true ]
		do
			if ! [[ $shell =~ $re ]] ; then #CONTROLLO SUl SHELL
                		#SE CORRETTO STAMPO
                		echo -e "${yellow}Hai inserito shell: $shell${reset}\n" #STAMPA DELLA SHELL
				indice=true
        		else
                		#SE INSERITO VALORE NUMERICO RINSERISCO E RISTAMPO
                		echo -e "\n${red}ALERT: Hai inserito un valore numerico e non shell unica, RINSERISCI!${reset}" #VERIFICA DI ERRORE$
               			read shell
        		fi
		done
		#GESTIONE DELLE PASSWORD
                echo "${green}Inserisci password manualmente digitando 0 o crea password casuale di 8 caratteri digitando 1${reset}"
                read value;
                if [[ $value -eq 1 ]]; then
                	password=(`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 8`) #CREA PASSWORD CASUALE
                        echo "${magenta}Password generata correttamente${reset}" #STAMPA DI CONFERMA
                else
                        echo -e "\n${green}Inserisci la password:${reset}" #UTENTE INSERISCE PASSWORD
                        read password
		fi

                bin/useradd -u $userID -g $gid -p $password -s/bin/bash $nomeU #CREAZIONE DELL'UTENTE
               	echo "${magenta}Utente creato con successo, con password:${reset}" #STAMPA DI CONFERMA
                echo "$password" #STAMPA PASSWORD
                echo -e "\n${green}Digita INVIO per continuare${reset}"
        fi
}

function funzione7(){
	echo -e "${yellow}Questa operazione crea utenti in serie${reset}\n"
	echo "${green}Inserisci NUMERO di nuovi utenti da creare:${reset}"
	read n
	#VERIFICA CHE VENGA INSERITO UN NUMERO ALTRIMENTI RICHIEDI
	re='^[0-9]+$' #RICONOSCERE VALORI INTERI
        indice=false
	while [ $indice != true ]
	do
		if ! [[ $n =~ $re ]] ; then #CONTROLLO SU N
                	echo -e "\n${red}ALERT: NON hai inserito un valore numerico ma una stringa, RINSERISCI!${reset}"
                	read n
		else
			indice=true
		fi
	done
	echo -e "\n${green}Inserisci NOME UTENTI generale:${reset}"
	read utente
	#VERIFICA SU NOME UTENTE
	indice=false
	while [ $indice != true ]
	do
        	if ! [[ $utente =~ $re ]] ; then #CONTROLLO SUl NOME UTENTE
                	#SE CORRETTO STAMPO
                	echo -e "${yellow}Hai inserito nome utente: $utente${reset}\n" #STAMPA DELL'USERNAME
			indice=true
        	else
                	#SE INSERITO UID RINSERISCO E RISTAMPO
                	echo "${red}ALERT: Hai inserito un UID e non un nome utente, RINSERISCI!${reset}" #VERIFICA DI ERRORE$
                	read utente
	        fi
	done
	echo "${green}Inserisci NUMERO DI BASE da inserire in coda al primo utente${reset}"
	read num_coda
	#VERIFICA SU NUMERO DI CODA
	#VERIFICA CHE VENGA INSERITO UN NUMERO ALTRIMENTI RICHIEDI
        indice=false
        while [ $indice != true ]
	do
		if ! [[ $num_coda =~ $re ]] ; then #CONTROLLO SU num_coda
                	echo -e "\n${red}ALERT: NON hai inserito un valore numerico ma una stringa, RINSERISCI!${reset}" 
	                read num_coda
		else
			indice=true
		fi
	done
	echo -e "\n${green}Inserisci USER ID iniziale:${reset}"
	read userID
	#VERIFICA SU USER ID
	#VERIFICA CHE VENGA INSERITO UN NUMERO ALTRIMENTI RICHIEDI
        indice=false
        while [ $indice != true ]
	do
		if ! [[ $userID =~ $re ]] ; then #CONTROLLO SU userID
                	echo -e "\n${red}ALERT: NON hai inserito un valore numerico ma una stringa, RINSERISCI!${reset}" 
               		read userID
		else
			indice=true
		fi
	done
	echo -e "\n${green}Inserisci GID unico:${reset}"
	read gid
	#VERIFICA SU GID
        #VERIFICA CHE VENGA INSERITO UN NUMERO ALTRIMENTI RICHIEDI
        indice=false
        while [ $indice != true ]
	do
		if ! [[ $gid =~ $re ]] ; then #CONTROLLO SU GID
                	echo -e "\n${red}ALERT: NON hai inserito un valore numerico ma una stringa, RINSERISCI!${reset}" 
                	read gid
		else
			indice=true
		fi
	done
	echo -e "\n${green}Inserisci SHELL unica:${reset}"
	read shell
	#CONTROLLO SU SHELL
	indice=false
        while [ $indice != true ]
	do
		if ! [[ $shell =~ $re ]] ; then #CONTROLLO SUl SHELL
                	#SE CORRETTO STAMPO
                	echo -e "${yellow}Hai inserito shell: $shell${reset}\n" #STAMPA DELLA SHELL
			indice=true
       		else
                	#SE INSERITO VALORE NUMERICO RINSERISCO E RISTAMPO
                	echo -e "\n${red}ALERT: Hai inserito un valore numerico e non shell unica, RINSERISCI!${reset}" #VERIFICA DI ERRORE$
                	read shell
        	fi
	done
	echo "${green}Digitare 1 per creare utenti con password casuali di 8 caratteri o 0 per creare password unica per tutti gli utenti:${reset}"
	read value
	if [[ $value -eq 0 ]]; then
		#PASSWORD UNICA PER TUTTI GLI UTENTI
		echo "${green}Inserisci la password unica:${reset}"
		read password
		fine=n+num_coda #DEFINISCO FINE DEL CICLO
		for (( ut=num_coda; ut<fine; ut++ )) #UT = VALORE INIZIALE DA METTERE IN CODA
		do
			#CREO NUOVO UTENTE CON DATI INSERITI PRIMA
			bin/useradd -u $userID -g $gid -p $password -s/bin/bash $utente$ut
			let userID+=1 #AUMENTO DI UNO L'USER ID E IL NUMERO DI CODA AUMENTA NEL CICLO
		done
		echo "${magenta}Utenti creati con successo, con password:${reset}" #STAMPA DI CONFERMA E DELLA PASSWORD
		echo "$password"
	else
		#GESTIONE DEL CASO CON PASSWORD CASUALI
		echo "Verranno generate passoword casuali di 8 caratteri e salvate sul file password.txt"
		fine=n+num_coda #DEFINISCO FINE DEL CICLO
		for (( ut=num_coda; ut<fine; ut++ )) #UT = VALORE INIZIALE DA METTERE IN CODA
		do
			#CREO NUOVO UTENTE CON DATI INSERITI PRIMA
			password=(`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 8`)
			echo $utente$ut = $password >>password.txt
			bin/useradd -u $userID -g $gid -p $password -s/bin/bash $utente$ut
			let userID+=1 #AUMENTO DI UNO L'USER ID E IL NUMERO DI CODA AUMENTA NEL CICLO
		done
		echo -e "\n${magenta}Utenti creati con successo, con password salvate nel file password.txt${magenta}" #STAMPA  DI CONFERMA
		#GESTIONE DEL FILE PASSWORD.TXT
		echo "${green}Inserisci 1 per leggere le password o 0 per continuare${reset}"
		read value
		if [[ $value -eq 1 ]]; then
			cat -n password.txt #LETTURA DELLE PASSWORD
		fi
	fi
	echo -e "\n${green}Digita INVIO per continuare${reset}"
}

function funzione_hp(){
	#STAMPO PICCOLA DESCRIZIONE PER OGNI FUNZIONE
	echo -e "${green}Questa è la funzione help del programma userManager\n${reset}"
	echo -e "\n${yellow}Funzione 1: questa operazione visualizza elenco degli utenti cn UserID maggiore di un valore inserito nel file di configurazione in formato ordinato e tabellare${reset}"
	echo -e "${yellow}Funzione 2: questa operazione consente di visualizzare in modo tabellare e ordinato l'elenco di utenti ricercati per nome inserito dall'utente${reset}"
	echo -e "${yellow}Funzione 3: questa operazione stampa in modo chiaro tutti i dati dell'utente associato all'user ID inserito dall'utente${reset}"
	echo -e "${yellow}Funzione 4: questa operazione cancella un solo utente basandosi sul suo userID, gestendo il caso di valori minori del file di configurazione, stampando i dati dell'utente che si riferisci all'UID inserito e chiedendo conferma${reset}"
	echo -e "${yellow}Funzione 5: questa operazione digitando l'inizio del nome visualizza l'elenco degli utenti da eliminare appartenenti al medesimo gruppo o aventi un nome (o parte di un nome) in comune chiedendo conferma${reset}"
	echo -e "${yellow}Funzione 6: questa operazione permette di creare un nuovo utente inserendo i nome utente, UID, GID, SHELL. La password può essere inserita o generata casualmente${reset}"
	echo -e "${yellow}Funzione 7: questa operazione crea utenti in serie con il medesimo nome utente generale il numero da inserire in coda inseriti dall'utente, UserID che cresce in serie, GID e shell comuni inseriti dall'utente. Le passoword possono essere generate casualmente e salvate in un file password.txt o inserita manualmente una password unica${reset}"
}

#Per utilizzare comando help da riga di comando
if [[ "$1" == "--help" || "$1" == "-h" ]]; then ##SE INSERISCO COMANDO SULLA RIGA DI COMANDO
	funzione_hp #RICHIAMO LA FUNZIONE
	exit
fi

operazione=1 #VARIABILE PER CICLO WHILE
while [ $operazione -lt 8 ]
do
	clear
	echo -e "${green}Questo è il progetto di Bash di Edoardo Signoretto${reset}\n"
	echo "1. Visualizza elenco utenti completo"
	echo "2. Visualizza elenco utenti per nome"
	echo "3. Ricerca utente per UID"
	echo "4. Cancella utente per UID"
	echo "5. Cancella utenti per nome"
	echo "6. Crea singolo utente"
	echo "7. Crea gruppo di utenti"
	echo -e "8. Esci\n"
	echo "${green}Inserisci l'operazione da eseguire e premi INVIO${reset}"
	read operazione
	indice=false
	re='^[0-9]+$' #INDICE DI VALORI INTERI
	while [ $indice != true ]
	do
		if ! [[ $operazione =~ $re ]] ; then #CONTROLLO SU OPERAZIONE
        	       	echo -e "\n${red}ALERT: Non hai inserito un valore numerico ma una stringa, RINSERISCI UN VALORE NUMERICO${reset}" 
                	read operazione
		else
			indice=true
        	fi
	done

	#CONTROLLO SU VALORE INSERITO
	indice=false
	while [ $indice != true ]
	do
		if [[ $operazione -ge 9 ]]; then
			echo -e "${red}\nALERT: Hai inserito un valore ERRATO, rinserisci!${reset}"
			read operazione
		else
			indice=true
		fi
	done

	#STAMPA DELL'OPERAZIONE SELEZIONATA
	case $operazione in
		1) echo -e "\nHai selezionato l'operazione 1"; funzione1; read;;
		2) echo -e "\nHai selezionato l'operazione 2"; funzione2; read;;
		3) echo -e "\nHai selezionato l'operazione 3"; funzione3; read;;
		4) echo -e "\nHai selezionato l'operazione 4"; funzione4; read;;
		5) echo -e "\nHai selezionato l'operazione 5"; funzione5; read;;
		6) echo -e "\nHai selezionato l'operazione 6"; funzione6; read;;
		7) echo -e "\nHai selezionato l'operazione 7"; funzione7; read;;
		8) echo -e "\n${red}Hai selezionato l'operazione D'USCITA${reset}";;
		esac
done
