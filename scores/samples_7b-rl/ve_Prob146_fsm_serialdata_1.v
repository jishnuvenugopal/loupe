
module TopModule (
    input clk,
    input reset,
    input in,
    output reg [7:0] out_byte,
    output reg done
);


localparam IDLE      = 2'b00;
localparam RECEIVE   = 2'b01;
localparam WAIT_STOP = 2'b10;

reg [1:0] state;
reg [3:0] bit_count;
 
reg [7:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done <= 0;
        shift_reg <= 0;
        bit_count <= 0;
        out_byte <= 0;
    end
    else begin
        done <= 0;
 

        case (state)
            IDLE: begin
                if (in == 0) begin  
                    state <= RECEIVE;
                    shift_reg <= 0;
 
                    bit_count <= 0;
                end
            end

            RECEIVE: begin
                shift_reg <= {shift_reg[6:0], in};
 
                bit_count <= bit_count + 1;

                if (bit_count == 7) begin
                    
                    state <= WAIT_STOP;
                    bit_count <= 0;
                end
            end

            WAIT_STOP: begin
                if (in) begin 
                    done <= 1;
                    out_byte <= shift_reg;
 
                    state <= IDLE;
                end
                else begin
                    
                    state <= WAIT_STOP;
                end
            end

            default: state <= IDLE;
        endcase
    end
end

endmodule
