
module TopModule (
    input clk,
    input reset,
    output reg [3:0] q,
    output reg [3:0] ena
);

    
    reg [3:0] bcd_counter;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bcd_counter <= 4'b0000;
        end else begin
            bcd_counter <= bcd_counter + 1'b1;
        end
    end

    
    reg [3:0] bcd_table [0:9] = {
        4'b0000, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b0110, 4'b0111, 4'b1000, 4'b1001
    };

    
    assign q[3:0] = bcd_table[bcd_counter[3]];
    assign q[7:4] = bcd_table[bcd_counter[2]];
    assign q[11:8] = bcd_table[bcd_counter[1]];
    assign q[15:12] = bcd_table[bcd_counter[0]];

    
    reg [3:0] enable_counter;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            enable_counter <= 4'b0000;
        end else begin
            enable_counter <= enable_counter + 1'b1;
        end
    end

    
    assign ena[3] = enable_counter[3];
    assign ena[2] = enable_counter[2];
    assign ena[1] = enable_counter[1];
    assign ena[0] = enable_counter[0];

endmodule
