
module TopModule (
    input clk,
    input reset,
    output reg [3:0] q,
    output reg [3:0] ena
);

    
    reg [3:0] ones_counter;
    reg [3:0] ones_enable;

    
    reg [3:0] tens_counter;
    reg [3:0] tens_enable;

    
    reg [3:0] hundreds_counter;
    reg [3:0] hundreds_enable;

    
    reg [3:0] thousands_counter;
    reg [3:0] thousands_enable;

    
    reg reset_signal;

    
    reg clk_edge;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reset_signal <= 1'b1;
            ones_counter <= 4'b0000;
            tens_counter <= 4'b0000;
            hundreds_counter <= 4'b0000;
            thousands_counter <= 4'b0000;
            ones_enable <= 4'b0000;
            tens_enable <= 4'b0000;
            hundreds_enable <= 4'b0000;
            clk_edge <= 1'b0;
        end else begin
            reset_signal <= 1'b0;
            if (clk_edge) begin
                ones_counter <= ones_counter + 1'b1;
                tens_counter <= tens_counter + 1'b1;
                hundreds_counter <= hundreds_counter + 1'b1;
                thousands_counter <= thousands_counter + 1'b1;
                ones_enable <= ones_enable + 1'b1;
                tens_enable <= tens_enable + 1'b1;
                hundreds_enable <= hundreds_enable + 1'b1;
                clk_edge <= 1'b0;
            end
        end
    end

    
    assign ena = {ones_enable, tens_enable, hundreds_enable, thousands_enable};

    
    assign q = {thousands_counter, hundreds_counter, tens_counter, ones_counter};

endmodule
