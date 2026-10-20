
module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

    
    reg [7:0] smaller_ab;
    always @(a, b) begin
        if (a < b) begin
            smaller_ab = a;
        end else begin
            smaller_ab = b;
        end
    end

    
    reg [7:0] smaller_cd;
    always @(c, d) begin
        if (c < d) begin
            smaller_cd = c;
        end else begin
            smaller_cd = d;
        end
    end

    
    always @(smaller_ab, smaller_cd) begin
        if (smaller_ab < smaller_cd) begin
            min = smaller_ab;
        end else begin
            min = smaller_cd;
        end
    end

endmodule
