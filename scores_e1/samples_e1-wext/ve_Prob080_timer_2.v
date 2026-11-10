
module TopModule (
    input clk,
    input load,
    input data (10 bits),
    output tc
);

    
    reg [9:0] counter;

    
    reg [9:0] d_flip_flop;

    
    reg terminal_count;

    
    always @(posedge clk) begin
        if (load) begin
            
            counter <= data;
            
            terminal_count <= 0;
        end else begin
            
            counter <= counter - 1;
            
            if (counter == 0) begin
                
                terminal_count <= 1;
            end
        end
    end

    
    assign tc = terminal_count;

endmodule
