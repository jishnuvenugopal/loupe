
module TopModule (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire [15:0] c,
    input wire [15:0] d,
    input wire [15:0] e,
    input wire [15:0] f,
    input wire [15:0] g,
    input wire [15:0] h,
    input wire [15:0] i,
    input wire [3:0] sel,
    output reg [15:0] out
);

    
    reg [15:0] selectedInput;

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            selectedInput <= 16'b0;
            out <= 16'b11111111;
        end else begin
            case (sel)
                4'b0000: selectedInput <= a;
                4'b0001: selectedInput <= b;
                4'b0010: selectedInput <= c;
                4'b0011: selectedInput <= d;
                4'b0100: selectedInput <= e;
                4'b0101: selectedInput <= f;
                4'b0110: selectedInput <= g;
                4'b0111: selectedInput <= h;
                4'b1000: selectedInput <= i;
                default: selectedInput <= 16'b11111111;
            endcase
            out <= selectedInput;
        end
    end

endmodule
