
module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [3:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            
            disc <= 0;
            flag <= 0;
            err <= 0;
            
            if (in == 0) begin
                
                if (count == 5)
                    disc <= 1;
                else if (count == 6)
                    flag <= 1;
                
                count <= 0;
            end else begin
                
                if (count >= 7) begin
                    err <= 1;
                end else begin
                    count <= count + 1;
                end
            end
        end
    end

endmodule
