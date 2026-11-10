
module TopModule (
    input wire [3:0] a,
    input wire [3:0] b,
    input wire [3:0] c,
    input wire [3:0] d,
    input wire [3:0] e,
    output reg q
);

    always @(*) begin
        
        if (a == 4'b0000) begin
            q = 1'b0;
        end else if (a == 4'b0001) begin
            q = 1'b1;
        end else if (a == 4'b0010) begin
            q = 1'b0;
        end else if (a == 4'b0011) begin
            q = 1'b1;
        end else if (a == 4'b0100) begin
            q = 1'b0;
        end else if (a == 4'b0101) begin
            q = 1'b1;
        end else if (a == 4'b0110) begin
            q = 1'b0;
        end else if (a == 4'b0111) begin
            q = 1'b1;
        end else if (a == 4'b1000) begin
            q = 1'b0;
        end else if (a == 4'b1001) begin
            q = 1'b1;
        end else if (a == 4'b1010) begin
            q = 1'b0;
        end else if (a == 4'b1011) begin
            q = 1'b1;
        end else if (a == 4'b1100) begin
            q = 1'b0;
        end else if (a == 4'b1101) begin
            q = 1'b1;
        end else if (a == 4'b1110) begin
            q = 1'b0;
        end else if (a == 4'b1111) begin
            q = 1'b1;
        end
    end

endmodule
