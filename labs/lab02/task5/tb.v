// tb.v
// Testbench for 4-bit ADD/SUB ALU using 2's complement

module tb;

  // Declarations for inputs and outputs
  reg  [3:0] t_a;
  reg  [3:0] t_b;
  reg        t_op;       // 0 = ADD, 1 = SUB
  wire [3:0] t_result;

  // Workaround for string expression in $monitor
  reg [23:0] op_str;
  always @(*) begin
    op_str = t_op ? "SUB" : "ADD";
  end

  // Instantiate DUT
  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  // Apply test vectors
  initial begin
    // Initialize
    t_a = 4'd0; t_b = 4'd0; t_op = 1'b0; #5;

    // --- Addition Tests (op = 0) ---
    t_a = 4'd5; t_b = 4'd3; t_op = 1'b0; #5; // 5 + 3 = 8
    t_a = 4'd9; t_b = 4'd4; t_op = 1'b0; #5; // 9 + 4 = 13
    t_a = 4'd7; t_b = 4'd0; t_op = 1'b0; #5; // 7 + 0 = 7

    // --- Subtraction Tests via 2's complement (op = 1) ---
    t_a = 4'd8; t_b = 4'd3; t_op = 1'b1; #5; // 8 - 3 = 5
    t_a = 4'd5; t_b = 4'd5; t_op = 1'b1; #5; // 5 - 5 = 0
    t_a = 4'd3; t_b = 4'd5; t_op = 1'b1; #5; // 3 - 5 = -2 (4'b1110)

    $finish;
  end

  // Monitor execution using the simple variable op_str
  initial
    $monitor($time, " | op=%b (%s) | a=%d b=%d -> result=%d (bin=%b)",
             t_op, op_str, t_a, t_b, t_result, t_result);

endmodule