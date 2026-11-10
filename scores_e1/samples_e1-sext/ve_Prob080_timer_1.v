
module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    
    reg [9:0] count;
    reg [9:0] initial_count;
    reg [9:0] count_down;
    reg [9:0] count_up;
    reg [9:0] count_reset;

    always @(posedge clk) begin
        if (load) begin
            initial_count <= data;
            count_down <= initial_count;
            count_up <= 0;
            count_reset <= 0;
        end else begin
            if (count_down > 0) begin
                count_down <= count_down - 1;
            end else if (count_up > 0) begin
                count_up <= count_up - 1;
            end else if (count_reset > 0) begin
                count_reset <= count_reset - 1;
            end else begin
                count <= count_up;
                count_up <= 0;
                count_reset <= 0;
            end
        end
    end

    
    reg [9:0] d_flip_flop_count;
    reg [9:0] d_flip_flop_count_next;
    reg [9:0] d_flip_flop_count_reset;

    always @(posedge clk) begin
        if (load) begin
            d_flip_flop_count_next <= data;
            d_flip_flop_count_reset <= 0;
        end else begin
            d_flip_flop_count_next <= d_flip_flop_count;
            d_flip_flop_count_reset <= d_flip_flop_count_reset + 1;
        end
    end

    always @(posedge clk) begin
        if (d_flip_flop_count_reset > 0) begin
            d_flip_flop_count_reset <= d_flip_flop_count_reset - 1;
        end else begin
            d_flip_flop_count <= d_flip_flop_count_next;
        end
    end

    
    assign count_down = count;
    assign count_up = count;
    assign count_reset = count;
    assign tc = d_flip_flop_count == 0;

endmodule
