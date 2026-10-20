
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    
    reg [1:0] state;

    
    reg out_reg;

    
    assign out = out_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: 
                    if (in == 1'b0)
                        state <= 2'b00;
 
                    else
                        state <= 2'b10;
 
                2'b01: 
                    if (in == 1'b0)
                        state <= 2'b00;
 
                    else
                        state <= 2'b11;
 
                2'b10: 
                    if (in == 1'b0)
                        state <= 2'b00;
 
                    else
                        state <= 2'b11;
 
                2'b11: 
                    state <= 2'b00;
 
            endcase
        end
    end

    always @(posedge clk) begin
        case (state)
            2'b00: 
                out_reg <= 1'b0;
            2'b01: 
                out_reg <= 1'b0;
            2'b10: 
                out_reg <= 1'b0;
            2'b11: 
                if (in == 1'b1)
                    out_reg <= 1'b1;
                else
                    out_reg <= 1'b0;
        endcase
    end

endmodule
