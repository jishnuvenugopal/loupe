
module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    
    reg [3:0] counter;
    reg [1:0] counter_enable;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'b0000;
            counter_enable <= 2'b00;
        end else begin
            if (slowena) begin
                counter_enable <= 2'b01;
            end else begin
                counter_enable <= 2'b10;
            end
            if (counter_enable == 2'b01) begin
                counter <= counter + 1'b1;
            end
        end
    end

    
    assign q = counter;

endmodule
