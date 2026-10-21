
module TopModule (
    input clk,
    input [7:0] in,
    input [7:0] anyedge
);

    
    reg [7:0] ff;
    reg [7:0] ff_prev;

    
    reg [3:0] counter;

    
    always @(posedge clk) begin
        
        ff_prev = ff;
        ff = in;

        
        if (ff != ff_prev) begin
            counter <= counter + 1;
        end

        
        if (counter == 1) begin
            anyedge <= anyedge | (1 << i);
        end else begin
            anyedge <= anyedge & ~(1 << i);
        end
    end

endmodule
