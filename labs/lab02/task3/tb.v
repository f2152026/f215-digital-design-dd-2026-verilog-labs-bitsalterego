// tb_comparator.v
// Testbench for a parameterized N-bit magnitude comparator

module tb_comparator;

  localparam WIDTH = 4;

  // Declarations
  reg  [WIDTH-1:0] t_a;
  reg  [WIDTH-1:0] t_b;
  wire             t_eq;
  wire             t_gt;
  wire             t_lt;

  integer i, j;

  // Instantiate DUT
  comp2 DUT(
    .A  (t_a),
    .B  (t_b),
    .EQ (t_eq),
    .GT (t_gt),
    .LT (t_lt)
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
    // 1. Edge/Specific test cases
t_a = 2'd0; t_b = 2'd0; #5; // Equal (0 == 0)
    t_a = 2'd3; t_b = 2'd1; #5; // Greater (3 > 1)
    t_a = 2'd1; t_b = 2'd2; #5; // Less (1 < 2)
    t_a = 2'd3; t_b = 2'd3; #5; // Max Equal (3 == 3)

    // 2. Exhaustive check of all 16 combinations (4 x 4)
    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i[1:0];
        t_b = j[1:0];
        #5;
      end
    end

    $finish;
  end

  // Monitor outputs
  initial
    $monitor($time, " A=%d B=%d | EQ=%b GT=%b LT=%b", t_a, t_b, t_eq, t_gt, t_lt);

endmodule