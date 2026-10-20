
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire [3:0] in;
    assign in = {a, b, c, d};

    reg out;

    always @(*) begin
        case (in)
            4'b0100: out = 1'b1;
 
            4'b1110: out = 1'b1;
 
            4'b1100: out = 1'b1;
 
            default: out = 1'b0;
        endcase
    end

    
    

endmodule
