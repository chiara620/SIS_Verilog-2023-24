module tb_MorraCinese();
//"testbench.script": script testbench per il modello SIS
//"output_verilog.txt: testo con le uscite generate
	integer tbf, outf;
	
	reg [1:0] PRIMO;
    reg [1:0] SECONDO;
    reg clk;
	reg [0:0] INIZIA;
	wire [1:0] MANCHE;
	wire [1:0] PARTITA;
	
	MorraCinese MorraCinese(PRIMO, SECONDO, clk, INIZIA, MANCHE, PARTITA);
	
	always #10 clk = ~clk; 
	
	initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
		tbf = $fopen("testbench.script", "w");
		outf = $fopen("output_verilog.txt", "w");
		$fdisplay(tbf, "read_blif FSMD.blif");
      	
        clk = 1'b1;
		INIZIA = 1'b1;
		PRIMO = 2'b10;
		SECONDO = 2'b01;     //in questa partita, maxmanche è 13
		$fdisplay(tbf, "simulate %b %b %b %b %b", PRIMO[1], PRIMO[0], SECONDO[1], SECONDO[0], INIZIA);
		#20;
		$fdisplay(outf, "Outputs: %b %b %b %b", MANCHE[1], MANCHE[0], PARTITA[1], PARTITA[0]);
        INIZIA = 1'b0;
		PRIMO = 2'b01;
		SECONDO = 2'b10;
		$fdisplay(tbf, "simulate %b %b %b %b %b", PRIMO[1], PRIMO[0], SECONDO[1], SECONDO[0], INIZIA);
		#20;
		$fdisplay(outf, "Outputs: %b %b %b %b", MANCHE[1], MANCHE[0], PARTITA[1], PARTITA[0]);
		PRIMO = 2'b01;
		SECONDO = 2'b01;
		$fdisplay(tbf, "simulate %b %b %b %b %b", PRIMO[1], PRIMO[0], SECONDO[1], SECONDO[0], INIZIA);
		#20;
		$fdisplay(outf, "Outputs: %b %b %b %b", MANCHE[1], MANCHE[0], PARTITA[1], PARTITA[0]);   //partita interrotta
		
		INIZIA = 1'b1;     //l'arrivo di un input di INIZIA=1 interrompe correttamente la partita corrente
		PRIMO = 2'b00;
		SECONDO = 2'b10;     //in questa partita, maxmanche è 5
		$fdisplay(tbf, "simulate %b %b %b %b %b", PRIMO[1], PRIMO[0], SECONDO[1], SECONDO[0], INIZIA);
		#20;
		$fdisplay(outf, "Outputs: %b %b %b %b", MANCHE[1], MANCHE[0], PARTITA[1], PARTITA[0]);     //il giocatore uno ha immesso un input non valido (00) e la manche non viene conteggiata
		INIZIA = 1'b0;
		PRIMO = 2'b00;
		SECONDO = 2'b10;
		$fdisplay(tbf, "simulate %b %b %b %b %b", PRIMO[1], PRIMO[0], SECONDO[1], SECONDO[0], INIZIA);
		#20;
		$fdisplay(outf, "Outputs: %b %b %b %b", MANCHE[1], MANCHE[0], PARTITA[1], PARTITA[0]);
		PRIMO = 2'b01;
		SECONDO = 2'b11;
		$fdisplay(tbf, "simulate %b %b %b %b %b", PRIMO[1], PRIMO[0], SECONDO[1], SECONDO[0], INIZIA);
		#20;
		$fdisplay(outf, "Outputs: %b %b %b %b", MANCHE[1], MANCHE[0], PARTITA[1], PARTITA[0]);
		PRIMO = 2'b10;
		SECONDO = 2'b01;
		$fdisplay(tbf, "simulate %b %b %b %b %b", PRIMO[1], PRIMO[0], SECONDO[1], SECONDO[0], INIZIA);
		#20;
		$fdisplay(outf, "Outputs: %b %b %b %b", MANCHE[1], MANCHE[0], PARTITA[1], PARTITA[0]);     //il giocatore uno ha un vantaggio di due manche, ma non vince la partita perché non sono ancora state giocate quattro manche
		PRIMO = 2'b01;
		SECONDO = 2'b10;
		$fdisplay(tbf, "simulate %b %b %b %b %b", PRIMO[1], PRIMO[0], SECONDO[1], SECONDO[0], INIZIA);
		#20;
		$fdisplay(outf, "Outputs: %b %b %b %b", MANCHE[1], MANCHE[0], PARTITA[1], PARTITA[0]);
		PRIMO = 2'b10;
		SECONDO = 2'b10;
		$fdisplay(tbf, "simulate %b %b %b %b %b", PRIMO[1], PRIMO[0], SECONDO[1], SECONDO[0], INIZIA);
		#20;
		$fdisplay(outf, "Outputs: %b %b %b %b", MANCHE[1], MANCHE[0], PARTITA[1], PARTITA[0]);     //il giocatore due ha giocato un input non valido: 10, con cui ha vinto la partita precedente
		PRIMO = 2'b11;
		SECONDO = 2'b11;
		$fdisplay(tbf, "simulate %b %b %b %b %b", PRIMO[1], PRIMO[0], SECONDO[1], SECONDO[0], INIZIA);
		#20;
		$fdisplay(outf, "Outputs: %b %b %b %b", MANCHE[1], MANCHE[0], PARTITA[1], PARTITA[0]);
		PRIMO = 2'b10;
		SECONDO = 2'b01;
		$fdisplay(tbf, "simulate %b %b %b %b %b", PRIMO[1], PRIMO[0], SECONDO[1], SECONDO[0], INIZIA);
		#20;
		$fdisplay(outf, "Outputs: %b %b %b %b", MANCHE[1], MANCHE[0], PARTITA[1], PARTITA[0]);  //vince G1; se non avesse vinto in questa manche, la partita sarebbe terminata in pareggio
		
		INIZIA = 1'b1;
		PRIMO = 2'b00;
		SECONDO = 2'b00;     //in questa partita, maxmanche è 4
		$fdisplay(tbf, "simulate %b %b %b %b %b", PRIMO[1], PRIMO[0], SECONDO[1], SECONDO[0], INIZIA);
		#20;
		$fdisplay(outf, "Outputs: %b %b %b %b", MANCHE[1], MANCHE[0], PARTITA[1], PARTITA[0]);
		INIZIA = 1'b0;
		PRIMO = 2'b11;
		SECONDO = 2'b11;
		$fdisplay(tbf, "simulate %b %b %b %b %b", PRIMO[1], PRIMO[0], SECONDO[1], SECONDO[0], INIZIA);
		#20;
		$fdisplay(outf, "Outputs: %b %b %b %b", MANCHE[1], MANCHE[0], PARTITA[1], PARTITA[0]);
		PRIMO = 2'b01;
		SECONDO = 2'b11;
		$fdisplay(tbf, "simulate %b %b %b %b %b", PRIMO[1], PRIMO[0], SECONDO[1], SECONDO[0], INIZIA);
		#20;
		$fdisplay(outf, "Outputs: %b %b %b %b", MANCHE[1], MANCHE[0], PARTITA[1], PARTITA[0]);
		PRIMO = 2'b10;
		SECONDO = 2'b11;
		$fdisplay(tbf, "simulate %b %b %b %b %b", PRIMO[1], PRIMO[0], SECONDO[1], SECONDO[0], INIZIA);
		#20;
		$fdisplay(outf, "Outputs: %b %b %b %b", MANCHE[1], MANCHE[0], PARTITA[1], PARTITA[0]);
		PRIMO = 2'b00;
		SECONDO = 2'b01;
		$fdisplay(tbf, "simulate %b %b %b %b %b", PRIMO[1], PRIMO[0], SECONDO[1], SECONDO[0], INIZIA);
		#20;
		$fdisplay(outf, "Outputs: %b %b %b %b", MANCHE[1], MANCHE[0], PARTITA[1], PARTITA[0]);
		PRIMO = 2'b01;
		SECONDO = 2'b11;
		$fdisplay(tbf, "simulate %b %b %b %b %b", PRIMO[1], PRIMO[0], SECONDO[1], SECONDO[0], INIZIA);
		#20;
		$fdisplay(outf, "Outputs: %b %b %b %b", MANCHE[1], MANCHE[0], PARTITA[1], PARTITA[0]);     //per la seconda manche di fila viene giocato un input non valido: in questa in particolare, il giocatore due rigioca la mossa con cui ha vinto nell'ultima manche valida (dunque quella parecedente, invalida, non viene considerata)
		PRIMO = 2'b01;
		SECONDO = 2'b01;
		$fdisplay(tbf, "simulate %b %b %b %b %b", PRIMO[1], PRIMO[0], SECONDO[1], SECONDO[0], INIZIA);
		#20;
		$fdisplay(outf, "Outputs: %b %b %b %b", MANCHE[1], MANCHE[0], PARTITA[1], PARTITA[0]);     //nessuno ha vinto e nmanche ha raggiunto maxmanche: la partita termina in pareggio

		$fdisplay(tbf, "quit");
		$fclose(tbf);
		$fclose(outf);
		$finish;
    end
endmodule