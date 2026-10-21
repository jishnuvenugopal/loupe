
module comparator_4bit (
    input wire [3:0] A,
    input wire [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    
    reg [3:0] difference;
    reg [3:0] borrow;

    
    always @(posedge A or posedge B) begin
        if (A > B) begin
            difference <= A - B;
            borrow <= 1'b1;
        end else if (A < B) begin
            difference <= B - A;
            borrow <= 1'b0;
        end else begin
            difference <= 4'b0;
            borrow <= 1'b0;
        end
    end

    
    always @(posedge difference or posedge borrow) begin
        if (borrow == 1'b1) begin
            A_less <= 1'b1;
            A_greater <= 1'b0;
            A_equal <= 1'b0;
        end else if (difference != 4'b0) begin
            A_less <= 1'b0;
            A_greater <= 1'b1;
            A_equal <= 1'b0;
        end else begin
            A_less <= 1'b0;
            A_greater <= 1'b0;
            A_equal <= 1'b1;
        end
    end

endmodule
