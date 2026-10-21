
module PriorityEncoder (
    input wire [3:0] in,  
    output reg [1:0] pos  
);

    
    reg [1:0] firstOne;

    
    reg [1:0] count;

    always @(posedge in) begin
        
        firstOne = in[0] ? 2'b00 : firstOne[1];
        firstOne = in[1] ? 2'b01 : firstOne[0];

        
        count = firstOne[0] + firstOne[1];
    end

    
    assign pos = count;

endmodule
