
module TopModule (
    input clk,
    input reset,
    output reg [3:0] q,
    output reg [3:0] ena
);

    
    reg [3:0] ones_counter;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ones_counter <= 4'b0000;
        end else begin
            ones_counter <= ones_counter + 1'b1;
        end
    end

    
    reg [3:0] tens_counter;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tens_counter <= 4'b0000;
        end else begin
            tens_counter <= tens_counter + 1'b1;
        end
    end

    
    reg [3:0] hundreds_counter;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hundreds_counter <= 4'b0000;
        end else begin
            hundreds_counter <= hundreds_counter + 1'b1;
        end
    end

    
    reg [3:0] thousands_counter;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            thousands_counter <= 4'b0000;
        end else begin
            thousands_counter <= thousands_counter + 1'b1;
        end
    end

    
    assign q = {thousands_counter, hundreds_counter, tens_counter, ones_counter};

    
    assign ena = {thousands_counter[3], hundreds_counter[3], tens_counter[3], ones_counter[3]};

endmodule
