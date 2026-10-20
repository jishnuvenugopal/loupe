
module TopModule (
    input clk,
    input reset,
    input in,
    output reg [7:0] out_byte,
    output reg done
);


localparam S_IDLE        = 3'd0;
localparam S_START_BIT   = 3'd1;
localparam S_RECEIVE_DATA= 3'd2;
localparam S_VERIFY_STOP = 3'd3;
localparam S_WAIT_STOP   = 3'd4;

reg [2:0] current_state;
reg [2:0] bit_counter;
reg [7:0] rx_data;


always @(posedge clk) begin
    if (reset) begin
        current_state <= S_IDLE;
        done <= 0;
        bit_counter <=0;
        rx_data <=0;
        out_byte <=0;
    end else begin
        done <=0;
        case (current_state)
            S_IDLE: begin
                if (!in) begin 
                    current_state <= S_START_BIT;
                    bit_counter <=0;
                end
            end
            S_START_BIT: begin
                current_state <= S_RECEIVE_DATA;
            end
            S_RECEIVE_DATA: begin
                if (bit_counter < 8) begin
                    
                    rx_data <= {in, rx_data[7:1]};
                    bit_counter <= bit_counter + 1;
                end else begin
                    current_state <= S_VERIFY_STOP;
                end
            end
            S_VERIFY_STOP: begin
                if (in) begin 
                    out_byte <= rx_data;
                    done <= 1;
                    current_state <= S_IDLE;
                end else begin
                    current_state <= S_WAIT_STOP;
                end
            end
            S_WAIT_STOP: begin
                if (in) begin 
                    current_state <= S_IDLE;
                end
            end
            default: current_state <= S_IDLE;
        endcase
    end
end

endmodule
