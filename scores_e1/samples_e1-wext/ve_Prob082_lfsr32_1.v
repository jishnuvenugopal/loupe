
module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    
    reg [31:0] lfsr_state = 32'h1;

    
    reg [31:0] tap_32 = 32'h0;
    reg [31:0] tap_22 = 32'h0;
    reg [31:0] tap_2 = 32'h0;
    reg [31:0] tap_1 = 32'h0;

    
    reg [31:0] shift_register = 32'h0;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_state <= 32'h1;
            shift_register <= 32'h0;
            tap_32 <= 32'h0;
            tap_22 <= 32'h0;
            tap_2 <= 32'h0;
            tap_1 <= 32'h0;
        end else begin
            
            tap_32 <= lfsr_state[31];
            tap_22 <= lfsr_state[21];
            tap_2 <= lfsr_state[1];
            tap_1 <= lfsr_state[0];

            
            shift_register <= {tap_32, tap_22, tap_2, tap_1, lfsr_state[30]};

            
            lfsr_state <= shift_register;
        end
    end

    
    assign q = shift_register;

endmodule
