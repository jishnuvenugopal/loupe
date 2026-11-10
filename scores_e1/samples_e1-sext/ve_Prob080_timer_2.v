
module TopModule (
    input clk,
    input load,
    input data (10 bits),
    output tc
);

    
    reg [9:0] counter;
    reg [9:0] duration;
    reg [9:0] count;
    reg [9:0] count_max;
    reg [9:0] count_min;
    reg [9:0] count_step;
    reg [9:0] count_reset;
    reg [9:0] count_load;
    reg [9:0] count_done;

    always @(posedge clk) begin
        if (count_reset) begin
            count <= count_reset;
            count_max <= count_reset;
            count_min <= count_reset;
            count_step <= count_reset;
            count_load <= count_reset;
            count_done <= count_reset;
        end else begin
            if (count_load) begin
                count <= count_load;
                count_max <= count_load;
                count_min <= count_load;
                count_step <= count_load;
                count_load <= count_reset;
            end else begin
                count <= count - count_step;
                if (count == count_min) begin
                    count_done <= 1;
                end
            end
        end
    end

    
    reg [9:0] d_flip_flop;
    reg [9:0] d_flip_flop_load;
    reg [9:0] d_flip_flop_done;

    always @(posedge clk) begin
        if (d_flip_flop_load) begin
            d_flip_flop <= d_flip_flop_load;
            d_flip_flop_load <= d_flip_flop_reset;
        end else begin
            d_flip_flop <= d_flip_flop;
            if (d_flip_flop == count_max) begin
                d_flip_flop_done <= 1;
            end
        end
    end

    
    assign counter = count;
    assign duration = d_flip_flop;
    assign tc = d_flip_flop_done;

    
    assign count_load = load & data;
    assign d_flip_flop_load = load & d_flip_flop;

endmodule
