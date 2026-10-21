
module TopModule (
    input a,
    input b,
    input c,
    input d,
    output reg out_sop,
    output reg out_pos
);

    
    reg [3:0] sum;
    reg [3:0] product;

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            sum <= 4'b0;
            product <= 4'b0;
            out_sop <= 1'b0;
            out_pos <= 1'b0;
        end else begin
            sum <= a & b & c & d;
            product <= ~a & ~b & ~c & ~d;

            
            if (sum == 4'b1111) begin
                out_sop <= 1'b1;
                out_pos <= 1'b0;
            end else if (product == 4'b1111) begin
                out_sop <= 1'b0;
                out_pos <= 1'b1;
            end else begin
                out_sop <= 1'b0;
                out_pos <= 1'b0;
            end
        end
    end

endmodule
