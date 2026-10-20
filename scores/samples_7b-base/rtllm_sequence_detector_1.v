
module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

    
    parameter IDLE = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;
    parameter S3 = 2'b11;
    parameter S4 = 2'b11;
 

    
    reg [1:0] current_state, next_state;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        next_state = current_state;
        sequence_detected = 1'b0;

        case (current_state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    next_state = S1;
                end
            end
            S1: begin
                if (data_in == 1'b0) begin
                    next_state = S2;
                end
            end
            S2: begin
                if (data_in == 1'b0) begin
                    next_state = S3;
                end
            end
            S3: begin
                if (data_in == 1'b1) begin
                    next_state = S4;
                end else begin
                    next_state = IDLE;
                end
            end
            S4: begin
                next_state = IDLE;
 
                sequence_detected = 1'b1;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule
