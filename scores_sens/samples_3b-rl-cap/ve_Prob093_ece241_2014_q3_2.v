
module TopModule (
    input  wire c,
    input  wire d,
    output reg  [3:0] mux_in
);

    
    wire [3:0] w0, w1, w2, w3;
    wire [3:0] w4, w5, w6, w7;
    wire [3:0] w8, w9, w10, w11;
    wire [3:0] w12, w13, w14, w15;

    
    
    
    
    

    
    assign w0 = {c, d};
    assign w1 = {c, d};
    assign w2 = {c, d};
    assign w3 = {c, d};

    
    assign w4 = {c, d};
    assign w5 = {c, d};
    assign w6 = {c, d};
    assign w7 = {c, d};

    
    assign w8 = {c, d};
    assign w9 = {c, d};
    assign w10 = {c, d};
    assign w11 = {c, d};

    
    assign w12 = {c, d};
    assign w13 = {c, d};
    assign w14 = {c, d};
    assign w15 = {c, d};

    always @(*) begin
        case ({c, d})
            2'b00: mux_in = w0;
            2'b01: mux_in = w1;
            2'b10: mux_in = w2;
            2'b11: mux_in = w3;
        endcase
    end

endmodule
