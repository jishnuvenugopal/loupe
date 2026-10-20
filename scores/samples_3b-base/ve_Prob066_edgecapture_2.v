
module TopModule (
    input  clk,
    input  reset,
    input  [31:0] in,
    output [31:0] out
);

    
    reg [31:0] current_in;

    
    reg [31:0] output;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output <= 0;
        end else begin
            
            if (current_in == 1'b1 && in == 1'b0) begin
                output <= 1'b1;
            end else begin
                output <= 1'b0;
            end
        end
    end

    
    always @(posedge clk) begin
        current_in <= in;
    end

endmodule
