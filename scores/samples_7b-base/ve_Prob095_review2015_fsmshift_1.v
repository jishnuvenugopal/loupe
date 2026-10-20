
module TopModule(
    input clk,
    input reset,
    output shift_ena
);

    
    localparam [1:0] DISABLED = 2'b00,
                   ENABLED = 2'b01;

    
    reg [1:0] state, next_state;

    
    reg [1:0] cycle_count;
    reg [1:0] next_cycle_count;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= DISABLED;
            shift_ena <= 1'b0;
        end else begin
            state <= next_state;
            shift_ena <= (state == ENABLED) ? 1'b1 : 1'b0;
        end
    end

    
    always @(*) begin
        next_state = state;
        case (state)
            DISABLED:
                if (reset == 1'b0)
                    next_state = ENABLED;
                else
                    next_state = DISABLED;
            ENABLED:
                if (cycle_count == 3'b011) begin 
                    next_state = DISABLED;
                end else begin
                    next_state = ENABLED;
                end
            default:
                next_state = DISABLED;
        endcase
    end

    
    always @(*) begin
        next_cycle_count = cycle_count;
        if (reset == 1'b0) begin
            if (state == ENABLED)
                next_cycle_count = cycle_count + 1;
        end
    end

endmodule
