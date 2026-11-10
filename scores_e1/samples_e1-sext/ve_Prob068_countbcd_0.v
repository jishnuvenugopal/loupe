
module TopModule (
    input clk,
    input reset,
    output reg [3:0] q,
    output reg [3:0] ena
);

    
    reg [3:0] count;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000;
        end else begin
            count <= count + 1'b1;
        end
    end

    
    assign q[3:0] = count[3:0];
    assign q[7:4] = count[7:4];
    assign q[11:8] = count[11:8];
    assign q[15:12] = count[15:12];

    
    assign ena[0] = count[3];
    assign ena[1] = count[7];
    assign ena[2] = count[11];

endmodule
