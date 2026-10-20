
module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] ena,
    output reg [15:0] q
);

    
    reg [3:0] ones_counter;
    reg [3:0] tens_counter;
    reg [3:0] hundreds_counter;
    reg [3:0] thousands_counter;

    
    reg [3:0] digit_ones;
    reg [3:0] digit_tens;
    reg [3:0] digit_hundreds;
    reg [3:0] digit_thousands;

    
    assign ena[0] = digit_ones == 4'b0000;
 
    assign ena[1] = digit_tens == 4'b0000;
 
    assign ena[2] = digit_hundreds == 4'b0000;
 
    assign ena[3] = digit_thousands == 4'b0000;
 

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ones_counter <= 4'b0000;
            tens_counter <= 4'b0000;
            hundreds_counter <= 4'b0000;
            thousands_counter <= 4'b0000;
            digit_ones <= 4'b0000;
            digit_tens <= 4'b0000;
            digit_hundreds <= 4'b0000;
            digit_thousands <= 4'b0000;
        end else begin
            ones_counter <= ones_counter + 1'b1;
            tens_counter <= tens_counter + 1'b1;
            hundreds_counter <= hundreds_counter + 1'b1;
            thousands_counter <= thousands_counter + 1'b1;

            
            digit_ones <= ones_counter;
            digit_tens <= tens_counter;
            digit_hundreds <= hundreds_counter;
            digit_thousands <= thousands_counter;
        end
    end

    
    assign q = {digit_thousands, digit_hundreds, digit_tens, digit_ones};

endmodule
