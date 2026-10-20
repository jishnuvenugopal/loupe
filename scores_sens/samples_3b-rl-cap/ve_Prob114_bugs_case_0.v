
module TopModule (
    input        clk,
    input        rst,
    input [7:0]  code,
    output reg [3:0] out,
    output reg       valid
);

    
    reg [9:0] match;

    
    always @(posedge clk) begin
        if (rst) begin
            out  <= 4'b0000;
            valid <= 1'b0;
        end else begin
            
            match = {4'b0, code} == 10'b0000000000 ? 10'b1000000000 :
                    {4'b0, code} == 10'b0000000100 ? 10'b0100000000 :
                    {4'b0, code} == 10'b0000001000 ? 10'b0010000000 :
                    {4'b0, code} == 10'b0000001100 ? 10'b0001000000 :
                    {4'b0, code} == 10'b0000010000 ? 10'b0000100000 :
                    {4'b0, code} == 10'b0000010100 ? 10'b0000010000 :
                    {4'b0, code} == 10'b0000011000 ? 10'b0000001000 :
                    {4'b0, code} == 10'b0000011100 ? 10'b0000000100 :
                    {4'b0, code} == 10'b0000100000 ? 10'b0000000010 :
                    {4'b0, code} == 10'b0000100100 ? 10'b0000000001 :
                    10'b0000000000;

            
            if (match[9]) begin
                out  <= 4'b0000;
                valid <= 1'b1;
            end else if (match[8]) begin
                out  <= 4'b0001;
                valid <= 1'b1;
            end else if (match[7]) begin
                out  <= 4'b0010;
                valid <= 1'b1;
            end else if (match[6]) begin
                out  <= 4'b0011;
                valid <= 1'b1;
            end else if (match[5]) begin
                out  <= 4'b0100;
                valid <= 1'b1;
            end else if (match[4]) begin
                out  <= 4'b0101;
                valid <= 1'b1;
            end else if (match[3]) begin
                out  <= 4'b0110;
                valid <= 1'b1;
            end else if (match[2]) begin
                out  <= 4'b0111;
                valid <= 1'b1;
            end else if (match[1]) begin
                out  <= 4'b1000;
                valid <= 1'b1;
            end else if (match[0]) begin
                out  <= 4'b1001;
                valid <= 1'b1;
            end else begin
                out  <= 4'b0000;
                valid <= 1'b0;
            end
        end
    end

endmodule
