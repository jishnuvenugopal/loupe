
module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    reg [9:0] counter;
    reg [9:0] count;
    reg [9:0] load_count;
    reg [9:0] load_data;
    reg [9:0] load_count_data;

    always @(posedge clk) begin
        if (load) begin
            load_count = data;
            load_data = data;
        end else begin
            if (counter == 0) begin
                tc = 1'b1;
            end else begin
                counter = counter - 1;
            end
        end
    end

    always @(posedge clk) begin
        if (load) begin
            load_count_data = load_count;
        end else begin
            if (counter == 0) begin
                load_count_data = 0;
            end else begin
                load_count_data = load_count_data - 1;
            end
        end
    end

    always @(posedge clk) begin
        if (load) begin
            load_count = load_count_data;
        end else begin
            if (counter == 0) begin
                load_count_data = 0;
            end else begin
                load_count_data = load_count_data - 1;
            end
        end
    end

endmodule
