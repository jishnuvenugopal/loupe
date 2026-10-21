
module TopModule (
    input wire c,
    input wire d,
    output reg [3:0] mux_in
);

    
    reg [1:0] mux1;
    assign mux1 = {c, d};

    
    reg [1:0] mux2;
    assign mux2 = {mux1, c};

    
    assign mux_in = {mux2, d};

endmodule
