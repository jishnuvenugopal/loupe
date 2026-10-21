
module comparator_3bit (
    input wire [2:0] A,  
    input wire [2:0] B,  
    output reg A_greater,  
    output reg A_equal,   
    output reg A_less    
);

always @(posedge clk or negedge rst) begin
    if (rst) begin
        A_greater <= 0;
        A_equal <= 0;
        A_less <= 0;
    end else begin
        if (A > B) begin
            A_greater <= 1;
            A_equal <= 0;
            A_less <= 0;
        end else if (A < B) begin
            A_greater <= 0;
            A_equal <= 0;
            A_less <= 1;
        end else begin
            A_greater <= 0;
            A_equal <= 1;
            A_less <= 0;
        end
    end
end

endmodule
