
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output reg out
);

    
    function [3:0] karnaugh_map(input [3:0] inputs);
        case (inputs)
            4'b0000: karnaugh_map = 4'b0000;
            4'b0001: karnaugh_map = 4'b0001;
            4'b0010: karnaugh_map = 4'b0010;
            4'b0011: karnaugh_map = 4'b0011;
            4'b0100: karnaugh_map = 4'b0100;
            4'b0101: karnaugh_map = 4'b0101;
            4'b0110: karnaugh_map = 4'b0110;
            4'b0111: karnaugh_map = 4'b0111;
            4'b1000: karnaugh_map = 4'b1000;
            4'b1001: karnaugh_map = 4'b1001;
            4'b1010: karnaugh_map = 4'b1010;
            4'b1011: karnaugh_map = 4'b1011;
            4'b1100: karnaugh_map = 4'b1100;
            4'b1101: karnaugh_map = 4'b1101;
            4'b1110: karnaugh_map = 4'b1110;
            4'b1111: karnaugh_map = 4'b1111;
        endcase
    endfunction

    
    always @(*) begin
        out = karnaugh_map({a, b, c, d});
    end

endmodule
