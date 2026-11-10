
module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

    
    reg [63:0] counter_value = 64'b0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            
            counter_value <= 64'b0;
        end else begin
            
            if (counter_value[0] == 0) begin
                
                counter_value <= {counter_value[63:1], 1'b1};
            end else begin
                
                counter_value <= {counter_value[63:1], 1'b0};
            end
        end
    end

    
    assign Q = counter_value;

endmodule
