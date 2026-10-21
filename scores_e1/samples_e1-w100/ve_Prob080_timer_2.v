
module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    
    reg [9:0] counter;
    reg [9:0] load_counter;
    reg [9:0] load_value;
    reg [9:0] load_count;
    reg [9:0] load_flag;

    always @(posedge clk) begin
        if (load_flag) begin
            load_counter <= load_value;
            load_flag <= 0;
        end else begin
            if (load) begin
                load_counter <= data;
                load_flag <= 1;
            end else begin
                if (load_counter > 0) begin
                    load_counter <= load_counter - 1;
                end else begin
                    tc <= 1;
                end
            end
        end
    end

    
    reg [9:0] duration;
    reg [9:0] duration_count;
    reg [9:0] duration_flag;

    always @(posedge clk) begin
        if (duration_flag) begin
            duration_count <= duration;
            duration_flag <= 0;
        end else begin
            if (load) begin
                duration_count <= data;
                duration_flag <= 1;
            end else begin
                if (duration_count > 0) begin
                    duration_count <= duration_count - 1;
                end else begin
                    tc <= 1;
                end
            end
        end
    end

endmodule
