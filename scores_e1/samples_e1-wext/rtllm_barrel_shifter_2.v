
module barrel_shifter (
    input wire [7:0] in,
    input wire [2:0] ctrl,
    output reg [7:0] out
);

    always @(*) begin
        
        reg [7:0] shifted1 = in[3:0];
        reg [7:0] shifted2 = in[7:4];

        
        reg [7:0] shifted3 = shifted1[1:0];
        reg [7:0] shifted4 = shifted2[3:2];

        
        reg [7:0] shifted5 = shifted3[0];
        reg [7:0] shifted6 = shifted4[1];

        
        case (ctrl)
            3'b000: out = in;
 
            3'b001: out = shifted1;
 
            3'b010: out = shifted2;
 
            3'b011: out = shifted3;
 
            3'b100: out = shifted4;
 
            3'b101: out = shifted5;
 
            3'b110: out = shifted6;
 
            3'b111: out = shifted7;
 
        endcase
    end

endmodule
