
module TopModule (
    input  clk,
    input  reset,
    input  [7:0] d,
    output [7:0] q
);

    
    reg [7:0] dff0, dff1, dff2, dff3, dff4, dff5, dff6, dff7;

    
    DFlipFlop dff0_inst (
        .clk(clk),
        .reset(reset),
        .d(d[0]),
        .q(dff0)
    );

    DFlipFlop dff1_inst (
        .clk(clk),
        .reset(reset),
        .d(d[1]),
        .q(dff1)
    );

    DFlipFlop dff2_inst (
        .clk(clk),
        .reset(reset),
        .d(d[2]),
        .q(dff2)
    );

    DFlipFlop dff3_inst (
        .clk(clk),
        .reset(reset),
        .d(d[3]),
        .q(dff3)
    );

    DFlipFlop dff4_inst (
        .clk(clk),
        .reset(reset),
        .d(d[4]),
        .q(dff4)
    );

    DFlipFlop dff5_inst (
        .clk(clk),
        .reset(reset),
        .d(d[5]),
        .q(dff5)
    );

    DFlipFlop dff6_inst (
        .clk(clk),
        .reset(reset),
        .d(d[6]),
        .q(dff6)
    );

    DFlipFlop dff7_inst (
        .clk(clk),
        .reset(reset),
        .d(d[7]),
        .q(dff7)
    );

    
    assign q = dff7;

endmodule


module DFlipFlop (
    input  clk,
    input  reset,
    input  d,
    output q
);

    
    always @(posedge reset) begin
        q <= 0;
    end

    
    always @(posedge clk) begin
        if (reset) begin
            q <= 0;
        end else begin
            q <= d;
        end
    end

endmodule
