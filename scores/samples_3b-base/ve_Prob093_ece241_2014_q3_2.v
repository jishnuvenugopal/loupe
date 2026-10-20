
module TopModule(
    input  c,
    input  d,
    output reg [3:0] mux_in
);

    
    wire mux1_out;
    always @(*) begin
        if (c == 1'b0 && d == 1'b0) mux1_out = 1'b0;
        else mux1_out = 1'b1;
    end

    
    wire mux2_out;
    always @(*) begin
        if (c == 1'b1 && d == 1'b1) mux2_out = 1'b1;
        else mux2_out = 1'b0;
    end

    
    always @(*) begin
        case ({c, d})
            2'b00: mux_in = 4'b0001;
            2'b01: mux_in = 4'b0010;
            2'b11: mux_in = 4'b0101;
            2'b10: mux_in = 4'b0110;
            default: mux_in = 4'b0000;
        endcase
    end

endmodule
