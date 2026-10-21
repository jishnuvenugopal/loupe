
module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    
    reg [1:0] current_state;
    reg [7:0] next_state;
    reg [7:0] input_bits;
    reg [7:0] output_bits;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= STATE_IDLE;
            input_bits <= 8'b0;
            output_bits <= 8'b0;
        end else begin
            case (current_state)
                STATE_IDLE: begin
                    if (x) begin
                        input_bits <= x;
                        next_state <= STATE_CONVERTING;
                    end else begin
                        next_state <= STATE_IDLE;
                    end
                end
                STATE_CONVERTING: begin
                    if (input_bits[7] == 1'b1) begin
                        output_bits <= ~input_bits;
                    end else begin
                        output_bits <= input_bits;
                    end
                    next_state <= STATE_IDLE;
                end
            endcase
            current_state <= next_state;
        end
    end

    
    always @(*) begin
        z <= output_bits;
    end

    
    parameter STATE_IDLE = 2'b00,
              STATE_CONVERTING = 2'b01;

endmodule
