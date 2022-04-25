module NextPClogic(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch); 
       	input [63:0] CurrentPC, SignExtImm64; 
       	input Branch, ALUZero, Uncondbranch; 
       	output reg [63:0] NextPC; 

  reg [63:0] temporaryImm; //used to append 00 on sign extended val
  
initial begin 
  $dumpfile("dump.vcd");
  $dumpvars(1);
end


    always @(*) begin

      temporaryImm = SignExtImm64 << 2; //Puts the 00 on sign extended value

    	//B instructions
      if(Uncondbranch == 1'b1) begin
       		NextPC  <= #1 CurrentPC + temporaryImm; //go to target
       	end
      else if(Branch && ALUZero == 1'b1) begin // for conditional 
       		 //go when the comparison yields 0 
       			NextPC <= #2 CurrentPC + temporaryImm; //go to target
       		end

       	
       	else begin
       		NextPC <= #2 CurrentPC + 4;
       	end
   	end

endmodule
