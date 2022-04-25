`define STRLEN 32
module NextPClogicTest;


	task passTest;
		input [63:0] actualOut, expectedOut;
		input [`STRLEN*8:0] testType;
		inout [7:0] passed;
	
      if(actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end 

	endtask 
	
	task allPassed;
		input [7:0] passed;
		input [7:0] numTests;
		
      if(passed == numTests) $display ("All passed");
	
	endtask
    reg [7:0] passed;
	reg [7:0] numTests;
    reg [63:0] CurrentPC;
    reg [63:0] SignExtImm64;
	reg Branch, ALUZero, Uncondbranch;
	wire [63:0] NextPC;

	reg[63:0] expectNextPC;

	NextPClogic uut(
		.CurrentPC(CurrentPC),
		.SignExtImm64(SignExtImm64),
		.Branch(Branch),
		.ALUZero(ALUZero),
		.Uncondbranch(Uncondbranch),
		.NextPC(NextPC));

	initial begin //initial block
		
		CurrentPC = 64'b0;
		SignExtImm64 = 64'b0;
		Branch = 1'b0;
		ALUZero = 1'b0;
		Uncondbranch = 1'b0;
		passed = 7'b0;
		numTests = 7'b0;
		#3;
		ALUZero = 1'b0;
		Uncondbranch = 1'b0;
		expectNextPC = 64'h14;
		CurrentPC = 64'h10; //hex
		SignExtImm64 = 64'b0;
		Branch = 1'b0;

		#4;
      passTest(NextPC, expectNextPC, "Ordinary next PC", passed);
		numTests = numTests + 1;
      	ALUZero = 1'b1;
		Uncondbranch = 1'b0;
		expectNextPC = 64'h18;
		CurrentPC = 64'h10;
		SignExtImm64 = 64'h2;
		Branch = 1'b1;

		#4;
      passTest(NextPC, expectNextPC, "CBZ type", passed);
		numTests = numTests + 1;
      	ALUZero = 1'b0;
		Uncondbranch = 1'b0;
		expectNextPC = 64'h14;
        CurrentPC = 64'h10;
		SignExtImm64 = 64'h3;
		Branch = 1'b1;

		#4;
      passTest(NextPC, expectNextPC, "CBZ type", passed);
		numTests = numTests + 1;
		ALUZero = 1'b0;
		Uncondbranch = 1'b1;
		expectNextPC = 64'h20;
		CurrentPC = 64'h10;
		SignExtImm64 = 64'h4;
		Branch = 1'b0;

		#4;
      passTest(NextPC, expectNextPC, "B type", passed);
		numTests = numTests + 1;
		
		allPassed(passed, numTests);

		$finish;
	end
      
endmodule