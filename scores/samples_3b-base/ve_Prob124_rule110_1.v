
module TopModule (
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

    
    reg [511:0] current_state;

    
    always @(posedge clk) begin
        if (load) begin
            current_state <= data;
        end
    end

    
    always @(posedge clk) begin
        
        reg [511:0] next_state = 512'b0;

        
        for (int i = 0;
 i < 512;
 i++) begin
            
            reg left = (i == 0) ? 0 : current_state[i - 1];
            reg center = current_state[i];
            reg right = (i == 511) ? 0 : current_state[i + 1];

            
            case ({left, center, right})
                5'b111: next_state[i] = 0;
                5'b110: next_state[i] = 1;
                5'b101: next_state[i] = 1;
                5'b100: next_state[i] = 0;
                5'b011: next_state[i] = 1;
                5'b010: next_state[i] = 1;
                5'b001: next_state[i] = 1;
                5'b000: next_state[i] = 0;
            endcase
        end

        
        current_state <= next_state;
    end

    
    assign q = current_state;

endmodule
