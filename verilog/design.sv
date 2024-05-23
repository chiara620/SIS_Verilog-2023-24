module MorraCinese(
input [1:0] PRIMO, [1:0] SECONDO, clk, [0:0] INIZIA,
output reg [1:0] MANCHE, reg [1:0] PARTITA);
    reg [4:0] nmanche;     //registro che conta quante manche sono state già giocate
    reg [4:0] maxmanche;     //registro che ricorda il numero massimo di manche per la partita corrente
	reg[2:0] stato = 3'b000;
	reg[2:0] stato_prossimo = 3'b000;
    integer VAN;     //Vantaggio: se è maggiore di 1 ha vinto il giocatore uno, se è minore di -1 ha vinto il giocatore due

    always @(posedge clk) begin : UPDATE
		stato = stato_prossimo;
	end

    always @(PRIMO, SECONDO, INIZIA) begin : FSM
		case(stato)
        3'b000: //A : stato di pareggio. Tutti i giocatori possono giocare tutte le mosse.
            if (INIZIA == 1'b1) begin     //in qualsiasi stato ci si trovi, se arriva l'input INIZIA=1 la partita viene resettata
                MANCHE = 2'b00;
                stato = 3'b000;
            end else if ((PRIMO == SECONDO) && (PRIMO != 2'b00)) begin     //pareggio, qualcora entrambi i giocatore inseriscano lo stesso input (diverso da 00)
                MANCHE = 2'b11;
                stato_prossimo = 3'b000; //A 
            end else if (PRIMO == 2'b00 || SECONDO == 2'b00) begin     //se uno dei due giocatori gioca una mossa non valida, la manche è ritenuta nulla
                MANCHE = 2'b00;
                stato_prossimo = 3'b000; //A 
            end else if (PRIMO == 2'b01 && SECONDO == 2'b11) begin
                MANCHE = 2'b01;
                stato_prossimo = 3'b001; //B 
            end else if (PRIMO == 2'b10 && SECONDO == 2'b01) begin
                MANCHE = 2'b01;
                stato_prossimo = 3'b010; //C
            end else if (PRIMO == 2'b11 && SECONDO == 2'b10) begin
                MANCHE = 2'b01;
                stato_prossimo = 3'b011; //D 
            end else if (PRIMO == 2'b11 && SECONDO == 2'b01) begin
                MANCHE = 2'b10;
                stato_prossimo = 3'b100; //E 
            end else if (PRIMO == 2'b01 && SECONDO == 2'b10) begin
                MANCHE = 2'b10;
                stato_prossimo = 3'b101; //F 
            end else if (PRIMO == 2'b10 && SECONDO == 2'b11) begin
                MANCHE = 2'b10;
                stato_prossimo = 3'b110; //G
            end
        3'b001: //B : Il giocatore uno ha vinto con sasso, quindi non può usare quella mossa nella manche corrente
            if (INIZIA == 1'b1) begin
                MANCHE = 2'b00;
                stato = 3'b000;
            end else if ((PRIMO == 2'b10 && SECONDO == 2'b10) || (PRIMO == 2'b11 && SECONDO == 2'b11)) begin     //lo stato di pareggio si raggiunge solo qualora sia eseguito lo stesso input da entrambi i giocatori, ma deve essere diverso sia da 00 che dall'ultima mossa "vittoriosa"
                MANCHE = 2'b11;
                stato_prossimo = 3'b000; //A 
            end else if (PRIMO == 2'b00 || SECONDO == 2'b00 || PRIMO == 2'b01) begin     //qualora il giocatore che ha vinto la partita precedente giocasse lo stesso input con cui ha vinto, la manche verrebbe considerata non valida
                MANCHE = 2'b00;
                stato_prossimo = 3'b001; //B 
            end else if (PRIMO == 2'b10 && SECONDO == 2'b11) begin
                MANCHE = 2'b10;
                stato_prossimo = 3'b110; //G  
            end else if (PRIMO == 2'b11 && SECONDO == 2'b01) begin
                MANCHE = 2'b10;
                stato_prossimo = 3'b100; //E
            end else if (PRIMO == 2'b10 && SECONDO == 2'b01) begin
                MANCHE = 2'b01;
                stato_prossimo = 3'b010; //C  
            end else if (PRIMO == 2'b11 && SECONDO == 2'b10) begin
                MANCHE = 2'b01;
                stato_prossimo = 3'b011; //D
            end 
        3'b010: //C : il giocatore uno ha vinto con carta
            if (INIZIA == 1'b1) begin
                MANCHE = 2'b00;
                stato = 3'b000;
            end else if ((PRIMO == 2'b01 && SECONDO == 2'b01) || (PRIMO == 2'b11 && SECONDO == 2'b11)) begin
                MANCHE = 2'b11;
                stato_prossimo = 3'b000; //A 
            end else if (PRIMO == 2'b00 || SECONDO == 2'b00 || PRIMO == 2'b10) begin
                MANCHE = 2'b00;
                stato_prossimo = 3'b010; //C 
            end else if (PRIMO == 2'b11 && SECONDO == 2'b10) begin
                MANCHE = 2'b01;
                stato_prossimo = 3'b011; //D  
            end else if (PRIMO == 2'b01 && SECONDO == 2'b10) begin
                MANCHE = 2'b10;
                stato_prossimo = 3'b101; //F
            end else if (PRIMO == 2'b11 && SECONDO == 2'b01) begin
                MANCHE = 2'b10;
                stato_prossimo = 3'b100; //E  
            end else if (PRIMO == 2'b01 && SECONDO == 2'b11) begin
                MANCHE = 2'b01;
                stato_prossimo = 3'b001; //B
            end 
        3'b011: //D : il giocatore uno ha vinto con forbici
            if (INIZIA == 1'b1) begin
                MANCHE = 2'b00;
                stato = 3'b000;
            end else if ((PRIMO == 2'b01 && SECONDO == 2'b01) || (PRIMO == 2'b10 && SECONDO == 2'b10)) begin
                MANCHE = 2'b11;
                stato_prossimo = 3'b000; //A 
            end else if (PRIMO == 2'b00 || SECONDO == 2'b00 || PRIMO == 2'b11) begin
                MANCHE = 2'b00;
                stato_prossimo = 3'b011; //D 
            end else if (PRIMO == 2'b01 && SECONDO == 2'b10) begin
                MANCHE = 2'b10;
                stato_prossimo = 3'b101; //F 
            end else if (PRIMO == 2'b10 && SECONDO == 2'b11) begin
                MANCHE = 2'b10;
                stato_prossimo = 3'b110; //G
            end else if (PRIMO == 2'b10 && SECONDO == 2'b01) begin
                MANCHE = 2'b01;
                stato_prossimo = 3'b010; //C  
            end else if (PRIMO == 2'b01 && SECONDO == 2'b11) begin
                MANCHE = 2'b01;
                stato_prossimo = 3'b001; //B
            end 
        3'b100: //E : il giocatore due ha vinto con sasso
            if (INIZIA == 1'b1) begin
                MANCHE = 2'b00;
                stato = 3'b000;
            end else if ((PRIMO == 2'b11 && SECONDO == 2'b11) || (PRIMO == 2'b10 && SECONDO == 2'b10)) begin
                MANCHE = 2'b11;
                stato_prossimo = 3'b000; //A 
            end else if (PRIMO == 2'b00 || SECONDO == 2'b00 || SECONDO == 2'b01) begin
                MANCHE = 2'b00;
                stato_prossimo = 3'b100; //E 
            end else if (PRIMO == 2'b10 && SECONDO == 2'b11) begin
                MANCHE = 2'b10;
                stato_prossimo = 3'b110; //G 
            end else if (PRIMO == 2'b11 && SECONDO == 2'b10) begin
                MANCHE = 2'b01;
                stato_prossimo = 3'b011; //D
            end else if (PRIMO == 2'b01 && SECONDO == 2'b11) begin
                MANCHE = 2'b01;
                stato_prossimo = 3'b001; //B  
            end else if (PRIMO == 2'b01 && SECONDO == 2'b10) begin
                MANCHE = 2'b10;
                stato_prossimo = 3'b101; //F
            end 
        3'b101: //F : il giocatore due ha vinto con carta
            if (INIZIA == 1'b1) begin
                MANCHE = 2'b00;
                stato = 3'b000;
            end else if ((PRIMO == 2'b11 && SECONDO == 2'b11) || (PRIMO == 2'b01 && SECONDO == 2'b01)) begin
                MANCHE = 2'b11;
                stato_prossimo = 3'b000; //A 
            end else if (PRIMO == 2'b00 || SECONDO == 2'b00 || SECONDO == 2'b10) begin
                MANCHE = 2'b00;
                stato_prossimo = 3'b101; //F
            end else if (PRIMO == 2'b10 && SECONDO == 2'b11) begin
                MANCHE = 2'b10;
                stato_prossimo = 3'b110; //G 
            end else if (PRIMO == 2'b10 && SECONDO == 2'b11) begin
                MANCHE = 2'b10;
                stato_prossimo = 3'b010; //C
            end else if (PRIMO == 2'b01 && SECONDO == 2'b11) begin
                MANCHE = 2'b01;
                stato_prossimo = 3'b001; //B  
            end else if (PRIMO == 2'b11 && SECONDO == 2'b01) begin
                MANCHE = 2'b10;
                stato_prossimo = 3'b100; //E
            end 
        3'b110: //G : il giocatore due ha vinto con forbici
            if (INIZIA == 1'b1) begin
                MANCHE = 2'b00;
                stato = 3'b000;
            end else if (INIZIA == 1'b1) begin
                MANCHE = 2'b00;
                stato_prossimo = 3'b000; //A
            end else if ((PRIMO == 2'b10 && SECONDO == 2'b10) || (PRIMO == 2'b01 && SECONDO == 2'b01)) begin
                MANCHE = 2'b11;
                stato_prossimo = 3'b000; //A 
            end else if (PRIMO == 2'b00 || SECONDO == 2'b00 || SECONDO == 2'b11) begin
                MANCHE = 2'b00;
                stato_prossimo = 3'b110; //G
            end else if (PRIMO == 2'b11 && SECONDO == 2'b01) begin
                MANCHE = 2'b10;
                stato_prossimo = 3'b100; //E 
            end else if (PRIMO == 2'b01 && SECONDO == 2'b10) begin
                MANCHE = 2'b10;
                stato_prossimo = 3'b101; //F
            end else if (PRIMO == 2'b11 && SECONDO == 2'b10) begin
                MANCHE = 2'b01;
                stato_prossimo = 3'b011; //D  
            end else if (PRIMO == 2'b10 && SECONDO == 2'b01) begin
                MANCHE = 2'b01;
                stato_prossimo = 3'b010; //C
            end
        endcase
    end

    always @(posedge clk) begin : DATAPATH
        if (INIZIA) begin
            maxmanche[4]= 0;     //maxmanche è settato come un registro a cinque bit (poichè il suo massimo è 19), di cui il primo bit è sempre 0 e i successivi sono PRIMO e SECONDO concatenati
            maxmanche[3:2] = PRIMO;
            maxmanche[1:0] = SECONDO;
            maxmanche = maxmanche + 5'b00100;     //a maxmanche precedentemente formato vengono sommate 4 partite extra, come da regolamento
            nmanche = 5'b00000;
            VAN = 0;
            PARTITA = 2'b00;
        end else begin
            if (MANCHE == 2'b00) begin     //nmanche non viene aumentato se l'ultima manche è "non valida"
                nmanche = nmanche;
            end else begin
                nmanche = nmanche + 4'b0001;
            end
            if (MANCHE == 2'b01) begin     //se l'ultima manche è stata vinta dal giocatore uno, vantaggio aumenta di uno
                VAN = VAN + 1;
            end else if (MANCHE == 2'b10) begin     //se è stata vinta dal giocatore due, diminuisce di uno
                VAN = VAN - 1;
            end
            if (VAN >= 2 && nmanche >= 4'b0100) begin     //se il vantaggio è maggiore di 1 e sono state giocate almeno quattro partite, vince il giocatore uno
                PARTITA = 2'b01;
            end else if (VAN <= -2 && nmanche >= 4'b0100) begin     //se è minore di -1 e sono state giocate almeno quattro partite, vince il giocatore due
                PARTITA = 2'b10;
            end else if (nmanche == maxmanche) begin     //se le manche hanno raggiunto il numero massimo, la partita termina in pareggio
                PARTITA = 2'b11;
            end else begin     //in tutti gli altri casi, si va avanti a giocare
                PARTITA = 2'b00;
            end
        end
    end

endmodule