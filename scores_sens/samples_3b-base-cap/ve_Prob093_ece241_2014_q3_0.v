
module TopModule (
    input  c,
    input  d,
    output reg [3:0] mux_in
);

    
    reg [3:0] mux_00;
    always @(*) begin
        if (c == 1'b0 && d == 1'b0) mux_00 = 4'b0001;
        else mux_00 = 4'b0000;
    end

    
    reg [3:0] mux_01;
    always @(*) begin
        if (c == 1'b0 && d == 1'b1) mux_01 = 4'b0010;
        else mux_01 = 4'b0000;
    end

    
    reg [3:0] mux_out;
    always @(*) begin
        if (c == 1'b0) mux_out = mux_00;
        else mux_out = mux_01;
    end

    
    assign mux_in = mux_out;

endmodule
