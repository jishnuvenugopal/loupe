
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

    reg [511:0] q_reg;
    wire [511:0] next_q;

    generate
        genvar idx;
        for (idx = 0;
 idx < 512;
 idx = idx + 1) begin : gen_next_state
            if (idx == 0) begin
                
                assign next_q[idx] = 1'b0 ^ q_reg[idx + 1];
            end else if (idx == 511) begin
                
                assign next_q[idx] = q_reg[idx - 1] ^ 1'b0;
            end else begin
                
                assign next_q[idx] = q_reg[idx - 1] ^ q_reg[idx + 1];
            end
        end
    endgenerate

    
    always @(posedge clk) begin
        if (load)
            q_reg <= data;
        else
            q_reg <= next_q;
    end

    
    assign q = q_reg;

endmodule
