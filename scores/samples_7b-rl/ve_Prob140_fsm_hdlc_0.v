
module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);
    
    reg [7:0] count;
    
    
    always @(posedge clk) begin
        if (reset)
            count <= 0;
        else if (in)
            count <= (count == 0) ? 1 : count + 1;
        else
            count <= 0;
    end
    
    
    always @(posedge clk) begin
        if (reset) begin
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            
            disc <= 0;
            flag <= 0;
            err <= 0;
            
            
            if (count == 5 && !in)
                disc <= 1;
            else if (count == 7 && !in)
                flag <= 1;
            else if (count >=7 && in)
                err <= 1;
        end
    end
    
endmodule
