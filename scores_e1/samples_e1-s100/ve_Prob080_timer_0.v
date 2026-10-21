
module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    
    reg [9:0] counter;

    
    reg [9:0] d_flip_flop;

    
    always @(posedge clk) begin
        if (load) begin
            
            counter <= data;
            
            d_flip_flop <= 10'b0;
        end else begin
            
            counter <= counter - 1'b1;
            
            d_flip_flop <= counter;
        end
    end

    
    always @(posedge clk) begin
        if (counter == 0) begin
            
            tc <= 1'b1;
        end else begin
            
            tc <= 1'b0;
        end
    end

endmodule
