
module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    
    reg [3:0] count;
    reg last_non_one;
 

    
    assign disc = (count == 4'd6) && (last_non_one == 1'b0);
    assign flag = (count == 4'd7) && (last_non_one == 1'b0);
    assign err = (count >= 4'd8) && (last_non_one == 1'b0);

    always @(posedge clk) begin
        if (reset) begin
            count <= 4'd0;
            last_non_one <= 1'b0;
        end else begin
            if (in) begin 
                if (last_non_one) 
                    count <= count + 1;
                else 
                    count <= 4'd1;
                last_non_one <= 1'b1;
 
            end else begin 
                count <= 4'd0;
 
                last_non_one <= 1'b0;
            end
        end
    end

endmodule
