
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  out
);

    
    reg [1:0] state;

    
    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            out   <= 1'b0;
        end else begin
            case (state)
                2'b00: begin 
                    if (in == 1'b0)
                        state <= 2'b00;
 
                    else
                        state <= 2'b01;
 
                    out   <= 1'b0;
                end
                2'b01: begin 
                    if (in == 1'b0)
                        state <= 2'b00;
 
                    else
                        state <= 2'b10;
 
                    out   <= 1'b0;
                end
                2'b10: begin 
                    if (in == 1'b0)
                        state <= 2'b00;
 
                    else
                        state <= 2'b11;
 
                    out   <= 1'b0;
                end
                2'b11: begin 
                    if (in == 1'b0)
                        state <= 2'b10;
 
                    else
                        state <= 2'b10;
 
                    out   <= 1'b1;
                end
                default: begin
                    state <= 2'b00;
                    out   <= 1'b0;
                end
            endcase
        end
    end

endmodule
