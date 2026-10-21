
module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input reg ack
);

    
    reg [1:0] state;
    reg [3:0] delay;
    reg [3:0] remaining_time;
    reg [3:0] count_value;
    reg [3:0] count_index;
    reg [3:0] count_max;
    reg [3:0] count_min;
    reg [3:0] count_step;
    reg [3:0] count_reset;
    reg [3:0] count_start;
    reg [3:0] count_stop;
    reg [3:0] count_wait;
    reg [3:0] count_count;
    reg [3:0] count_done;

    
    reg [3:0] counter;

    
    reg start_flag;
    reg counting_flag;
    reg done_flag;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            delay <= 4'b0000;
            remaining_time <= 4'b0000;
            count_value <= 4'b0000;
            count_index <= 4'b0000;
            count_max <= 4'b0000;
            count_min <= 4'b0000;
            count_step <= 4'b0000;
            count_reset <= 4'b0000;
            count_start <= 4'b0000;
            count_stop <= 4'b0000;
            count_wait <= 4'b0000;
            count_count <= 4'b0000;
            count_done <= 4'b0000;
            counter <= 4'b0000;
            start_flag <= 0;
            counting_flag <= 0;
            done_flag <= 0;
        end else begin
            case (state)
                2'b00: begin
                    if (start_flag) begin
                        start_flag <= 0;
                        count_value <= 4'b0000;
                        count_index <= 4'b0000;
                        count_max <= 4'b0000;
                        count_min <= 4'b0000;
                        count_step <= 4'b0000;
                        count_reset <= 4'b0000;
                        count_start <= 4'b0000;
                        count_stop <= 4'b0000;
                        count_wait <= 4'b0000;
                        count_count <= 4'b0000;
                        count_done <= 4'b0000;
                        counter <= 4'b0000;
                    end else if (data == 2'b1101) begin
                        start_flag <= 1;
                        delay <= data[3:0];
                        count_value <= 4'b0000;
                        count_index <= 4'b0000;
                        count_max <= 4'b0000;
                        count_min <= 4'b0000;
                        count_step <= 4'b0000;
                        count_reset <= 4'b0000;
                        count_start <= 4'b0000;
                        count_stop <= 4'b0000;
                        count_wait <= 4'b0000;
                        count_count <= 4'b0000;
                        count_done <= 4'b0000;
                        counter <= 4'b0000;
                    end
                end
                2'b01: begin
                    if (counting_flag) begin
                        count_value <= count_value + 1;
                        if (count_value == count_max) begin
                            count_value <= count_min;
                            count_index <= count_index + 1;
                            if (count_index == count_max) begin
                                count_index <= count_min;
                                count_max <= count_max + count_step;
                                count_min <= count_min + count_step;
                                count_step <= count_step + count_step;
                            end
                        end
                    end else if (data == 2'b1101) begin
                        start_flag <= 1;
                        delay <= data[3:0];
                        count_value <= 4'b0000;
                        count_index <= 4'b0000;
                        count_max <= 4'b0000;
                        count_min <= 4'b0000;
                        count_step <= 4'b0000;
                        count_reset <= 4'b0000;
                        count_start <= 4'b0000;
                        count_stop <= 4'b0000;
                        count_wait <= 4'b0000;
                        count_count <= 4'b0000;
                        count_done <= 4'b0000;
                        counter <= 4'b0000;
                    end
                end
                2'b10: begin
                    if (counting_flag) begin
                        count_value <= count_value + 1;
                        if (count_value == count_max) begin
                            count_value <= count_min;
                            count_index <= count_index + 1;
                            if (count_index == count_max) begin
                                count_index <= count_min;
                                count_max <= count_max + count_step;
                                count_min <= count_min + count_step;
                                count_step <= count_step + count_step;
                            end
                        end
                    end else if (data == 2'b1101) begin
                        start_flag <= 1;
                        delay <= data[3:0];
                        count_value <= 4'b0000;
                        count_index <= 4'b0000;
                        count_max <= 4'b0000;
                        count_min <= 4'b0000;
                        count_step <= 4'b0000;
                        count_reset <= 4'b0000;
                        count_start <= 4'b0000;
                        count_stop <= 4'b0000;
                        count_wait <= 4'b0000;
                        count_count <= 4'b0000;
                        count_done <= 4'b0000;
                        counter <= 4'b0000;
                    end
                end
                2'b11: begin
                    if (counting_flag) begin
                        count_value <= count_value + 1;
                        if (count_value == count_max) begin
                            count_value <= count_min;
                            count_index <= count_index + 1;
                            if (count_index == count_max) begin
                                count_index <= count_min;
                                count_max <= count_max + count_step;
                                count_min <= count_min + count_step;
                                count_step <= count_step + count_step;
                            end
                        end
                    end else if (data == 2'b1101) begin
                        start_flag <= 1;
                        delay <= data[3:0];
                        count_value <= 4'b0000;
                        count_index <= 4'b0000;
                        count_max <= 4'b0000;
                        count_min <= 4'b0000;
                        count_step <= 4'b0000;
                        count_reset <= 4'b0000;
                        count_start <= 4'b0000;
                        count_stop <= 4'b0000;
                        count_wait <= 4'b0000;
                        count_count <= 4'b0000;
                        count_done <= 4'b0000;
                        counter <= 4'b0000;
                    end
                end
                default: begin
                    state <= 2'b00;
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counting_flag <= 0;
        end else begin
            if (start_flag) begin
                counting_flag <= 1;
                counter <= 0;
            end else if (counting_flag) begin
                counter <= counter + 1;
                if (counter == delay) begin
                    counting_flag <= 0;
                    done_flag <= 1;
                end
            end
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            done_flag <= 0;
        end else begin
            if (done_flag) begin
                done_flag <= 0;
                start_flag <= 1;
            end
        end
    end

endmodule
