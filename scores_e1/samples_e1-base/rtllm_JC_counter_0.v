
module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

    
    reg [63:0] counter = 0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
        end else begin
            
            if (counter[0] == 0) begin
                
                counter <= counter >> 1 | 1 << 63;
            end else begin
                
                counter <= counter >> 1;
            end
        end
    end

    
    assign Q = counter;

endmodule
