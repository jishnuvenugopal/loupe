
module TopModule (
    input  [15:0] a, b, c, d, e, f, g, h, i,
    input  [3:0] sel,
    output [15:0] out
);

    
    reg [15:0] inputData;

    
    reg [3:0] selector;

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            inputData <= 16'b0;
            selector <= 4'b0;
            out <= 16'b11111111;
        end else begin
            inputData <= a;
            selector <= sel;
            case (selector)
                4'b0000: out <= inputData[0];
                4'b0001: out <= inputData[1];
                4'b0010: out <= inputData[2];
                4'b0011: out <= inputData[3];
                4'b0100: out <= inputData[4];
                4'b0101: out <= inputData[5];
                4'b0110: out <= inputData[6];
                4'b0111: out <= inputData[7];
                4'b1000: out <= inputData[8];
                4'b1001: out <= inputData[9];
                4'b1010: out <= inputData[10];
                4'b1011: out <= inputData[11];
                4'b1100: out <= inputData[12];
                4'b1101: out <= inputData[13];
                4'b1110: out <= inputData[14];
                4'b1111: out <= inputData[15];
                default: out <= 16'b11111111;
            endcase
        end
    end

endmodule
