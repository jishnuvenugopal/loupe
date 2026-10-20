
module TopModule (
    input  clk,
    input  reset,
    input  [31:0] in,
    output [31:0] out
);

    
    reg [31:0] capture_reg;

    
    reg [31:0] current_in;

    
    reg [31:0] previous_in;

    
    assign current_in = in;

    
    assign previous_in = previous_in;

    
    assign capture_reg = current_in;

    
    assign out = capture_reg;

    
    always @(posedge reset) begin
        capture_reg <= 32'b0;
    end

    
    always @(posedge clk) begin
        if (current_in != previous_in) begin
            capture_reg <= current_in;
        end
    end

endmodule
