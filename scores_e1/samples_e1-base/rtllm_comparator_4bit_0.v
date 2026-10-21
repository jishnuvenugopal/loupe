
module comparator_4bit (
    input wire [3:0] A,
    input wire [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    
    reg [3:0] result;
    reg borrow;

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            result <= 4'b0000;
            borrow <= 1'b0;
        end else begin
            result <= A - B;
            borrow <= (result[3] == 1'b1);
        end
    end

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            A_greater <= 1'b0;
            A_equal <= 1'b0;
            A_less <= 1'b0;
        end else begin
            if (borrow == 1'b0 && result != 4'b0) begin
                A_greater <= 1'b1;
                A_equal <= 1'b0;
                A_less <= 1'b0;
            end else if (borrow == 1'b0 && result == 4'b0) begin
                A_greater <= 1'b0;
                A_equal <= 1'b1;
                A_less <= 1'b0;
            end else if (borrow == 1'b1) begin
                A_greater <= 1'b0;
                A_equal <= 1'b0;
                A_less <= 1'b1;
            end
        end
    end

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            A_greater <= 1'b0;
            A_equal <= 1'b0;
            A_less <= 1'b0;
        end else begin
            if (borrow == 1'b0 && result == 4'b0) begin
                A_greater <= 1'b0;
                A_equal <= 1'b1;
                A_less <= 1'b0;
            end else if (borrow == 1'b0 && result != 4'b0) begin
                A_greater <= 1'b0;
                A_equal <= 1'b0;
                A_less <= 1'b1;
            end else if (borrow == 1'b1) begin
                A_greater <= 1'b0;
                A_equal <= 1'b0;
                A_less <= 1'b1;
            end
        end
    end

endmodule
