
module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

    
    typedef enum {IDLE, INCREMENT, DECREMENT} counter_state_t;
    reg counter_state;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;
 
            counter_state <= IDLE;
        end else if (train_valid) begin
            case (counter_state)
                IDLE: begin
                    if (train_taken) begin
                        state <= 2'b00;
 
                        counter_state <= DECREMENT;
                    end else begin
                        state <= 2'b01;
 
                        counter_state <= INCREMENT;
                    end
                end
                INCREMENT: begin
                    if (state == 2'b00) begin
                        state <= 2'b01;
 
                    end else begin
                        state <= 2'b02;
 
                    end
                    counter_state <= IDLE;
                end
                DECREMENT: begin
                    if (state == 2'b01) begin
                        state <= 2'b00;
 
                    end else begin
                        state <= 2'b01;
 
                    end
                    counter_state <= IDLE;
                end
            endcase
        end
    end

endmodule
