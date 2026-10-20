
module TopModule (
    input  wire c,
    input  wire d,
    output reg  [3:0] mux_in
);

    
    
    
    
    

    always @(*) begin
        mux_in[0] = c;
        mux_in[1] = d;
        mux_in[2] = c;
        mux_in[3] = d;
    end

endmodule
