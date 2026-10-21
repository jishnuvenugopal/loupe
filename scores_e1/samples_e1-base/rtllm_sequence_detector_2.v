
module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

    
    typedef enum {IDLE, S1, S2, S3, S4} state_t;
    state_t current_state, next_state;

    
    localparam [3:0] sequence = 4'b1001;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(posedge clk) begin
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    next_state <= S1;
                end else begin
                    next_state <= IDLE;
                end
            end
            S1: begin
                if (data_in == 1'b0) begin
                    next_state <= IDLE;
                end else begin
                    next_state <= S2;
                end
            end
            S2: begin
                if (data_in == 1'b1) begin
                    next_state <= IDLE;
                end else begin
                    next_state <= S3;
                end
            end
            S3: begin
                if (data_in == 1'b0) begin
                    next_state <= IDLE;
                end else begin
                    next_state <= S4;
                end
            end
            S4: begin
                if (data_in == 1'b1) begin
                    sequence_detected <= 1'b1;
                    next_state <= IDLE;
                end else begin
                    next_state <= IDLE;
                end
            end
        endcase
    end

endmodule
