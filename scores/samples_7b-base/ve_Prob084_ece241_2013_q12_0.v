
module TopModule(clk, enable, S, A, B, C, Z);
    input clk, enable, S, A, B, C;
    output Z;

    reg [7:0] Q;
    reg [2:0] address;

    always @(posedge clk) begin
        if (enable)
            Q <= {S, Q[7:1]};
 
    end

    assign address = {A, B, C};
 

    assign Z = Q[address];
 
endmodule
