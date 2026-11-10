
module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

    
    typedef enum {IDLE, INCREMENT, DECREMENT} counter_state;

    
    reg [1:0] counter_state_reg = IDLE;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter_state_reg <= IDLE;
            state <= 2'b01;
 
        end else begin
            case (counter_state_reg)
                IDLE: begin
                    if (train_valid && train_taken) begin
                        counter_state_reg <= INCREMENT;
                    end
                end
                INCREMENT: begin
                    if (train_valid && train_taken) begin
                        state <= state + 1'b1;
                        if (state == 3'b11) begin
                            state <= 2'b00;
 
                        end
                    end else begin
                        counter_state_reg <= DECREMENT;
                    end
                end
                DECREMENT: begin
                    if (train_valid && train_taken) begin
                        state <= state - 1'b1;
                        if (state == 2'b00) begin
                            state <= 2'b01;
 
                        end
                    end else begin
                        counter_state_reg <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule
