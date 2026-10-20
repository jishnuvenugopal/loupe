
module TopModule (
    input       clk,            
    input       reset,          
    input [31:0] in,             
    output reg [31:0] out        
);

    
    reg [31:0] current_input_reg;
    reg [31:0] previous_input_reg;
    reg [31:0] capture_bit;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            
            current_input_reg <= 0;
            previous_input_reg <= 0;
            capture_bit <= 0;
            out <= 0;
        end else begin
            
            current_input_reg <= in;

            
            for (integer i = 0;
 i < 32;
 i = i + 1) begin
                if (previous_input_reg[i] == 1 && current_input_reg[i] == 0) begin
                    capture_bit[i] <= 1;
                end else if (previous_input_reg[i] == 0) begin
                    capture_bit[i] <= 0;
                end
            end

            
            out <= out | capture_bit;

            
            capture_bit <= 0;
        end
    end

endmodule
