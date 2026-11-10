
module TopModule (
    input wire [3:0] x,
    output reg f
);

    
    
    reg [1:0] f_comb;

    
    always @(*) begin
        case (x)
            4'b0000: f_comb = 2'b00;
 
            4'b0001: f_comb = 2'b01;
 
            4'b0010: f_comb = 2'b11;
 
            4'b0011: f_comb = 2'b10;
 
            4'b0100: f_comb = 2'b00;
 
            4'b0101: f_comb = 2'b01;
 
            4'b0110: f_comb = 2'b11;
 
            4'b0111: f_comb = 2'b10;
 
            4'b1000: f_comb = 2'b00;
 
            4'b1001: f_comb = 2'b01;
 
            4'b1010: f_comb = 2'b11;
 
            4'b1011: f_comb = 2'b10;
 
            4'b1100: f_comb = 2'b00;
 
            4'b1101: f_comb = 2'b01;
 
            4'b1110: f_comb = 2'b11;
 
            4'b1111: f_comb = 2'b10;
 
            default: f_comb = 2'b00;
 
        endcase
    end

    
    assign f = f_comb;

endmodule
