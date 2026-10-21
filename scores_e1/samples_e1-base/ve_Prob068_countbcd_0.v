
module TopModule (
    input clk,
    input reset,
    output reg [3:0] q,
    output reg [3:0] ena
);

    
    reg [3:0] bcd_counter;
    reg [3:0] bcd_code;

    
    reg [3:0] enable_counter;
    reg [3:0] enable_code;

    
    reg [3:0] bcd_table [0:9] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bcd_counter <= 0;
            bcd_code <= 0;
        end else begin
            bcd_counter <= bcd_counter + 1;
            bcd_code <= bcd_table[bcd_counter];
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            enable_counter <= 0;
            enable_code <= 0;
        end else begin
            enable_counter <= enable_counter + 1;
            enable_code <= bcd_counter == 9;
        end
    end

    
    assign q = bcd_code;
    assign ena = enable_code;

endmodule
