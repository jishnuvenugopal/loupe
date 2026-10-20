
module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    
    localparam IDLE         = 2'd0;
    localparam CAPTURE_DELAY = 2'd1;
    localparam COUNTING     = 2'd2;
    localparam DONE         = 2'd3;

    reg [1:0] state;
    reg [3:0] start_shift_reg;
   
    reg [3:0] delay_shift_reg;
   
    reg [3:0] delay_reg;
         
    reg [3:0] count_reg;
         
    reg [9:0] cycle_counter;
     
    reg [1:0] bit_counter;
       

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            start_shift_reg <= 4'b0;
            delay_shift_reg <= 4'b0;
            delay_reg <= 4'b0;
            count_reg <= 4'b0;
            cycle_counter <= 10'b0;
            bit_counter <= 2'b0;
            done <= 1'b0;
            counting <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'b0;
                    
                    start_shift_reg <= {start_shift_reg[2:0], data};
                    if (start_shift_reg == 4'b1101) begin
                        state <= CAPTURE_DELAY;
                        bit_counter <= 2'b0;
                        delay_shift_reg <= 4'b0;
                    end
                end

                CAPTURE_DELAY: begin
                    
                    delay_shift_reg <= {delay_shift_reg[2:0], data};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 2'd3) begin
                        delay_reg <= delay_shift_reg;
                        state <= COUNTING;
                        count_reg <= delay_shift_reg;
                        cycle_counter <= 10'b0;
                        counting <= 1'b1;
                    end
                end

                COUNTING: begin
                    count <= count_reg;
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'b0;
                        if (count_reg > 4'd0) begin
                            count_reg <= count_reg - 1'b1;
                        end else begin
                            state <= DONE;
                            counting <= 1'b0;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end
                end

                DONE: begin
                    done <= 1'b1;
                    if (ack) begin
                        state <= IDLE;
                        done <= 1'b0;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
