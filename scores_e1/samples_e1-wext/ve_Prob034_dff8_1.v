
module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

    
    reg [7:0] dffs[7:0];

    
    assign dffs[0] = d[0];
    assign dffs[1] = d[1];
    assign dffs[2] = d[2];
    assign dffs[3] = d[3];
    assign dffs[4] = d[4];
    assign dffs[5] = d[5];
    assign dffs[6] = d[6];
    assign dffs[7] = d[7];

    
    always @(posedge clk) begin
        q[0] <= dffs[0];
        q[1] <= dffs[1];
        q[2] <= dffs[2];
        q[3] <= dffs[3];
        q[4] <= dffs[4];
        q[5] <= dffs[5];
        q[6] <= dffs[6];
        q[7] <= dffs[7];
    end

endmodule
