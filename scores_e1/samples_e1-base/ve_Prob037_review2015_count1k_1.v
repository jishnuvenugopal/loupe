
module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    
    reg [9:0] counter;
    reg [9:0] next_counter;

    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
        end else begin
            next_counter <= counter + 1;
        end
    end

    
    always @(posedge reset) begin
        counter <= 0;
    end

    
    assign q = counter;

endmodule
