
module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

reg [31:0] current_state;
reg [31:0] previous_state;
reg [31:0] capture_flag;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= 32'b0;
        previous_state <= 32'b0;
        capture_flag <= 32'b0;
    end else begin
        previous_state <= current_state;
        current_state <= in;
        capture_flag <= 32'b0;
        
        
        if (previous_state == 32'b1 && current_state == 32'b0) begin
            capture_flag <= 32'hFFFFFFFF;
        end
    end
end

assign out = capture_flag;

endmodule
