
module TopModule (
    input clk,
    input load,
    input data (10 bits),
    output tc
);

    
    reg [9:0] counter;

    
    reg [9:0] d_flip_flop;

    
    reg [9:0] timer_count;
    reg timer_start;
    reg timer_running;

    
    reg clk_edge;

    
    initial begin
        counter = 0;
        d_flip_flop = 0;
        timer_count = 0;
        timer_start = 0;
        timer_running = 0;
    end

    
    always @(posedge clk) begin
        clk_edge = 1'b1;
    end

    
    always @(negedge clk) begin
        clk_edge = 1'b0;
    end

    
    always @(posedge clk) begin
        if (clk_edge) begin
            if (load) begin
                counter = data;
                d_flip_flop = data;
            end else begin
                counter <= counter - 1'b1;
            end
        end
    end

    
    always @(posedge clk) begin
        if (clk_edge) begin
            if (timer_start) begin
                timer_count <= timer_count - 1'b1;
                if (timer_count == 0) begin
                    timer_running = 0;
                    tc = 1'b1;
                end
            end else if (load) begin
                timer_start = 1;
                timer_count = data;
                timer_running = 1;
            end
        end
    end

endmodule
