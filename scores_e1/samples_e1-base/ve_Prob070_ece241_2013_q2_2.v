
module TopModule (
    input a,
    input b,
    input c,
    input d,
    output reg out_sop,
    output reg out_pos
);

    
    reg [3:0] xor_products = {a, b, c, d};

    
    reg [3:0] xor_sums = {a, b, c, d};

    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            xor_products <= {4'b0};
        end else begin
            xor_products <= {a, b, c, d};
        end
    end

    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            xor_sums <= {4'b0};
        end else begin
            xor_sums <= {a, b, c, d};
        end
    end

    
    assign out_sop = xor_products[0] | xor_products[1] | xor_products[2] | xor_products[3];

    
    assign out_pos = xor_sums[0] & xor_sums[1] & xor_sums[2] & xor_sums[3];

endmodule
