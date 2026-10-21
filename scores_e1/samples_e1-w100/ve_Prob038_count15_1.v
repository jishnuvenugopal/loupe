
module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    
    reg [3:0] count;

    
    reg [3:0] counter;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000;
            counter <= 4'b0000;
        end else begin
            counter <= counter + 1'b1;
            if (counter == 4'b1111) begin
                counter <= 4'b0000;
            end
        end
    end

    
    assign count = counter;

    
    assign q = count;

endmodule
