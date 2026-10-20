
module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] ena,
    output reg [15:0] q
);

    
    parameter NUM_DIGITS = 4;

    
    parameter DIGIT_WIDTH = 4;

    
    parameter OUTPUT_WIDTH = NUM_DIGITS * DIGIT_WIDTH;

    
    reg [NUM_DIGITS-1:0] ena_reg;

    
    reg [DIGIT_WIDTH-1:0] digit_counter[NUM_DIGITS-1:0];

    
    reg [OUTPUT_WIDTH-1:0] output_reg;

    
    always @(posedge reset) begin
        for (int i = 0;
 i < NUM_DIGITS;
 i++) begin
            digit_counter[i] <= 0;
            ena_reg[i] <= 0;
        end
        output_reg <= 0;
    end

    
    always @(posedge clk) begin
        if (reset) begin
            for (int i = 0;
 i < NUM_DIGITS;
 i++) begin
                digit_counter[i] <= 0;
                ena_reg[i] <= 0;
            end
            output_reg <= 0;
        end else begin
            for (int i = 0;
 i < NUM_DIGITS;
 i++) begin
                if (ena_reg[i]) begin
                    digit_counter[i] <= digit_counter[i] + 1;
                end
            end
            
            output_reg <= {digit_counter[NUM_DIGITS-1], digit_counter[NUM_DIGITS-2], digit_counter[NUM_DIGITS-3], digit_counter[NUM_DIGITS-4], 0, 0, 0, 0};
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            ena_reg <= 0;
        end else begin
            ena_reg <= {1'b1, 1'b1, 1'b1, 1'b0};
        end
    end

    
    assign q = output_reg;

endmodule
