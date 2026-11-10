
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
        
        reg [7:0] shifted_in = in >> 4;
        
        reg [7:0] shifted_in2 = shifted_in >> 2;
        
        reg [7:0] shifted_in3 = shifted_in >> 1;

        
        case (ctrl)
            3'b000: out = in;
            3'b001: out = shifted_in;
            3'b010: out = shifted_in2;
            3'b011: out = shifted_in3;
            3'b100: out = shifted_in >> 4;
            3'b101: out = shifted_in2 >> 4;
            3'b110: out = shifted_in3 >> 4;
            3'b111: out = shifted_in >> 4;
        endcase
    end

endmodule
