
module TopModule (
    input c,
    input d,
    output reg [3:0] mux_in
);

    
    reg a, b;

    
    assign a = d;
    assign b = c;

    
    always @(*) begin
        case ({a, b})
            2'b00: mux_in = 4'b1000;
            2'b01: mux_in = 4'b0000;
            2'b11: mux_in = 4'b1100;
            default: mux_in = 4'b1000;
 
        endcase
    end

endmodule
