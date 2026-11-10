
module TopModule (
    input clk,
    input load,
    input data (10 bits),
    output tc
);

    
    reg [9:0] counter;

    
    reg [9:0] d_flip_flop;

    
    reg tc;

    
    always @(posedge clk) begin
        
        if (load) begin
            counter <= data;
        end
        
        else begin
            counter <= counter - 1;
        end
        
        d_flip_flop <= counter;
        
        tc <= (counter == 0);
    end

endmodule
