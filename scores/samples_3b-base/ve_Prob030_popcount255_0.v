
module TopModule (
    input  [255:0] in,  
    output [7:0] out   
);

    
    reg [255:0] shifted_in;
    reg [255:0] shifted_in_1;
    reg [255:0] shifted_in_2;
    reg [255:0] shifted_in_3;
    reg [255:0] shifted_in_4;
    reg [255:0] shifted_in_5;
    reg [255:0] shifted_in_6;
    reg [255:0] shifted_in_7;

    
    reg [7:0] count_1;
    reg [7:0] count_2;
    reg [7:0] count_3;
    reg [7:0] count_4;
    reg [7:0] count_5;
    reg [7:0] count_6;
    reg [7:0] count_7;

    
    always @(posedge clk) begin
        shifted_in <= in;
        shifted_in_1 <= shifted_in << 1;
        shifted_in_2 <= shifted_in_1 << 1;
        shifted_in_3 <= shifted_in_2 << 1;
        shifted_in_4 <= shifted_in_3 << 1;
        shifted_in_5 <= shifted_in_4 << 1;
        shifted_in_6 <= shifted_in_5 << 1;
        shifted_in_7 <= shifted_in_6 << 1;
    end

    
    always @(posedge clk) begin
        count_1 <= shifted_in_1 & 1;
        count_2 <= shifted_in_2 & 1;
        count_3 <= shifted_in_3 & 1;
        count_4 <= shifted_in_4 & 1;
        count_5 <= shifted_in_5 & 1;
        count_6 <= shifted_in_6 & 1;
        count_7 <= shifted_in_7 & 1;
    end

    
    always @(posedge clk) begin
        out <= count_1 + count_2 + count_3 + count_4 + count_5 + count_6 + count_7;
    end

endmodule
