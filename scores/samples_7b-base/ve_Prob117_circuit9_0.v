
module TopModule (clk, a, q);
    input clk, a;
    output reg [2:0] q;
 

    always @(posedge clk) begin
        if (a == 1) begin
            case (q)
                3'b010: q <= 3'b011;
 
                3'b011: q <= 3'b100;
 
                3'b100: q <= 3'b110;
 
                3'b110: q <= 3'b100;
 
                default: q <= 3'b010;
 
            endcase
        end else begin
            case (q)
                3'b100: q <= 3'b010;
 
                3'b010: q <= 3'b011;
 
                3'b011: q <= 3'b100;
 
                3'b100: q <= 3'b110;
 
                default: q <= 3'b010;
 
            endcase
        end
    end
endmodule
