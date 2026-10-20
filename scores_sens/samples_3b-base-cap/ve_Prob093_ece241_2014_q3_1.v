
module TopModule (
    input  c,
    input  d,
    output reg [3:0] mux_in
);

    
    reg [3:0] mux_2_1_0;
    reg [3:0] mux_2_1_1;
    reg [3:0] mux_2_1_2;
    reg [3:0] mux_2_1_3;

    
    reg [3:0] mux_4_1;

    
    always @(*) begin
        mux_2_1_0 = (c == 1'b0) ? d : 4'b0;
        mux_2_1_1 = (c == 1'b0) ? 4'b0 : d;
        mux_2_1_2 = (c == 1'b1) ? d : 4'b0;
        mux_2_1_3 = (c == 1'b1) ? 4'b0 : d;
    end

    
    always @(*) begin
        mux_4_1 = (d == 1'b0) ? mux_2_1_0 : mux_2_1_1;
        mux_4_1 = (d == 1'b1) ? mux_2_1_2 : mux_4_1;
    end

    
    assign mux_in = mux_4_1;

endmodule
