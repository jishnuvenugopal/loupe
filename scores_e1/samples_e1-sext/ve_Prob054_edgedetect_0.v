
module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] counter;
    reg state;

    always @(posedge clk) begin
        
        if (in[0] == 1'b0 && state == 1'b0) begin
            counter <= counter + 1'b1;
            state <= 1'b1;
        end else if (in[0] == 1'b1 && state == 1'b1) begin
            counter <= counter + 1'b1;
        end else if (in[0] == 1'b1 && state == 1'b0) begin
            counter <= counter + 1'b1;
            state <= 1'b0;
        end

        
        if (counter == 1'b1) begin
            pedge <= pedge + 1'b1;
            counter <= 1'b0;
        end
    end

endmodule
