
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    output reg  start_shifting
);

    
    reg [2:0] sequence;

    always @(posedge clk) begin
        if (reset) begin
            sequence <= 3'b0;
            start_shifting <= 1'b0;
        end else begin
            
            sequence <= {sequence[1:0], data};
            
            if (sequence == 3'b110) begin
                start_shifting <= 1'b1;
            end else begin
                start_shifting <= 1'b0;
            end
        end
    end

endmodule
