
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    
    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;
 
        end else begin
            case (state)
                1'b1: begin 
                    if (in == 1'b0) begin
                        state <= 1'b0;
 
                    end
                end
                1'b0: begin 
                    if (in == 1'b0) begin
                        state <= 1'b1;
 
                    end
                end
            endcase
        end
    end

    assign out = state;

endmodule
