
module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    reg [7:0] Q;
    wire [2:0] sel;

    assign sel = {A, B, C};

    
    always @(posedge clk) begin
        if (enable)
            Q <= { Q[6:0], S };
    end

    
    assign Z = Q[sel];

endmodule
