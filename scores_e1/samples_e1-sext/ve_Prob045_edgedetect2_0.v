
module TopModule (
    input clk,
    input in      (8 bits),
    input anyedge (8 bits),
    output reg [7:0] out
);

    
    reg [7:0] state;
    reg [7:0] next_state;
    reg [7:0] counter;

    
    always @(posedge clk) begin
        if (anyedge == 1'b1) begin
            state <= in;
            counter <= 8'b0;
        end
    end

    
    always @(posedge clk) begin
        if (state != next_state) begin
            next_state <= state;
            counter <= counter + 1'b1;
        end
    end

    
    always @(posedge clk) begin
        if (counter == 8'b0) begin
            out <= state;
        end
    end

endmodule
