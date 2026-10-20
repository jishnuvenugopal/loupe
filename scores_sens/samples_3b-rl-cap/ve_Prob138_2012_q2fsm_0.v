
module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    
    reg [1:0] state;

    
    always @(posedge clk) begin
        if (reset)
            state <= 2'b00;
 
        else begin
            case (state)
                2'b00: 
                    if (w)
                        state <= 2'b01;
 
                    else
                        state <= 2'b00;
 
                2'b01: 
                    if (w)
                        state <= 2'b10;
 
                    else
                        state <= 2'b11;
 
                2'b10: 
                    if (w)
                        state <= 2'b11;
 
                    else
                        state <= 2'b11;
 
                2'b11: 
                    if (w)
                        state <= 2'b10;
 
                    else
                        state <= 2'b00;
 
                default: 
                    state <= 2'b11;
 
            endcase
        end
    end

    
    assign z = (state == 2'b11) || (state == 2'b10);

endmodule
