
module TopModule (
    input [255:0] in,  
    output reg [7:0] out  
);

    
    localparam NUM_SHIFT_REGS = 8;
    localparam NUM_COUNTERS = 8;

    
    reg [255:0] shift_regs[NUM_SHIFT_REGS];

    
    reg [NUM_COUNTERS-1:0] counters[NUM_COUNTERS];

    
    initial begin
        for (int i = 0;
 i < NUM_SHIFT_REGS;
 i++) begin
            shift_regs[i] = in;
        end
    end

    
    always @(posedge clk) begin
        for (int i = 0;
 i < NUM_SHIFT_REGS - 1;
 i++) begin
            shift_regs[i] = shift_regs[i + 1];
        end
        shift_regs[NUM_SHIFT_REGS - 1] = in;
    end

    
    always @(posedge clk) begin
        for (int i = 0;
 i < NUM_COUNTERS;
 i++) begin
            if (shift_regs[i] == 1) begin
                counters[i] = counters[i] + 1;
            end
        end
    end

    
    assign out = $countones(counters);

endmodule
