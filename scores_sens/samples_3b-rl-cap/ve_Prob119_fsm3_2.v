
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    
    reg [1:0] state;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;
            out   <= 1'b0;
        end else begin
            case (state)
                2'b00: begin 
                    if (in)
                        state <= 2'b01;
 
                    else
                        state <= 2'b00;
 
                    out   <= 1'b0;
                end
                2'b01: begin 
                    if (in)
                        state <= 2'b10;
 
                    else
                        state <= 2'b01;
 
                    out   <= 1'b0;
                end
                2'b10: begin 
                    if (in)
                        state <= 2'b00;
 
                    else
                        state <= 2'b11;
 
                    out   <= 1'b0;
                end
                2'b11: begin 
                    if (in)
                        state <= 2'b01;
 
                    else
                        state <= 2'b10;
 
                    out   <= 1'b1;
                end
            endcase
        end
    end

endmodule
