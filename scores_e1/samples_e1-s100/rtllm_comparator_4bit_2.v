
module comparator_4bit (
    input wire [3:0] A,
    input wire [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    
    reg [3:0] diff;
    reg [3:0] borrow;

    
    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            diff <= 4'b0000;
            borrow <= 1'b0;
        end else begin
            diff <= A - B;
            borrow <= (diff[3] && ~B[3]);
        end
    end

    
    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            A_greater <= 1'b0;
            A_equal <= 1'b0;
            A_less <= 1'b0;
        end else begin
            if (borrow) begin
                A_less <= 1'b1;
            end else if (diff == 4'b0) begin
                A_equal <= 1'b1;
            end else begin
                A_greater <= 1'b1;
            end
        end
    end

endmodule
