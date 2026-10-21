
module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

    
    reg [15:0] reg_count;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_count <= 0;
 
        end else begin
            if (up_down) begin
                reg_count <= reg_count + 1;
 
            end else begin
                reg_count <= reg_count - 1;
 
            end
        end
    end

    
    assign count = reg_count;

endmodule
