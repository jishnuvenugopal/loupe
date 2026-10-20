
module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    
    reg [7:0] Q;
    reg [2:0] address;

    
    always @(posedge clk) begin
        if (enable)
            Q <= {S, Q[7:1]};
    end

    
    assign address = {C, B, A};
    assign Z = Q[address];

endmodule
