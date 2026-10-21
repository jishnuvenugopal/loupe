
module PriorityEncoder (
    input  [3:0] in,
    output reg [1:0] pos
);

    
    reg [3:0] firstOne;
    always @(posedge in) begin
        firstOne = in & ~in[3];
    end

    
    reg [1:0] count;
    always @(posedge firstOne) begin
        if (firstOne == 0) begin
            count = 0;
        end else begin
            count = count + 1;
        end
    end

    
    assign pos = count;

endmodule
