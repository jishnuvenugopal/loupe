
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    output reg  start_shifting
);

    
    reg [3:0] prev3;

    always @(posedge clk) begin
        if (reset) begin
            prev3  <= 4'b0000;
            start_shifting <= 1'b0;
        end else begin
            
            prev3 <= {prev3[2:0], data};
            
            if (prev3 == 4'b1101) begin
                start_shifting <= 1'b1;
            end else begin
                start_shifting <= 1'b0;
            end
        end
    end

endmodule
