
module TopModule (
    input clk,
    input [7:0] in,
    input [7:0] anyedge
);

    
    reg [7:0] state;

    
    reg [7:0] counter;

    always @(posedge clk) begin
        
        state <= in;

        
        if (state != state[7]) begin
            counter <= counter + 1;
        end else begin
            counter <= counter;
        end

        
        anyedge <= counter == 1 ? 1 : 0;
    end

endmodule
