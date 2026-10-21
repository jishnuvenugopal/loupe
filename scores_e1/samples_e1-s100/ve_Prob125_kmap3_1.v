
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output reg out
);

    
    reg [2:0] karnaugh_map [4:0];

    
    initial begin
        karnaugh_map[0] = 3'b000;
 
        karnaugh_map[1] = 3'b001;
 
        karnaugh_map[2] = 3'b010;
 
        karnaugh_map[3] = 3'b011;
 
        karnaugh_map[4] = 3'b100;
 
    end

    
    always @(a, b, c) begin
        out = karnaugh_map[a'b'c];
    end

endmodule
