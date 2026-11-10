
module barrel_shifter (
    input wire [7:0] in,
    input wire [2:0] ctrl,
    output reg [7:0] out
);

    
    module mux2X1 (
        input wire [1:0] sel,
        input wire [7:0] a,
        input wire [7:0] b,
        output reg [7:0] out
    );
        assign out = sel == 2'b00 ? a : b;
    endmodule

    
    always @(*) begin
        
        reg [7:0] shifted = in >> 4;
        
        shifted = shifted >> 2;
        
        shifted = shifted >> 1;
        
        out = shifted;
    end

endmodule
