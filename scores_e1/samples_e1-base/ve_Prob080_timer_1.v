
module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    
    reg [9:0] counter;
    reg load_counter;
    reg [9:0] load_value;
    reg [9:0] load_count;

    
    reg [9:0] count;
    reg [9:0] count_next;
    reg [9:0] count_prev;

    
    reg timer_elapsed;

    
    reg clk_edge;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            load_counter <= 0;
            load_value <= 0;
            load_count <= 0;
            count <= 0;
            count_next <= 0;
            count_prev <= 0;
            timer_elapsed <= 0;
            clk_edge <= 0;
        end else begin
            if (clk_edge) begin
                if (load) begin
                    load_counter <= 1;
                    load_value <= data;
                    load_count <= 0;
                end else begin
                    load_counter <= 0;
                    load_value <= 0;
                    load_count <= 0;
                end
            end
            clk_edge <= clk;
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
        end else begin
            if (load_counter) begin
                counter <= load_value;
                load_counter <= 0;
            end else begin
                counter <= counter - 1;
            end
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
        end else begin
            count_prev <= count;
            count_next <= counter;
            if (counter == 0) begin
                count_next <= 0;
                timer_elapsed <= 1;
            end else begin
                count_next <= counter - 1;
            end
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tc <= 0;
        end else begin
            tc <= timer_elapsed;
        end
    end

endmodule
