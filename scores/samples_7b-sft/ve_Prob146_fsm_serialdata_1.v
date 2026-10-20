
module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);


localparam IDLE      = 2'b00;
localparam DATA      = 2'b01;
localparam STOP      = 2'b10;
localparam WAIT_STOP = 2'b11;

reg [1:0] state, next_state;
reg [2:0] bit_count;
 
reg [7:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        bit_count <= 3'b0;
        shift_reg <= 8'b0;
        done <= 1'b0;
        out_byte <= 8'b0;
    end else begin
        state <= next_state;

        case (state)
            IDLE: begin
                done <= 1'b0;
                if (in == 1'b0) begin
                    next_state <= DATA;
                    bit_count <= 3'b0;
                    shift_reg <= 8'b0;
                end else begin
                    next_state <= IDLE;
                end
            end

            DATA: begin
                if (bit_count < 3'd7) begin
                    
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                    next_state <= DATA;
                end else begin
                    
                    shift_reg <= {in, shift_reg[7:1]};
                    next_state <= STOP;
                end
            end

            STOP: begin
                if (in == 1'b1) begin
                    out_byte <= shift_reg;
                    done <= 1'b1;
                    next_state <= IDLE;
                end else begin
                    done <= 1'b0;
                    next_state <= WAIT_STOP;
                end
            end

            WAIT_STOP: begin
                if (in == 1'b1) begin
                    next_state <= IDLE;
                end else begin
                    next_state <= WAIT_STOP;
                end
            end

            default: next_state <= IDLE;
        endcase
    end
end

endmodule
