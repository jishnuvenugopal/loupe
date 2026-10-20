
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
        reg [511:0] next_state;

        
        for (int i = 0;
 i < 512;
 i++) begin
            
            reg left, center, right;
            left = (i == 0) ? 0 : current_state[i - 1];
            center = current_state[i];
            right = (i == 511) ? 0 : current_state[i + 1];

            
            case ({left, center, right})
                4'b000: next_state[i] = 0;
                4'b001: next_state[i] = 1;
                4'b010: next_state[i] = 1;
                4'b011: next_state[i] = 0;
                4'b100: next_state[i] = 1;
                4'b101: next_state[i] = 1;
                4'b110: next_state[i] = 1;
                4'b111: next_state[i] = 0;
                default: next_state[i] = 0;
            endcase
        end

        
        current_state <= next_state;
    end

    
    assign q = current_state;

endmodule
