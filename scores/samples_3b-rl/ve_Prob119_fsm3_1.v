
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    
    reg [1:0] state;

    
    reg [1:0] next_state;

    
    reg out_reg;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;
 
        end else begin
            case (state)
                2'b00: begin 
                    if (in)
                        next_state <= 2'b01;
 
                    else
                        next_state <= 2'b00;
 
                    out_reg <= 1'b0;
                end
                2'b01: begin 
                    if (in)
                        next_state <= 2'b10;
 
                    else
                        next_state <= 2'b01;
 
                    out_reg <= 1'b0;
                end
                2'b10: begin 
                    if (in)
                        next_state <= 2'b00;
 
                    else
                        next_state <= 2'b11;
 
                    out_reg <= 1'b0;
                end
                2'b11: begin 
                    if (in)
                        next_state <= 2'b10;
 
                    else
                        next_state <= 2'b01;
 
                    out_reg <= 1'b1;
                end
                default: begin
                    state <= 2'b00;
 
                    next_state <= 2'b00;
                    out_reg <= 1'b0;
                end
            endcase
            state <= next_state;
            out_reg <= out;
        end
    end

    
    assign out = out_reg;

endmodule
