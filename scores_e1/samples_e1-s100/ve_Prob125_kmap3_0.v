
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output reg out
);

    
    reg [2:0] ab;
    reg [2:0] cd;
    reg [2:0] d_out;

    
    always @(a, b, c, d) begin
        
        ab = {a, b};
        cd = {c, d};

        
        case (cd)
            3'b000: d_out = 1'b0;
            3'b001: d_out = 1'b1;
            3'b010: d_out = 1'b1;
            3'b011: d_out = 1'b1;
            3'b100: d_out = 1'b1;
            3'b101: d_out = 1'b1;
            3'b110: d_out = 1'b1;
            3'b111: d_out = 1'b1;
        endcase

        
        out = d_out;
    end

endmodule
